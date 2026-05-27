import 'package:barter_app/screens/map_screen/widgets/cluster_marker_widget.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/svg_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/geo_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../models/map/point_of_interest.dart';
import '../models/poi_cluster_osm.dart';
import '../models/poi_sub_cluster_osm.dart';

part 'map_operations_state.dart';

class MapOperationsCubit extends Cubit<MapOperationsState> {
  double currentZoom = 12.0;
  static const double MAX_DISTANCE_FOR_AUTO_ACTION_KM = 5.0;

  String? expandedMainClusterId;
  Set<String> expandedSubClusterIds = {};

  static const double MAIN_CLUSTER_THRESHOLD_KM = 1.0;
  static const double SUB_CLUSTER_THRESHOLD_M = 500.0;
  static const int MIN_POIS_FOR_MAIN_CLUSTER_DISPLAY = 3;
  static const int MIN_POIS_FOR_SUB_CLUSTER_DISPLAY = 2;

  static const double MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD = 14.0;
  static const double SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD = kIsWeb ? 16.0 : 15.5;
  static const double MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD = 13.0;
  static const double SUB_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD = kIsWeb ? 15.5 : 14.5;

  List<PoiClusterOsm> mainPoiClusters = [];
  List<PoiSubClusterOsm> looseSubClusters = [];
  List<PointOfInterest> individualPois = [];

  String? lastAutoCollapsedMainClusterId;
  Set<String> lastAutoCollapsedSubClusterIds = {};

  // Track POIs and zoom level used for last clustering to avoid redundant operations
  List<String> _lastClusteredPoiIds = [];
  double _lastClusteringZoom = -1.0;

  // Track zoom from previous performMainClustering invocation
  double? _previousPerformMainClusteringZoom;

  MapOperationsCubit() : super(MapOperationsInitial());

