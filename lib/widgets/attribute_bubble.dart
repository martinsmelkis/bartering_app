import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/attribute_matching_utils.dart';
import '../utils/text_utils.dart';

class AttributeBubble extends StatelessWidget {
  final dynamic attribute;
  final AttributeMatchType matchType;
  final double scaleFactor;
  final List<String>? currentUserInterestIds;
  final List<String>? currentUserOfferIds;
  final bool isPoiInterest;

  const AttributeBubble({
    super.key,
    required this.attribute,
    this.matchType = AttributeMatchType.none,
    this.scaleFactor = 1.0,
    this.currentUserInterestIds,
    this.currentUserOfferIds,
    this.isPoiInterest = false,
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

  Color _getTextColorForCategory(String? uiStyleHint, Color defaultTextColor) {
    final hint = uiStyleHint?.toLowerCase();
    
    if (hint == 'yellow' || hint == 'orange') {
      // Make text 20% darker for yellow and orange
      final hsl = HSLColor.fromColor(defaultTextColor);
      return hsl.withLightness(
        (hsl.lightness * 0.7).clamp(0.0, 1.0),
      ).toColor();
    }
    
    return defaultTextColor;
  }

  @override
  Widget build(BuildContext context) {
    String attributeText;
    String? uiStyleHint;
    
    // Handle different attribute types
    if (attribute.runtimeType.toString().contains('ParsedAttributeData')) {
      attributeText = TextUtils.getTranslatedOrNormalizedAttribute(
        attribute.attribute,
        context,
      );
      uiStyleHint = attribute.uiStyleHint;
    } else {
      attributeText = TextUtils.getTranslatedOrNormalizedAttribute(
        attribute.attributeId,
        context,
      );
      uiStyleHint = attribute.uiStyleHint;
    }

    // Get styling based on match type
    final style = AttributeMatchingUtils.getAttributeStyle(
      matchType: matchType,
      defaultColor: _getColorForAttribute(uiStyleHint),
      complementaryColor: AppColors.secondary,
      similarColor: Colors.blue,
    );

    // Apply category-specific text color adjustments
    final adjustedTextColor = _getTextColorForCategory(uiStyleHint, style.textColor);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0 * scaleFactor,
        vertical: 4.0 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12.0 * scaleFactor),
        border: style.borderColor != null
            ? Border.all(
                color: style.borderColor!,
                width: style.borderWidth!,
              )
            : null,
      ),
      child: Text(
        attributeText,
        style: TextStyle(
          fontSize: 11.0 * scaleFactor,
          color: adjustedTextColor,
          fontWeight: style.fontWeight,
        ),
      ),
    );
  }
}
