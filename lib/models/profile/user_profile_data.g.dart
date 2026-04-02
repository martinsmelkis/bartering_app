// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportResult _$ExportResultFromJson(Map<String, dynamic> json) => ExportResult(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$ExportResultToJson(ExportResult instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};

UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    UserProfileData(
      userId: json['userId'] as String,
      name: json['name'] as String,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
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
      preferredLanguage: json['preferredLanguage'] as String?,
      lastOnlineAt: (json['lastOnlineAt'] as num?)?.toInt(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
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
      'preferredLanguage': ?instance.preferredLanguage,
      'lastOnlineAt': ?instance.lastOnlineAt,
      'averageRating': ?instance.averageRating,
      'totalReviews': ?instance.totalReviews,
    };
