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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      attributes:
          (json['attributes'] as List<dynamic>?)
              ?.map(
                (e) =>
                    UserAttributeEntryData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      profileKeywordDataMap:
          (json['profileKeywordDataMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
      selfDescription: json['selfDescription'] as String?,
      accountType: $enumDecodeNullable(
        _$AccountTypeEnumMap,
        json['accountType'],
      ),
      profileAvatarIcon: json['profileAvatarIcon'] as String?,
      workReferenceImageUrls:
          (json['workReferenceImageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activePostingIds:
          (json['activePostingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastOnlineAt: (json['lastOnlineAt'] as num?)?.toInt(),
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
    );

Map<String, dynamic> _$UserProfileDataToJson(UserProfileData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'attributes': instance.attributes,
      'profileKeywordDataMap': instance.profileKeywordDataMap,
      'selfDescription': instance.selfDescription,
      'accountType': _$AccountTypeEnumMap[instance.accountType],
      'profileAvatarIcon': instance.profileAvatarIcon,
      'workReferenceImageUrls': instance.workReferenceImageUrls,
      'activePostingIds': instance.activePostingIds,
      'lastOnlineAt': ?instance.lastOnlineAt,
      'preferredLanguage': instance.preferredLanguage,
    };

const _$AccountTypeEnumMap = {
  AccountType.INDIVIDUAL: 'individual',
  AccountType.INDIVIDUAL_VERIFIED: 'individual_verified',
  AccountType.BUSINESS_UNVERIFIED: 'business_unverified',
  AccountType.BUSINESS_VERIFIED: 'business_verified',
  AccountType.ADMIN: 'admin',
  AccountType.MODERATOR: 'moderator',
  AccountType.SUSPENDED: 'suspended',
};
