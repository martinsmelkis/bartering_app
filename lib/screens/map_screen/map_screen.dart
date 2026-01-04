import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/map_screen/widgets/drawer_main.dart';
import 'package:barter_app/screens/map_screen/widgets/main_navigation.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/widgets/search_in_map.dart';
import 'package:barter_app/screens/map_screen/widgets/zoom_buttons.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/user_profile_screen.dart';
import 'package:barter_app/services/firebase_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/map/point_of_interest.dart';
import '../../models/profile/user_profile_data.dart';
import '../../models/user/user_attribute_entry_data.dart';
import '../../services/firebase_auth_service.dart';
import '../../utils/geo_utils.dart';
import '../../utils/responsive_breakpoints.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/adaptive_chat_layout.dart';
import 'cubit/chat_panel_cubit.dart';
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
      sourceName: "osmFrance", //for caching |
      tileExtension: ".png",
      minZoomLevel: 2,
      maxZoomLevel: 19,
      urlsServers: [
        TileURLs(url: "https://a.tile.openstreetmap.fr/hot/"),
        TileURLs(url: "https://b.tile.openstreetmap.fr/hot/"),
        TileURLs(url: "https://c.tile.openstreetmap.fr/hot/"),
        TileURLs(url: "https://a.tile.openstreetmap.org"),
        TileURLs(url: "https://b.tile.openstreetmap.org"),
        TileURLs(url: "https://c.tile.openstreetmap.org"),
        TileURLs(url: "https://tiles.wmflabs.org/osm/"),
      ],
      tileSize: 512,
    ),
  );

  List<PointOfInterest> _allPois = [];
  Set<GeoPoint> _currentMarkerPositions = {}; // Track all marker positions
  bool _isMapReady = false; // Track map initialization status
  int _currentRenderOperation = 0; // Track current render operation to cancel stale ones
  bool _isUpdatingVisuals = false; // Prevent concurrent updates

  // Avatar SVG assets (dynamically generated)
  static const int _svgAssetCount = 25;

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/path$index.svg';

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

  @override
  void initState() {
    super.initState();
    poiCubit = context.read<PoiCubit>();
    mapOperationsCubit = context.read<MapOperationsCubit>();

    _mapController.addObserver(this);
    _loadUserProfile();
    
    // Load match history to update badge count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationsCubit>().loadMatchHistory();
      }
    });
    
    // Handle any pending notification that opened the app when it was terminated
    // Add a delay to ensure the route is fully settled before attempting navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          print('🗺️ Map screen is mounted and ready, handling pending messages...');
          FirebaseService().handlePendingInitialMessage();
        }
      });
    });
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

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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

  void _onMapReady(bool isReady) {
    _isMapReady = true;
    
    // If initial POIs were provided (e.g., from match history), use them instead of fetching
    if (widget.initialPois != null && widget.initialPois!.isNotEmpty) {
      print('🗺️ Using provided initial POIs (${widget.initialPois!.length} items)');
      
      // Center map on the first POI
      final firstPoi = widget.initialPois!.first;
      _mapController.setZoom(zoomLevel: 15.0);
      _mapController.moveTo(
        GeoPoint(latitude: firstPoi.profile.latitude ?? 0.0,
            longitude: firstPoi.profile.longitude ?? 0.0),
      );
      
      _processPois(widget.initialPois!);
    } else {
      // Default behavior: zoom to saved location and fetch nearby POIs
      _zoomToSavedLocation();
      print('🗺️ No initial POIs provided, fetching nearby POIs');
      poiCubit.fetchPois(radius: 65000);
      // If POIs were already loaded before map was ready, process them now
      if (_allPois.isNotEmpty) {
        _processPois(_allPois);
      }
    }
  }

  void _processPois(List<PointOfInterest> pois) {
    _allPois = List.from(pois);
    if (zoomLevelNotifier.value.toDouble() <= 13.5) {
      mapOperationsCubit.performMainClustering(_allPois);
    }

    // Only update visuals if map is ready
    if (_isMapReady && _mapController.isAllLayersVisible) {
      print('@@@@@@@@@@@@ updateVisuals from _processPois');
      _updateMapVisuals();
    } else {
      print('Map not ready yet, POIs stored. Will display when map is ready.');
    }
  }

  void _cleanUpMarkers() {
    // Remove all existing markers from previous render
    if (_currentMarkerPositions.isNotEmpty) {
      for (var position in _currentMarkerPositions.toList()) {
        try {
          _mapController.removeMarker(position);
        } catch (e) {
          print('@@@@@@@@@@@ Error removing marker at $position: $e');
        }
      }
    }
    _mapController.removeAllCircle();
    _mapController.removeAllShapes();

    // Clear the tracking set and rebuild it
    _currentMarkerPositions.clear();
  }

  /// Checks if the current render operation is still valid
  /// Returns true if operation should continue, false if it was cancelled
  bool _isRenderOperationValid(int currentOperation) {
    if (currentOperation != _currentRenderOperation) {
      //_cleanUpMarkers();
      print('@@@@@@@@ Render operation #$currentOperation cancelled (new operation started)');
      _isUpdatingVisuals = false;
      return false;
    }
    return true;
  }

  Future<void> _updateMapVisuals() async {
    print('@@@@@@@@@@@ _updateMapVisuals called: mounted=$mounted, '
        'allLayersVisible=${_mapController.isAllLayersVisible}');
    if (!mounted || !_mapController.isAllLayersVisible) {
      print('@@@@@@@@@@@ Skipping visual update - map not ready');
      return;
    }

    // Prevent concurrent updates
    if (_isUpdatingVisuals) {
      print('@@@@@@@@@@@ Already updating visuals, skipping...');
      _isUpdatingVisuals = false;
      //return;
    }
    _cleanUpMarkers();
    mapOperationsCubit.handleZoomBasedClusterChanges(_mapController);

    _isUpdatingVisuals = true;
    // Increment operation counter to invalidate any ongoing operations
    _currentRenderOperation++;
    final currentOperation = _currentRenderOperation;
    print('@@@@@@@@@@@ Starting render operation #$currentOperation vs ${_currentRenderOperation}');

    print('@@@@@@@@@@@ Updating map visuals with ${_allPois.length} POIs');
    final l10n = AppLocalizations.of(context)!;

    for (var mainCluster in mapOperationsCubit.mainPoiClusters) {
      // Check if operation is still current
      if (!_isRenderOperationValid(currentOperation)) return;

      if (mainCluster.isExpanded) {
        print('@@@@@@@@@@@ Main cluster ${mainCluster
            .id} EXPANDED with ${mainCluster.subClusters.length} sub-clusters');
        for (var subCluster in mainCluster.subClusters) {
          if (subCluster.isExpanded || subCluster.pois.length <
              MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
            for (var poi in subCluster.pois) {
              // Check if operation is still current before each marker add
              if (!_isRenderOperationValid(currentOperation)) return;

              print('@@@@@@@@@@@ Adding POI marker: ${poi.profile.userId}');
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
            print('@@@@@@@@@@@ Sub-cluster ${subCluster
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

    print('@@@@@@@@@@@ Processing ${mapOperationsCubit.looseSubClusters.length} loose sub-clusters');
    for (var looseSubCluster in mapOperationsCubit.looseSubClusters) {
      if (looseSubCluster.isExpanded || looseSubCluster.pois.length <
          MapOperationsCubit.MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
        print('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster}');
        for (var poi in looseSubCluster.pois) {
          print('@@@@@@@@@@@ Adding loose POI marker: ${poi.profile.userId}');
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
        print('@@@@@@@@@@@ Loose sub-cluster ${looseSubCluster.id} COLLAPSED - adding cluster marker');
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

    Set<String> renderedPoiIds = {};

    print('@@@@@@@@@@@ Calculating truly individual POIs...');
    // Collect all POIs that have been rendered (either as individual or in clusters)
    for (var mc in mapOperationsCubit.mainPoiClusters) {
      if (mc.isExpanded) {
        // If main cluster is expanded, track POIs from sub-clusters
        for (var sc in mc.subClusters) {
          for (var p in sc.pois) {
            renderedPoiIds.add(p.profile.userId);
          }
        }
        // Also track individual POIs within the expanded main cluster
        for (var p in mc.individualPoisWithinExpandedCluster) {
          renderedPoiIds.add(p.profile.userId);
        }
      } else {
        // If main cluster is collapsed, track all POIs in the cluster
        for (var p in mc.allPoisInCluster) {
          renderedPoiIds.add(p.profile.userId);
        }
      }
    }

    // Track POIs in loose sub-clusters
    for (var sc in mapOperationsCubit.looseSubClusters) {
      for (var p in sc.pois) {
        renderedPoiIds.add(p.profile.userId);
      }
    }

    List<PointOfInterest> trulyIndividualPois =
    _allPois.where((p) => !renderedPoiIds.contains(p.profile.userId)).toList();

    print('@@@@@@@@@@@ Truly individual POIs: ${trulyIndividualPois.length}');
    for (var poi in trulyIndividualPois) {
      print('@@@@@@@@@@@ Adding truly individual POI marker: ${poi.profile
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

    if (zoomLevelNotifier.value.toDouble() <= 13.5) {
      mapOperationsCubit.performMainClustering(_allPois);
    }

    _isUpdatingVisuals = false;
  }

  void _onIndividualPoiTap(PointOfInterest poi) {
    print("Individual POI Tapped: ${poi.profile.userId}");
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
      // Large screen: Open as side panel via cubit (no setState needed!)
      chatCubit.openChat(poiId, poiName);
    } else {
      // Small screen: Navigate to full screen
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
    // Use the POI's userId to get a consistent random icon
    if (isSelfAvatar) {
      final userRepository = getIt<UserRepository>();
      _userInterests = await userRepository.getInterests(loadFromStorage: true);
      _userOfferings = await userRepository.getOfferings(loadFromStorage: true);
    }
    final userIdHashCode = poi.profile.userId.hashCode;
    print('@@@@@@@@@@ Creating POI marker for ${poi.profile.userId}, hashCode: $userIdHashCode');
    final index = userIdHashCode.abs() % _svgAssetCount;
    final selectedIconPath = _getSvgAsset(index + 1); // 1-based index

    final svgString = await _loadAndModifySvg(selectedIconPath, poi);
    // Create a local copy of the string to avoid reference issues
    final localSvgCopy = String.fromCharCodes(svgString.runes);

    return MarkerIcon(
      iconWidget: SvgPicture.string(
        localSvgCopy,
        width: AppDimensions.poiMarkerSize,
        height: AppDimensions.poiMarkerSize,
        key: ValueKey('poi_marker_${poi.profile.userId}'),
      ),
    );
  }

  /// Loads an SVG asset and replaces the default color with a color based on POI attributes
  Future<String> _loadAndModifySvg(String assetPath, PointOfInterest poi) async {
    final attributes = poi.profile.attributes?.map((e) => e.uiStyleHint).whereType<String>().toList();
    
    return AvatarColorUtils.loadAndColorSvgFromAttributes(
      assetPath: assetPath,
      attributes: attributes,
      relevancyScore: poi.matchRelevancyScore,
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
    double minDistance = double.infinity;
    dynamic closestItem;
    void checkItem(dynamic item, GeoPoint itemLocation) {
      final distance = GeoUtils.calculateDistance(point.latitude, point.longitude, itemLocation.latitude, itemLocation.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        closestItem = item;
      }
    }
    // Iterate through all potentially visible items
    for (var mainCluster in mapOperationsCubit.mainPoiClusters) {
      if (!mainCluster.isExpanded) {
        checkItem(mainCluster, mainCluster.centroid);
      } else {
        for (var subCluster in mainCluster.subClusters) {
          if (!subCluster.isExpanded) {
            checkItem(subCluster, subCluster.centroid);
          } else {
            for (var poi in subCluster.pois) {
              checkItem(poi, GeoPoint(latitude: poi.profile.latitude ?? 0.0,
                  longitude: poi.profile.longitude ?? 0.0));
            }
          }
        }
        for (var poi in mainCluster.individualPoisWithinExpandedCluster) {
          checkItem(poi, GeoPoint(latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0));
        }
      }
    }
    for (var looseSubCluster in mapOperationsCubit.looseSubClusters) {
      if (!looseSubCluster.isExpanded) {
        checkItem(looseSubCluster, looseSubCluster.centroid);
      } else {
        for (var poi in looseSubCluster.pois) {
          checkItem(poi, GeoPoint(latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0));
        }
      }
    }
    for (var poi in mapOperationsCubit.individualPois) {
      checkItem(poi, GeoPoint(latitude: poi.profile.latitude ?? 0.0,
          longitude: poi.profile.longitude ?? 0.0));
    }
    for (var poi in widget.initialPois ?? List.empty()) {
      checkItem(poi, GeoPoint(latitude: poi.profile.latitude, longitude: poi.profile.longitude));
    }
    const tapThresholdKm = 0.1; // 50 meters
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

  Region? _previousMapRegion = null;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top;

    // Use BlocBuilder to listen to chat state changes without rebuilding map
    return BlocBuilder<ChatPanelCubit, ChatPanelState>(
        builder: (context, chatState) {
          return AdaptiveChatLayout(
          mainContent: Scaffold(
            key: _scaffoldKey, // Use persistent key to prevent rebuilds
            drawer: PointerInterceptor(child: DrawerMain(poiCubit: poiCubit,)),
            body:
            MultiBlocListener(
              listeners: [
                BlocListener<PoiCubit, PoiState>(
                  listener: (context, state) {
                    if (state is PoiError) {
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
                  return Stack(
                      children: [
                        OSMFlutter(
                          controller: _mapController,
                          osmOption: OSMOption(
                            zoomOption: const ZoomOption(initZoom: 8, minZoomLevel: 2, maxZoomLevel: 19),
                            userTrackingOption: const UserTrackingOption(
                              enableTracking: true,
                              unFollowUser: false,
                            ),
                          ),
                          onMapIsReady: _onMapReady,
                          onMapMoved: (event) {
                            if (((_previousMapRegion?.boundingBox.east ?? 0) - event.boundingBox.east).abs() > 0.0004
                                || ((_previousMapRegion?.boundingBox.north ?? 0) - event.boundingBox.north).abs() > 0.0004) {
                              _mapController.getZoom().then((v) {
                                print('@@@@@@@@@@ MAP MOVED: ${((_previousMapRegion?.boundingBox.east ?? 0) - event.boundingBox.east).abs()} '
                                    '${((_previousMapRegion?.boundingBox.north ?? 0) - event.boundingBox.north).abs()}');
                                zoomLevelNotifier.value = v.toInt();
                                mapOperationsCubit.currentZoom = zoomLevelNotifier.value.toDouble();
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
                          child: PointerInterceptor(child: _buildUserAvatarFAB()),
                        ),
                        Positioned(
                          top: kIsWeb ? 26 : topPadding,
                          left: 64,
                          right: 64,
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
                                          // Large screen: Open as side panel
                                          chatCubit.openChatsList();
                                        } else {
                                          // Small screen: Navigate to full screen
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
                                              badgeState.unreadCount > 99
                                                  ? '99+'
                                                  : badgeState.unreadCount.toString(),
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
                        // Search nearby users button
                        Positioned(
                          top: 88,
                          right: 12,
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
                                icon: const Icon(Icons.settings_input_antenna, color: Colors
                                    .black87),
                                onPressed: () async {
                                  mapOperationsCubit.reset();
                                  for (var c in mapOperationsCubit.mainPoiClusters) {
                                    c.isExpanded = false;
                                  }
                                  
                                  // Get search settings
                                  final settingsService = getIt<SettingsService>();
                                  final useMapCenter = await settingsService.getUseMapCenterForSearch();
                                  final radiusKm = await settingsService.getNearbyUsersRadius();
                                  
                                  if (useMapCenter) {
                                    // Use map center
                                    final mapCenter = await _mapController.centerMap;
                                    await poiCubit.fetchPois(
                                      lat: mapCenter.latitude,
                                      lon: mapCenter.longitude,
                                      radius: radiusKm * 1000, // Convert km to meters
                                    );
                                  } else {
                                    // Use user location (default)
                                    await poiCubit.fetchPois(radius: radiusKm * 1000); // Convert km to meters
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
                      ]
                  );
                },
              ),
            ),
          ),
          panelView: chatState.view,
          selectedPoiId: chatState.selectedPoiId,
          selectedPoiName: chatState.selectedPoiName,
          onClose: () => context.read<ChatPanelCubit>().closePanel(),
          onChatSelected: (poiId, poiName) {
            context.read<ChatPanelCubit>().openChat(poiId, poiName);
          },
        );
      },
    );
  }

  Widget _buildUserAvatarFAB() {
    if (_currentUserId == null) {
      return const SizedBox.shrink();
    }

    final userRepository = getIt<UserRepository>();
    final userInterests = _userInterests?.isEmpty == true ? userRepository.userInterests : _userInterests;
    final userOfferings = _userOfferings?.isEmpty == true ? userRepository.userOfferings : _userOfferings;

    print('@@@@@@@@@ _buildUserAvatarFAB ${_currentUserId} ${userRepository.userInterests} ||| ${_userInterests}');

    final List<UserAttributeEntryData> attrList = List.of(userOfferings?.map((e) => UserAttributeEntryData(
        attributeId: e.attribute, type: 0, relevancy: e.relevancyScore,
        description: "", uiStyleHint: e.uiStyleHint),) ?? []);
    attrList.addAll(userInterests?.map((e) => UserAttributeEntryData(
        attributeId: e.attribute, type: 1, relevancy: e.relevancyScore,
        description: "", uiStyleHint: e.uiStyleHint)) ?? List.empty());
    // Create a dummy POI for the user
    final userPoi = PointOfInterest(
      profile: UserProfileData(
        userId: _currentUserId ?? "",
        name: _currentUserName ?? "",
        latitude: 0,
        longitude: 0,
        attributes: attrList,
        profileKeywordDataMap: null,
        activePostingIds: List.empty(growable: false),
      ),
      distanceKm: 0,
    );

    return FutureBuilder<MarkerIcon>(
      future: _createPoiMarker(userPoi, AppLocalizations.of(context)!, isSelfAvatar: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final markerWidget = snapshot.data!.iconWidget!;

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    UserProfileScreen(
                      userId: _currentUserId!,
                      userName: _currentUserName!,
                      interests: userInterests,
                      offerings: userOfferings,
                    ),
              ),
            );
            // Reload match history when user returns
            if (mounted) {
              context.read<NotificationsCubit>().loadMatchHistory();
            }
          },
          child: Stack(
            children: [
              Container(
                width: AppDimensions.userAvatarSize,
                height: AppDimensions.userAvatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: markerWidget,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, notificationState) {
                    final unreadCount = notificationState.matchHistory?.unviewedCount ?? 0;
                    
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: AppDimensions.avatarEditIconSize,
                          height: AppDimensions.avatarEditIconSize,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: AppDimensions.avatarEditIconInnerSize,
                            color: AppColors.primary,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : unreadCount.toString(),
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
            ],
          ),
        );
      },
    );
  }

  @override
  Future<void> mapIsReady(bool isReady) async {

  }

}