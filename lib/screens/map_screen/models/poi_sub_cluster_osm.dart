import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../models/map/point_of_interest.dart';

class PoiSubClusterOsm {
  final String id;
  final GeoPoint centroid;
  final List<PointOfInterest> pois;
  bool isExpanded;

  PoiSubClusterOsm({
    required this.id,
    required this.centroid,
    required this.pois,
    this.isExpanded = false,
  });
}