import 'package:flutter/material.dart';

/// A reusable circular count badge widget that displays a number
/// with optional "99+" truncation for large values.
///
/// Typically positioned at the top-right corner of another widget using Stack.
///
/// Example usage:
/// ```dart
/// Stack(
///   clipBehavior: Clip.none,
///   children: [
///     SomeWidget(),
///     if (count > 0)
///       Positioned(
///         top: -4,
///         right: -4,
///         child: CountBadge(count: count),
///       ),
///   ],
/// )
/// ```
class CountBadge extends StatelessWidget {
  /// The count to display. Will show "99+" if greater than 99.
  final int count;

  /// Background color of the badge. Defaults to red.
  final Color backgroundColor;

  /// Text color. Defaults to white.
  final Color textColor;

  /// Border color around the badge.
  final Color? borderColor;

  /// Size of the badge. If null, auto-sizes based on content.
  final double? size;

  /// Padding inside the badge. Defaults to 6 logical pixels.
  final EdgeInsets padding;

  /// Border width around the badge. Defaults to 0.
  final double borderWidth;

  /// Font size of the count text. Defaults to 10.
  final double fontSize;

  /// Minimum width/height constraints. Defaults to 20x20.
  final BoxConstraints constraints;

  /// Threshold at which to show "+" suffix. Defaults to 99.
  final int maxDisplayCount;

  const CountBadge({
    super.key,
    required this.count,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.borderColor,
    this.size,
    this.padding = const EdgeInsets.all(6),
    this.borderWidth = 0,
    this.fontSize = 10,
    this.constraints = const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    this.maxDisplayCount = 99,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = count > maxDisplayCount ? '$maxDisplayCount+' : count.toString();

    Widget badge = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: borderWidth > 0 || borderColor != null
            ? Border.all(
                color: borderColor ?? Colors.white,
                width: borderWidth > 0 ? borderWidth : 1.0,
              )
            : null,
      ),
      constraints: constraints,
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // If fixed size is specified, wrap in SizedBox
    if (size != null) {
      badge = SizedBox(
        width: size,
        height: size,
        child: badge,
      );
    }

    return badge;
  }
}

/// A positioned version of [CountBadge] for convenience.
///
/// Automatically positions the badge relative to a parent Stack.
/// If no position is specified, defaults to top-right corner.
class PositionedCountBadge extends StatelessWidget {
  /// The count to display
  final int count;

  /// Position from the top
  final double? top;

  /// Position from the right
  final double? right;

  /// Position from the bottom
  final double? bottom;

  /// Position from the left
  final double? left;

  /// Background color of the badge
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Border color around the badge
  final Color? borderColor;

  /// Padding inside the badge
  final EdgeInsets padding;

  /// Border width
  final double borderWidth;

  /// Font size
  final double fontSize;

  /// Minimum size constraints
  final BoxConstraints constraints;

  /// Threshold for "+" suffix
  final int maxDisplayCount;

  const PositionedCountBadge({
    super.key,
    required this.count,
    this.top = -4,
    this.right = -4,
    this.bottom,
    this.left,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.borderColor,
    this.padding = const EdgeInsets.all(6),
    this.borderWidth = 0,
    this.fontSize = 10,
    this.constraints = const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    this.maxDisplayCount = 99,
  });

  @override
  Widget build(BuildContext context) {
    // Hide if count is 0 or less
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: CountBadge(
        count: count,
        backgroundColor: backgroundColor,
        textColor: textColor,
        borderColor: borderColor,
        padding: padding,
        borderWidth: borderWidth,
        fontSize: fontSize,
        constraints: constraints,
        maxDisplayCount: maxDisplayCount,
      ),
    );
  }
}
