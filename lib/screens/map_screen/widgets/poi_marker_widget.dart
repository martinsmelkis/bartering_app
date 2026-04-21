import 'dart:convert';
import 'dart:math';

import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/avatar_icon_utils.dart';
import 'package:barter_app/utils/category_stats_utils.dart';import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:barter_app/widgets/online_status_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget class for creating POI markers on the map
class PoiMarkerWidget {
  /// Creates a marker icon for a POI with high-resolution rendering for web
  static Future<MarkerIcon> createMarker({
    required PointOfInterest poi,
    required List<ParsedAttributeData>? userInterests,
    required List<ParsedAttributeData>? userOfferings,
  }) async {
    final profileAvatarIcon = poi.profile.profileAvatarIcon?.trim();

    // Use the POI's userId to get a consistent random icon fallback
    final userIdHashCode = poi.profile.userId.hashCode;
    logDebug('@@@@@@@@@@ Creating POI marker for ${poi.profile.userId}, hashCode: $userIdHashCode');
    final selectedIconPath = poi.profile.profileAvatarIconId != null
        ? AvatarIconUtils.assetPathFromIconId(poi.profile.profileAvatarIconId)
        : AvatarIconUtils.deterministicFallbackAssetPath(poi.profile.userId);

    // Check if there's a match between user interests/offerings and POI offerings/interests
    final hasMatch = TextUtils.checkForAttributeBarterMatch(poi, userInterests, userOfferings);

    // Determine relevance tier based on matchRelevancyScore
    final relevancyScore = poi.matchRelevancyScore ?? 0.0;
    final isHighRelevance = kIsWeb ? relevancyScore >= 0.50 : relevancyScore >= 0.70;

    // Debug: Always log relevancy score to diagnose issues
    logDebug('@@@@@@@@@@ POI ${poi.profile.userId} RAW matchRelevancyScore: ${poi.matchRelevancyScore} (${(relevancyScore * 100).toStringAsFixed(1)}%)');

    // Calculate sizes using original AppDimensions.mapPoiMarkerSize
    final circleSize = AppDimensions.mapPoiMarkerSize;
    final strokeWidth = kIsWeb ? 7.5 : 6.0;
    final gap = strokeWidth + 2;
    final svgSize = circleSize - gap;

    // Calculate gradient glow color and alpha based on relevance score
    // Web: starts at 50% with alpha 0.2, progresses to 90% with alpha 1.0
    // Native: starts at 70% with alpha 0.3, progresses to 100% with alpha ~0.85
    Color? glowColor;
    double glowAlpha = kIsWeb ? 0.2 : 0.3;

    if (isHighRelevance) {
      if (kIsWeb) {
        // Web platform: 0.50-0.90 range, alpha 0.2 to 1.0
        final normalizedScore = ((relevancyScore - 0.50) / 0.40).clamp(0.0, 1.0);
        
        logDebug('@@@@@@@@@@ WEB NORMALIZATION: score=$relevancyScore, normalized=$normalizedScore');

        // Tiered boost system
        double colorBoost = 0.7;
        double alphaBoost = 0.5;
        if (relevancyScore >= 0.80) {
          colorBoost = 1.2;
          alphaBoost = 0.9;
        } else if (relevancyScore >= 0.65) {
          colorBoost = 0.9;
          alphaBoost = 0.6;
        }

        final boostedColorScore = (normalizedScore * colorBoost).clamp(0.0, 1.0);

        // Interpolate color from orange to deep orange
        glowColor = Color.lerp(Colors.white54, Colors.orangeAccent.shade700, boostedColorScore);

        // Interpolate alpha from 0.2 to 1.0
        final baseAlpha = 0.2 + (normalizedScore * 0.8);
        glowAlpha = (baseAlpha * alphaBoost).clamp(0.2, 1.0);

        logDebug('@@@@@@@@@@ WEB RESULT: color=$glowColor, alpha=${glowAlpha.toStringAsFixed(3)}');
      } else {
        // Native platform: original 0.70-1.0 range, alpha 0.3 to ~0.85
        final rawNormalized = (relevancyScore - 0.70) / 0.30;
        var normalizedScore = rawNormalized.clamp(0.0, 1.0);

        logDebug('@@@@@@@@@@ NATIVE NORMALIZATION: score=$relevancyScore, raw=$rawNormalized, clamped=$normalizedScore');

        // Tiered boost system to make higher scores stand out more
        double colorBoost = 1.0;
        double alphaBoost = 1.0;
        if (relevancyScore >= 0.90) {
          colorBoost = 1.2;
          alphaBoost = 1.2;
          logDebug('@@@@@@@@@@ NATIVE BOOST: score >= 0.90');
        } else if (relevancyScore >= 0.80) {
          colorBoost = 1.1;
          alphaBoost = 1.1;
          logDebug('@@@@@@@@@@ NATIVE BOOST: score >= 0.80');
        }

        final boostedColorScore = (normalizedScore * colorBoost).clamp(0.0, 0.9);

        // Interpolate color from orange to deep orange
        glowColor = Color.lerp(Colors.orange.shade500, Colors.deepOrange.shade400, boostedColorScore);

        // Interpolate alpha from 0.3 to 0.6, then apply boost
        final baseAlpha = 0.3 + (normalizedScore * 0.35);
        glowAlpha = (baseAlpha * alphaBoost).clamp(0.35, 0.85);

        logDebug('@@@@@@@@@@ NATIVE RESULT: boostedColor=$boostedColorScore, color=$glowColor, alpha=${glowAlpha.toStringAsFixed(3)}');
      }
    }

    // For WEB platform: Use direct SVG string for sharp vector rendering
    // The modified flutter_osm_web plugin now supports passing SVG directly to Leaflet
    if (kIsWeb) {
      logDebug('@@@@@@@@@@ Using direct SVG for web platform');

      // Prefer backend-provided SVG avatar content, fallback to generated asset.
      String svgString;
      var isCustomProfileAvatar = false;
      if (profileAvatarIcon != null && profileAvatarIcon.isNotEmpty) {
        if (profileAvatarIcon.contains('<svg')) {
          svgString = profileAvatarIcon;
          isCustomProfileAvatar = true;
        } else if (profileAvatarIcon.startsWith('data:image/svg+xml;base64,')) {
          svgString = utf8.decode(
            base64Decode(profileAvatarIcon.split(',').last),
            allowMalformed: true,
          );
          isCustomProfileAvatar = true;
        } else {
          svgString = await rootBundle.loadString(selectedIconPath ?? 'assets/icons/avatars/path1.svg');
        }
      } else {
        svgString = await rootBundle.loadString(selectedIconPath ?? 'assets/icons/avatars/path1.svg');
      }

      // Calculate color segments for the border
      final colorWeights = CategoryStatsUtils.calculateColorWeights(
        poi.profile.profileKeywordDataMap,
        attributes: poi.profile.attributes,
      );

      // Build a composite marker SVG that includes:
      // 1. Glow effect (if high relevance)
      // 2. Colored segmented border
      // 3. Avatar in center
      // 4. Online status badge
      // 5. Match indicator (if has match)
      final compositeSvg = _buildCompositeMarkerSvg(
        avatarSvgContent: svgString,
        colorWeights: colorWeights,
        size: circleSize,
        strokeWidth: strokeWidth,
        hasMatch: hasMatch,
        glowColor: glowColor,
        glowAlpha: glowAlpha,
        isOnline: poi.isOnline,
        isAway: poi.isAway,
        useOriginalViewBox: isCustomProfileAvatar,
      );

      logDebug('@@@@@@@@@@ Returning MarkerIcon with SVG string (${compositeSvg.length} chars)');

      // Return MarkerIcon with direct SVG - the modified plugin will pass this to Leaflet
      return MarkerIcon(
        svgString: compositeSvg,
      );
    }

    // For NATIVE platforms: Use widget-based rendering with flutter_svg
    String svgString;
    var isCustomProfileAvatar = false;
    if (profileAvatarIcon != null && profileAvatarIcon.isNotEmpty) {
      if (profileAvatarIcon.contains('<svg')) {
        svgString = profileAvatarIcon;
        isCustomProfileAvatar = true;
      } else if (profileAvatarIcon.startsWith('data:image/svg+xml;base64,')) {
        svgString = utf8.decode(
          base64Decode(profileAvatarIcon.split(',').last),
          allowMalformed: true,
        );
        isCustomProfileAvatar = true;
      } else {
        svgString = await rootBundle.loadString(selectedIconPath ?? 'assets/icons/avatars/path1.svg');
      }
    } else {
      svgString = await rootBundle.loadString(selectedIconPath ?? 'assets/icons/avatars/path1.svg');
    }

    final localSvgCopy = isCustomProfileAvatar
        ? _normalizeSvgForNativeAvatar(svgString)
        : String.fromCharCodes(svgString.runes);

    // Mobile native: Use widget-based SVG rendering at high resolution
    Widget markerWidget = SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow effect for relevant POIs
          if (glowColor != null)
            Positioned(
              left: 23,
              top: 23,
              child: Container(
                width: circleSize - circleSize / 2.4,
                height: circleSize - circleSize / 2.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: glowAlpha),
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ),
          // Circular colored border around avatar based on profileKeywordDataMap and attributes
          CategoryStatsUtils.buildCategoryStatsCircle(
            keywordMap: poi.profile.profileKeywordDataMap,
            attributes: poi.profile.attributes,
            size: circleSize,
            strokeWidth: strokeWidth,
            gapWidth: 8.0,
            child: ClipOval(
              child: SvgPicture.string(
                localSvgCopy,
                width: svgSize,
                height: svgSize,
                fit: BoxFit.fill,
                clipBehavior: Clip.antiAlias,
                semanticsLabel: '${poi.profile.name} avatar',
                key: ValueKey('poi_marker_${poi.profile.userId}'),
                allowDrawingOutsideViewBox: false,
              ),
            ),
          ),
          // Online status badge - positioned closer to the edge
          PositionedOnlineStatusBadge(
            isOnline: poi.isOnline,
            isAway: poi.isAway,
            size: 21,
            right: 20,
            top: 20,
            borderWidth: 2.625,
          ),
          // Match indicator - positioned at bottom right
          if (hasMatch)
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4.2,
                      offset: Offset(0, 2.1),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.handshake,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );

