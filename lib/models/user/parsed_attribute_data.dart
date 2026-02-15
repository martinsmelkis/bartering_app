import 'package:barter_app/utils/text_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parsed_attribute_data.g.dart';

/// Response model for AI-parsed attributes that includes
/// the attribute name, relevancy score, and UI style hint (category)
/// The [attributeKey] stores the server-side canonical key (e.g., "car_parts") for consistent
/// matching across all languages, while [attribute] stores the localized display name.
@JsonSerializable()
class ParsedAttributeData {
  /// The server-side canonical attribute key (e.g., "car_parts", "photography")
  /// Use this for matching, storage, and API communication - not for display.
  /// For backward compatibility, if null it will be derived from attribute.
  final String? attributeKey;

  /// The localized/translated attribute name for display purposes (e.g., "Auto detaļas", "Photography")
  /// This is the human-readable version in the user's current language.
  final String attribute;

  /// Relevancy score (0.0 to 1.0) indicating how relevant this attribute is
  final double relevancyScore;

  /// UI style hint/category for displaying this attribute (e.g., "hobby", "skill", "interest")
  final String uiStyleHint;

  const ParsedAttributeData({
    required this.attributeKey,
    required this.attribute,
    required this.relevancyScore,
    required this.uiStyleHint,
  });

  factory ParsedAttributeData.fromJson(Map<String, dynamic> json) =>
      _$ParsedAttributeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParsedAttributeDataToJson(this);

  /// Returns the effective attribute key for matching.
  /// If attributeKey is not set (backward compatibility), derives it from attribute.
  /// Guaranteed to return a non-null string.
  String get effectiveAttributeKey {
    // Use stored key if available (new API responses and newly saved data)
    final key = attributeKey;
    if (key != null && key.isNotEmpty) {
      return key;
    }
    // Fallback: derive from the attribute name (for old stored data)
    // normalizeAttributeId always returns a non-null string (empty string if input is null/empty)
    final derived = TextUtils.normalizeAttributeId(attribute);
    return derived.isNotEmpty ? derived : 'unknown_attribute';
  }

  /// Returns the effective display attribute for UI.
  /// This is always the localized attribute name.
  String get effectiveDisplayAttribute => attribute;

  ParsedAttributeData copyWith({
    String? attributeKey,
    String? attribute,
    double? relevancyScore,
    String? uiStyleHint,
  }) {
    return ParsedAttributeData(
      attributeKey: attributeKey ?? this.attributeKey,
      attribute: attribute ?? this.attribute,
      relevancyScore: relevancyScore ?? this.relevancyScore,
      uiStyleHint: uiStyleHint ?? this.uiStyleHint,
    );
  }
}
