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
  static const double SUB_CLUSTER_AUTO_EXPAND_ZOOM_THRESHOLD = 16.0;
  static const double MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD = 13.5;
  static const double SUB_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD = 15.5;

  List<PoiClusterOsm> mainPoiClusters = [];
  List<PoiSubClusterOsm> looseSubClusters = [];
  List<PointOfInterest> individualPois = [];

  String? lastAutoCollapsedMainClusterId;
  Set<String> lastAutoCollapsedSubClusterIds = {};

  MapOperationsCubit() : super(MapOperationsInitial());

  void performMainClustering(List<PointOfInterest> _allPois) {
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
        bool isCurrentlyExpanded = expandedMainClusterId == clusterId;

        var mainCluster = PoiClusterOsm(
          id: clusterId,
          centroid: centroid,
          allPoisInCluster: List.from(currentMainClusterGroup),
          isExpanded: isCurrentlyExpanded,
        );
        if (isCurrentlyExpanded) {
          performSubClusteringWithinMainCluster(mainCluster);
        }
        // mainCluster.isExpanded = false?
        newMainClusters.add(mainCluster);
      } else {
        poisNotFormingMainClusters.addAll(currentMainClusterGroup);
      }
    }

    mainPoiClusters = newMainClusters;
    final result = _performSubClustering(poisNotFormingMainClusters, "loose_sub_");
    looseSubClusters = result.$1;
    individualPois = result.$2;

    emit(MapOperationsClusterUpdateSuccess(currentZoom));
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

        newSubClusters.add(PoiSubClusterOsm(
          id: subClusterId,
          centroid: centroid,
          pois: List.from(currentSubClusterGroup),
          isExpanded: expandedSubClusterIds.contains(subClusterId),
        ));
      } else {
        individualPoisAfterSub.addAll(currentSubClusterGroup);
      }
    }
    return (newSubClusters, individualPoisAfterSub);
  }


  Future<void> handleZoomBasedClusterChanges(MapController _mapController) async {
    bool visualsNeedUpdate = false;
    final BoundingBox? currentBounds = await _mapController.bounds;
    if (currentBounds == null) return;

    final mapCenter = await _mapController.centerMap;

    print('@@@@@@@@@@@@@ currentZoom ${currentZoom} @@@@@@@@@@@@@');
    // --- 1. Handle Auto-Collapse ---
    if (currentZoom < MAIN_CLUSTER_AUTO_COLLAPSE_ZOOM_THRESHOLD) {
      for (var mainCluster in mainPoiClusters) {
        if (mainCluster.isExpanded) {
          double distanceToCenter = GeoUtils.calculateDistance(
              mapCenter.latitude, mapCenter.longitude,
              mainCluster.centroid.latitude, mainCluster.centroid.longitude
          );
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
        if (!mainCluster.isExpanded) {
          double distanceToCenter = GeoUtils.calculateDistance(
              mapCenter.latitude, mapCenter.longitude,
              mainCluster.centroid.latitude, mainCluster.centroid.longitude
          );
          if (distanceToCenter <= MAX_DISTANCE_FOR_AUTO_ACTION_KM) {
            print("Auto-expanding NEARBY main cluster '${mainCluster.id}' due to zoom level ($currentZoom). Dist: $distanceToCenter km");
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
                print("Auto-expanding sub-cluster '${sub.id}' (part of NEARBY main '${mainCluster.id}') due to main expand & zoom.");
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
    print('@@@@@@@@@ allSubClustersForSync ${allSubClustersForSync}');
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

    print('@@@@@@@@@@ try emit MapOperationsClusterUpdateSuccess ${visualsNeedUpdate}');
    if (visualsNeedUpdate) {
      emit(MapOperationsClusterUpdateSuccess(currentZoom));
    }
  }

  void reset() {
    expandedMainClusterId = null;
    expandedSubClusterIds.clear();
    lastAutoCollapsedMainClusterId = null;
    lastAutoCollapsedSubClusterIds.clear();
  }

}