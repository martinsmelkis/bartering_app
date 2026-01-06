import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget that displays an avatar with a circular rating indicator around it
class RatingCircleAvatar extends StatelessWidget {
  final Widget child;
  final double? rating; // 0-5 scale
  final double size;
  final bool isLoading;

  const RatingCircleAvatar({
    super.key,
    required this.child,
    this.rating,
    this.size = 52,
    this.isLoading = false,
  });

  Color _getRatingColor() {
    if (rating == null) return Colors.grey.shade300;
    if (rating! >= 4.0) return Colors.green;
    if (rating! > 3.0) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rating circle indicator
          if (!isLoading && rating != null)
            CustomPaint(
              size: Size(size, size),
              painter: RatingCirclePainter(
                rating: rating!,
                color: _getRatingColor(),
                strokeWidth: 3.0,
              ),
            ),
          // Avatar content
          Container(
            width: size - 4,
            height: size - 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the rating circle
class RatingCirclePainter extends CustomPainter {
  final double rating; // 0-5 scale
  final Color color;
  final double strokeWidth;

  RatingCirclePainter({
    required this.rating,
    required this.color,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle (empty)
    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Filled circle based on rating (0-5 scale)
    if (rating > 0) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Convert rating (0-5) to sweep angle (0-360 degrees)
      final sweepAngle = (rating / 5.0) * 2 * math.pi;
      
      // Start from top (-90 degrees)
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RatingCirclePainter oldDelegate) {
    return oldDelegate.rating != rating ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