  void performMainClustering(List<PointOfInterest> _allPois, {bool emitUpdate = true}) {
    // Cache zoom state at method entry for transition-aware emit logic
    final double previousZoomAtMethodEntry = _previousPerformMainClusteringZoom ?? currentZoom;
    final double currentZoomAtMethodEntry = currentZoom;

    // Save current cluster counts for comparison
    final int previousMainClusterCount = mainPoiClusters.length;
    final int previousLooseSubClusterCount = looseSubClusters.length;
    final int previousIndividualPoiCount = individualPois.length;

    // Save current clusters for state preservation
    List<PoiClusterOsm> previousClusters = List.from(mainPoiClusters);

    List<PointOfInterest> remainingPois = List.from(_allPois);
    List<PoiClusterOsm> newMainClusters = [];
    List<PointOfInterest> poisNotFormingMainClusters = [];
    int clusterCounter = 0;

    while (remainingPois.isNotEmpty) {
      PointOfInterest currentPoi = remainingPois.removeAt(0);
      List<PointOfInterest> currentMainClusterGroup = [currentPoi];
      List<PointOfInterest> poisToRemoveFromRemaining = [];

      for (var otherPoi in remainingPois) {
        if (GeoUtils.calculateDistance(currentPoi.profile.latitude ?? 0.0,
            currentPoi.profile.longitude ?? 0.0, otherPoi.profile.latitude ?? 0.0,
            otherPoi.profile.longitude ?? 0.0) < MAIN_CLUSTER_THRESHOLD_KM) {
          currentMainClusterGroup.add(otherPoi);
          poisToRemoveFromRemaining.add(otherPoi);
        }
      }
      remainingPois.removeWhere((p) => poisToRemoveFromRemaining.contains(p));

      if (currentMainClusterGroup.length >= MIN_POIS_FOR_MAIN_CLUSTER_DISPLAY) {
        double sumLat = 0, sumLon = 0;
        for (var p in currentMainClusterGroup) {
          sumLat += p.profile.latitude ?? 0.0;
          sumLon += p.profile.longitude ?? 0.0;
        }
        GeoPoint centroid = GeoPoint(latitude: sumLat / currentMainClusterGroup.length, longitude: sumLon / currentMainClusterGroup.length);
        String clusterId = "main_cluster_${centroid.latitude}_${centroid.longitude}_${clusterCounter++}";

        // Check if this cluster matches a previously expanded one by centroid proximity
        bool isCurrentlyExpanded = expandedMainClusterId == clusterId;

        // Also check if any previous cluster with similar centroid was expanded
        if (!isCurrentlyExpanded) {
          for (var prevCluster in previousClusters) {
            if (prevCluster.isExpanded) {
              double distance = GeoUtils.calculateDistance(
                  centroid.latitude, centroid.longitude,
                  prevCluster.centroid.latitude, prevCluster.centroid.longitude
              );
              if (distance < 0.1) { // Within 100m, treat as same cluster
                isCurrentlyExpanded = true;
                expandedMainClusterId = clusterId; // Update to new ID
                break;
              }
            }
          }
        }

        var mainCluster = PoiClusterOsm(
          id: clusterId,
          centroid: centroid,
          allPoisInCluster: List.from(currentMainClusterGroup),
          isExpanded: isCurrentlyExpanded,
        );
        if (isCurrentlyExpanded) {
          performSubClusteringWithinMainCluster(mainCluster);
        }
        newMainClusters.add(mainCluster);
      } else {
        poisNotFormingMainClusters.addAll(currentMainClusterGroup);
      }
    }

    mainPoiClusters = newMainClusters;
    final result = _performSubClustering(poisNotFormingMainClusters, "loose_sub_");
    looseSubClusters = result.$1;
    individualPois = result.$2;

    // Only emit if clustering results have changed
    final bool clustersChanged =
        mainPoiClusters.length != previousMainClusterCount ||
            looseSubClusters.length != previousLooseSubClusterCount ||
            individualPois.length != previousIndividualPoiCount;

    // Force UI update when zoom crosses from expand threshold down to collapse threshold
    final bool crossedMainExpandToCollapseThreshold =
        previousZoomAtMethodEntry >= MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD &&
            currentZoomAtMethodEntry <= MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD;

    final bool crossedSubExpandToCollapseThreshold =
        currentZoomAtMethodEntry >= SUB_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD &&
        previousZoomAtMethodEntry - currentZoomAtMethodEntry >= 1.0;

    _previousPerformMainClusteringZoom = currentZoomAtMethodEntry;

    if (!kIsWeb && crossedSubExpandToCollapseThreshold) {
      final result = _performSubClustering(poisNotFormingMainClusters, "loose_sub_");
      looseSubClusters = result.$1;
      individualPois = result.$2;
    }

    if ((clustersChanged && emitUpdate) || ((!kIsWeb && crossedMainExpandToCollapseThreshold) ||
        (!kIsWeb && crossedSubExpandToCollapseThreshold))) {
      emit(MapOperationsClusterUpdateSuccess(currentZoom));
    }
  }

  void performSubClusteringWithinMainCluster(PoiClusterOsm mainCluster) {
    final result = _performSubClustering(mainCluster.allPoisInCluster, "main_${mainCluster.id}_sub_");
    mainCluster.subClusters = result.$1;
    mainCluster.individualPoisWithinExpandedCluster = result.$2;
  }

