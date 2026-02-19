import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/text_utils.dart';

/// A selectable attribute bubble widget that combines the styling of AttributeBubble
/// with the Material animations of ChoiceChip (press effects, elevation changes).
/// Uses rounder corners (16px radius) for a more bubble-like appearance.
class SelectableAttributeBubble extends StatelessWidget {
  final dynamic attribute;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final double scaleFactor;

  const SelectableAttributeBubble({
    super.key,
    required this.attribute,
    this.isSelected = false,
    this.onSelected,
    this.scaleFactor = 1.0,
  });

  Color _getColorForAttribute(String? uiStyleHint) {
    switch (uiStyleHint?.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        // Make yellow 10% darker
        return HSLColor.fromColor(Colors.amber).withLightness(
          (HSLColor.fromColor(Colors.amber).lightness * 0.95).clamp(0.0, 1.0),
        ).toColor();
      case 'orange':
        // Make orange 10% darker
        return HSLColor.fromColor(Colors.orange).withLightness(
          (HSLColor.fromColor(Colors.orange).lightness * 0.95).clamp(0.0, 1.0),
        ).toColor();
      case 'teal':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  Color _getTextColorForCategory(String? uiStyleHint, Color baseTextColor) {
    final hint = uiStyleHint?.toLowerCase();

    if (hint == 'yellow' || hint == 'orange') {
      // Make text 20% darker for yellow and orange
      final hsl = HSLColor.fromColor(baseTextColor);
      return hsl.withLightness(
        (hsl.lightness * 0.7).clamp(0.0, 1.0),
      ).toColor();
    }

    return baseTextColor;
  }

  @override
  Widget build(BuildContext context) {
    String attributeText = '';
    String? uiStyleHint;

    // Safely extract data from attribute object
    try {
      final dynamic attr = attribute;

      // Try ParsedAttributeData first (has 'effectiveAttributeKey' getter)
      try {
        final attrKey = attr.effectiveAttributeKey;
        if (attrKey != null && attrKey is String && attrKey.isNotEmpty) {
          attributeText = TextUtils.getTranslatedOrNormalizedAttribute(
            attrKey,
            context,
          );
          uiStyleHint = attr.uiStyleHint?.toString();
        }
      } catch (_) {
        // Not a ParsedAttributeData, try next approach
      }

      // Try to extract attribute key directly
      if (attributeText.isEmpty) {
        try {
          final attrId = attr.attributeId;
          if (attrId != null && attrId is String) {
            attributeText = TextUtils.getTranslatedOrNormalizedAttribute(
              attrId,
              context,
            );
            uiStyleHint = attr.uiStyleHint?.toString();
          }
        } catch (_) {
          // Not found
        }
      }

      // Fallback: try to convert to string
      if (attributeText.isEmpty) {
        attributeText = attr?.toString() ?? 'Unknown';
      }
    } catch (e) {
      attributeText = 'Error';
    }

    return _buildChip(context, attributeText, uiStyleHint);
  }

  Widget _buildChip(BuildContext context, String attributeText, String? uiStyleHint) {
    final baseColor = _getColorForAttribute(uiStyleHint);

    // Determine colors based on selection state
    // Match AttributeBubble styling from _buildBubble():
    // - Unselected: background with alpha 0.2, no border, base color text
    // - Selected: solid background, white text, white border
    final Color backgroundColor;
    final Color textColor;
    final Color? borderColor;
    final double borderWidth;

    if (isSelected) {
      // Selected: solid color background, white text, white border (like AttributeBubble with match)
      backgroundColor = baseColor;
      textColor = Colors.white;
      borderColor = Colors.white;
      borderWidth = 2.0;
    } else {
      // Unselected: semi-transparent background matching AttributeBubble (alpha 0.2),
      // with a darker outline of the main color
      backgroundColor = baseColor.withValues(alpha: 0.2);
      textColor = _getTextColorForCategory(uiStyleHint, baseColor);
      // Create a darker version of the base color for the border
      final hsl = HSLColor.fromColor(baseColor);
      borderColor = hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
      borderWidth = 1.5;
    }

    return ChoiceChip(
      label: Text(
        attributeText,
        style: TextStyle(
          fontSize: 12.0 * scaleFactor,
          color: textColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: baseColor,
      backgroundColor: backgroundColor,
      checkmarkColor: Colors.white,
      // Rounder corners for bubble-like appearance (matches AttributeBubble: 12.0)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0 * scaleFactor),
      ),
      side: borderColor != null
          ? BorderSide(
              color: borderColor,
              width: borderWidth,
            )
          : null,
      // Adjust padding for bubble-like proportions
      padding: EdgeInsets.symmetric(
        horizontal: 8.0 * scaleFactor,
        vertical: 4.0 * scaleFactor,
      ),
      // Material elevation animations
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
      shadowColor: baseColor.withValues(alpha: 0.4),
    );
  }
}
