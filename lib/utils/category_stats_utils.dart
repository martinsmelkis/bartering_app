import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Utility class for calculating and displaying category statistics
class CategoryStatsUtils {
  /// Color mapping for categories based on position (matching avatar_color_utils logic)
  /// idx 0=GREEN, 1=RED, 2=BLUE, 3=PURPLE, 4=YELLOW, 5=ORANGE, 6=TEAL
  static const List<Color> categoryColors = [
    Color(0xFF66BB6A), // Colors.green.shade400
    Color(0xFFE57373), // Colors.red.shade300
    Color(0xFF42A5F5), // Colors.blue.shade400
    Color(0xFFBA68C8), // Colors.purple.shade300
    Color(0xFFFDD835), // Colors.yellow.shade600
    Color(0xFFFFB74D), // Colors.orange.shade400
    Color(0xFF26A69A), // Colors.teal.shade400
  ];

  /// Calculates color weights from profileKeywordDataMap
  /// Returns a list of all 7 color-weight pairs based on keyword relevancy scores
  /// Handles negative weights by normalizing them proportionally
  static List<MapEntry<Color, double>> calculateColorWeights(
    Map<String, double>? keywordMap,
  ) {
    // Always create weights for all 7 categories
    final List<double> weights = List.filled(7, 0.0);
    
    // Extract weights from keywordMap
    if (keywordMap != null && keywordMap.isNotEmpty) {
      int idx = 0;
      for (var entry in keywordMap.entries) {
        if (idx < 7) {
          weights[idx] = entry.value;
        }
        idx++;
      }
    }

    // Find the minimum weight
    final minWeight = weights.reduce((a, b) => a < b ? a : b);

    // If there are negative weights, shift all weights to make them positive
    final double offset = minWeight < 0 ? minWeight.abs() : 0.0;
    
    // Apply offset to all weights and create color-weight pairs
    final List<MapEntry<Color, double>> colorWeights = [];
    for (int i = 0; i < 7; i++) {
      final adjustedWeight = weights[i] + offset;
      // Use a minimum weight of 0.01 to ensure all categories are visible
      final displayWeight = adjustedWeight > 0 ? adjustedWeight : 0.01;
      colorWeights.add(MapEntry(categoryColors[i], displayWeight));
    }

    return colorWeights;
  }

  /// Builds a widget displaying a colored bar representing category distribution
  /// Each segment's width is proportional to its category's weight/relevancy
  /// Always displays all 7 categories, even if keywordMap is null or empty
  static Widget buildCategoryStatsBar({
    required Map<String, double>? keywordMap,
    double height = 4.0,
    double borderRadius = 2.0,
    Widget? fallbackWidget,
  }) {
    final colorWeights = calculateColorWeights(keywordMap);

    // Calculate total weight for normalization
    final totalWeight = colorWeights.fold<double>(
      0.0,
      (sum, entry) => sum + entry.value,
    );

    // If total weight is 0 or invalid, show fallback
    if (totalWeight <= 0) {
      return fallbackWidget ?? const Divider();
    }

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          children: colorWeights.map((entry) {
            final percentage = entry.value / totalWeight;
            final flex = (percentage * 1000).round();
            // Ensure a minimum flex value of 1 to show all categories
            return Flexible(
              flex: flex > 0 ? flex : 1,
              child: Container(
                color: entry.key,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds a widget displaying a colored circular border around an avatar
  /// Each segment's arc length is proportional to its category's weight/relevancy
  /// Always displays all 7 categories, even if keywordMap is null or empty
  static Widget buildCategoryStatsCircle({
    required Map<String, double>? keywordMap,
    required Widget child,
    double size = 80.0,
    double strokeWidth = 4.0,
    double gapWidth = 2.0,
  }) {
    final colorWeights = calculateColorWeights(keywordMap);

    // Calculate total weight for normalization
    final totalWeight = colorWeights.fold<double>(
      0.0,
      (sum, entry) => sum + entry.value,
    );

    // If total weight is 0 or invalid, show child without border
    if (totalWeight <= 0) {
      return SizedBox(
        width: size,
        height: size,
        child: child,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular border with colored segments
          CustomPaint(
            size: Size(size/2 + 5, size/2 + 5),
            painter: _CategoryCirclePainter(
              colorWeights: colorWeights,
              totalWeight: totalWeight,
              strokeWidth: strokeWidth,
              gapWidth: gapWidth,
            ),
          ),
          // Avatar/child centered inside
          SizedBox(
            width: size - (strokeWidth * 2) - 4,
            height: size - (strokeWidth * 2) - 4,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing the circular category border
class _CategoryCirclePainter extends CustomPainter {
  final List<MapEntry<Color, double>> colorWeights;
  final double totalWeight;
  final double strokeWidth;
  final double gapWidth;

  _CategoryCirclePainter({
    required this.colorWeights,
    required this.totalWeight,
    required this.strokeWidth,
    required this.gapWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Start from the top (-90 degrees in radians)
    double startAngle = -math.pi / 2;
    
    // Calculate total gap angle to subtract from full circle
    final gapAngle = (gapWidth / (2 * math.pi * radius)) * 2 * math.pi;
    final totalGapAngle = gapAngle * colorWeights.length;
    final effectiveCircleAngle = 2 * math.pi - totalGapAngle;

    for (final entry in colorWeights) {
      final percentage = entry.value / totalWeight;
      final sweepAngle = effectiveCircleAngle * percentage;

      final paint = Paint()
        ..color = entry.key
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Move to next segment (including gap)
      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryCirclePainter oldDelegate) {
    return oldDelegate.colorWeights != colorWeights ||
        oldDelegate.totalWeight != totalWeight ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapWidth != gapWidth;
  }
}
