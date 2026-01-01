import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parsed_attribute_data.g.dart';

/// Response model for AI-parsed attributes that includes
/// the attribute name, relevancy score, and UI style hint (category)
@JsonSerializable()
class ParsedAttributeData {
  /// The attribute/interest name (e.g., "photography", "hiking")
  final String attribute;

  /// Relevancy score (0.0 to 1.0) indicating how relevant this attribute is
  final double relevancyScore;

  /// UI style hint/category for displaying this attribute (e.g., "hobby", "skill", "interest")
  final String uiStyleHint;

  const ParsedAttributeData({
    required this.attribute,
    required this.relevancyScore,
    required this.uiStyleHint,
  });

  factory ParsedAttributeData.fromJson(Map<String, dynamic> json) =>
      _$ParsedAttributeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParsedAttributeDataToJson(this);

  ParsedAttributeData copyWith({
    String? attribute,
    double? relevancyScore,
    String? uiStyleHint,
  }) {
    return ParsedAttributeData(
      attribute: attribute ?? this.attribute,
      relevancyScore: relevancyScore ?? this.relevancyScore,
      uiStyleHint: uiStyleHint ?? this.uiStyleHint,
    );
  }
}
