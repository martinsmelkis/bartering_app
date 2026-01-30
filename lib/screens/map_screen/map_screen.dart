import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/map_screen/widgets/drawer_main.dart';
import 'package:barter_app/screens/map_screen/widgets/invite_friends_dialog.dart';
import 'package:barter_app/screens/map_screen/widgets/main_navigation.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_marker_widget.dart';
import 'package:barter_app/screens/map_screen/widgets/search_in_map.dart';
import 'package:barter_app/screens/map_screen/widgets/search_results_list_view.dart';
import 'package:barter_app/screens/map_screen/widgets/user_avatar_fab.dart';
import 'package:barter_app/screens/map_screen/widgets/zoom_buttons.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/map/point_of_interest.dart';
import '../../services/messaging/firebase_auth_service.dart';
import '../../services/messaging/firebase_service.dart';
import '../../utils/geo_utils.dart';
import '../../utils/responsive_breakpoints.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/adaptive_chat_layout.dart';
import '../settings_screen/adaptive_settings_layout.dart';
import '../user_profile_screen/adaptive_profile_layout.dart';
import '../initialize_screen/initialize_screen.dart';
import 'cubit/chat_panel_cubit.dart';
import 'cubit/poi_panel_cubit.dart';
import 'adaptive_poi_layout.dart';
import 'cubit/settings_panel_cubit.dart';
import 'cubit/profile_panel_cubit.dart';
import 'cubit/map_operations_cubit.dart';
import 'cubit/map_screen_api_cubit.dart';
import 'models/poi_cluster_osm.dart';
import 'models/poi_sub_cluster_osm.dart';

class MapScreenV2 extends StatefulWidget {
  final List<PointOfInterest>? initialPois;

  const MapScreenV2({super.key, this.initialPois});

  @override
  State<MapScreenV2> createState() => _MapScreenV2State();
}

class _MapScreenV2State extends State<MapScreenV2> with OSMMixinObserver {
  final MapController _mapController = MapController.customLayer(
    initPosition: GeoPoint(latitude: 48.8584, longitude: 2.2945), // Paris
    customTile: CustomTile(
      sourceName: "osmDeu", // for caching | osmDeu, osmFrance
      tileExtension: ".png",
      minZoomLevel: 2,
      maxZoomLevel: 19,
      urlsServers: [
        //TileURLs(url: "https://a.tile.openstreetmap.fr/hot/"),
        //TileURLs(url: "https://b.tile.openstreetmap.fr/hot/"),
        //TileURLs(url: "https://c.tile.openstreetmap.fr/hot/"),
        TileURLs(url: "https://tile.openstreetmap.de/"),
        TileURLs(url: "https://b.tile.openstreetmap.org"),
        TileURLs(url: "https://c.tile.openstreetmap.org"),
        TileURLs(url: "https://tiles.wmflabs.org/osm/"),
      ],
      tileSize: 256,
    ),
  );

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

  // Key to force SearchResultsListView to rebuild when attributes change
  int _searchResultsKey = 0;

