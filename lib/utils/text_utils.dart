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

  /// Checks if there's a match between current user and POI
  /// Returns true if:
  /// - Current user's interests match POI's offerings (type == 1), OR
  /// - Current user's offerings match POI's interests (type != 1)
  static bool checkForAttributeBarterMatch(PointOfInterest poi,
      List<ParsedAttributeData>? interests, List<ParsedAttributeData>? offers) {
    // Return false if both are null
    if (interests == null && offers == null) {
      return false;
    }

    // Get POI's interests (type != 1) and offerings (type == 1)
    final poiInterests = poi.profile.attributes
        ?.where((attr) => attr.type != 1)
        .map((attr) => attr.attributeId.replaceAll("_", " "))
        .toSet() ?? {};
    final poiOfferings = poi.profile.attributes
        ?.where((attr) => attr.type == 1)
        .map((attr) => attr.attributeId.replaceAll("_", " "))
        .toSet() ?? {};

    // Check if current user's interests match POI's offerings (only if interests is not null)
    final userInterestsMatchPoiOfferings = interests?.any((id) =>
        poiOfferings.contains(id.attribute.toLowerCase())) ?? false;

    // Check if current user's offerings match POI's interests (only if offers is not null)
    final userOfferingsMatchPoiInterests = offers?.any((id) =>
        poiInterests.contains(id.attribute.toLowerCase())) ?? false;

    return userInterestsMatchPoiOfferings || userOfferingsMatchPoiInterests;
  }

}