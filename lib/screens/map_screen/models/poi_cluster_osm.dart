import 'package:barter_app/screens/map_screen/models/poi_sub_cluster_osm.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../models/map/point_of_interest.dart';

class PoiClusterOsm {
  final String id;
  final GeoPoint centroid;
  final List<PointOfInterest> allPoisInCluster;
  List<PoiSubClusterOsm> subClusters = [];
  List<PointOfInterest> individualPoisWithinExpandedCluster = [];
  bool isExpanded;

  PoiClusterOsm({
    required this.id,
    required this.centroid,
    required this.allPoisInCluster,
    this.isExpanded = false,
  });
}