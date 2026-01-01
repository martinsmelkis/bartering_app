import 'package:json_annotation/json_annotation.dart';

part 'user_attributes_data.g.dart'; // Import the generated part

@JsonSerializable()
class UserAttributesData {
  // Id to get original onboarding data - cache on Server in some Map or Redis
  final String userId;
  // Saves space, Server will have a map locally, no keywords needed
  final Map<String, double> attributesRelevancyData;

  const UserAttributesData({
    required this.userId,
    required this.attributesRelevancyData,
  });

  // Factory constructor for creating a new UserInterestsData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserAttributesData.fromJson(Map<String, dynamic> json) =>
      _$UserAttributesDataFromJson(json);

  // Method for converting a UserInterestsData instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$UserAttributesDataToJson(this);

  UserAttributesData copyWith({
    String? userId,
    Map<String, double>? attributesRelevancyData,
  }) {
    return UserAttributesData(
      userId: userId ?? this.userId,
      attributesRelevancyData: attributesRelevancyData ?? this.attributesRelevancyData,
    );
  }
}