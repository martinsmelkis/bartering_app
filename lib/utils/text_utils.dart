import 'package:barter_app/l10n/app_localizations.mapper.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/cupertino.dart';

import '../models/map/point_of_interest.dart';

class TextUtils {

  static String normalizeSnakeCase(String text) {
    if (text.isEmpty) {
      return '';
    }

    // 1. Split the string by underscores.
    // "charity_work" -> ["charity", "work"]
    final words = text.split('_');

    // 2. Capitalize the first letter of each word.
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return '';
      }
      // "charity" -> "C" + "harity" -> "Charity"
      // "work" -> "W" + "ork" -> "Work"
      return '${word[0].toUpperCase()}${word.substring(1)}';
    });

    // 3. Join the words back together with a space.
    // ["Charity", "Work"] -> "Charity Work"
    return capitalizedWords.join(' ');
  }

  static String getTranslatedOrNormalizedAttribute(String attribute, BuildContext context) {
    String parsedAttribute;
    try {
      var localizedItem = context.parseL10n('attr_$attribute');
      if (localizedItem.contains("Translation key not found")) {
        throw Exception("Translation key not found");
      }
      parsedAttribute = localizedItem;
    } catch (e) {
      logDebugError('localize error for item: $attribute', e);
      parsedAttribute = TextUtils.normalizeSnakeCase(attribute);
    }
    return parsedAttribute;
  }

  /// Normalize notification text that contains attribute IDs
  /// Converts 'attr_xxx' format to readable text when localization is not available
  /// Example: 'attr_social_media' -> 'Social Media'
  static String normalizeNotificationText(String? text) {
    if (text == null || text.isEmpty) return '';
    
    // Check if text contains 'attr_' prefix
    if (text.contains('attr_')) {
      // Remove 'attr_' prefix and normalize snake_case
      final normalized = text.replaceAllMapped(
        RegExp(r'attr_([a-z_]+)', caseSensitive: false),
        (match) {
          final attributeName = match.group(1) ?? '';
          // Convert snake_case to Title Case (e.g., 'social_media' -> 'Social Media')
          return normalizeSnakeCase(attributeName);
        },
      );
      return normalized;
    }
    
    return text;
  }

  /// Normalizes text for attribute comparison by:
  /// 1. Converting to lowercase
  /// 2. Replacing spaces with underscores
  /// 3. Trimming whitespace
  /// 4. Removing diacritics (e.g., ā→a, š→s, ē→e, ž→z, etc.)
  /// 
  /// Use this for API-returned attributes (canonical keys).
  static String normalizeAttributeId(String? text) {
    if (text == null || text.isEmpty) return '';
    
    var normalized = text.toLowerCase().trim().replaceAll(' ', '_');
    
    // Remove diacritics by mapping accented characters to their base forms
    final diacriticMap = {
      // Latin extended A
      'ā': 'a', 'ă': 'a', 'ą': 'a', 'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'ć': 'c', 'č': 'c', 'ç': 'c',
      'đ': 'd', 'ď': 'd',
      'ē': 'e', 'ė': 'e', 'ę': 'e', 'ě': 'e', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ģ': 'g', 'ğ': 'g',
      'ī': 'i', 'į': 'i', 'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ķ': 'k',
      'ļ': 'l', 'ł': 'l', 'ľ': 'l', 'ĺ': 'l',
      'ņ': 'n', 'ň': 'n', 'ñ': 'n', 'ń': 'n',
      'ō': 'o', 'ő': 'o', 'ø': 'o', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ř': 'r', 'ŗ': 'r',
      'š': 's', 'ś': 's', 'ş': 's', 'ș': 's',
      'ť': 't', 'ţ': 't', 'ț': 't',
      'ū': 'u', 'ų': 'u', 'ů': 'u', 'ű': 'u', 'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ž': 'z', 'ź': 'z', 'ż': 'z',
      'æ': 'ae', 'œ': 'oe', 'ß': 'ss',
    };
    
    for (final entry in diacriticMap.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    
    return normalized;
  }

  /// Normalizes custom user-entered attribute text for use as a key.
  /// Unlike normalizeAttributeId, this PRESERVES diacritics so that
  /// custom attributes like "Zemeņu vākšana" can match between users
  /// who entered the exact same text.
  /// 
  /// Only performs:
  /// 1. Converting to lowercase
  /// 2. Replacing spaces with underscores  
  /// 3. Trimming whitespace
  static String normalizeCustomAttributeKey(String? text) {
    if (text == null || text.isEmpty) return '';
    
    // Just lowercase, trim, and replace spaces with underscores
    // DO NOT remove diacritics - we want "Zemeņu vākšana" to stay as "zemeņu_vākšana"
    return text.toLowerCase().trim().replaceAll(' ', '_');
  }
  /// Returns true if:
  /// - Current user's interests match POI's offerings (type == 1), OR
  /// - Current user's offerings match POI's interests (type != 1)
  /// 
  /// NOTE: This method attempts to match using both canonical keys (effectiveAttributeKey)
  /// and display names (attribute) because POI data may contain localized display text
  /// in attributeId field rather than canonical keys.
  static bool checkForAttributeBarterMatch(PointOfInterest poi,
      List<ParsedAttributeData>? interests, List<ParsedAttributeData>? offers) {
    // Return false if both are null
    if (interests == null && offers == null) {
      return false;
    }

    // Get POI's interests (type != 1) and offerings (type == 1)
    final poiInterests = poi.profile.attributes
        ?.where((attr) => attr.type != 1)
        .toList() ?? [];
    final poiOfferings = poi.profile.attributes
        ?.where((attr) => attr.type == 1)
        .toList() ?? [];
    
    // Create sets of normalized POI attributeIds (these might be canonical keys OR display names)
    final poiInterestIds = poiInterests.map((attr) => normalizeAttributeId(attr.attributeId)).toSet();
    final poiOfferingIds = poiOfferings.map((attr) => normalizeAttributeId(attr.attributeId)).toSet();

    debugPrint('@@@@@ POI offerings: ${poiOfferingIds.take(3)} User offer keys: ${offers?.map((o) => normalizeAttributeId(o.effectiveAttributeKey)).take(3)}');
    debugPrint('@@@@@ POI interests: ${poiInterestIds.take(3)} User interest keys: ${interests?.map((i) => normalizeAttributeId(i.effectiveAttributeKey)).take(3)}');

    // Strategy 1: Match by canonical key (effectiveAttributeKey vs POI attributeId)
    // This works when POI has canonical keys like "artificial_intelligence"
    final userInterestsMatchByKey = interests?.any((id) =>
        poiOfferingIds.contains(normalizeAttributeId(id.effectiveAttributeKey))) ?? false;
    final userOffersMatchByKey = offers?.any((id) =>
        poiInterestIds.contains(normalizeAttributeId(id.effectiveAttributeKey))) ?? false;
    
    if (userInterestsMatchByKey || userOffersMatchByKey) {
      debugPrint('@@@@@@ Match found by canonical key!');
      return true;
    }
    
    // Strategy 2: Match by display name (attribute vs POI attributeId)
    // This handles the case where POI's attributeId is localized text like "Mākslīgais intelekts"
    // and user's display name is also "Mākslīgais intelekts"
    final userInterestDisplayNames = interests?.map((i) => normalizeAttributeId(i.attribute)).toSet() ?? {};
    final userOfferDisplayNames = offers?.map((o) => normalizeAttributeId(o.attribute)).toSet() ?? {};
    
    // Check if any POI offering matches user's interest by display name
    final poiOfferingsMatchUserInterests = poiOfferings.any((poiAttr) =>
        userInterestDisplayNames.contains(normalizeAttributeId(poiAttr.attributeId)));
    // Check if any POI interest matches user's offering by display name  
    final poiInterestsMatchUserOffers = poiInterests.any((poiAttr) =>
        userOfferDisplayNames.contains(normalizeAttributeId(poiAttr.attributeId)));
    
    if (poiOfferingsMatchUserInterests || poiInterestsMatchUserOffers) {
      debugPrint('@@@@@@ Match found by display name!');
      return true;
    }

    debugPrint('@@@@@@ No match found');
    return false;
  }

}