    return MarkerIcon(
      iconWidget: markerWidget,
    );
  }

  /// Builds a composite SVG marker with all visual elements
  /// This creates a single SVG that contains: avatar, border, badges, and indicators
  static String _buildCompositeMarkerSvg({
    required String avatarSvgContent,
    required List<MapEntry<Color, double>> colorWeights,
    required double size,
    required double strokeWidth,
    required bool hasMatch,
    required Color? glowColor,
    required double glowAlpha,
    required bool isOnline,
    required bool isAway,
    required bool useOriginalViewBox,
  }) {
    final center = size / 2;
    final radius = (size - strokeWidth) / 2;

    // Calculate total weight for normalization
    final totalWeight = colorWeights.fold<double>(0.0, (sum, entry) => sum + entry.value);

    // Reorder color weights for SVG: GREEN, RED, BLUE, PURPLE, YELLOW, TEAL, ORANGE
    // Original order: GREEN(0), RED(1), BLUE(2), PURPLE(3), YELLOW(4), ORANGE(5), TEAL(6)
    // SVG order: GREEN(0), RED(1), BLUE(2), PURPLE(3), YELLOW(4), TEAL(6), ORANGE(5)
    // This ensures teal is not next to green, and yellow is not next to orange
    final List<MapEntry<Color, double>> reorderedWeights = List.from(colorWeights);
    if (reorderedWeights.length >= 7) {
      // Swap ORANGE (index 5) and TEAL (index 6)
      final tmp = reorderedWeights[5];
      reorderedWeights[5] = reorderedWeights[6];
      reorderedWeights[6] = tmp;
    }

    // Build segmented border path
    String borderSegments = '';
    if (totalWeight > 0) {
      double currentAngle = -90; // Start at top
      for (int i = 0; i < reorderedWeights.length; i++) {
        final entry = reorderedWeights[i];
        final percentage = entry.value / totalWeight;
        final sweepAngle = percentage * 360;

        // Calculate arc path for this segment
        final startAngle = currentAngle * 3.14159 / 180;
        final endAngle = (currentAngle + sweepAngle - 2) * 3.14159 / 180; // -2 for gap

        final x1 = center + radius * cos(startAngle);
        final y1 = center + radius * sin(startAngle);
        final x2 = center + radius * cos(endAngle);
        final y2 = center + radius * sin(endAngle);

        final largeArc = sweepAngle > 180 ? 1 : 0;

        // Add segment path
        final colorHex = _colorToHex(entry.key);
        borderSegments +=
            '<path d="M $center $center L $x1 $y1 A $radius $radius 0 $largeArc 1 $x2 $y2 Z" '
            'fill="none" stroke="$colorHex" stroke-width="$strokeWidth" stroke-linecap="round" />\n';

        currentAngle += sweepAngle;
      }
    }

    // Determine background color based on glow
    final backgroundColor = glowColor != null 
        ? _colorToHex(glowColor) 
        : '#F5F5F5';

    // Build online status badge
    String onlineBadge = '';
    if (isOnline || isAway) {
      final badgeColor = isOnline ? '#4CAF50' : '#FF9800'; // Green or Orange
      final badgeX = size - 16;
      final badgeY = 8;
      onlineBadge = '''
    <!-- Online status badge -->
    <circle cx="$badgeX" cy="$badgeY" r="10" fill="$badgeColor" stroke="white" stroke-width="2" />
''';
    }

    // Build match indicator
    String matchIndicator = '';
    if (hasMatch) {
      final matchX = size - 16;
      final matchY = size - 16;
      matchIndicator = '''
    <!-- Match indicator -->
    <circle cx="$matchX" cy="$matchY" r="15" fill="#FF6B6B" stroke="white" stroke-width="2" />
    <text x="$matchX" y="${matchY + 6}" text-anchor="middle" fill="white" font-size="20">🤝</text>
''';
    }

    // Extract avatar inner content and preserve original viewBox so custom SVGs
    // (e.g. Material icons with viewBox 0 -960 960 960) render correctly.
    final avatarViewBox = _extractSvgViewBox(avatarSvgContent);
    final avatarContent = avatarSvgContent
        .replaceAll(RegExp(r'<\?xml.*\?>'), '')
        .replaceAll(RegExp(r'<svg[^>]*>'), '')
        .replaceAll(RegExp(r'</svg>'), '')
        .replaceAll(RegExp(r'\swidth="[^"]*"'), ' ')
        .replaceAll(RegExp(r'\sheight="[^"]*"'), ' ');

    // Build final composite SVG
    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">
  
  <!-- Segmented colored border -->
  <g transform="rotate(-90 $center $center)">
    $borderSegments
  </g>
  
  <!-- Avatar circle with clip -->
  <defs>
    <clipPath id="avatarClip">
      <circle cx="$center" cy="$center" r="${radius - strokeWidth / 2}" />
    </clipPath>
  </defs>
  
  <!-- Avatar content -->
  <g clip-path="url(#avatarClip)">
    <rect x="0" y="0" width="$size" height="$size" fill="$backgroundColor" />
    ${useOriginalViewBox
        ? '<svg x="0" y="0" width="$size" height="$size" viewBox="$avatarViewBox" preserveAspectRatio="xMidYMid meet">$avatarContent</svg>'
        : '<g transform="translate(${size * -0.2}, ${size * -0.2}) scale(${size * 1.4 / 512})">$avatarContent</g>'}
  </g>
  
  $onlineBadge
  $matchIndicator
</svg>''';  }

  static String _normalizeSvgForNativeAvatar(String svg) {
    final cleaned = svg
        .replaceAll(RegExp(r'<\?xml.*\?>'), '')
        .replaceAll(RegExp(r'<svg[^>]*>'), '')
        .replaceAll(RegExp(r'</svg>'), '')
        .replaceAll(RegExp(r'\swidth="[^"]*"'), ' ')
        .replaceAll(RegExp(r'\sheight="[^"]*"'), ' ')
        .trim();

    final viewBox = _extractSvgViewBox(svg).trim().split(RegExp(r'\s+'));
    double minX = 0;
    double minY = 0;
    double vbWidth = 512;
    double vbHeight = 512;

    if (viewBox.length >= 4) {
      minX = double.tryParse(viewBox[0]) ?? 0;
      minY = double.tryParse(viewBox[1]) ?? 0;
      vbWidth = double.tryParse(viewBox[2]) ?? 512;
      vbHeight = double.tryParse(viewBox[3]) ?? 512;
    }

    final largestSide = vbWidth > vbHeight ? vbWidth : vbHeight;
    final scale = (largestSide == 0 ? 1.0 : 512 / largestSide) * 0.65;
    final scaledWidth = vbWidth * scale;
    final scaledHeight = vbHeight * scale;

    // Rebase original minX/minY (including negatives) into 0..512 canvas and center.
    final tx = ((512 - scaledWidth) / 2) - (minX * scale);
    final ty = ((512 - scaledHeight) / 2) - (minY * scale);

    return '<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512" '
        'preserveAspectRatio="xMidYMid meet">'
        '<g transform="translate($tx $ty) scale($scale)">$cleaned</g>'
        '</svg>';
  }

  static String _extractSvgViewBox(String svg) {
    final match = RegExp(r'viewBox="([^"]+)"', caseSensitive: false).firstMatch(svg);
    if (match != null) {
      return match.group(1)!;
    }

    final widthMatch = RegExp(r'width="([0-9]+(?:\.[0-9]+)?)', caseSensitive: false).firstMatch(svg);
    final heightMatch = RegExp(r'height="([0-9]+(?:\.[0-9]+)?)', caseSensitive: false).firstMatch(svg);
    final width = double.tryParse(widthMatch?.group(1) ?? '');
    final height = double.tryParse(heightMatch?.group(1) ?? '');
    if (width != null && height != null) {
      return '0 0 $width $height';
    }

    return '0 0 512 512';
  }

  /// Converts a Color to hex string
  static String _colorToHex(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}