  (List<PoiSubClusterOsm>, List<PointOfInterest>) _performSubClustering(List<PointOfInterest> poisToSubCluster, String idPrefix) {
    List<PointOfInterest> remainingPoisForSub = List.from(poisToSubCluster);
    List<PoiSubClusterOsm> newSubClusters = [];
    List<PointOfInterest> individualPoisAfterSub = [];
    int subClusterCounter = 0;

    while (remainingPoisForSub.isNotEmpty) {
      PointOfInterest currentPoi = remainingPoisForSub.removeAt(0);
      List<PointOfInterest> currentSubClusterGroup = [currentPoi];
      List<PointOfInterest> poisToRemoveFromRemaining = [];

      for (var otherPoi in remainingPoisForSub) {
        if (GeoUtils.calculateDistance(currentPoi.profile.latitude ?? 0.0,
            currentPoi.profile.longitude ?? 0.0, otherPoi.profile.latitude ?? 0.0,
            otherPoi.profile.longitude ?? 0.0) * 1000 < SUB_CLUSTER_THRESHOLD_M) {
          currentSubClusterGroup.add(otherPoi);
          poisToRemoveFromRemaining.add(otherPoi);
        }
      }
      remainingPoisForSub.removeWhere((p) => poisToRemoveFromRemaining.contains(p));

      if (currentSubClusterGroup.length >= MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
        double sumLat = 0, sumLon = 0;
        for (var p in currentSubClusterGroup) {
          sumLat += p.profile.latitude ?? 0.0;
          sumLon += p.profile.longitude ?? 0.0;
        }
        GeoPoint centroid = GeoPoint(latitude: sumLat / currentSubClusterGroup.length, longitude: sumLon / currentSubClusterGroup.length);
        String subClusterId = "${idPrefix}sub_cluster_${centroid.latitude}_${centroid.longitude}_${subClusterCounter++}";

        // Check by ID match first
        bool isExpanded = expandedSubClusterIds.contains(subClusterId);
        // Also check by centroid proximity for sub-clusters from expanded main clusters
        if (!isExpanded && idPrefix.startsWith("main_")) {
          for (var mainCluster in mainPoiClusters) {
            if (mainCluster.isExpanded) {
              for (var prevSub in mainCluster.subClusters) {
                if (prevSub.isExpanded) {
                  double distance = GeoUtils.calculateDistance(
                      centroid.latitude, centroid.longitude,
                      prevSub.centroid.latitude, prevSub.centroid.longitude
                  );
                  if (distance < 0.05) { // Within 50m
                    isExpanded = true;
                    expandedSubClusterIds.add(subClusterId);
                    break;
                  }
                }
              }
            }
            if (isExpanded) break;
          }
        }

        newSubClusters.add(PoiSubClusterOsm(
          id: subClusterId,
          centroid: centroid,
          pois: List.from(currentSubClusterGroup),
          isExpanded: isExpanded,
        ));
      } else {
        individualPoisAfterSub.addAll(currentSubClusterGroup);
      }
    }
    return (newSubClusters, individualPoisAfterSub);
  }


