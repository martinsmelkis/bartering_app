import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:barter_app/widgets/online_status_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget class for creating POI markers on the map
class PoiMarkerWidget {
  // Avatar SVG assets (dynamically generated)
  static const int _svgAssetCount = 29;

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/path$index.svg';

  /// Creates a marker icon for a POI
  static Future<MarkerIcon> createMarker({
    required PointOfInterest poi,
    required List<ParsedAttributeData>? userInterests,
    required List<ParsedAttributeData>? userOfferings,
  }) async {
    // Use the POI's userId to get a consistent random icon
    final userIdHashCode = poi.profile.userId.hashCode;
    logDebug('@@@@@@@@@@ Creating POI marker for ${poi.profile.userId}, hashCode: $userIdHashCode');
    final index = userIdHashCode.abs() % _svgAssetCount;
    final selectedIconPath = _getSvgAsset(index + 1); // 1-based index

    // Load SVG without color modification
    final svgString = await rootBundle.loadString(selectedIconPath);
    final localSvgCopy = String.fromCharCodes(svgString.runes);

    // Check if there's a match between user interests/offerings and POI offerings/interests
    final hasMatch = TextUtils.checkForAttributeBarterMatch(poi, userInterests, userOfferings);

    // Determine relevance tier based on matchRelevancyScore
    final relevancyScore = poi.matchRelevancyScore ?? 0.0;
    final isHighRelevance = relevancyScore >= 0.70;

    // Debug: Always log relevancy score to diagnose issues
    logDebug('@@@@@@@@@@ POI ${poi.profile.userId} RAW matchRelevancyScore: ${poi.matchRelevancyScore} (${(relevancyScore * 100).toStringAsFixed(1)}%)');

    // Calculate sizes for circle
    final strokeWidth = kIsWeb ? 7.2 : 12.6;
    final circleSize = AppDimensions.mapPoiMarkerSize;
    final gap = strokeWidth + 2;
    final svgSize = circleSize - gap;

    // Calculate gradient glow color and alpha based on relevance score (70% - 100%)
    Color? glowColor;
    double glowAlpha = 0.3;
    
    if (isHighRelevance) {
      // Map relevance from 0.70-1.0 range to 0.0-1.0 range for interpolation
      // Formula: (score - min) / (max - min) = (score - 0.70) / (1.0 - 0.70)
      final rawNormalized = (relevancyScore - 0.70) / 0.30;
      var normalizedScore = rawNormalized.clamp(0.0, 1.0);
      
      // Debug calculation
      logDebug('@@@@@@@@@@ NORMALIZATION: score=$relevancyScore, raw=(score-0.70)/0.30=$rawNormalized, clamped=$normalizedScore');
      
      // Tiered boost system to make higher scores stand out more
      double colorBoost = 1.0;
      double alphaBoost = 1.0;
      if (relevancyScore >= 0.90) {
        // Top tier: 30% boost for scores >= 90%
        colorBoost = 1.2; // 30% more towards red
        alphaBoost = 1.2; // 30% more alpha intensity
        logDebug('@@@@@@@@@@ BOOST APPLIED: score >= 0.90, boosting by 30%');
      } else if (relevancyScore >= 0.80) {
        // Mid tier: 20% boost for scores >= 80%
        colorBoost = 1.1; // 20% more towards red
        alphaBoost = 1.1; // 20% more alpha intensity
        logDebug('@@@@@@@@@@ BOOST APPLIED: score >= 0.80, boosting by 20%');
      }
      
      // Apply color boost: push normalized score closer to 1.0 for redder color
      final boostedColorScore = (normalizedScore * colorBoost).clamp(0.0, 0.9);
      
      // Interpolate color from AppColors.primary to Colors.redAccent
      glowColor = Color.lerp(Colors.orange.shade500, Colors.deepOrange.shade400, boostedColorScore);
      
      // Interpolate alpha from 0.3 to 0.6, then apply boost
      final baseAlpha = 0.3 + (normalizedScore * 0.3); // 0.3 to 0.6
      glowAlpha = (baseAlpha * alphaBoost).clamp(0.3, 0.8); // Boost but cap at 0.9
      
      logDebug('@@@@@@@@@@ RESULT: boostedColor=$boostedColorScore, color=$glowColor, alpha=${glowAlpha.toStringAsFixed(3)}');
    }

    // Create the base marker widget
    Widget baseMarker = Stack(
      clipBehavior: Clip.none,
      children: [
        // Glow effect for relevant POIs
        if (glowColor != null)
          Positioned(
            left: kIsWeb ? 18 : 38,
            top: kIsWeb ? 18 : 38,
            child: Container(
              width: circleSize - circleSize / (kIsWeb ? 2.5 : 2.4),
              height: circleSize - circleSize / (kIsWeb ? 2.5 : 2.4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: glowAlpha),
                    blurRadius: kIsWeb ? 3 : 4,
                    spreadRadius: kIsWeb ? 3 : 4,
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
          gapWidth: kIsWeb ? 1.2 : 1.0,
          child: ClipOval(
            child: SvgPicture.string(
              localSvgCopy,
              width: svgSize,
              height: svgSize,
              fit: BoxFit.contain,
              allowDrawingOutsideViewBox: false,
              placeholderBuilder: (context) => Container(
                width: svgSize,
                height: svgSize,
                color: Colors.grey.shade200,
              ),
              key: ValueKey('poi_marker_${poi.profile.userId}'),
            ),
          ),
        ),
        // Online status badge - positioned closer to the edge
        PositionedOnlineStatusBadge(
          isOnline: poi.isOnline,
          isAway: poi.isAway,
          size: kIsWeb ? 14.4 : 26.25,
          right: kIsWeb ? 14.4 : 34.65,
          top: kIsWeb ? 14.4 : 34.65,
          borderWidth: kIsWeb ? 3.0 : 2.625,
        ),
        // Match indicator - positioned at bottom right
        if (hasMatch)
          Positioned(
            right: kIsWeb ? 14.4 : 26.25,
            bottom: kIsWeb ? 14.4 : 26.25,
            child: Container(
              width: kIsWeb ? 21.6 : 44.1,
              height: kIsWeb ? 21.6 : 44.1,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: kIsWeb ? 1.2 : 2.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: kIsWeb ? 1.92 : 4.2,
                    offset: Offset(0, kIsWeb ? 1.2 : 2.1),
                  ),
                ],
              ),
              child: Icon(
                Icons.handshake,
                size: kIsWeb ? 18 : 31.5,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );

    return MarkerIcon(
      iconWidget: baseMarker,
    );
  }
}
