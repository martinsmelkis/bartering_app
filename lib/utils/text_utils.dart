import 'package:barter_app/l10n/app_localizations.mapper.dart';
import 'package:flutter/cupertino.dart';

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
      print('@@@@@@@@@ localize error: $e, item: $attribute');
      parsedAttribute = TextUtils.normalizeSnakeCase(attribute);
      print(e);
    }
    return parsedAttribute;
  }

}