  Future<void> handleZoomBasedClusterChanges(MapController _mapController, {bool emitUpdate = true}) async {
    bool visualsNeedUpdate = false;
    final BoundingBox? currentBounds = await _mapController.bounds;
    if (currentBounds == null) return;

    final mapCenter = await _mapController.centerMap;

    debugPrint('@@@@@@@@@@@@@ currentZoom ${currentZoom} @@@@@@@@@@@@@');
    // --- 1. Handle Auto-Collapse ---
    if (currentZoom < MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD) {
      for (var mainCluster in mainPoiClusters) {
        double distanceToCenter = GeoUtils.calculateDistance(
            mapCenter.latitude, mapCenter.longitude,
            mainCluster.centroid.latitude, mainCluster.centroid.longitude
        );
        print("Checking if can Auto-collapse NEARBY main cluster '${mainCluster.id} ${mainCluster.isExpanded}' due to zoom out ($currentZoom). Dist: $distanceToCenter km");
        if (mainCluster.isExpanded) {
          if (distanceToCenter <= MAX_DISTANCE_FOR_AUTO_ACTION_KM) {
            print("Auto-collapsing NEARBY main cluster '${mainCluster.id}' due to zoom out ($currentZoom). Dist: $distanceToCenter km");
            mainCluster.isExpanded = false;
            if (expandedMainClusterId == mainCluster.id) {
              expandedMainClusterId = null;
            }
            lastAutoCollapsedMainClusterId = mainCluster.id;
            visualsNeedUpdate = true;

            for (var sub in mainCluster.subClusters) {
              if (sub.isExpanded || expandedSubClusterIds.contains(sub.id)) {
                print("Auto-collapsing sub-cluster '${sub.id}' (part of main '${mainCluster.id}') due to main collapse or zoom.");
                sub.isExpanded = false;
                expandedSubClusterIds.remove(sub.id);
                lastAutoCollapsedSubClusterIds.add(sub.id);
              }
            }
          } else {
            print("Skipping auto-collapse of FAR main cluster '${mainCluster.id}'. Dist: $distanceToCenter km");
          }
        }
      }
    }

    if (currentZoom < SUB_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD) {
      List<PoiSubClusterOsm> allSubClusters = [];
      allSubClusters.addAll(looseSubClusters);
      mainPoiClusters.forEach((mc) => allSubClusters.addAll(mc.subClusters));
      allSubClusters = allSubClusters.toSet().toList();

      print('@@@@@@@@@@@ Checking ${allSubClusters
          .length} sub-clusters for auto-collapse at zoom $currentZoom');
      print(
          '@@@@@@@@@@@ expandedSubClusterIds contains: $expandedSubClusterIds');
      for (var subCluster in allSubClusters) {
        print('@@@@@@@@@@@ Sub-cluster ${subCluster.id}: isExpanded=${subCluster
            .isExpanded}, inExpandedSet=${expandedSubClusterIds.contains(
            subCluster.id)}');
        if (subCluster.isExpanded) {
          double distanceToCenter = GeoUtils.calculateDistance(
              mapCenter.latitude, mapCenter.longitude,
              subCluster.centroid.latitude, subCluster.centroid.longitude
          );

          bool partOfJustCollapsedMain = false;
          if (currentZoom < MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD) {
            // Check if this sub-cluster belongs to a main cluster that was just collapsed
            try {
              mainPoiClusters.firstWhere(
                      (mc) =>
                  mc.subClusters.any((s) =>
                  s.id == subCluster.id) && !mc.isExpanded
              );
              partOfJustCollapsedMain = true;
              print('@@@@@@@@@@@ Sub-cluster ${subCluster
                  .id} is part of a just-collapsed main cluster');
            } catch (e) {
              partOfJustCollapsedMain = false;
            }
          }

          if (distanceToCenter <= MAX_DISTANCE_FOR_AUTO_ACTION_KM) {
            if (!partOfJustCollapsedMain) {
              print("Auto-collapsing NEARBY sub-cluster '${subCluster
                  .id}' due to zoom out ($currentZoom). Dist: $distanceToCenter km");
              subCluster.isExpanded = false;
              expandedSubClusterIds.remove(subCluster.id);
              lastAutoCollapsedSubClusterIds.add(subCluster.id);
              visualsNeedUpdate = true;
            } else {
              print("Sub-cluster '${subCluster
                  .id}' already handled by main cluster collapse");
              if (expandedSubClusterIds.contains(subCluster.id)) {
                expandedSubClusterIds.remove(subCluster.id);
                if (!lastAutoCollapsedSubClusterIds.contains(subCluster.id)) {
                  lastAutoCollapsedSubClusterIds.add(subCluster.id);
                }
                visualsNeedUpdate = true;
              }
            }
          } else {
            print("Skipping auto-collapse of FAR sub-cluster '${subCluster
                .id}'. Dist: $distanceToCenter km (threshold: $MAX_DISTANCE_FOR_AUTO_ACTION_KM km)");
          }
        }
      }
    }

    // --- 2. Handle Auto-Expand (No longer checks direct screen visibility, but checks proximity to center) ---
    if (currentZoom >= MAIN_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD) {
      for (var mainCluster in mainPoiClusters) {
        debugPrint("Check if can Auto-expand MAIN cluster '${mainCluster.id} ${mainCluster.isExpanded}' due to zoom level ($currentZoom).");
        if (!mainCluster.isExpanded) {
          double distanceToCenter = GeoUtils.calculateDistance(
              mapCenter.latitude, mapCenter.longitude,
              mainCluster.centroid.latitude, mainCluster.centroid.longitude
          );
          if (distanceToCenter <= MAX_DISTANCE_FOR_AUTO_ACTION_KM) {
            debugPrint("Auto-expanding NEARBY main cluster '${mainCluster.id}' due to zoom level ($currentZoom). Dist: $distanceToCenter km");
            mainCluster.isExpanded = true;
            if (expandedMainClusterId == null) {
              expandedMainClusterId = mainCluster.id;
            }
            performSubClusteringWithinMainCluster(mainCluster);
            if (lastAutoCollapsedMainClusterId == mainCluster.id) lastAutoCollapsedMainClusterId = null;
            visualsNeedUpdate = true;

            for (var sub in mainCluster.subClusters) {
              if (!sub.isExpanded && currentZoom >= SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD) {
                // Sub-cluster's distance is implicitly handled by its parent main cluster's distance check here
                debugPrint("Auto-expanding sub-cluster '${sub.id}' (part of NEARBY main '${mainCluster.id}') due to main expand & zoom.");
                sub.isExpanded = true;
                expandedSubClusterIds.add(sub.id);
                lastAutoCollapsedSubClusterIds.remove(sub.id);
              }
            }
          } else {
            print("Skipping auto-expand of FAR main cluster '${mainCluster.id}'. Dist: $distanceToCenter km");
          }
        }
      }
    }

    if (currentZoom >= SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD) {
      List<PoiSubClusterOsm> allPotentiallyExpandableSubClusters = [];
      allPotentiallyExpandableSubClusters.addAll(looseSubClusters.where((sc) => !sc.isExpanded));
      for (var mainCluster in mainPoiClusters) {
        if (mainCluster.isExpanded) { // Only from already (or just now) expanded main clusters
          allPotentiallyExpandableSubClusters.addAll(mainCluster.subClusters.where((sc) => !sc.isExpanded));
        }
      }
      allPotentiallyExpandableSubClusters = allPotentiallyExpandableSubClusters.toSet().toList();

      for (var subCluster in allPotentiallyExpandableSubClusters) {
        if (!subCluster.isExpanded) { // Check again, might have been expanded by parent loop
          double distanceToCenter = GeoUtils.calculateDistance(
              mapCenter.latitude, mapCenter.longitude,
              subCluster.centroid.latitude, subCluster.centroid.longitude
          );
          if (distanceToCenter <= MAX_DISTANCE_FOR_AUTO_ACTION_KM) {
            print("Auto-expanding NEARBY sub-cluster '${subCluster.id}' by zoom level ($currentZoom). Dist: $distanceToCenter km");
            subCluster.isExpanded = true;
            expandedSubClusterIds.add(subCluster.id);
            lastAutoCollapsedSubClusterIds.remove(subCluster.id);
            visualsNeedUpdate = true;
          } else {
            print("Skipping auto-expand of FAR sub-cluster '${subCluster.id}'. Dist: $distanceToCenter km");
          }
        }
      }
    }

    // Cleanup logic (remains the same)
    if (expandedMainClusterId != null) {
      PoiClusterOsm? cluster;
      try {
        cluster = mainPoiClusters.firstWhere((c) => c.id == expandedMainClusterId);
      } catch (e) {
        print('@@@@@@@@@@@@ mainPoiClusters.firstWhere failed: $e');
      }
      if (cluster?.isExpanded == false) {
        expandedMainClusterId = null;
        final firstActuallyExpanded = mainPoiClusters.firstWhere((c) => c.isExpanded);
        expandedMainClusterId = firstActuallyExpanded.id;
      }
    }
    Set<String> validExpandedSubClusterIds = {};
    List<PoiSubClusterOsm> allSubClustersForSync = [];
    allSubClustersForSync.addAll(looseSubClusters);
    mainPoiClusters.forEach((mc) => allSubClustersForSync.addAll(mc.subClusters));
    debugPrint('@@@@@@@@@ allSubClustersForSync ${allSubClustersForSync}');
    for(var sub in allSubClustersForSync) {
      if (sub.isExpanded) {
        validExpandedSubClusterIds.add(sub.id);
      }
    }
    if (expandedSubClusterIds.length != validExpandedSubClusterIds.length
        || !expandedSubClusterIds.containsAll(validExpandedSubClusterIds)) {
      expandedSubClusterIds = validExpandedSubClusterIds;
      visualsNeedUpdate = true;
    }

    debugPrint('@@@@@@@@@@ try emit MapOperationsClusterUpdateSuccess ${visualsNeedUpdate}');
    if (visualsNeedUpdate && emitUpdate) {
      emit(MapOperationsClusterUpdateSuccess(currentZoom));
    }
  }

