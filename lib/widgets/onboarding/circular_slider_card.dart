import 'dart:math';
import 'package:flutter/material.dart';

import '../../screens/onboarding_screen/cubit/onboarding_cubit.dart';

class CircularSliderCard extends StatelessWidget {
  final OnboardingQuestion question;
  final ValueChanged<double> onAnswered;

  const CircularSliderCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  // Maps a value from -1.0 to 1.0 to an angle from PI (left) to 0 (right).
  double _valueToAngle(double? value) {
    final currentValue = value ?? 0.0;
    // Map value [-1, 1] to t [0, 1]
    final t = (currentValue + 1.0) / 2.0;
    // Map t [0, 1] to angle [PI, 0]
    return pi - (t * pi);
  }

  // Handles the drag gesture to update the slider value.
  void _handleDrag(Offset localPosition, BuildContext context) {
    final size = context.size!;
    final center = Offset(size.width / 2, size.height / 2);
    //final radius = min(size.width / 2, size.height / 2) - 5;
    //const touchTolerance = 35.0; // Pixel tolerance around the track

    var angle = atan2(localPosition.dy - center.dy/2, localPosition.dx - center.dx/2);

    // We only care about the bottom half of the circle for our semi-circle (0 to PI)
    angle = angle.clamp(0.0, pi);

    // Map the angle [PI (left), 0 (right)] back to a value from -1.0 to 1.0
    final double t = (pi - angle) / pi;
    final double value = (t * 2.0) - 1.0;

    onAnswered(value);
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor;
    if (question.answer == null) {
      iconColor = Colors.grey;
    } else {
      final double t = (question.answer! + 1.0) / 2.0;
      final double hue = t * 300;
      iconColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
          bottom: 16,
          left: 16,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150, // Increased height for a larger radius and touch area
              width: 240,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent, // Ensures the whole area is tappable
                onPanUpdate: (details) => _handleDrag(details.localPosition, context),
                onPanStart: (details) => _handleDrag(details.localPosition, context),
                onTapDown: (details) => _handleDrag(details.localPosition, context),
                child: CustomPaint(
                  painter: _ClockArmSliderPainter(
                    angle: _valueToAngle(question.answer),
                    color: iconColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.construction_outlined,
                      color: iconColor,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "0",
                  style: TextStyle(
                    fontWeight: (question.answer ?? 0.0) < -0.1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  "100",
                  style: TextStyle(
                    fontWeight: (question.answer ?? 0.0) > 0.1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockArmSliderPainter extends CustomPainter {
  final double angle;
  final Color color;

  _ClockArmSliderPainter({required this.angle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2) + Offset(0, 25);
    final radius = min(size.width / 2, size.height / 2) - 10;

    final trackPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final armPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // 1. Draw the semi-circular track at the bottom
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0, // Start angle (right)
      pi, // Sweep angle (180 degrees)
      false,
      trackPaint,
    );

    // 2. Calculate the end point of the clock arm
    final armEndPoint = Offset(
      center.dx + radius * cos(angle) - 0,
      center.dy + radius * sin(angle) - 15,
    );

    // 3. Draw the clock arm line from the center to the end point
    canvas.drawLine(center, armEndPoint, armPaint);

    // 4. Draw the arrowhead at the end of the arm
    const arrowSize = 12.0;
    const arrowAngle = pi * 0.2; // The angle of the arrowhead lines

    // Calculate the angles for the two lines of the arrowhead
    final angle1 = angle + pi - arrowAngle;
    final angle2 = angle + pi + arrowAngle;

    // Calculate the points for the arrowhead
    final p1 = Offset(armEndPoint.dx + arrowSize * cos(angle1), armEndPoint.dy + arrowSize * sin(angle1));
    final p2 = Offset(armEndPoint.dx + arrowSize * cos(angle2), armEndPoint.dy + arrowSize * sin(angle2));

    // Draw the arrowhead lines
    canvas.drawLine(armEndPoint, p1, armPaint);
    canvas.drawLine(armEndPoint, p2, armPaint);
  }

  @override
  bool shouldRepaint(covariant _ClockArmSliderPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.color != color;
  }
}
