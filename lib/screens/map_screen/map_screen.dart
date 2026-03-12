import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/map_screen/widgets/drawer_main.dart';
import 'package:barter_app/screens/map_screen/widgets/invite_friends_dialog.dart';
import 'package:barter_app/screens/map_screen/widgets/main_navigation.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_marker_widget.dart';
import 'package:barter_app/screens/map_screen/widgets/search_in_map.dart';
import 'package:barter_app/screens/map_screen/widgets/search_filter_checkboxes.dart';
import 'package:barter_app/screens/map_screen/widgets/search_results_list_view.dart';
import 'package:barter_app/screens/map_screen/widgets/suggestion_keywords_list.dart';
import 'package:barter_app/screens/map_screen/widgets/user_avatar_fab.dart';
import 'package:barter_app/screens/map_screen/widgets/zoom_buttons.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/services/messaging/global_chat_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/back_button_handler.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/map/point_of_interest.dart';
import '../../services/messaging/firebase_auth_service.dart';
import '../../services/messaging/firebase_service.dart';
import '../../utils/geo_utils.dart';
import '../../utils/responsive_breakpoints.dart';
import '../../widgets/count_badge.dart';
import '../initialize_screen/initialize_screen.dart';
import 'cubit/chat_panel_cubit.dart';
import 'cubit/poi_panel_cubit.dart';
import 'cubit/settings_panel_cubit.dart';
import 'cubit/profile_panel_cubit.dart';
import 'cubit/map_operations_cubit.dart';
import 'cubit/map_screen_api_cubit.dart';
import 'models/poi_cluster_osm.dart';
import 'models/poi_sub_cluster_osm.dart';
import 'widgets/map_overlay_layout.dart';

class MapScreenV2 extends StatefulWidget {
  final List<PointOfInterest>? initialPois;

  const MapScreenV2({super.key, this.initialPois});

  @override
  State<MapScreenV2> createState() => _MapScreenV2State();
}

class _MapScreenV2State extends State<MapScreenV2> with OSMMixinObserver {
  // Use late initialization to prevent controller creation during router redirects
  // The controller is created in initState() only when the widget is actually mounted
  late final MapController _mapController;

  List<PointOfInterest> _allPois = [];
  Set<GeoPoint> _currentMarkerPositions = {}; // Track all marker positions
  bool _isMapReady = false; // Track map initialization status
  int _currentRenderOperation = 0; // Track current render operation to cancel stale ones
  bool _isUpdatingVisuals = false; // Prevent concurrent updates
  Region? _previousMapRegion = null;
  GeoPoint? _noUsersMarkerPosition; // Position of the "no users nearby" marker

  late PoiCubit poiCubit;
  late MapOperationsCubit mapOperationsCubit;
  ValueNotifier<int> zoomLevelNotifier = ValueNotifier(16);
  ValueNotifier<bool> showFab = ValueNotifier(true);
  
  // Search checkboxes state
  ValueNotifier<bool> _showCheckboxesNotifier = ValueNotifier(false);
  ValueNotifier<bool> _seekingCheckedNotifier = ValueNotifier(true);
  ValueNotifier<bool> _offeringCheckedNotifier = ValueNotifier(true);

  // User profile data
  String? _currentUserId;
  String? _currentUserName;
  List<ParsedAttributeData>? _userInterests;
  List<ParsedAttributeData>? _userOfferings;

  // GlobalKey to preserve Scaffold state and prevent map rebuilds
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKey to preserve map content and prevent rebuilds when panels open
  final GlobalKey _mapContentKey = GlobalKey();

  // Search results list view state
  bool _showSearchResultsList = false;
  List<PointOfInterest> _searchResults = [];
  List<PointOfInterest> _previousSearchResults = [];

  // Key to force SearchResultsListView to rebuild when attributes change
  int _searchResultsKey = 0;
  // GPS location tracking enabled state
  bool _isGpsLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controller here instead of eagerly as a final field
    // This prevents controller creation during router redirects
    _mapController = MapController.customLayer(
      initPosition: GeoPoint(latitude: 48.8584, longitude: 2.2945), // Paris
      customTile: CustomTile(
        sourceName: "osmDeu", // for caching | osmDeu, osmFrance
        tileExtension: ".png",
        minZoomLevel: 3,
        maxZoomLevel: 18,
        urlsServers: [
          //TileURLs(url: "https://a.tile.openstreetmap.fr/hot/"),
          //TileURLs(url: "https://b.tile.openstreetmap.fr/hot/"),
          //TileURLs(url: "https://c.tile.openstreetmap.fr/hot/"),
          TileURLs(url: "https://tile.openstreetmap.de/"),
          TileURLs(url: "https://b.tile.openstreetmap.org"),
          TileURLs(url: "https://c.tile.openstreetmap.org"),
        ],
        tileSize: 256
      )
    );
    
    poiCubit = context.read<PoiCubit>();
    mapOperationsCubit = context.read<MapOperationsCubit>();
    _mapController.addObserver(this);

    // Load GPS location setting
    final settingsService = getIt<SettingsService>();
    _isGpsLocationEnabled = settingsService.isGpsLocationEnabledSync();

    _loadUserProfile();