  void reset() {
    expandedMainClusterId = null;
    expandedSubClusterIds.clear();
    lastAutoCollapsedMainClusterId = null;
    lastAutoCollapsedSubClusterIds.clear();
    // Reset clustering tracking
    _lastClusteredPoiIds = [];
    _lastClusteringZoom = -1.0;
  }

  /// Check if two lists of POIs are different
  /// Returns true if the POIs have changed (different count or different user IDs)
  static bool havePoisChanged(List<PointOfInterest> newPois, List<PointOfInterest> oldPois) {
    // Different lengths means they've changed
    if (newPois.length != oldPois.length) return true;

    // If both are empty, nothing changed
    if (newPois.isEmpty && oldPois.isEmpty) return false;

    // Compare POI user IDs and match scores in order
    for (int i = 0; i < newPois.length; i++) {
      if (newPois[i].profile.userId != oldPois[i].profile.userId) {
        return true;
      }
      // Also check if match relevancy score changed (for keyword search refresh)
      final newScore = newPois[i].matchRelevancyScore ?? 0.0;
      final oldScore = oldPois[i].matchRelevancyScore ?? 0.0;
      if ((newScore - oldScore).abs() > 0.0001) { // Small tolerance for float comparison
        return true;
      }
    }

    return false;
  }

