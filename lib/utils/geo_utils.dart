
import 'dart:math';

class GeoUtils {

  static double calculateDistance(double lat1,
      double lon1,
      double lat2,
      double lon2) {
    const R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double deg2rad(deg) {
    return deg * (pi / 180);
  }

}