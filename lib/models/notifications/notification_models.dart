import 'package:json_annotation/json_annotation.dart';

part 'notification_models.g.dart';

/// Notification frequency enum
enum NotificationFrequency {
  @JsonValue('INSTANT')
  instant,
  @JsonValue('DAILY')
  daily,
  @JsonValue('WEEKLY')
  weekly,
  @JsonValue('MANUAL')
  manual
}

/// User notification contacts
@JsonSerializable()
class UserNotificationContacts {
  final String userId;
  final String? email;
  final bool emailVerified;
  final List<PushTokenInfo> pushTokens;
  final bool notificationsEnabled;
  final int? quietHoursStart; // Hour in 24-hour format (0-23)
  final int? quietHoursEnd; // Hour in 24-hour format (0-23)

  const UserNotificationContacts({
    required this.userId,
    this.email,
    this.emailVerified = false,
    this.pushTokens = const [],
    this.notificationsEnabled = true,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  factory UserNotificationContacts.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationContactsFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationContactsToJson(this);
}

/// Push token information
@JsonSerializable()
class PushTokenInfo {
  final String token;
  final String platform; // 'ANDROID', 'IOS', 'WEB'
  final String? deviceId;
  final bool isActive;
  final DateTime? addedAt;

  const PushTokenInfo({
    required this.token,
    required this.platform,
    this.deviceId,
    this.isActive = true,
    this.addedAt,
  });

  factory PushTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$PushTokenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PushTokenInfoToJson(this);
}

/// Attribute notification preference
@JsonSerializable()
class AttributeNotificationPreference {
  final String id;
  final String userId;
  final String attributeId;
  final bool notificationsEnabled;
  final NotificationFrequency notificationFrequency;
  final double minMatchScore;
  final bool notifyOnNewPostings;
  final bool notifyOnNewUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttributeNotificationPreference({
    required this.id,
    required this.userId,
    required this.attributeId,
    this.notificationsEnabled = true,
    this.notificationFrequency = NotificationFrequency.instant,
    this.minMatchScore = 0.7,
    this.notifyOnNewPostings = true,
    this.notifyOnNewUsers = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AttributeNotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$AttributeNotificationPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeNotificationPreferenceToJson(this);
}

/// Posting notification preference
@JsonSerializable()
class PostingNotificationPreference {
  final String postingId;
  final bool notificationsEnabled;
  final NotificationFrequency notificationFrequency;
  final double minMatchScore;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostingNotificationPreference({
    required this.postingId,
    this.notificationsEnabled = true,
    this.notificationFrequency = NotificationFrequency.instant,
    this.minMatchScore = 0.7,
    this.createdAt,
    this.updatedAt,
  });

  factory PostingNotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$PostingNotificationPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$PostingNotificationPreferenceToJson(this);
}

/// Match history entry
@JsonSerializable()
class MatchHistoryEntry {
  final String id;
  final String userId;
  final String matchType; // 'POSTING_MATCH', 'ATTRIBUTE_MATCH', 'USER_MATCH'
  final String sourceType; // 'ATTRIBUTE', 'POSTING'
  final String sourceId;
  final String targetType; // 'POSTING', 'USER'
  final String targetId;
  final double matchScore;
  final String? matchReason;
  final bool notificationSent;
  final DateTime? notificationSentAt;
  final bool viewed;
  final DateTime? viewedAt;
  final bool dismissed;
  final DateTime? dismissedAt;
  final DateTime matchedAt;

  const MatchHistoryEntry({
    required this.id,
    required this.userId,
    required this.matchType,
    required this.sourceType,
    required this.sourceId,
    required this.targetType,
    required this.targetId,
    required this.matchScore,
    this.matchReason,
    this.notificationSent = false,
    this.notificationSentAt,
    this.viewed = false,
    this.viewedAt,
    this.dismissed = false,
    this.dismissedAt,
    required this.matchedAt,
  });

  factory MatchHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$MatchHistoryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MatchHistoryEntryToJson(this);
}

// Keep old name as alias for backward compatibility
typedef MatchHistoryItem = MatchHistoryEntry;

/// Request/Response models

@JsonSerializable()
class UpdateUserNotificationContactsRequest {
  final String? email;
  final bool? notificationsEnabled;
  final int? quietHoursStart;
  final int? quietHoursEnd;

  const UpdateUserNotificationContactsRequest({
    this.email,
    this.notificationsEnabled,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  factory UpdateUserNotificationContactsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserNotificationContactsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserNotificationContactsRequestToJson(this);
}

@JsonSerializable()
class AddPushTokenRequest {
  final String token;
  final String platform;
  final String? deviceId;

  const AddPushTokenRequest({
    required this.token,
    required this.platform,
    this.deviceId,
  });

  factory AddPushTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPushTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddPushTokenRequestToJson(this);
}

@JsonSerializable()
class UpdateAttributeNotificationPreferenceRequest {
  final bool? notificationsEnabled;
  final NotificationFrequency? notificationFrequency;
  final double? minMatchScore;
  final bool? notifyOnNewPostings;
  final bool? notifyOnNewUsers;

  const UpdateAttributeNotificationPreferenceRequest({
    this.notificationsEnabled,
    this.notificationFrequency,
    this.minMatchScore,
    this.notifyOnNewPostings,
    this.notifyOnNewUsers,
  });

  factory UpdateAttributeNotificationPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAttributeNotificationPreferenceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAttributeNotificationPreferenceRequestToJson(this);
}

@JsonSerializable()
class UpdatePostingNotificationPreferenceRequest {
  final bool? notificationsEnabled;
  final NotificationFrequency? notificationFrequency;
  final double? minMatchScore;

  const UpdatePostingNotificationPreferenceRequest({
    this.notificationsEnabled,
    this.notificationFrequency,
    this.minMatchScore,
  });

  factory UpdatePostingNotificationPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostingNotificationPreferenceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePostingNotificationPreferenceRequestToJson(this);
}

@JsonSerializable()
class AttributeBatchRequest {
  final List<String> attributeIds;
  final AttributeBatchPreferences preferences;

  const AttributeBatchRequest({
    required this.attributeIds,
    required this.preferences,
  });

  factory AttributeBatchRequest.fromJson(Map<String, dynamic> json) =>
      _$AttributeBatchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeBatchRequestToJson(this);
}

@JsonSerializable()
class AttributeBatchPreferences {
  final bool notificationsEnabled;
  final NotificationFrequency notificationFrequency;
  final double minMatchScore;
  final bool notifyOnNewPostings;
  final bool notifyOnNewUsers;

  const AttributeBatchPreferences({
    this.notificationsEnabled = true,
    this.notificationFrequency = NotificationFrequency.instant,
    this.minMatchScore = 0.7,
    this.notifyOnNewPostings = true,
    this.notifyOnNewUsers = false,
  });

  factory AttributeBatchPreferences.fromJson(Map<String, dynamic> json) =>
      _$AttributeBatchPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeBatchPreferencesToJson(this);
}

@JsonSerializable()
class MatchHistoryResponse {
  final List<MatchHistoryEntry> matches;
  final int totalCount;
  final int unviewedCount;

  const MatchHistoryResponse({
    required this.matches,
    required this.totalCount,
    required this.unviewedCount,
  });

  factory MatchHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchHistoryResponseToJson(this);
}

@JsonSerializable()
class NotificationPreferencesResponse {
  final bool success;
  final String message;

  const NotificationPreferencesResponse({
    required this.success,
    required this.message,
  });

  factory NotificationPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesResponseToJson(this);
}

/// Response wrapper for user contacts
@JsonSerializable()
class UserContactsResponse {
  final UserNotificationContacts contacts;

  const UserContactsResponse({
    required this.contacts,
  });

  factory UserContactsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserContactsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserContactsResponseToJson(this);
}

/// Response wrapper for attribute preferences list
@JsonSerializable()
class AttributePreferencesListResponse {
  final List<AttributeNotificationPreference> preferences;
  final int totalCount;

  const AttributePreferencesListResponse({
    required this.preferences,
    required this.totalCount,
  });

  factory AttributePreferencesListResponse.fromJson(Map<String, dynamic> json) =>
      _$AttributePreferencesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttributePreferencesListResponseToJson(this);
}

/// Response wrapper for single attribute preference
@JsonSerializable()
class AttributePreferenceResponse {
  final AttributeNotificationPreference preference;

  const AttributePreferenceResponse({
    required this.preference,
  });

  factory AttributePreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttributePreferenceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttributePreferenceResponseToJson(this);
}

/// Response for batch attribute preferences creation
@JsonSerializable()
class BatchAttributePreferencesResponse {
  final bool success;
  final int created;
  final int skipped;
  final List<AttributeNotificationPreference> preferences;

  const BatchAttributePreferencesResponse({
    required this.success,
    required this.created,
    required this.skipped,
    required this.preferences,
  });

  factory BatchAttributePreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchAttributePreferencesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BatchAttributePreferencesResponseToJson(this);
}

/// Response wrapper for posting preference
@JsonSerializable()
class PostingPreferenceResponse {
  final PostingNotificationPreference preference;

  const PostingPreferenceResponse({
    required this.preference,
  });

  factory PostingPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$PostingPreferenceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostingPreferenceResponseToJson(this);
}