  /// Check if main clustering should be performed based on POI changes and zoom level
  bool shouldPerformMainClustering(List<PointOfInterest> pois, double currentZoom) {
    if (_lastClusteredPoiIds.isEmpty) {
      return true;
    }

    // Get current POI IDs
    final currentPoiIds = pois.map((poi) => poi.profile.userId).toList()..sort();

    // Check if POIs have changed (different set or different count)
    if (currentPoiIds.length != _lastClusteredPoiIds.length) {
      logDebug('@@@@@@@@@ POI count changed: ${_lastClusteredPoiIds.length} -> ${currentPoiIds.length}');
      return true;
    }

    // Check if any POI IDs are different
    for (int i = 0; i < currentPoiIds.length; i++) {
      if (currentPoiIds[i] != _lastClusteredPoiIds[i]) {
        logDebug('@@@@@@@@@ POI set changed');
        return true;
      }
    }

    // Check if zoom level has changed significantly (more than 1.0 level)
    // Increased threshold to avoid re-clustering on small zoom changes
    if ((_lastClusteringZoom - currentZoom).abs() > 0.5) {
      logDebug('@@@@@@@@@ Zoom changed significantly: $_lastClusteringZoom -> $currentZoom');
      return true;
    }

    // POIs and zoom are essentially the same, skip clustering
    return false;
  }

  /// Update tracking variables after performing main clustering
  void updateClusteringTracking(List<PointOfInterest> pois, double zoom) {
    _lastClusteredPoiIds = pois.map((poi) => poi.profile.userId).toList()..sort();
    _lastClusteringZoom = zoom;
  }

  /// Reset clustering tracking (e.g., when zooming past clustering threshold)
  void resetClusteringTracking() {
    _lastClusteredPoiIds = [];
    _lastClusteringZoom = -1.0;
    individualPois = [];
  }

  /// Get the last zoom level used for clustering
  double getLastClusteringZoom() => _lastClusteringZoom;

