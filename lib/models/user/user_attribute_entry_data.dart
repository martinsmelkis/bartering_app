import 'package:json_annotation/json_annotation.dart';

part 'user_attribute_entry_data.g.dart'; // Import the generated part

@JsonSerializable()
class UserAttributeEntryData {

  final String attributeId;
  final int type; // index from EAttributeType, as on Server - UserAttributeType
  final double relevancy;
  final String? description;
  final String? uiStyleHint;

  const UserAttributeEntryData({
    required this.attributeId,
    required this.type,
    required this.relevancy,
    required this.description,
    required this.uiStyleHint
  });

  // Factory constructor for creating a new UserInterestsData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserAttributeEntryData.fromJson(Map<String, dynamic> json) =>
      _$UserAttributeEntryDataFromJson(json);

  // Method for converting a UserInterestsData instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$UserAttributeEntryDataToJson(this);

  UserAttributeEntryData copyWith({
    String? attributeId,
    int? type,
    double? relevancy,
    String? description,
    String? uiStyleHint,
  }) {
    return UserAttributeEntryData(
      attributeId: attributeId ?? this.attributeId,
      type: type ?? this.type,
      relevancy: relevancy ?? this.relevancy,
      description: description ?? this.description,
      uiStyleHint: uiStyleHint ?? this.uiStyleHint,
    );
  }
}