    // Handle any pending notification that opened the app when it was terminated
    // Skip on web - uses WebSocket instead of FCM
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            FirebaseService().handlePendingInitialMessage();
            context.read<NotificationsCubit>().loadMatchHistory();
          }
        });
      });
    } else {
      // On web, just load match history without FCM handling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<NotificationsCubit>().loadMatchHistory();
        }
      });
    }
  }

  @override
  void didUpdateWidget(MapScreenV2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle when new initialPois are provided via navigation
    // This happens when using context.go() to navigate to an already-mounted map
    if (widget.initialPois?.isNotEmpty == true && widget.initialPois != oldWidget.initialPois) {
      logDebug('@@@@@@@@@ didUpdateWidget - New initialPois detected: ${widget.initialPois!.length}');

      if (_isMapReady && _mapController.isAllLayersVisible) {
        final firstPoi = widget.initialPois!.first;
        logDebug('@@@@@@@@@ didUpdateWidget - Centering map on POI: ${firstPoi.profile.userId}');

        _mapController.moveTo(
          GeoPoint(
            latitude: firstPoi.profile.latitude ?? 0.0,
            longitude: firstPoi.profile.longitude ?? 0.0,
          ),
        );
        _processPois(widget.initialPois!);
      } else {
        // Map not ready yet, will be handled in _onMapReady
        logDebug('@@@@@@@@@ didUpdateWidget - Map not ready, will process in _onMapReady');
      }
    }
  }

  Future<void> _loadUserProfile() async {
    final userRepository = getIt<UserRepository>();

    _currentUserId = await userRepository.getUserId();
    _currentUserName = await userRepository.getUserName();
    _userInterests = await userRepository.getInterests(loadFromStorage: true);
    _userOfferings = await userRepository.getOfferings(loadFromStorage: true);

    final tokenService = FCMTokenService();
    tokenService.onSessionStarted(_currentUserId ?? "");

    if (mounted) {
      setState(() {});
      _autoOpenProfileOnWebLargeScreen();
    }
  }

  /// Auto-open user profile panel on web/large screens for better UX
  void _autoOpenProfileOnWebLargeScreen() {
    if (!mounted) return;

    // Defer to ensure layout is settled and context is valid
    Future.microtask(() {
      if (!mounted) return;

      // Check if we're on web/large screen (can show side-by-side)
      if (kIsWeb && context.canShowSideBySide) {
        // Wait for user profile to be loaded
        if (_currentUserId != null && _currentUserName != null) {
          context.read<ProfilePanelCubit>().openProfile(
            userId: _currentUserId!,
            userName: _currentUserName!,
            interests: _userInterests,
            offerings: _userOfferings,
          );
          logDebug('✅ Auto-opened profile panel on web large screen');
        } else {
          logDebug('⚠️ Cannot auto-open profile: userId or userName is null');
        }
      } else {
        logDebug('🔔 Skipping profile auto-open: kIsWeb=$kIsWeb, canShowSideBySide=${context.canShowSideBySide}');
      }
    });
  }

  /// Perform default search based on settings
  Future<void> _performDefaultSearch() async {
    if (!mounted) return;

    // Ensure user profile is loaded before searching
    if (_currentUserId == null) {
      // Wait a bit and try again
      await Future.delayed(const Duration(milliseconds: 100));
      if (_currentUserId == null) return; // Give up if still not loaded
    }

    final settingsService = getIt<SettingsService>();
    final useMapCenter = await settingsService.getUseMapCenterForSearch();
    final radiusKm = await settingsService.getNearbyUsersRadius();

    double? lat;
    double? lon;

    // Get coordinates based on settings
    if (useMapCenter && _isMapReady) {
      try {
        final mapCenter = await _mapController.centerMap;
        lat = mapCenter.latitude;
        lon = mapCenter.longitude;
      } catch (e) {
        // If getting map center fails, continue without it (will use user location)
        debugPrint('Error getting map center: $e');
      }
    }

    await poiCubit.getComplementaryProfiles(
      _currentUserId ?? "",
      lat: lat,
      lon: lon,
      radiusMeters: radiusKm * 1000,
      fallbackToNearby: true, // Enable fallback to nearby
    );
  }

  /// Called when user attributes may have changed (e.g., after editing profile/settings)
  void _handleAttributesChanged() {
    setState(() {
      // Increment the key to force SearchResultsListView to rebuild
      _searchResultsKey++;
    });
    // Optionally reload user profile data
    _loadUserProfile();
  }

  Future<void> _zoomToSavedLocation() async {
    final locationString = await SecureStorageService().getOwnLocation();
    if (locationString != null && locationString.isNotEmpty) {
      final parts = locationString.split(', ');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0]);
        final lon = double.tryParse(parts[1]);
        if (lat != null && lon != null) {
          await _mapController.moveTo(GeoPoint(latitude: lat, longitude: lon));
          if (ResponsiveBreakpoints.isPhone(context)) _mapController.setZoom(zoomLevel: 12.0);
        }
      }
    }
  }

  void _onMapReady(bool isReady) async {
    // Guard to prevent multiple executions
    if (_isMapReady) {
      logDebug('@@@@@@@@@ _onMapReady called but already ready, ignoring');
      return;
    }
    
    _isMapReady = true;
    logDebug('@@@@@@@@@ _onMapReady called with initialPois: ${widget.initialPois?.length ?? 0}');

    // If initial POIs were provided (e.g., from match history), use them instead of fetching
    if (widget.initialPois != null && widget.initialPois!.isNotEmpty) {
      // Center map on the first POI
      final firstPoi = widget.initialPois!.first;
      logDebug('@@@@@@@@@ Centering map on POI: ${firstPoi.profile.userId} at ${firstPoi.profile.latitude}, ${firstPoi.profile.longitude}');
      _mapController.setZoom(zoomLevel: 16.0);
      _mapController.moveTo(
        GeoPoint(latitude: firstPoi.profile.latitude ?? 0.0,
            longitude: firstPoi.profile.longitude ?? 0.0),
      );
      _processPois(widget.initialPois!);
    } else {
      // Default behavior: zoom to saved location and perform default search
      await _zoomToSavedLocation();

      // Check if user has a saved location before performing search
      final locationString = await SecureStorageService().getOwnLocation();
      if (locationString != null && locationString.isNotEmpty) {
        // User has a location set, trigger default search now that map is ready
        await _performDefaultSearch();
      } else {
        debugPrint('⚠️ No user location set yet - skipping initial search');
        // Optionally show a message to the user that they need to set their location
      }

      // If POIs were already loaded before map was ready, process them now
      if (_allPois.isNotEmpty) {
        _processPois(_allPois);
      }
    }

    // Initialize global chat service after map is ready
    _initializeGlobalChat();
  }

  /// Initialize global chat connection after map is ready
  /// Re-enabled with server multi-connection support
  Future<void> _initializeGlobalChat() async {
    try {
      final globalChatService = getIt<GlobalChatService>();
      await globalChatService.initialize();
      logDebug('✅ Global chat service initialized (multi-connection mode enabled)');
    } catch (e) {
      logDebugError('Error initializing global chat service', e);
    }
  }

  void _processPois(List<PointOfInterest> pois, {bool ignoreListViewSetting = false}) async {
    logDebug('@@@@@@@@@ _processPois called with ${pois.length} POIs');
    _allPois = List.from(pois);

    // Show snackbar with matching users count - only in map area (not under profile panel)
    if (_allPois.isNotEmpty && mounted) {
      final l10n = AppLocalizations.of(context)!;
      // Get the map content's scaffold messenger (not the root one)
      final mapScaffoldContext = _scaffoldKey.currentContext;
      if (mapScaffoldContext != null && mapScaffoldContext.mounted) {
        ScaffoldMessenger.of(mapScaffoldContext).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(8.0),
            backgroundColor: AppColors.primaryVariant,
            content: Text(l10n.matchingUsersFound(_allPois.length),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }

    mapOperationsCubit.reset();
    if (_allPois.isNotEmpty && _noUsersMarkerPosition != null) {
      _removeNoUsersMarker();
    }

    // Check if we should show results as list (unless ignoreListViewSetting is true)
    bool shouldShowListOnly = false;
    if (!ignoreListViewSetting) {
      final settingsService = getIt<SettingsService>();
      final showAsList = await settingsService.getShowSearchResultsAsList();
      final poiPanelCubit = context.read<PoiPanelCubit>();

      // Disable list view by default on web + small/mobile screens
      // Only show list if showAsList is enabled AND (not on web OR screen is large enough)
      if (showAsList && _allPois.isNotEmpty && !(kIsWeb && !context.canShowSideBySide)) {
        // Update search results if list is already showing OR if POI panel is not open
        if (_showSearchResultsList || !poiPanelCubit.state.isOpen) {
          // Check if POIs have actually changed before updating
          final poisChanged = MapOperationsCubit.havePoisChanged(_allPois, _previousSearchResults);
          
          if (poisChanged) {
            logDebug('@@@@@@@@@ Updating search results list with ${_allPois.length} POIs (key: $_searchResultsKey)');
            // Show/update list view
            setState(() {
              _searchResults = List.from(_allPois); // Create new list to trigger update
              _previousSearchResults = List.from(_allPois); // Track current POIs
              _showSearchResultsList = true;
              _searchResultsKey++; // Force rebuild of list view widget
            });
          } else {
            logDebug('@@@@@@@@@ POIs unchanged, skipping list update');
          }

          // On small screens, return early (list only, no map markers) only if POI panel is closed
          if (!context.canShowSideBySide && !poiPanelCubit.state.isOpen) {
            shouldShowListOnly = true;
          }
        } else {
          logDebug('@@@@@@@@@ NOT updating search results list - list not showing and POI panel is open');
        }
      } else if (kIsWeb && !context.canShowSideBySide && showAsList) {
        logDebug('@@@@@@@@@ NOT showing search results list - disabled by default on web + small screens');
      }
    }

    // If showing list only (small screens), don't render map markers
    if (shouldShowListOnly) {
      return;
    }

    // Only update visuals if map is ready (clustering is already populated above)
    if (_isMapReady && _mapController.isAllLayersVisible) {
      logDebug('@@@@@@@@@@@@ updateVisuals from _processPois');

      _cleanUpMarkers();

      mapOperationsCubit.resetClusteringTracking();
      mapOperationsCubit.performMainClustering(_allPois);
      await mapOperationsCubit.handleZoomBasedClusterChanges(_mapController);
      await _updateMapVisuals();
    } else {
      logDebug('Map not ready yet, POIs stored. Will display when map is ready.');
    }

    if (_allPois.isEmpty && _isMapReady && _mapController.isAllLayersVisible) {
      _showNoUsersMarker();
      return;
    }
  }

  void _cleanUpMarkers() {
    logDebug('@@@@@@@@@ _cleanUpMarkers: Removing ${_currentMarkerPositions.length} markers');
    // Remove all existing markers from previous render
    if (_currentMarkerPositions.isNotEmpty) {
      for (var position in _currentMarkerPositions.toList()) {
        try {
          _mapController.removeMarker(position);
        } catch (e) {
          logDebugError('Error removing marker at $position', e);
        }
      }
    }
    _mapController.removeAllCircle();
    _mapController.removeAllShapes();

    // Clear the tracking set and rebuild it
    _currentMarkerPositions.clear();
    logDebug('@@@@@@@@@ _cleanUpMarkers: Complete, tracking set cleared');
  }

  /// Checks if the current render operation is still valid
  bool _isRenderOperationValid(int currentOperation) {
    if (currentOperation != _currentRenderOperation) {
      logDebug('@@@@@@@@ Render operation #$currentOperation cancelled (new operation started)');
      _isUpdatingVisuals = false;
      return false;
    }
    return true;
  }

  Future<void> _updateMapVisuals() async {
    logDebug('@@@@@@@@@@@ _updateMapVisuals called: mounted=$mounted, '
        'allLayersVisible=${_mapController.isAllLayersVisible}');
    if (!mounted || !_mapController.isAllLayersVisible) {
      logDebug('@@@@@@@@@@@ Skipping visual update - map not ready');
      return;
    }
    if (_isUpdatingVisuals) {
      logDebug('@@@@@@@@@@@ Already updating visuals, skipping');
      return;
    }
    
    // On native platforms, add a small delay to ensure the OSM widget is fully laid out
    // This prevents the !debugNeedsPaint error when capturing marker images
    if (!kIsWeb && _allPois.length == 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted || !_mapController.isAllLayersVisible) {
        logDebug('@@@@@@@@@@@ Skipping visual update - map not ready after delay');
        return;
      }
    }
    
    _cleanUpMarkers();
    _isUpdatingVisuals = true;
    _currentRenderOperation++;
    final currentOperation = _currentRenderOperation;
    logDebug('@@@@@@@@@@@ Starting render operation #$currentOperation vs ${_currentRenderOperation}');
    logDebug('@@@@@@@@@@@ Updating map visuals with ${_allPois.length} POIs');
    final l10n = AppLocalizations.of(context)!;
    // Collect all markers to be added in batch
    final List<({GeoPoint point, MarkerIcon icon,})> markersToAdd = [];

    for (var mainCluster in mapOperationsCubit.mainPoiClusters) {
      if (!_isRenderOperationValid(currentOperation)) return;
      logDebug('@@@@@@@@@@@ Processing main cluster ${mainCluster.id}, isExpanded=${mainCluster.isExpanded}, pois=${mainCluster.allPoisInCluster.length}');

      if (mainCluster.isExpanded) {
        logDebug('@@@@@@@@@@@ Main cluster ${mainCluster.id} EXPANDED with ${mainCluster.subClusters.length} sub-clusters');
        for (var subCluster in mainCluster.subClusters) {
          if (subCluster.isExpanded || subCluster.pois.length <
              MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
            for (var poi in subCluster.pois) {
              if (!_isRenderOperationValid(currentOperation)) return;
              try {
                logDebug('@@@@@@@@@@@ Preparing POI marker: ${poi.profile.userId}');
                final newMarker = await _createPoiMarker(poi, l10n);
                final position = GeoPoint(latitude: poi.profile.latitude ?? 0.0,
                    longitude: poi.profile.longitude ?? 0.0);
                markersToAdd.add((point: position, icon: newMarker));
                _currentMarkerPositions.add(position);
              } catch (e) {
                logDebugError('Failed to prepare POI marker for ${poi.profile.userId}', e);
              }
            }
          } else {
            logDebug('@@@@@@@@@@@ Sub-cluster ${subCluster.id} COLLAPSED - preparing cluster marker');
            if (!_isRenderOperationValid(currentOperation)) return;
            try {
              subCluster.isExpanded = false;
              final subClusterMarker = mapOperationsCubit.createSubClusterMarker(subCluster);
              final position = GeoPoint(latitude: subCluster.centroid.latitude,
                  longitude: subCluster.centroid.longitude);
              markersToAdd.add((point: position, icon: subClusterMarker));
              _currentMarkerPositions.add(position);
            } catch (e) {
              logDebugError('Failed to prepare sub-cluster marker', e);
            }
          }
        }
        for (var poi in mainCluster.individualPoisWithinExpandedCluster) {
          if (!_isRenderOperationValid(currentOperation)) return;
          try {
            final poiMarker = await _createPoiMarker(poi, l10n);
            final position = GeoPoint(
                latitude: poi.profile.latitude ?? 0.0,
                longitude: poi.profile.longitude ?? 0.0);
            markersToAdd.add((point: position, icon: poiMarker));
            _currentMarkerPositions.add(position);
          } catch (e) {
            logDebugError('Failed to prepare individual POI marker in cluster', e);
          }
        }
      } else {
        if (!_isRenderOperationValid(currentOperation)) return;
        try {
          final mainClusterMarker = mapOperationsCubit.createMainClusterMarker(mainCluster);
          final position = GeoPoint(latitude: mainCluster.centroid.latitude,
              longitude: mainCluster.centroid.longitude);
          markersToAdd.add((point: position, icon: mainClusterMarker));
          _currentMarkerPositions.add(position);
        } catch (e) {
          logDebugError('Failed to prepare main cluster marker', e);
        }
      }
    }

    logDebug('@@@@@@@@@@@ Processing ${mapOperationsCubit.looseSubClusters.length} loose sub-clusters');
    for (var looseSubCluster in mapOperationsCubit.looseSubClusters) {
      if (looseSubCluster.isExpanded || looseSubCluster.pois.length <
          MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
        logDebug('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster}');
        for (var poi in looseSubCluster.pois) {
          logDebug('@@@@@@@@@@@ Preparing loose POI marker: ${poi.profile.userId}');
          if (!_isRenderOperationValid(currentOperation)) return;
          try {
            final svg = await _createPoiMarker(poi, l10n);
            final position = GeoPoint(
                latitude: poi.profile.latitude ?? 0.0,
                longitude: poi.profile.longitude ?? 0.0);
            markersToAdd.add((point: position, icon: svg));
            _currentMarkerPositions.add(position);
          } catch (e) {
            logDebugError('Failed to prepare loose POI marker', e);
          }
        }
      } else {
        logDebug('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster.id} COLLAPSED - preparing cluster marker');
        if (!_isRenderOperationValid(currentOperation)) return;
        try {
          final position = GeoPoint(latitude: looseSubCluster.centroid.latitude,
              longitude: looseSubCluster.centroid.longitude);
          markersToAdd.add((point: position, icon: mapOperationsCubit.createSubClusterMarker(looseSubCluster)));
          _currentMarkerPositions.add(position);
        } catch (e) {
          logDebugError('Failed to prepare loose sub-cluster marker', e);
        }
      }
    }

    // Calculate which POIs are truly individual (not part of any cluster)
    List<PointOfInterest> trulyIndividualPois = mapOperationsCubit.calculateTrulyIndividualPois(_allPois);
    logDebug('@@@@@@@@@@@ Processing ${trulyIndividualPois.length} truly individual POIs');
    for (var poi in trulyIndividualPois) {
      if (!_isRenderOperationValid(currentOperation)) return;
      try {
        final svg = await _createPoiMarker(poi, l10n);
        final position = GeoPoint(
            latitude: poi.profile.latitude ?? 0.0,
            longitude: poi.profile.longitude ?? 0.0);
        markersToAdd.add((point: position, icon: svg));
        _currentMarkerPositions.add(position);
      } catch (e) {
        logDebugError('Failed to prepare truly individual POI marker', e);
      }
    }

    // Batch add all markers at once for better performance
    if (markersToAdd.isNotEmpty) {
      try {
        await _mapController.addMarkers(
          markersToAdd.map((m) => (
            point: m.point, icon: m.icon, angle: null, anchor: null,
          )).toList(),
        );
        logDebug('@@@@@@@@@@@ Successfully batch added ${markersToAdd.length} markers');
      } catch (e) {
        logDebugError('Failed to batch add markers', e);
        // Fallback to individual adds if batch fails
        logDebug('@@@@@@@@@@@ Falling back to individual marker adds');
        for (final marker in markersToAdd) {
          try {
            await _mapController.addMarker(
              marker.point,
              markerIcon: marker.icon,
            );
          } catch (e) {
            logDebugError('Failed to add individual marker fallback', e);
          }
        }
      }
    }

    mapOperationsCubit.updateClusteringTracking(_allPois, zoomLevelNotifier.value.toDouble());
    logDebug('@@@@@@@@@@@ _updateMapVisuals completed successfully, added ${_currentMarkerPositions.length} markers');
    _isUpdatingVisuals = false;
  }

  void _onIndividualPoiTap(PointOfInterest poi) {
    logDebug("Individual POI Tapped: ${poi.profile.userId}");

    // On large screens, show POI details using cubit
    if (context.canShowSideBySide) {
      final poiPanelCubit = context.read<PoiPanelCubit>();
      poiPanelCubit.openPoiDetails(poi);
      // If search results list is open, POI will show below it
      // If not, POI will show as a side panel via AdaptivePoiLayout
    } else {
      final screenHeight = MediaQuery.of(context).size.height;
      
      // On small screens, show as modal bottom sheet
      // Use microtask to defer modal display outside of layout phase
      Future.microtask(() {
        if (!mounted) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          useRootNavigator: false,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          builder: (context) =>
            PoiDetailsBottomSheet(
              poi: poi,
              onChatButtonPressed: () {
                Navigator.of(context).pop(); // Close the bottom sheet
                _openChat(poi.profile.userId, poi.profile.name);
              },
            ),
        );
      });
    }
  }

  void _onMainClusterTap(PoiClusterOsm tappedCluster) async {
    await _mapController.moveTo(tappedCluster.centroid);
    await Future.delayed(Duration(milliseconds: 200));
    await _mapController.setZoom(zoomLevel: MapOperationsCubit.MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.5);
    mapOperationsCubit.currentZoom = MapOperationsCubit.MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.5;
  }

  void _onSubClusterTap(PoiSubClusterOsm tappedSubCluster) async {
    await _mapController.moveTo(tappedSubCluster.centroid);
    await Future.delayed(Duration(milliseconds: 200));
    await _mapController.setZoom(zoomLevel: MapOperationsCubit.SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.5);
    mapOperationsCubit.currentZoom = MapOperationsCubit.SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.5;
  }

  /// Opens chat adaptively based on screen size using ChatPanelCubit
  void _openChat(String poiId, String poiName, {PointOfInterest? poi}) {
    final chatCubit = context.read<ChatPanelCubit>();
    if (context.canShowSideBySide) {
      chatCubit.openChat(poiId, poiName, poi: poi);
    } else {
      // Navigate to full-screen chat using GoRouter
      context.push('/chat/$poiId');
    }
  }

  Future<MarkerIcon> _createPoiMarker(PointOfInterest poi, AppLocalizations l10n) async {
    return await PoiMarkerWidget.createMarker(
      poi: poi,
      userInterests: _userInterests,
      userOfferings: _userOfferings
    );
  }

  void _onGeoPointTapped(GeoPoint point) {
    // Check if the "no users nearby" marker was tapped
    if (_noUsersMarkerPosition != null) {
      final distanceToNoUsersMarker = GeoUtils.calculateDistance(
        point.latitude,
        point.longitude,
        _noUsersMarkerPosition!.latitude,
        _noUsersMarkerPosition!.longitude,
      );

      if (distanceToNoUsersMarker < 0.1) { // 100 meters threshold
        _showInviteFriendsDialog();
        return;
      }
    }

    // Find the closest item to the tapped point using the cubit
    final result = mapOperationsCubit.findClosestItemToPoint(
      point,
      widget.initialPois,
    );

    if (result == null) return;

    final (closestItem, minDistance) = result;
    const tapThresholdKm = 0.1; // 100 meters

    if (minDistance < tapThresholdKm) {
      if (closestItem is PoiClusterOsm) {
        _onMainClusterTap(closestItem);
      } else if (closestItem is PoiSubClusterOsm) {
        _onSubClusterTap(closestItem);
      } else if (closestItem is PointOfInterest) {
        _onIndividualPoiTap(closestItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top;

    // Build map content separately to avoid rebuilds
    // Using GlobalKey to preserve widget identity across rebuilds
    final mapContent = ScaffoldMessenger(
      child: KeyedSubtree(
        key: _mapContentKey,
        child: Scaffold(
          key: _scaffoldKey, // Use persistent key to prevent rebuilds
          drawer: PointerInterceptor(
            child: DrawerMain(
              poiCubit: poiCubit,
              mapController: _mapController,
              onAttributesChanged: _handleAttributesChanged,
              onOpenSettingsPanel: () => context.read<SettingsPanelCubit>().openSettings(),
            ),
          ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PoiCubit, PoiState>(
              listener: (context, state) async {
                if (state is PoiAuthenticationError) {
                  // Clear all keys
                  await SecureStorageService().clearStorage();

                  // Use addPostFrameCallback to avoid navigator lock issues
                  if (context.mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;

                      if (kIsWeb) {
                        // On web with page-based navigation, use SystemNavigator to exit
                        // and let the app restart, which will show InitializeScreen
                        SystemNavigator.pop();
                      } else {
                        // On mobile, use standard navigation
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const InitializeScreen(),
                          ), (route) => false,
                        );
                      }
                    });
                  }
                } else if (state is PoiError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.message), backgroundColor: Colors.red),
                  );
                } else if (state is PoiLoaded) {
                  _processPois(state.pois);
                }
              },
            ),
            BlocListener<MapOperationsCubit, MapOperationsState>(
              listener: (context, state) async {
                if (state is MapOperationsClusterUpdateSuccess && mounted && !_isUpdatingVisuals) {
                  await _updateMapVisuals();
                }
              },
            ),
          ],
          child: ValueListenableBuilder(
            valueListenable: showFab,
            builder: (context, isVisible, child) {
              if (!isVisible) {
                return const SizedBox.shrink();
              }
              // Build the map Stack - just map and UI overlays
              final mapWidget = OSMFlutter(
                controller: _mapController,
                osmOption: _isGpsLocationEnabled ? OSMOption(
                  zoomOption: const ZoomOption(initZoom: 8, minZoomLevel: 5, maxZoomLevel: 18),
                  userTrackingOption: UserTrackingOption(
                    enableTracking: true,
                    unFollowUser: false,
                  ),
                  showContributorBadgeForOSM: true
                ) : OSMOption(
                  zoomOption: const ZoomOption(initZoom: 10, minZoomLevel: 5, maxZoomLevel: 18),
                  showContributorBadgeForOSM: true
                ),
                onMapIsReady: _onMapReady,
                onMapMoved: (event) {
                  _handleMapMoved(event);
                },
                onGeoPointClicked: _onGeoPointTapped,
              );

              final mapStack = Stack(
                children: [
                  mapWidget,
                  Positioned(
                    top: kIsWeb ? 8.h : 26.h,
                    left: 12 + MediaQuery.of(context).viewPadding.left,
                    child: PointerInterceptor(child: const MainNavigation()),
                  ),
                  Positioned(
                    bottom: 32 + MediaQuery.of(context).viewPadding.bottom,
                    right: 16 + MediaQuery.of(context).viewPadding.right,
                    child: PointerInterceptor(
                      child: UserAvatarFab(
                        userId: _currentUserId,
                        userName: _currentUserName,
                        userInterests: _userInterests,
                        userOfferings: _userOfferings,
                      ),
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 6.h : 28.h,
                    left: 64 + MediaQuery.of(context).viewPadding.left,
                    right: 100 + MediaQuery.of(context).viewPadding.right,
                    child: PointerInterceptor(
                      child: SearchInMapTextField(
                        controller: _mapController,
                        poiCubit: poiCubit,
                        showCheckboxesNotifier: _showCheckboxesNotifier,
                        seekingCheckedNotifier: _seekingCheckedNotifier,
                        offeringCheckedNotifier: _offeringCheckedNotifier,
                      ),
                    ),
                  ),
                  // Suggestion keywords list - horizontally scrollable attribute bubbles (rendered first)
                  Positioned(
                    top: kIsWeb ? 42 : 51.h,
                    left: MediaQuery.of(context).viewPadding.left,
                    right: MediaQuery.of(context).viewPadding.right,
                    child: SuggestionKeywordsList(
                      poiCubit: poiCubit,
                    ),
                  ),
                  // Search filter checkboxes - positioned above/overlapping suggestion list (rendered on top)
                  Positioned(
                    top: (kIsWeb ? 8.h : topPadding ?? 0) + 46, // Just below search field
                    left: 16 + MediaQuery.of(context).viewPadding.left,
                    right: 16 + MediaQuery.of(context).viewPadding.right,
                    child: SearchFilterCheckboxes(
                      showCheckboxesNotifier: _showCheckboxesNotifier,
                      seekingCheckedNotifier: _seekingCheckedNotifier,
                      offeringCheckedNotifier: _offeringCheckedNotifier,
                    ),
                  ),
                  // Chats button in top right
                  Positioned(
                    top: kIsWeb ? 8.h : 26.h,
                    right: 12 + MediaQuery.of(context).viewPadding.right,
                    child: PointerInterceptor(
                      child: BlocBuilder<ChatsBadgeCubit, ChatsBadgeState>(
                        builder: (context, badgeState) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  final chatCubit = context.read<ChatPanelCubit>();
                                  final poiCubit = context.read<PoiPanelCubit>();
                                  if (context.canShowSideBySide) {
                                    if (poiCubit.state.isOpen) {
                                      poiCubit.closePanel();
                                    }
                                    chatCubit.openChatsList();
                                  } else {
                                    context.push("/chats");
                                  }
                                },
                                heroTag: "ChatsFab",
                                mini: true,
                                backgroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(Icons.chat_bubble_outline),
                              ),
                              if (badgeState.unreadCount > 0)
                                PositionedCountBadge(
                                  count: badgeState.unreadCount,
                                  top: -4,
                                  right: -4,
                                  borderColor: AppColors.background,
                                  borderWidth: 2,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  // Search complementary users button (with fallback to nearby)
                  Positioned(
                    top: kIsWeb ? 8.h : 26.h,
                    right: 56 + MediaQuery.of(context).viewPadding.right,
                    child: PointerInterceptor(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade50.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/search_nearby_users.svg',
                            width: 30,
                            height: 30,
                            // Removed colorFilter to preserve SVG's original colors
                          ),
                          onPressed: () async {
                            mapOperationsCubit.reset();
                            // Close POI panel when performing new search
                            final poiPanelCubit = context.read<PoiPanelCubit>();
                            if (poiPanelCubit.state.isOpen) {
                              poiPanelCubit.closePanel();
                            }
                            final settingsService = getIt<SettingsService>();
                            final useMapCenter = await settingsService.getUseMapCenterForSearch();
                            final radiusKm = await settingsService.getNearbyUsersRadius();

                            if (useMapCenter) {
                              final mapCenter = await _mapController.centerMap;
                              await poiCubit.getComplementaryProfiles(
                                _currentUserId ?? "",
                                lat: mapCenter.latitude,
                                lon: mapCenter.longitude,
                                radiusMeters: radiusKm * 1000, // Convert km to meters
                                fallbackToNearby: true, // Enable fallback to nearby
                              );
                            } else {
                              // Use user location (default)
                              await poiCubit.getComplementaryProfiles(
                                _currentUserId ?? "",
                                radiusMeters: radiusKm * 1000, // Convert km to meters
                                fallbackToNearby: true, // Enable fallback to nearby
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 23.0 + MediaQuery.of(context).viewPadding.bottom,
                    left: 15 + MediaQuery.of(context).viewPadding.left,
                    child: ZoomNavigation(
                      controller: _mapController,
                      zoomNotifier: zoomLevelNotifier,
                    ),
                  ),
                  // Search results list view overlay (only for small screens)
                  if (_showSearchResultsList && !context.canShowSideBySide)
                    Positioned(
                      left: MediaQuery.of(context).viewPadding.left,
                      right: MediaQuery.of(context).viewPadding.right,
                      bottom: MediaQuery.of(context).viewPadding.bottom,
                      top: MediaQuery.of(context).size.height * 0.15,
                      child: PointerInterceptor(
                        child: SearchResultsListView(
                          key: ValueKey(_searchResultsKey),
                          pois: _searchResults,
                          isLargeScreen: false,
                          onClose: () {
                            setState(() {
                              _showSearchResultsList = false;
                              _searchResults = [];
                            });
                            if (_allPois.isNotEmpty) {
                              _processPois(_allPois, ignoreListViewSetting: true);
                            }
                          },
                          onPoiTap: (poi) async {
                            // On small screens, close the list when POI is tapped
                            setState(() {
                              _showSearchResultsList = false;
                            });
                            if (_allPois.isNotEmpty) {
                              _processPois(_allPois, ignoreListViewSetting: true);
                              await Future.delayed(const Duration(milliseconds: 100));
                            }
                            _onIndividualPoiTap(poi);
                          },
                          onChatTap: (poi) {
                            _openChat(poi.profile.userId, poi.profile.name);
                          },
                        ),
                      ),
                    ),
                ]
              );

              return mapStack;
            },
          ),
        ),
      ),
    ),
  );

    // Wrap with Stack-based overlays - each panel is an independent overlay
    return BackButtonHandler(
      onBackPressed: () async {
        // Allow normal navigation, adjust if needed for specific screens
        return true;
      },
      child: MapOverlayLayout(
        mapContent: mapContent,
        showSearchResultsList: _showSearchResultsList,
        searchResults: _searchResults,
        searchResultsKey: _searchResultsKey,
        onCloseSearchResults: () {
          setState(() {
            _showSearchResultsList = false;
            _searchResults = [];
          });
          // Clear markers from map when closing list
          if (_allPois.isNotEmpty) {
            mapOperationsCubit.reset();
            _updateMapVisuals();
          }
        },
        onSearchPoiTap: (poi) async {
          // Navigate to the user's location first for smooth animation
          if (poi.profile.latitude != null && poi.profile.longitude != null) {
            await _mapController.moveTo(
              GeoPoint(
                latitude: poi.profile.latitude!,
                longitude: poi.profile.longitude!,
              )
            );
          }
          Future.delayed(const Duration(milliseconds: 200), () {
            // Then load POI details after animation completes
            context.read<PoiPanelCubit>().openPoiDetails(poi);
          });
        },
        onSearchChatTap: (poi) {
          // Close any existing chat first, then open new one
          final chatCubit = context.read<ChatPanelCubit>();
          chatCubit.closePanel();
          // Small delay to ensure clean state
          Future.delayed(const Duration(milliseconds: 50), () {
            chatCubit.openChat(
              poi.profile.userId,
              poi.profile.name,
              poi: poi,
            );
          });
        },
      ),
    );
  }

  /// Shows a special marker when no users are nearby
  Future<void> _showNoUsersMarker() async {
    _removeNoUsersMarker();
    // Get current map center to place the marker
    final mapCenter = await _mapController.centerMap;
    _noUsersMarkerPosition = mapCenter;
    // Load and create the special marker with path333.svg
    final svgString = await rootBundle.loadString('assets/icons/avatars/path333.svg');
    final marker = mapOperationsCubit.createNoUsersMarker(svgString);

    await _mapController.addMarker(
      mapCenter,
      markerIcon: marker,
    );
    _currentMarkerPositions.add(mapCenter);
  }

  void _removeNoUsersMarker() {
    if (_noUsersMarkerPosition != null) {
      try {
        _mapController.removeMarker(_noUsersMarkerPosition!);
        _currentMarkerPositions.remove(_noUsersMarkerPosition);
      } catch (e) {
        print('@@@@@@@@@@@ Error removing no users marker: $e');
      }
      _noUsersMarkerPosition = null;
    }
  }

  void _showInviteFriendsDialog() {
    showDialog(
      context: context,
      builder: (context) => PointerInterceptor(
        child: const InviteFriendsDialog(),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _showCheckboxesNotifier.dispose();
    _seekingCheckedNotifier.dispose();
    _offeringCheckedNotifier.dispose();
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {}

  void _handleMapMoved(Region event) {
    // Track if zoom changed significantly (more than 0.5 levels)
    _mapController.getZoom().then((v) async {
      final newZoom = v.toDouble();
      final zoomChanged = (newZoom - mapOperationsCubit.currentZoom).abs() > 0.5;
      final positionChanged = (((_previousMapRegion?.boundingBox.east ?? 0) - event.boundingBox.east).abs() > 0.0004
          || ((_previousMapRegion?.boundingBox.north ?? 0) - event.boundingBox.north).abs() > 0.0004);

      // Process if either position or zoom changed
      if (mapOperationsCubit.shouldPerformMainClustering(_allPois, newZoom) || positionChanged || zoomChanged) {
        zoomLevelNotifier.value = v.toInt();
        mapOperationsCubit.currentZoom = newZoom;
        // Check if main clustering is needed due to zoom change
        // Only perform if we have POIs and zoom changed significantly (> 1.0 level)
        await mapOperationsCubit.handleZoomBasedClusterChanges(_mapController);
        if (_allPois.isNotEmpty && mapOperationsCubit.currentZoom <= 14) {
          // Check if zoom changed significantly enough to warrant re-clustering
          // by comparing with the stored clustering zoom level
          final lastClusteringZoom = mapOperationsCubit.getLastClusteringZoom();
          final zoomChangedSignificantly = lastClusteringZoom < 0 || (newZoom - lastClusteringZoom).abs() > 0.5;

          if (zoomChangedSignificantly || mapOperationsCubit.shouldPerformMainClustering(_allPois, newZoom)) {
            logDebug('@@@@@@@@@ Zoom changed to $newZoom - performing main clustering');
            if (!kIsWeb) {
              await Future.delayed(Duration(milliseconds: 1200), () async => {
                mapOperationsCubit.performMainClustering(_allPois)
              });
            } else {
              mapOperationsCubit.performMainClustering(_allPois);
            }
          }
        } else if (mapOperationsCubit.currentZoom > 14) {
          // Zoomed in past clustering threshold - reset tracking
          logDebug('@@@@@@@@@ Zoomed past clustering threshold - resetting tracking');
          if (!kIsWeb) {
            await Future.delayed(Duration(milliseconds: 1200), () async => {
              await mapOperationsCubit.handleZoomBasedClusterChanges(_mapController, emitUpdate: false),
              mapOperationsCubit.performMainClustering(_allPois),
            });
          } else {
            mapOperationsCubit.resetClusteringTracking();
            await mapOperationsCubit.handleZoomBasedClusterChanges(_mapController, emitUpdate: false);
            mapOperationsCubit.performMainClustering(_allPois);
          }
        }
      }
      _previousMapRegion = event;
    });
  }

}