  /// Calculates which POIs are truly individual (not part of any cluster)
  /// by filtering out POIs that are already rendered in clusters
  List<PointOfInterest> calculateTrulyIndividualPois(List<PointOfInterest> allPois) {
    Set<String> renderedPoiIds = {};

    debugPrint('@@@@@@@@@@@ Calculating truly individual POIs...');
    // Collect all POIs that have been rendered (either as individual or in clusters)
    for (var mc in mainPoiClusters) {
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
    for (var sc in looseSubClusters) {
      for (var p in sc.pois) {
        renderedPoiIds.add(p.profile.userId);
      }
    }

    List<PointOfInterest> trulyIndividualPois =
    allPois.where((p) => !renderedPoiIds.contains(p.profile.userId)).toList();

    debugPrint('@@@@@@@@@@@ Truly individual POIs: ${trulyIndividualPois.length}');
    return trulyIndividualPois;
  }

  /// Finds the closest item (POI, main cluster, or sub-cluster) to a tapped point
  /// Returns a record with (closestItem, distance in km)
  /// Returns null if no items exist
  (dynamic, double)? findClosestItemToPoint(
      GeoPoint tappedPoint,
      List<PointOfInterest>? additionalPois,
      ) {
    double minDistance = double.infinity;
    dynamic closestItem;

    void checkItem(dynamic item, GeoPoint itemLocation) {
      final distance = GeoUtils.calculateDistance(
        tappedPoint.latitude,
        tappedPoint.longitude,
        itemLocation.latitude,
        itemLocation.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestItem = item;
      }
    }

    // Iterate through all potentially visible items
    for (var mainCluster in mainPoiClusters) {
      if (!mainCluster.isExpanded) {
        // Main cluster is collapsed - check its centroid
        checkItem(mainCluster, mainCluster.centroid);
        // Also check sub-clusters that are rendered as markers at low zoom
        // (these are visually shown even when main cluster is collapsed)
        for (var subCluster in mainCluster.subClusters) {
          if (subCluster.pois.length >= MIN_POIS_FOR_SUB_CLUSTER_DISPLAY) {
            checkItem(subCluster, subCluster.centroid);
          }
        }
      } else {
        for (var subCluster in mainCluster.subClusters) {
          if (!subCluster.isExpanded) {
            checkItem(subCluster, subCluster.centroid);
          } else {
            for (var poi in subCluster.pois) {
              checkItem(
                poi,
                GeoPoint(
                  latitude: poi.profile.latitude ?? 0.0,
                  longitude: poi.profile.longitude ?? 0.0,
                ),
              );
            }
          }
        }
        for (var poi in mainCluster.individualPoisWithinExpandedCluster) {
          checkItem(
            poi,
            GeoPoint(
              latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0,
            ),
          );
        }
      }
    }

    for (var looseSubCluster in looseSubClusters) {
      if (!looseSubCluster.isExpanded) {
        checkItem(looseSubCluster, looseSubCluster.centroid);
      } else {
        for (var poi in looseSubCluster.pois) {
          checkItem(
            poi,
            GeoPoint(
              latitude: poi.profile.latitude ?? 0.0,
              longitude: poi.profile.longitude ?? 0.0,
            ),
          );
        }
      }
    }

    for (var poi in individualPois) {
      checkItem(
        poi,
        GeoPoint(
          latitude: poi.profile.latitude ?? 0.0,
          longitude: poi.profile.longitude ?? 0.0,
        ),
      );
    }

    // Check additional POIs (e.g., initial POIs passed to the map)
    if (additionalPois != null) {
      for (var poi in additionalPois) {
        checkItem(
          poi,
          GeoPoint(
            latitude: poi.profile.latitude ?? 0.0,
            longitude: poi.profile.longitude ?? 0.0,
          ),
        );
      }
    }

    if (closestItem == null) return null;
    return (closestItem, minDistance);
  }

  /// Creates a marker icon for a main cluster
  MarkerIcon createMainClusterMarker(PoiClusterOsm cluster) {
    return ClusterMarkerWidget.createMainClusterMarker(
      poiCount: cluster.allPoisInCluster.length,
    );
  }

  /// Creates a marker icon for a sub cluster
  MarkerIcon createSubClusterMarker(PoiSubClusterOsm cluster) {
    return ClusterMarkerWidget.createSubClusterMarker(
        poiCount: cluster.pois.length
    );
  }

  /// Creates a marker icon for when no users are nearby
  /// [svgString] - the SVG content loaded from assets
  /// [devicePixelRatio] - optional pixel ratio for sharp rendering on high-DPI screens
  MarkerIcon createNoUsersMarker(String svgString) {
    final markerSize = AppDimensions.mapPoiMarkerSize * (kIsWeb ? 0.5 : 1.0);

    return MarkerIcon(
      iconWidget: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgUtils.buildSharpSvg(
            svgString: svgString,
            width: markerSize * 2,
            height: markerSize * 2,
            devicePixelRatio: 1,
            fit: BoxFit.contain,
            clipBehavior: kIsWeb ? Clip.antiAlias : Clip.none,
            key: const ValueKey('no_users_marker'),
            allowDrawingOutsideViewBox: false,
          ),
          // Red question mark overlay icon
          Positioned(
            top: (markerSize * 2 * 0.1),
            right: (markerSize * 2 * 0.1),
            child: Container(
              width: markerSize * 0.8,
              height: markerSize * 0.8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: markerSize * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MarkerIcon createPlainSvgMarker(String svgString) {
    final markerSize = AppDimensions.mapPoiMarkerSize * (kIsWeb ? 0.5 : 0.3);
    return MarkerIcon(
      iconWidget:
      SvgUtils.buildSharpSvg(
        svgString: svgString,
        width: markerSize * 2,
        height: markerSize * 2,
        devicePixelRatio: 1,
        fit: BoxFit.contain,
        clipBehavior: kIsWeb ? Clip.antiAlias : Clip.none,
        key: const ValueKey('no_users_marker'),
        allowDrawingOutsideViewBox: false,
      ),
    );
  }

}