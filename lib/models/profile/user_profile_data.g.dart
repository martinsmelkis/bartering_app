// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    UserProfileData(
      userId: json['userId'] as String,
      name: json['name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map(
            (e) => UserAttributeEntryData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      profileKeywordDataMap:
          (json['profileKeywordDataMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
      activePostingIds: (json['activePostingIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserProfileDataToJson(UserProfileData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'attributes': instance.attributes,
      'profileKeywordDataMap': instance.profileKeywordDataMap,
      'activePostingIds': instance.activePostingIds,
    };
