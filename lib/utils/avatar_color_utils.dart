import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class for calculating avatar colors based on user attributes
class AvatarColorUtils {
  /// Determines the dominant color from a list of UI style hints
  /// Returns a color based on the most common color hint and an optional relevancy score
  ///
  /// Parameters:
  /// - [profileKeywordDataMap]: Optional map of keywords to relevancy scores.
  ///   Keys matching color categories (GREEN, RED, YELLOW, ORANGE, TEAL, PURPLE, BLUE)
  ///   will boost their respective color counts based on relevancy:
  ///   - Score >= 0.9: +2 to color count
  ///   - Score >= 0.7: +1 to color count
  static Color getDominantColorFromAttributes({
    required List<String>? attributes,
    double? relevancyScore,
    Map<String, double>? profileKeywordDataMap,
  }) {
    if (attributes == null || attributes.isEmpty) {
      return Colors.grey.shade100.withValues(alpha: 0.5);
    }

    // Join all attributes and count color occurrences
    final attributesString = attributes.join(", ");
    var mG = (attributesString.split("GREEN").length) - 1;
    var mR = (attributesString.split("RED").length) - 1;
    var mY = (attributesString.split("YELLOW").length) - 1;
    var mO = (attributesString.split("ORANGE").length) - 1;
    var mT = (attributesString.split("TEAL").length) - 1;
    var mP = (attributesString.split("PURPLE").length) - 1;
    var mB = (attributesString.split("BLUE").length) - 1;

    // Boost color counts based on profileKeywordDataMap relevancy scores
    if (profileKeywordDataMap != null && profileKeywordDataMap.isNotEmpty) {
      int idx = 0;
      profileKeywordDataMap.forEach((keyword, score) {
        int boost = 0;

        if (score >= 0.9) {
          boost = 2;
        } else if (score >= 0.7) {
          boost = 1;
        }

        if (boost > 0) {
          if (idx == 0) {
            mG += boost;
          } else if (idx == 1) {
            mR += boost;
          } else if (idx == 2) {
            mB += boost;
          } else if (idx == 3) {
            mP += boost;
          } else if (idx == 4) {
            mY += boost;
          } else if (idx == 5) {
            mO += boost;
          } else if (idx == 6) {
            mT += boost;
          }
        }
        idx++;
      });
    }

    final domColor = max(mG, max(mR, max(mY, max(mO, max(mT, max(mP, mB))))));

    // Determine color shade based on relevancy score
    // Top 5% = shade300, Top 30% = shade200, Rest = shade100
    int colorShade = 50;
    if (relevancyScore != null && relevancyScore != 1.0) {
      if (relevancyScore >= 0.85) {
        colorShade = 200;
      } else if (relevancyScore >= 0.75) {
        colorShade = 100;
      }
    }

    // Select the dominant color
    MaterialColor baseColor;
    if (mG == domColor) {
      baseColor = Colors.green;
    } else if (mR == domColor) {
      baseColor = Colors.red;
    } else if (mY == domColor) {
      baseColor = Colors.yellow;
    } else if (mO == domColor) {
      baseColor = Colors.orange;
    } else if (mT == domColor) {
      baseColor = Colors.teal;
    } else if (mP == domColor) {
      baseColor = Colors.purple;
    } else if (mB == domColor) {
      baseColor = Colors.blue;
    } else {
      return Colors.grey.shade100.withValues(alpha: 0.5);
    }

    return _getColorShade(baseColor, colorShade);
  }

  /// Gets a consistent color from a string (e.g., userId)
  /// Useful for generating unique but consistent colors for users
  static Color getColorFromString(String str) {
    final hash = str.hashCode;
    final colorOptions = [
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.blue,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];

    final selectedColor = colorOptions[hash.abs() % colorOptions.length];
    return selectedColor.shade300.withValues(alpha: 0.5);
  }

  /// Helper method to get color shade with alpha based on the shade level
  static Color _getColorShade(MaterialColor color, int shade) {
    switch (shade) {
      case 400:
        return color.shade400.withValues(alpha: 0.5);
      case 300:
        return color.shade300.withValues(alpha: 0.5);
      case 200:
        return color.shade200.withValues(alpha: 0.5);
      case 100:
      default:
        return color.shade100.withValues(alpha: 0.5);
    }
  }

  /// Loads an SVG from assets and replaces a default color with the specified color
  /// 
  /// Parameters:
  /// - [assetPath]: Path to the SVG asset
  /// - [replacementColor]: The color to use instead of the default
  /// - [defaultColorHex]: The default color hex to replace (defaults to '#ffd4a3')
  static Future<String> loadAndColorSvg({
    required String assetPath,
    required Color replacementColor,
    String defaultColorHex = '#ffd4a3',
  }) async {
    final svgString = await rootBundle.loadString(assetPath);

    // Convert color to hex
    final colorHex = '#${replacementColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    // Replace the default color with the new color
    final modifiedSvg = svgString.replaceAll(defaultColorHex, colorHex);

    return modifiedSvg;
  }

  /// Loads an SVG and colors it based on user attributes
  /// 
  /// This is a convenience method that combines [getDominantColorFromAttributes]
  /// and [loadAndColorSvg]
  /// 
  /// Parameters:
  /// - [profileKeywordDataMap]: Optional map of keywords to relevancy scores.
  ///   Keys matching color categories (GREEN, RED, YELLOW, ORANGE, TEAL, PURPLE, BLUE)
  ///   will boost their respective color counts based on relevancy:
  ///   - Score >= 0.9: +2 to color count
  ///   - Score >= 0.7: +1 to color count
  static Future<String> loadAndColorSvgFromAttributes({
    required String assetPath,
    required List<String>? attributes,
    double? relevancyScore,
    Map<String, double>? profileKeywordDataMap,
    String defaultColorHex = '#ffd4a3',
  }) async {
    final color = getDominantColorFromAttributes(
      attributes: attributes,
      relevancyScore: relevancyScore,
      profileKeywordDataMap: profileKeywordDataMap,
    );

    return loadAndColorSvg(
      assetPath: assetPath,
      replacementColor: color,
      defaultColorHex: defaultColorHex,
    );
  }

  /// Loads an SVG and colors it based on a string (e.g., userId)
  /// 
  /// This is a convenience method that combines [getColorFromString]
  /// and [loadAndColorSvg]
  static Future<String> loadAndColorSvgFromString({
    required String assetPath,
    required String identifier,
    String defaultColorHex = '#ffd4a3',
  }) async {
    final color = getColorFromString(identifier);

    return loadAndColorSvg(
      assetPath: assetPath,
      replacementColor: color,
      defaultColorHex: defaultColorHex,
    );
  }
}
