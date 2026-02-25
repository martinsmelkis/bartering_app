import 'dart:math';

import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

/// Widget class for creating cluster markers on the map
/// Supports both SVG-based rendering (for web) and widget-based rendering (for native)
class ClusterMarkerWidget {
  /// Creates a marker icon for a main cluster with high-resolution rendering for web
  static MarkerIcon createMainClusterMarker({
    required int poiCount,
  }) {
    final size = AppDimensions.mainClusterSize;
    final fontSize = AppDimensions.mainClusterFontSize;
    final borderWidth = AppDimensions.mainClusterBorderWidth;
    final primaryColor = Colors.orange.shade700;

    // For WEB platform: Use direct SVG string for sharp vector rendering
    if (kIsWeb) {
      final svgString = _buildMainClusterSvg(
        poiCount: poiCount,
        size: size,
        fontSize: fontSize * 1.7,
        borderWidth: borderWidth,
        primaryColor: primaryColor,
      );

      return MarkerIcon(
        svgString: svgString,
      );
    }

    // For NATIVE platforms: Use widget-based rendering
    return MarkerIcon(
      iconWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: borderWidth,
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
              fontSize: fontSize * 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a marker icon for a sub cluster with high-resolution rendering for web
  static MarkerIcon createSubClusterMarker({
    required int poiCount,
    double? devicePixelRatio,
  }) {
    final size = AppDimensions.subClusterSize;
    final fontSize = AppDimensions.subClusterFontSize;
    final borderWidth = AppDimensions.subClusterBorderWidth;
    final primaryColor = Colors.orange.shade700;

    // For WEB platform: Use direct SVG string for sharp vector rendering
    if (kIsWeb) {
      final svgString = _buildSubClusterSvg(
        poiCount: poiCount,
        size: size,
        fontSize: fontSize,
        borderWidth: borderWidth,
        primaryColor: primaryColor,
      );

      return MarkerIcon(
        svgString: svgString,
      );
    }

    // For NATIVE platforms: Use widget-based rendering
    return MarkerIcon(
      iconWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
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
              fontSize: fontSize * 1.6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an SVG string for a main cluster marker
  static String _buildMainClusterSvg({
    required int poiCount,
    required double size,
    required double fontSize,
    required double borderWidth,
    required Color primaryColor,
  }) {
    final center = size / 2;
    final radius = (size - borderWidth) / 2;
    final primaryHex = _colorToHex(primaryColor);

    // Calculate shadow offset based on size
    final shadowOffset = size * 0.06;
    final shadowBlur = size * 0.05;

    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">
  <defs>
    <!-- Drop shadow filter -->
    <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="$shadowOffset" stdDeviation="$shadowBlur" flood-color="black" flood-opacity="0.3"/>
    </filter>
  </defs>
  
  <!-- Main circle with shadow and primary color -->
  <circle cx="$center" cy="$center" r="$radius" 
          fill="$primaryHex" 
          fill-opacity="0.9"
          stroke="white" 
          stroke-width="$borderWidth"
          filter="url(#shadow)" />
  
  <!-- Text in center -->
  <text x="$center" y="$center" 
        text-anchor="middle" 
        dominant-baseline="middle"
        fill="white" 
        font-size="$fontSize"
        font-weight="bold"
        font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif">
    $poiCount
  </text>
</svg>''';
  }

  /// Builds an SVG string for a sub cluster marker
  static String _buildSubClusterSvg({
    required int poiCount,
    required double size,
    required double fontSize,
    required double borderWidth,
    required Color primaryColor,
  }) {
    final center = size / 2;
    final radius = (size - borderWidth) / 2;
    final primaryHex = _colorToHex(primaryColor);

    // Calculate shadow offset based on size
    final shadowOffset = size * 0.06;
    final shadowBlur = size * 0.06;

    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">
  <defs>
    <!-- Drop shadow filter -->
    <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="$shadowOffset" stdDeviation="$shadowBlur" flood-color="black" flood-opacity="0.4"/>
    </filter>
  </defs>
  
  <!-- Main circle with shadow and primary color -->
  <circle cx="$center" cy="$center" r="$radius" 
          fill="$primaryHex" 
          fill-opacity="0.8"
          stroke="white" 
          stroke-width="$borderWidth"
          filter="url(#shadow)" />
  
  <!-- Text in center -->
  <text x="$center" y="$center" 
        text-anchor="middle" 
        dominant-baseline="middle"
        fill="white" 
        font-size="$fontSize"
        font-weight="bold"
        font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif">
    $poiCount
  </text>
</svg>''';
  }

  /// Converts a Color to hex string
  static String _colorToHex(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}
