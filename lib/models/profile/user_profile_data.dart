import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_data.g.dart'; // Import the generated part

@JsonSerializable()
class UserProfileData {

  final String userId;
  final String name;
  final double longitude;
  final double latitude;
  final List<UserAttributeEntryData>? attributes;
  final Map<String, double>? profileKeywordDataMap;
  final List<String>? activePostingIds;

  const UserProfileData({
    required this.userId,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.attributes,
    required this.profileKeywordDataMap,
    required this.activePostingIds,
  });

  // Factory constructor for creating a new UserProfileData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDataFromJson(json);

  // Method for converting a UserProfileData instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$UserProfileDataToJson(this);

  UserProfileData copyWith({
    String? userId,
    String? name,
    double? latitude,
    double? longitude,
    List<UserAttributeEntryData>? attributes,
    Map<String, double>? profileKeywordDataMap,
    List<String>? activePostingIds,
  }) {
    return UserProfileData(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      attributes: attributes ?? this.attributes,
      profileKeywordDataMap: profileKeywordDataMap ?? this.profileKeywordDataMap,
      activePostingIds: activePostingIds ?? this.activePostingIds,
    );
  }
}
