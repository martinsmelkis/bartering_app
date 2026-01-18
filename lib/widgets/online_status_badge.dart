import 'package:flutter/material.dart';

/// A circular badge that displays online/away status
/// - Green: User is online (within last 5 minutes)
/// - Yellow: User is away (within last 24 hours)
class OnlineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final bool isAway;
  final double size;
  final double borderWidth;

  const OnlineStatusBadge({
    super.key,
    required this.isOnline,
    this.isAway = false,
    this.size = 12.0,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnline && !isAway) {
      return const SizedBox.shrink();
    }

    // Determine badge color: green for online, yellow for away
    final badgeColor = isOnline ? Colors.green : Colors.orange.shade600;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

/// A positioned online/away status badge for use with Stack
class PositionedOnlineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final bool isAway;
  final double size;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double borderWidth;

  const PositionedOnlineStatusBadge({
    super.key,
    required this.isOnline,
    this.isAway = false,
    this.size = 12.0,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnline && !isAway) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: OnlineStatusBadge(
        isOnline: isOnline,
        isAway: isAway,
        size: size,
        borderWidth: borderWidth,
      ),
    );
  }
}
