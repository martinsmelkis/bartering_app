import 'package:flutter/material.dart';

/// A circular badge that displays online status with a green dot
class OnlineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final double size;
  final double borderWidth;

  const OnlineStatusBadge({
    super.key,
    required this.isOnline,
    this.size = 12.0,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
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

/// A positioned online status badge for use with Stack
class PositionedOnlineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final double size;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double borderWidth;

  const PositionedOnlineStatusBadge({
    super.key,
    required this.isOnline,
    this.size = 12.0,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: OnlineStatusBadge(
        isOnline: isOnline,
        size: size,
        borderWidth: borderWidth,
      ),
    );
  }
}
