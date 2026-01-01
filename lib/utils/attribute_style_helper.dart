import 'package:flutter/material.dart';

/// Helper class to provide consistent styling for attributes based on their uiStyleHint
/// uiStyleHint contains color names like: GREEN, RED, YELLOW, ORANGE, TEAL, PURPLE, BLUE
class AttributeStyleHelper {

  /// Returns a color based on the uiStyleHint color name
  static Color getColorForStyleHint(String? uiStyleHint,
      {bool isSelected = false}) {
    final baseColor = _getBaseColor(uiStyleHint);

    if (isSelected) {
      // When selected, use a more opaque/saturated version
      return baseColor.withValues(alpha: 0.8);
    }
    // Unselected gets a lighter, more transparent version
    return baseColor.withValues(alpha: 0.3);
  }

  /// Returns the base color for a style hint color name
  static Color _getBaseColor(String? uiStyleHint) {
    if (uiStyleHint == null || uiStyleHint.isEmpty) {
      return Colors.grey.shade300;
    }

    // Check if the hint contains any of our color keywords
    final hint = uiStyleHint.toUpperCase();

    if (hint.contains('GREEN')) {
      return Colors.green.shade400;
    } else if (hint.contains('RED')) {
      return Colors.red.shade400;
    } else if (hint.contains('YELLOW')) {
      return Colors.yellow.shade600;
    } else if (hint.contains('ORANGE')) {
      return Colors.orange.shade400;
    } else if (hint.contains('TEAL')) {
      return Colors.teal.shade400;
    } else if (hint.contains('PURPLE')) {
      return Colors.purple.shade400;
    } else if (hint.contains('BLUE')) {
      return Colors.blue.shade400;
    } else if (hint.contains('PINK')) {
      return Colors.pink.shade400;
    }

    // Default for unknown categories
    return Colors.blueGrey.shade300;
  }

  /// Returns text color that contrasts well with the background
  static Color getTextColor(String? uiStyleHint, {bool isSelected = false}) {
    if (isSelected) {
      return Colors.white;
    }
    return Colors.black87;
  }

  /// Returns a border color for the chip
  static Color getBorderColor(String? uiStyleHint) {
    return _getBaseColor(uiStyleHint).withValues(alpha: 0.6);
  }
}