  @override
  void initState() {
    super.initState();
    poiCubit = context.read<PoiCubit>();
    mapOperationsCubit = context.read<MapOperationsCubit>();
    _mapController.addObserver(this);
    _loadUserProfile();

    // Handle any pending notification that opened the app when it was terminated
    // Add a delay to ensure the route is fully settled before attempting navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationsCubit>().loadMatchHistory();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          FirebaseService().handlePendingInitialMessage();
        }
      });
    });
  }

  @override
  void didUpdateWidget(MapScreenV2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle when new initialPois are provided via navigation
    // This happens when using context.go() to navigate to an already-mounted map
    if (widget.initialPois != null &&
        widget.initialPois!.isNotEmpty &&
        widget.initialPois != oldWidget.initialPois) {
      logDebug('@@@@@@@@@ didUpdateWidget - New initialPois detected: ${widget.initialPois!.length}');

      // If map is ready, process immediately
      if (_isMapReady && _mapController.isAllLayersVisible) {
        final firstPoi = widget.initialPois!.first;
        logDebug('@@@@@@@@@ didUpdateWidget - Centering map on POI: ${firstPoi.profile.userId}');

        _mapController.setZoom(zoomLevel: 15.0);
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
    _currentUserName = await userRepository.getUserName(); // Default to userId if no name

    final interests = await userRepository.getInterests(loadFromStorage: true);
    final offerings = await userRepository.getOfferings(loadFromStorage: true);
    // Load interests and offerings
    _userInterests = interests;
    _userOfferings = offerings;

    final tokenService = FCMTokenService();
    tokenService.onSessionStarted(_currentUserId ?? "");

    if (mounted) {
      setState(() {});
      // Auto-open profile panel after user data is loaded
      _autoOpenProfileOnWebLargeScreen();
    }
  }

  /// Auto-open user profile panel on web/large screens for better UX
  void _autoOpenProfileOnWebLargeScreen() {
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
      }
    }
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
    final searchType = await settingsService.getDefaultSearchType();
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
    // If not using map center, lat/lon will be null and methods will use user's saved location

    // Perform search based on default type
    switch (searchType) {
      case 'complementary':
        await poiCubit.getComplementaryProfiles(
          _currentUserId ?? "",
          lat: lat,
          lon: lon,
          radiusMeters: radiusKm * 1000,
          fallbackToNearby: true, // Enable fallback to nearby
        );
        break;
      case 'similar':
        await poiCubit.getSimilarProfiles(
          _currentUserId ?? "",
          lat: lat,
          lon: lon,
          radiusMeters: radiusKm * 1000,
        );
        break;
      case 'nearby':
      default:
        await poiCubit.fetchPois(
          lat: lat,
          lon: lon,
          radius: radiusKm * 1000,
        );
        break;
    }
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
          _mapController.setZoom(zoomLevel: 8.0);
          _mapController.moveTo(GeoPoint(latitude: lat, longitude: lon));
        }
      }
    }
  }

  void _onMapReady(bool isReady) async {
    _isMapReady = true;
    logDebug('@@@@@@@@@ _onMapReady called with initialPois: ${widget.initialPois?.length ?? 0}');
    // If initial POIs were provided (e.g., from match history), use them instead of fetching
    if (widget.initialPois != null && widget.initialPois!.isNotEmpty) {
      // Center map on the first POI
      final firstPoi = widget.initialPois!.first;
      logDebug('@@@@@@@@@ Centering map on POI: ${firstPoi.profile.userId} at ${firstPoi.profile.latitude}, ${firstPoi.profile.longitude}');
      _mapController.setZoom(zoomLevel: 15.0);
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
        _performDefaultSearch();
      } else {
        debugPrint('⚠️ No user location set yet - skipping initial search');
        // Optionally show a message to the user that they need to set their location
      }

      // If POIs were already loaded before map was ready, process them now
      if (_allPois.isNotEmpty) {
        _processPois(_allPois);
      }
    }
  }

  void _processPois(List<PointOfInterest> pois, {bool ignoreListViewSetting = false}) async {
    logDebug('@@@@@@@@@ _processPois called with ${pois.length} POIs');
    _allPois = List.from(pois);

    mapOperationsCubit.reset();

    // Remove the "no users" marker if POIs are now available
    if (_allPois.isNotEmpty && _noUsersMarkerPosition != null) {
      _removeNoUsersMarker();
    }

    // Check if we should show results as list (unless ignoreListViewSetting is true)
    bool shouldShowListOnly = false;
    if (!ignoreListViewSetting) {
      final settingsService = getIt<SettingsService>();
      final showAsList = await settingsService.getShowSearchResultsAsList();
      final poiPanelCubit = context.read<PoiPanelCubit>();

      if (showAsList && _allPois.isNotEmpty) {
        // Update search results if list is already showing OR if POI panel is not open
        if (_showSearchResultsList || !poiPanelCubit.state.isOpen) {
          logDebug('@@@@@@@@@ Updating search results list with ${_allPois.length} POIs (key: $_searchResultsKey)');
          // Show/update list view
          setState(() {
            _searchResults = List.from(_allPois); // Create new list to trigger update
            _showSearchResultsList = true;
            _searchResultsKey++; // Force rebuild of list view widget
          });

          // On small screens, return early (list only, no map markers) only if POI panel is closed
          if (!context.canShowSideBySide && !poiPanelCubit.state.isOpen) {
            shouldShowListOnly = true;
          }
        } else {
          logDebug('@@@@@@@@@ NOT updating search results list - list not showing and POI panel is open');
        }
      }
    }

    // If showing list only (small screens), don't render map markers
    if (shouldShowListOnly) {
      return;
    }

    // Force cluster refresh to clear old markers from previous search
    if (zoomLevelNotifier.value.toDouble() <= 14) {
      logDebug('@@@@@@@@@ Force performing main clustering for ${_allPois.length} POIs at zoom ${zoomLevelNotifier.value}');
      mapOperationsCubit.performMainClustering(_allPois);
      mapOperationsCubit.updateClusteringTracking(_allPois, zoomLevelNotifier.value.toDouble());
    }

    // Only update visuals if map is ready
    if (_isMapReady && _mapController.isAllLayersVisible) {
      logDebug('@@@@@@@@@@@@ updateVisuals from _processPois');
      _updateMapVisuals();
    } else {
      logDebug('Map not ready yet, POIs stored. Will display when map is ready.');
    }

    // If no POIs found, show the special "invite friends" marker
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
  /// Returns true if operation should continue, false if it was cancelled
  bool _isRenderOperationValid(int currentOperation) {
    if (currentOperation != _currentRenderOperation) {
      //_cleanUpMarkers();
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

    // Prevent concurrent updates
    if (_isUpdatingVisuals) {
      logDebug('@@@@@@@@@@@ Already updating visuals, skipping...');
      //return;
    }
    _cleanUpMarkers();
    mapOperationsCubit.handleZoomBasedClusterChanges(_mapController);

    _isUpdatingVisuals = true;
    // Increment operation counter to invalidate any ongoing operations
    _currentRenderOperation++;
    final currentOperation = _currentRenderOperation;
    logDebug('@@@@@@@@@@@ Starting render operation #$currentOperation vs ${_currentRenderOperation}');

    logDebug('@@@@@@@@@@@ Updating map visuals with ${_allPois.length} POIs');
    final l10n = AppLocalizations.of(context)!;

    for (var mainCluster in mapOperationsCubit.mainPoiClusters) {
      // Check if operation is still current
      if (!_isRenderOperationValid(currentOperation)) return;

      if (mainCluster.isExpanded) {
        logDebug('@@@@@@@@@@@ Main cluster ${mainCluster
            .id} EXPANDED with ${mainCluster.subClusters.length} sub-clusters');
        for (var subCluster in mainCluster.subClusters) {
          if (subCluster.isExpanded || subCluster.pois.length <
              MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
            for (var poi in subCluster.pois) {
              // Check if operation is still current before each marker add
              if (!_isRenderOperationValid(currentOperation)) return;

              logDebug('@@@@@@@@@@@ Adding POI marker: ${poi.profile.userId}');
              final newMarker = await _createPoiMarker(poi, l10n);
              final position = GeoPoint(latitude: poi.profile.latitude ?? 0.0,
                  longitude: poi.profile.longitude ?? 0.0);
              await _mapController.addMarker(
                position,
                markerIcon: newMarker,
              );
              _currentMarkerPositions.add(position);
            }
          } else {
            logDebug('@@@@@@@@@@@ Sub-cluster ${subCluster
                .id} COLLAPSED - adding cluster marker');
            if (!_isRenderOperationValid(currentOperation)) return;
            subCluster.isExpanded = false;
            final subClusterMarker = _createSubClusterMarker(subCluster, l10n);
            final position = GeoPoint(latitude: subCluster.centroid.latitude,
                longitude: subCluster.centroid.longitude);
            await _mapController.addMarker(
              position,
              markerIcon: subClusterMarker,
            );
            _currentMarkerPositions.add(position);
          }
        }
        for (var poi in mainCluster.individualPoisWithinExpandedCluster) {
          // Check if operation is still current
          if (!_isRenderOperationValid(currentOperation)) return;

          final poiMarker = await _createPoiMarker(poi, l10n);
          final position = GeoPoint(
              latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0);
          await _mapController.addMarker(
            position,
            markerIcon: poiMarker,
          );
          _currentMarkerPositions.add(position);
        }
      } else {
        if (!_isRenderOperationValid(currentOperation)) return;
        final mainClusterMarker = _createMainClusterMarker(mainCluster, l10n);
        final position = GeoPoint(latitude: mainCluster.centroid.latitude,
            longitude: mainCluster.centroid.longitude);
        await _mapController.addMarker(
          position,
          markerIcon: mainClusterMarker,
        );
        mainCluster.isExpanded = false;
        _currentMarkerPositions.add(position);
      }
    }

    logDebug('@@@@@@@@@@@ Processing ${mapOperationsCubit.looseSubClusters.length} loose sub-clusters');
    for (var looseSubCluster in mapOperationsCubit.looseSubClusters) {
      if (looseSubCluster.isExpanded || looseSubCluster.pois.length <
          MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
        logDebug('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster}');
        for (var poi in looseSubCluster.pois) {
          logDebug('@@@@@@@@@@@ Adding loose POI marker: ${poi.profile.userId}');
          if (!_isRenderOperationValid(currentOperation)) return;
          final svg = await _createPoiMarker(poi, l10n);
          final position = GeoPoint(
              latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0);
          await _mapController.addMarker(
            position,
            markerIcon: svg,
          );
          _currentMarkerPositions.add(position);
        }
      } else {
        logDebug('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster.id} COLLAPSED - adding cluster marker');
        //looseSubCluster.isExpanded = false;
        if (!_isRenderOperationValid(currentOperation)) return;
        final position = GeoPoint(latitude: looseSubCluster.centroid.latitude,
            longitude: looseSubCluster.centroid.longitude);
        await _mapController.addMarker(
          position,
          markerIcon: _createSubClusterMarker(looseSubCluster, l10n),
        );
        _currentMarkerPositions.add(position);
      }
    }

    // Calculate which POIs are truly individual (not part of any cluster)
    List<PointOfInterest> trulyIndividualPois = mapOperationsCubit.calculateTrulyIndividualPois(_allPois);
    for (var poi in trulyIndividualPois) {
      logDebug('@@@@@@@@@@@ Adding truly individual POI marker: ${poi.profile
          .userId}');
      if (!_isRenderOperationValid(currentOperation)) return;

      final svg = await _createPoiMarker(poi, l10n);
      final position = GeoPoint(
          latitude: poi.profile.latitude ?? 0.0, longitude: poi.profile.longitude ?? 0.0);
      await _mapController.addMarker(
        position,
        markerIcon: svg,
      );
      _currentMarkerPositions.add(position);
    }
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
      // On small screens, show as modal bottom sheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        useRootNavigator: false,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
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
    }
  }

  void _onMainClusterTap(PoiClusterOsm tappedCluster) {
    tappedCluster.isExpanded = true;
    mapOperationsCubit.expandedMainClusterId = tappedCluster.id;
    mapOperationsCubit.performSubClusteringWithinMainCluster(tappedCluster);
    _mapController.setZoom(zoomLevel: MapOperationsCubit.MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.2);
    _mapController.moveTo(tappedCluster.centroid);
    _updateMapVisuals();
  }

  void _onSubClusterTap(PoiSubClusterOsm tappedSubCluster) {
    tappedSubCluster.isExpanded = true;
    mapOperationsCubit.expandedSubClusterIds.add(tappedSubCluster.id);
    _mapController.setZoom(zoomLevel: MapOperationsCubit.SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD + 0.2);
    _mapController.moveTo(tappedSubCluster.centroid);
    _updateMapVisuals();
  }

  /// Opens chat adaptively based on screen size using ChatPanelCubit
  void _openChat(String poiId, String poiName) {
    final chatCubit = context.read<ChatPanelCubit>();
    if (context.canShowSideBySide) {
      chatCubit.openChat(poiId, poiName);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ChatScreen(
                poiId: poiId,
                poiName: poiName,
              ),
        ),
      );
    }
  }

  Future<MarkerIcon> _createPoiMarker(PointOfInterest poi, AppLocalizations l10n, {bool isSelfAvatar = false}) async {
    // Load user interests/offerings if needed
    if (isSelfAvatar) {
      final userRepository = getIt<UserRepository>();
      _userInterests = await userRepository.getInterests(loadFromStorage: true);
      _userOfferings = await userRepository.getOfferings(loadFromStorage: true);
    }

    // Delegate to the refactored widget class
    return await PoiMarkerWidget.createMarker(
      poi: poi,
      userInterests: _userInterests,
      userOfferings: _userOfferings,
    );
  }

  MarkerIcon _createMainClusterMarker(PoiClusterOsm cluster,
      AppLocalizations l10n) {
    final poiCount = cluster.allPoisInCluster.length;

    return MarkerIcon(
      iconWidget: Container(
        width: AppDimensions.mainClusterSize,
        height: AppDimensions.mainClusterSize,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: AppDimensions.mainClusterBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            poiCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimensions.mainClusterFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  MarkerIcon _createSubClusterMarker(PoiSubClusterOsm cluster, AppLocalizations l10n) {
    final poiCount = cluster.pois.length;

    return MarkerIcon(
      iconWidget: Container(
        width: AppDimensions.subClusterSize,
        height: AppDimensions.subClusterSize,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: AppDimensions.subClusterBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            poiCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimensions.subClusterFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
    final mapContent = KeyedSubtree(
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
                          ),
                              (route) => false,
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

              // Build the map Stack
              final mapStack = Stack(
                  children: [
                    OSMFlutter(
                      controller: _mapController,
                      osmOption: OSMOption(
                          zoomOption: const ZoomOption(initZoom: 8, minZoomLevel: 2, maxZoomLevel: 19),
                          userTrackingOption: const UserTrackingOption(
                            enableTracking: true,
                            unFollowUser: false,
                          ),
                          showContributorBadgeForOSM: true
                      ),
                      onMapIsReady: _onMapReady,
                      onMapMoved: (event) {
                        if (((_previousMapRegion?.boundingBox.east ?? 0) - event.boundingBox.east).abs() > 0.0004
                            || ((_previousMapRegion?.boundingBox.north ?? 0) - event.boundingBox.north).abs() > 0.0004) {
                          _mapController.getZoom().then((v) {
                            print('@@@@@@@@@@ MAP MOVED: ${((_previousMapRegion?.boundingBox.east ?? 0) - event.boundingBox.east).abs()} '
                                '${((_previousMapRegion?.boundingBox.north ?? 0) - event.boundingBox.north).abs()}');
                            final newZoom = v.toDouble();
                            zoomLevelNotifier.value = v.toInt();
                            mapOperationsCubit.currentZoom = newZoom;

                            // Check if main clustering is needed due to zoom change
                            // Only perform if we have POIs and zoom is in clustering range
                            if (_allPois.isNotEmpty && newZoom <= 13.5) {
                              if (mapOperationsCubit.shouldPerformMainClustering(_allPois, newZoom)) {
                                logDebug('@@@@@@@@@ Zoom changed to $newZoom - performing main clustering');
                                mapOperationsCubit.performMainClustering(_allPois);
                                mapOperationsCubit.updateClusteringTracking(_allPois, newZoom);
                              }
                            } else if (newZoom > 13.5) {
                              // Zoomed in past clustering threshold - reset tracking
                              logDebug('@@@@@@@@@ Zoomed past clustering threshold - resetting tracking');
                              mapOperationsCubit.resetClusteringTracking();
                            }

                            mapOperationsCubit.handleZoomBasedClusterChanges(_mapController);
                          });
                        }
                        _previousMapRegion = event;
                      },
                      onGeoPointClicked: _onGeoPointTapped,
                    ),
                    Positioned(
                      top: kIsWeb ? 26 : topPadding ?? 26.0,
                      left: 12,
                      child: PointerInterceptor(child: const MainNavigation()),
                    ),
                    Positioned(
                      bottom: 32,
                      right: 16,
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
                      top: kIsWeb ? 26 : topPadding,
                      left: 64,
                      right: 100,
                      child: PointerInterceptor(
                        child: SearchInMap(
                          controller: _mapController, poiCubit: poiCubit,),
                      ),
                    ),
                    // Chats button in top right
                    Positioned(
                      top: kIsWeb ? 26 : topPadding ?? 26.0,
                      right: 12,
                      child: PointerInterceptor(
                        child: BlocBuilder<ChatsBadgeCubit, ChatsBadgeState>(
                          builder: (context, badgeState) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    final chatCubit = context.read<ChatPanelCubit>();
                                    if (context.canShowSideBySide) {
                                      chatCubit.openChatsList();
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const ChatsListScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  heroTag: "ChatsFab",
                                  mini: true,
                                  backgroundColor: AppColors.background,
                                  child: const Icon(Icons.chat_bubble_outline),
                                ),
                                if (badgeState.unreadCount > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.background,
                                          width: 2,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Center(
                                        child: Text(
                                          badgeState.unreadCount > 99 ?
                                          '99+' : badgeState.unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    // Search complementary users button (with fallback to nearby)
                    Positioned(
                      top: kIsWeb ? 28 : (topPadding ?? 20.0),
                      right: 56,
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
                              width: 28,
                              height: 28,
                              // Removed colorFilter to preserve SVG's original colors
                            ),
                            onPressed: () async {
                              mapOperationsCubit.reset();
                              for (var c in mapOperationsCubit.mainPoiClusters) {
                                c.isExpanded = false;
                              }

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
                      bottom: 23.0,
                      left: 15,
                      child: ZoomNavigation(
                        controller: _mapController,
                        zoomNotifier: zoomLevelNotifier,
                      ),
                    ),
                    // Search results list view overlay (only for small screens)
                    if (_showSearchResultsList && !context.canShowSideBySide)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: MediaQuery.of(context).size.height * 0.15,
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
                  ]
              );

              // On large screens, show map with search results panel
              if (context.canShowSideBySide && _showSearchResultsList) {
                return Row(
                  children: [
                    Expanded(child: mapStack),
                    Container(
                      width: context.panelWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(-2, 0),
                          ),
                        ],
                      ),
                      child: SearchResultsListView(
                        key: ValueKey(_searchResultsKey),
                        pois: _searchResults,
                        isLargeScreen: true,
                        onClose: () {
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
                        onPoiTap: (poi) async {
                          // On large screens, open POI panel below the search results list
                          context.read<PoiPanelCubit>().openPoiDetails(poi);

                          // Navigate to the user's location on the map (like match history does)
                          if (poi.profile.latitude != null && poi.profile.longitude != null) {
                            //_mapController.setZoom(zoomLevel: 15.0);
                            _mapController.moveTo(
                              GeoPoint(
                                latitude: poi.profile.latitude!,
                                longitude: poi.profile.longitude!,
                              ),
                            );
                          }
                        },
                        onChatTap: (poi) {
                          _openChat(poi.profile.userId, poi.profile.name);
                        },
                      ),
                    ),
                  ],
                );
              }

              return mapStack;
            },
          ),
        ),
      ),
    );

    // Wrap with BlocBuilders for panels
    return BlocBuilder<PoiPanelCubit, PoiPanelState>(
      builder: (context, poiPanelState) {
        return BlocBuilder<ChatPanelCubit, ChatPanelState>(
          builder: (context, chatState) {
            return BlocBuilder<SettingsPanelCubit, SettingsPanelState>(
              builder: (context, settingsState) {
                return BlocBuilder<ProfilePanelCubit, ProfilePanelState>(
                  builder: (context, profileState) {
                    return AdaptiveProfileLayout(
                      showProfilePanel: profileState.isOpen,
                      userId: profileState.userId,
                      userName: profileState.userName,
                      interests: profileState.interests,
                      offerings: profileState.offerings,
                      onClose: () => context.read<ProfilePanelCubit>().closeProfile(),
                      mainContent: AdaptiveSettingsLayout(
                        showSettingsPanel: settingsState.isOpen,
                        onClose: () => context.read<SettingsPanelCubit>().closeSettings(),
                        mainContent: AdaptiveChatLayout(
                          // Only suppress chat panel when POI is shown in AdaptivePoiLayout
                          // (not when shown below search results list)
                          suppressChatPanel: poiPanelState.isOpen &&
                              !_showSearchResultsList &&
                              chatState.isChatOpen &&
                              chatState.selectedPoiId == poiPanelState.selectedPoi?.profile.userId,
                          panelView: chatState.view,
                          selectedPoiId: chatState.selectedPoiId,
                          selectedPoiName: chatState.selectedPoiName,
                          onClose: () => context.read<ChatPanelCubit>().closePanel(),
                          onChatSelected: (poiId, poiName) {
                            context.read<ChatPanelCubit>().openChat(poiId, poiName);
                          },
                          mainContent: AdaptivePoiLayout(
                            // Only show POI panel here if search results list is NOT open
                            // (if list is open, POI shows below the list instead)
                            showPoiPanel: poiPanelState.isOpen && !_showSearchResultsList,
                            selectedPoi: poiPanelState.selectedPoi,
                            onClose: () => context.read<PoiPanelCubit>().closePanel(),
                            onChatButtonPressed: () {
                              final poi = poiPanelState.selectedPoi;
                              if (poi != null) {
                                if (context.canShowSideBySide) {
                                  context.read<ChatPanelCubit>().openChat(
                                    poi.profile.userId,
                                    poi.profile.name,
                                  );
                                } else {
                                  context.read<PoiPanelCubit>().closePanel();
                                  _openChat(poi.profile.userId, poi.profile.name);
                                }
                              }
                            },
                            mainContent: mapContent,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Shows a special marker when no users are nearby
  Future<void> _showNoUsersMarker() async {
    _removeNoUsersMarker();
    // Get current map center to place the marker
    final mapCenter = await _mapController.centerMap;
    _noUsersMarkerPosition = mapCenter;
    // Load and create the special marker with path333.svg
    final svgString = await rootBundle.loadString('assets/icons/path333.svg');
    final marker = MarkerIcon(
      iconWidget: SvgPicture.string(
        svgString,
        width: AppDimensions.poiMarkerSize * 1.1, // Make it slightly larger
        height: AppDimensions.poiMarkerSize * 1.1,
        key: const ValueKey('no_users_marker'),
      ),
    );

    await _mapController.addMarker(
      mapCenter,
      markerIcon: marker,
    );
    _currentMarkerPositions.add(mapCenter);
    // On web, give DOM time to process the marker iframe creation
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
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
      builder: (context) => const InviteFriendsDialog(),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {}

}
