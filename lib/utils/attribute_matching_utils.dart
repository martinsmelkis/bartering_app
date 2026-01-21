import 'package:flutter/material.dart';
import '../models/user/parsed_attribute_data.dart';
import '../models/user/user_attribute_entry_data.dart';
import '../repositories/user_repository.dart';
import '../configure_dependencies.dart';
import 'text_utils.dart';

/// Utility class for matching and highlighting user attributes
class AttributeMatchingUtils {
  /// Loads and normalizes current user's interests and offerings
  static Future<UserAttributesMatch> loadUserAttributes(BuildContext context) async {
    try {
      final userRepository = getIt<UserRepository>();
      final currentUserInterests = await userRepository.getInterests();
      final currentUserOffers = await userRepository.getOfferings();

      // Normalize/translate the current user's attributes using the same method
      // that will be used for POI attributes, ensuring proper comparison
      final interestIds = currentUserInterests
          ?.map((attr) => TextUtils.getTranslatedOrNormalizedAttribute(
              attr.attribute, context))
          .toList() ?? [];
      
      final offerIds = currentUserOffers
          ?.map((attr) => TextUtils.getTranslatedOrNormalizedAttribute(
              attr.attribute, context))
          .toList() ?? [];

      return UserAttributesMatch(
        interestIds: interestIds,
        offerIds: offerIds,
      );
    } catch (e) {
      debugPrint('Error loading user attributes: $e');
      return UserAttributesMatch(
        interestIds: [],
        offerIds: [],
      );
    }
  }

  /// Determines the match type for an attribute
  static AttributeMatchType getMatchType({
    required String normalizedAttribute,
    required List<String> currentUserInterestIds,
    required List<String> currentUserOfferIds,
    required bool isPoiInterest, // true if this is POI's interest, false if offering
  }) {
    if (isPoiInterest) {
      // For POI's interest:
      // - Complementary match: user offers what POI wants
      if (currentUserOfferIds.contains(normalizedAttribute)) {
        return AttributeMatchType.complementary;
      }
      // - Similar match: both interested in same thing
      if (currentUserInterestIds.contains(normalizedAttribute)) {
        return AttributeMatchType.similar;
      }
    } else {
      // For POI's offering:
      // - Complementary match: POI offers what user wants
      if (currentUserInterestIds.contains(normalizedAttribute)) {
        return AttributeMatchType.complementary;
      }
      // - Similar match: both offer same thing
      if (currentUserOfferIds.contains(normalizedAttribute)) {
        return AttributeMatchType.similar;
      }
    }
    
    return AttributeMatchType.none;
  }

  /// Gets styling information for an attribute based on match type
  static AttributeStyle getAttributeStyle({
    required AttributeMatchType matchType,
    required Color defaultColor,
    required Color complementaryColor,
    required Color similarColor,
  }) {
    switch (matchType) {
      case AttributeMatchType.complementary:
        return AttributeStyle(
          backgroundColor: complementaryColor.withValues(alpha: 0.2),
          textColor: complementaryColor,
          fontWeight: FontWeight.bold,
          borderColor: complementaryColor,
          borderWidth: 1.5,
        );
      case AttributeMatchType.similar:
        return AttributeStyle(
          backgroundColor: similarColor.withValues(alpha: 0.2),
          textColor: similarColor,
          fontWeight: FontWeight.bold,
          borderColor: similarColor,
          borderWidth: 1.5,
        );
      case AttributeMatchType.none:
        return AttributeStyle(
          backgroundColor: defaultColor.withValues(alpha: 0.2),
          textColor: defaultColor,
          fontWeight: FontWeight.w500,
          borderColor: null,
          borderWidth: null,
        );
    }
  }

  /// Builds text spans with styling based on matches
  /// This is used for RichText display (like in POI bottom sheet)
  static List<TextSpan> buildAttributeSpans({
    required BuildContext context,
    required List<UserAttributeEntryData> attributes,
    required List<String> currentUserInterestIds,
    required List<String> currentUserOfferIds,
    required bool isPoiInterest,
    required Color complementaryColor,
    required Color similarColor,
    required double fontSize,
  }) {
    if (attributes.isEmpty) return [];

    List<TextSpan> spans = [];
    for (var i = 0; i < attributes.length; i++) {
      final attribute = attributes[i];
      final normalizedAttr = TextUtils.getTranslatedOrNormalizedAttribute(
          attribute.attributeId, context);

      final matchType = getMatchType(
        normalizedAttribute: normalizedAttr,
        currentUserInterestIds: currentUserInterestIds,
        currentUserOfferIds: currentUserOfferIds,
        isPoiInterest: isPoiInterest,
      );

      Color? textColor;
      FontWeight fontWeight = FontWeight.normal;
      Color? underscoreColor = _parseColorFromHint(attribute.uiStyleHint);

      if (matchType == AttributeMatchType.complementary) {
        textColor = complementaryColor;
        fontWeight = FontWeight.bold;
      } else if (matchType == AttributeMatchType.similar) {
        textColor = similarColor;
        fontWeight = FontWeight.bold;
      }

      spans.add(
        TextSpan(
          text: normalizedAttr,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
            decoration: (matchType != AttributeMatchType.none)
                ? null
                : underscoreColor != null ? TextDecoration.underline : null,
            decorationColor: (matchType != AttributeMatchType.none)
                ? null
                : underscoreColor,
            decorationThickness: 3,
          ),
        ),
      );

      // Add comma separator if not the last item
      if (i < attributes.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }

  /// Helper to parse color from a string hint
  static Color? _parseColorFromHint(String? hint) {
    if (hint != null) {
      final hexString =
          hint == 'GREEN' ? '0xFF00FF00' :
          hint == 'RED' ? '0xFFFF0000' :
          hint == 'BLUE' ? '0xFF0044FF' :
          hint == 'YELLOW' ? '0xFFFFFF40' :
          hint == 'ORANGE' ? '0xFFFFA500' :
          hint == 'PURPLE' ? '0xFF800080' :
          hint == 'TEAL' ? '0xFF00A0A0' :
          '0xFF1A1A1A';
      try {
        return Color(int.parse(hexString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

/// Represents the current user's normalized attribute IDs
class UserAttributesMatch {
  final List<String> interestIds;
  final List<String> offerIds;

  UserAttributesMatch({
    required this.interestIds,
    required this.offerIds,
  });
}

/// Type of match between user and POI attributes
enum AttributeMatchType {
  complementary, // Can trade
  similar,       // Common ground
  none,          // No match
}

/// Styling information for an attribute
class AttributeStyle {
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final Color? borderColor;
  final double? borderWidth;

  AttributeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.fontWeight,
    this.borderColor,
    this.borderWidth,
  });
}
