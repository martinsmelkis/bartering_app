// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotificationContacts _$UserNotificationContactsFromJson(
  Map<String, dynamic> json,
) => UserNotificationContacts(
  userId: json['userId'] as String,
  email: json['email'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  pushTokens:
      (json['pushTokens'] as List<dynamic>?)
          ?.map((e) => PushTokenInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  quietHoursStart: (json['quietHoursStart'] as num?)?.toInt(),
  quietHoursEnd: (json['quietHoursEnd'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserNotificationContactsToJson(
  UserNotificationContacts instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'pushTokens': instance.pushTokens,
  'notificationsEnabled': instance.notificationsEnabled,
  'quietHoursStart': instance.quietHoursStart,
  'quietHoursEnd': instance.quietHoursEnd,
};

PushTokenInfo _$PushTokenInfoFromJson(Map<String, dynamic> json) =>
    PushTokenInfo(
      token: json['token'] as String,
      platform: json['platform'] as String,
      deviceId: json['deviceId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$PushTokenInfoToJson(PushTokenInfo instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': instance.platform,
      'deviceId': instance.deviceId,
      'isActive': instance.isActive,
      'addedAt': instance.addedAt?.toIso8601String(),
    };

AttributeNotificationPreference _$AttributeNotificationPreferenceFromJson(
  Map<String, dynamic> json,
) => AttributeNotificationPreference(
  id: json['id'] as String,
  userId: json['userId'] as String,
  attributeId: json['attributeId'] as String,
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  notificationFrequency:
      $enumDecodeNullable(
        _$NotificationFrequencyEnumMap,
        json['notificationFrequency'],
      ) ??
      NotificationFrequency.instant,
  minMatchScore: (json['minMatchScore'] as num?)?.toDouble() ?? 0.7,
  notifyOnNewPostings: json['notifyOnNewPostings'] as bool? ?? true,
  notifyOnNewUsers: json['notifyOnNewUsers'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AttributeNotificationPreferenceToJson(
  AttributeNotificationPreference instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'attributeId': instance.attributeId,
  'notificationsEnabled': instance.notificationsEnabled,
  'notificationFrequency':
      _$NotificationFrequencyEnumMap[instance.notificationFrequency]!,
  'minMatchScore': instance.minMatchScore,
  'notifyOnNewPostings': instance.notifyOnNewPostings,
  'notifyOnNewUsers': instance.notifyOnNewUsers,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$NotificationFrequencyEnumMap = {
  NotificationFrequency.instant: 'INSTANT',
  NotificationFrequency.daily: 'DAILY',
  NotificationFrequency.weekly: 'WEEKLY',
  NotificationFrequency.manual: 'MANUAL',
};

PostingNotificationPreference _$PostingNotificationPreferenceFromJson(
  Map<String, dynamic> json,
) => PostingNotificationPreference(
  postingId: json['postingId'] as String,
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  notificationFrequency:
      $enumDecodeNullable(
        _$NotificationFrequencyEnumMap,
        json['notificationFrequency'],
      ) ??
      NotificationFrequency.instant,
  minMatchScore: (json['minMatchScore'] as num?)?.toDouble() ?? 0.7,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PostingNotificationPreferenceToJson(
  PostingNotificationPreference instance,
) => <String, dynamic>{
  'postingId': instance.postingId,
  'notificationsEnabled': instance.notificationsEnabled,
  'notificationFrequency':
      _$NotificationFrequencyEnumMap[instance.notificationFrequency]!,
  'minMatchScore': instance.minMatchScore,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

MatchHistoryEntry _$MatchHistoryEntryFromJson(Map<String, dynamic> json) =>
    MatchHistoryEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      matchType: json['matchType'] as String,
      sourceType: json['sourceType'] as String,
      sourceId: json['sourceId'] as String,
      targetType: json['targetType'] as String,
      targetId: json['targetId'] as String,
      matchScore: (json['matchScore'] as num).toDouble(),
      matchReason: json['matchReason'] as String?,
      notificationSent: json['notificationSent'] as bool? ?? false,
      notificationSentAt: json['notificationSentAt'] == null
          ? null
          : DateTime.parse(json['notificationSentAt'] as String),
      viewed: json['viewed'] as bool? ?? false,
      viewedAt: json['viewedAt'] == null
          ? null
          : DateTime.parse(json['viewedAt'] as String),
      dismissed: json['dismissed'] as bool? ?? false,
      dismissedAt: json['dismissedAt'] == null
          ? null
          : DateTime.parse(json['dismissedAt'] as String),
      matchedAt: DateTime.parse(json['matchedAt'] as String),
    );

Map<String, dynamic> _$MatchHistoryEntryToJson(MatchHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'matchType': instance.matchType,
      'sourceType': instance.sourceType,
      'sourceId': instance.sourceId,
      'targetType': instance.targetType,
      'targetId': instance.targetId,
      'matchScore': instance.matchScore,
      'matchReason': instance.matchReason,
      'notificationSent': instance.notificationSent,
      'notificationSentAt': instance.notificationSentAt?.toIso8601String(),
      'viewed': instance.viewed,
      'viewedAt': instance.viewedAt?.toIso8601String(),
      'dismissed': instance.dismissed,
      'dismissedAt': instance.dismissedAt?.toIso8601String(),
      'matchedAt': instance.matchedAt.toIso8601String(),
    };

UpdateUserNotificationContactsRequest
_$UpdateUserNotificationContactsRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserNotificationContactsRequest(
      email: json['email'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      quietHoursStart: (json['quietHoursStart'] as num?)?.toInt(),
      quietHoursEnd: (json['quietHoursEnd'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateUserNotificationContactsRequestToJson(
  UpdateUserNotificationContactsRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'notificationsEnabled': instance.notificationsEnabled,
  'quietHoursStart': instance.quietHoursStart,
  'quietHoursEnd': instance.quietHoursEnd,
};

AddPushTokenRequest _$AddPushTokenRequestFromJson(Map<String, dynamic> json) =>
    AddPushTokenRequest(
      token: json['token'] as String,
      platform: json['platform'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$AddPushTokenRequestToJson(
  AddPushTokenRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'platform': instance.platform,
  'deviceId': instance.deviceId,
};

UpdateAttributeNotificationPreferenceRequest
_$UpdateAttributeNotificationPreferenceRequestFromJson(
  Map<String, dynamic> json,
) => UpdateAttributeNotificationPreferenceRequest(
  notificationsEnabled: json['notificationsEnabled'] as bool?,
  notificationFrequency: $enumDecodeNullable(
    _$NotificationFrequencyEnumMap,
    json['notificationFrequency'],
  ),
  minMatchScore: (json['minMatchScore'] as num?)?.toDouble(),
  notifyOnNewPostings: json['notifyOnNewPostings'] as bool?,
  notifyOnNewUsers: json['notifyOnNewUsers'] as bool?,
);

Map<String, dynamic> _$UpdateAttributeNotificationPreferenceRequestToJson(
  UpdateAttributeNotificationPreferenceRequest instance,
) => <String, dynamic>{
  'notificationsEnabled': instance.notificationsEnabled,
  'notificationFrequency':
      _$NotificationFrequencyEnumMap[instance.notificationFrequency],
  'minMatchScore': instance.minMatchScore,
  'notifyOnNewPostings': instance.notifyOnNewPostings,
  'notifyOnNewUsers': instance.notifyOnNewUsers,
};

UpdatePostingNotificationPreferenceRequest
_$UpdatePostingNotificationPreferenceRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePostingNotificationPreferenceRequest(
  notificationsEnabled: json['notificationsEnabled'] as bool?,
  notificationFrequency: $enumDecodeNullable(
    _$NotificationFrequencyEnumMap,
    json['notificationFrequency'],
  ),
  minMatchScore: (json['minMatchScore'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UpdatePostingNotificationPreferenceRequestToJson(
  UpdatePostingNotificationPreferenceRequest instance,
) => <String, dynamic>{
  'notificationsEnabled': instance.notificationsEnabled,
  'notificationFrequency':
      _$NotificationFrequencyEnumMap[instance.notificationFrequency],
  'minMatchScore': instance.minMatchScore,
};

AttributeBatchRequest _$AttributeBatchRequestFromJson(
  Map<String, dynamic> json,
) => AttributeBatchRequest(
  attributeIds: (json['attributeIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  preferences: AttributeBatchPreferences.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AttributeBatchRequestToJson(
  AttributeBatchRequest instance,
) => <String, dynamic>{
  'attributeIds': instance.attributeIds,
  'preferences': instance.preferences,
};

AttributeBatchPreferences _$AttributeBatchPreferencesFromJson(
  Map<String, dynamic> json,
) => AttributeBatchPreferences(
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  notificationFrequency:
      $enumDecodeNullable(
        _$NotificationFrequencyEnumMap,
        json['notificationFrequency'],
      ) ??
      NotificationFrequency.instant,
  minMatchScore: (json['minMatchScore'] as num?)?.toDouble() ?? 0.7,
  notifyOnNewPostings: json['notifyOnNewPostings'] as bool? ?? true,
  notifyOnNewUsers: json['notifyOnNewUsers'] as bool? ?? false,
);

Map<String, dynamic> _$AttributeBatchPreferencesToJson(
  AttributeBatchPreferences instance,
) => <String, dynamic>{
  'notificationsEnabled': instance.notificationsEnabled,
  'notificationFrequency':
      _$NotificationFrequencyEnumMap[instance.notificationFrequency]!,
  'minMatchScore': instance.minMatchScore,
  'notifyOnNewPostings': instance.notifyOnNewPostings,
  'notifyOnNewUsers': instance.notifyOnNewUsers,
};

MatchHistoryResponse _$MatchHistoryResponseFromJson(
  Map<String, dynamic> json,
) => MatchHistoryResponse(
  matches: (json['matches'] as List<dynamic>)
      .map((e) => MatchHistoryEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  unviewedCount: (json['unviewedCount'] as num).toInt(),
);

Map<String, dynamic> _$MatchHistoryResponseToJson(
  MatchHistoryResponse instance,
) => <String, dynamic>{
  'matches': instance.matches,
  'totalCount': instance.totalCount,
  'unviewedCount': instance.unviewedCount,
};

NotificationPreferencesResponse _$NotificationPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => NotificationPreferencesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$NotificationPreferencesResponseToJson(
  NotificationPreferencesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};

UserContactsResponse _$UserContactsResponseFromJson(
  Map<String, dynamic> json,
) => UserContactsResponse(
  contacts: UserNotificationContacts.fromJson(
    json['contacts'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserContactsResponseToJson(
  UserContactsResponse instance,
) => <String, dynamic>{'contacts': instance.contacts};

AttributePreferencesListResponse _$AttributePreferencesListResponseFromJson(
  Map<String, dynamic> json,
) => AttributePreferencesListResponse(
  preferences: (json['preferences'] as List<dynamic>)
      .map(
        (e) =>
            AttributeNotificationPreference.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
);

Map<String, dynamic> _$AttributePreferencesListResponseToJson(
  AttributePreferencesListResponse instance,
) => <String, dynamic>{
  'preferences': instance.preferences,
  'totalCount': instance.totalCount,
};

AttributePreferenceResponse _$AttributePreferenceResponseFromJson(
  Map<String, dynamic> json,
) => AttributePreferenceResponse(
  preference: AttributeNotificationPreference.fromJson(
    json['preference'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AttributePreferenceResponseToJson(
  AttributePreferenceResponse instance,
) => <String, dynamic>{'preference': instance.preference};

BatchAttributePreferencesResponse _$BatchAttributePreferencesResponseFromJson(
  Map<String, dynamic> json,
) => BatchAttributePreferencesResponse(
  success: json['success'] as bool,
  created: (json['created'] as num).toInt(),
  skipped: (json['skipped'] as num).toInt(),
  preferences: (json['preferences'] as List<dynamic>)
      .map(
        (e) =>
            AttributeNotificationPreference.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BatchAttributePreferencesResponseToJson(
  BatchAttributePreferencesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'created': instance.created,
  'skipped': instance.skipped,
  'preferences': instance.preferences,
};

PostingPreferenceResponse _$PostingPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => PostingPreferenceResponse(
  preference: PostingNotificationPreference.fromJson(
    json['preference'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PostingPreferenceResponseToJson(
  PostingPreferenceResponse instance,
) => <String, dynamic>{'preference': instance.preference};
