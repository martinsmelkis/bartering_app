import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_data.g.dart'; // Import the generated part

/// Converter for safely parsing keyword map, handling both numeric and string values
class KeywordMapConverter {
  static Map<String, double>? _fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final result = <String, double>{};
    json.forEach((key, value) {
      if (value is num) {
        result[key] = value.toDouble();
      } else if (value is String) {
        // Try to parse string as double, default to 0.0 if parsing fails
        result[key] = double.tryParse(value) ?? 0.0;
      }
      // Ignore values that are neither num nor String
    });

    return result.isEmpty ? null : result;
  }

  static Map<String, dynamic>? _toJson(Map<String, double>? object) => object;
}

enum AccountType {
  @JsonValue('individual')
  INDIVIDUAL,
  @JsonValue('individual_verified')
  INDIVIDUAL_VERIFIED,
  @JsonValue('business_unverified')
  BUSINESS_UNVERIFIED,
  @JsonValue('business_verified')
  BUSINESS_VERIFIED,
  @JsonValue('admin')
  ADMIN,
  @JsonValue('moderator')
  MODERATOR,
  @JsonValue('suspended')
  SUSPENDED,
}

@JsonSerializable()
class ExportResult {
  final bool success;
  final String message;

  const ExportResult({
    required this.success,
    required this.message,
  });

  factory ExportResult.fromJson(Map<String, dynamic> json) {
    return ExportResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

@JsonSerializable()
class UserProfileData {
  final String userId;
  final String name;
  final double? latitude;
  final double? longitude;
  final List<UserAttributeEntryData> attributes;
  final Map<String, double>? profileKeywordDataMap;
  final String? selfDescription;
  final AccountType? accountType;
  final String? profileAvatarIcon;
  // Canonical purchased icon ID used for entitlement checks on update
  final String? profileAvatarIconId;
  final List<String> workReferenceImageUrls;
  final List<String> activePostingIds;
  @JsonKey(includeIfNull: false)
  final int? lastOnlineAt; // Timestamp in milliseconds when user was last online
  final String preferredLanguage;

  const UserProfileData({
    required this.userId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.attributes = const [],
    this.profileKeywordDataMap,
    this.selfDescription,
    this.accountType,
    this.profileAvatarIcon,
    this.profileAvatarIconId,
    this.workReferenceImageUrls = const [],
    this.activePostingIds = const [],
    this.lastOnlineAt,
    this.preferredLanguage = 'en',
  });

  /// Check if user is currently online (within last 5 minutes)
  bool get isOnline {
    if (lastOnlineAt == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    final fiveMinutesInMs = 5 * 60 * 1000; // 5 minutes in milliseconds
    return (now - lastOnlineAt!) < fiveMinutesInMs;
  }

  /// Check if user is away (online within last 24 hours but not in last 5 minutes)
  bool get isAway {
    if (lastOnlineAt == null) return false;
    if (isOnline) return false; // If currently online, not away
    final now = DateTime.now().millisecondsSinceEpoch;
    final twentyFourHoursInMs = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
    return (now - lastOnlineAt!) < twentyFourHoursInMs;
  }

  // Factory constructor for creating a new UserProfileData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    // Manually parse profileKeywordDataMap to handle string values
    Map<String, double>? parsedKeywordMap;
    if (json['profileKeywordDataMap'] != null) {
      parsedKeywordMap = KeywordMapConverter._fromJson(
        json['profileKeywordDataMap'] as Map<String, dynamic>?,
      );
    }

    // Normalize accountType from backend values (case-insensitive)
    // and gracefully fallback to INDIVIDUAL when missing or unknown.
    final rawAccountType = json['accountType']?.toString();
    final normalizedAccountType = rawAccountType == null
        ? 'individual'
        : rawAccountType.toLowerCase();

    // Create a modified JSON with normalized fields
    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['profileKeywordDataMap'] = parsedKeywordMap;
    modifiedJson['accountType'] = {
      'individual': 'individual',
      'individual_verified': 'individual_verified',
      'business_unverified': 'business_unverified',
      'business_verified': 'business_verified',
      'admin': 'admin',
      'moderator': 'moderator',
      'suspended': 'suspended',
    }.containsKey(normalizedAccountType)
        ? normalizedAccountType
        : 'individual';

    return _$UserProfileDataFromJson(modifiedJson);
  }

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
    String? selfDescription,
    AccountType? accountType,
    String? profileAvatarIcon,
    String? profileAvatarIconId,
    List<String>? workReferenceImageUrls,
    List<String>? activePostingIds,
    int? lastOnlineAt,
    String? preferredLanguage,
  }) {
    return UserProfileData(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      attributes: attributes ?? this.attributes,
      profileKeywordDataMap: profileKeywordDataMap ?? this.profileKeywordDataMap,
      selfDescription: selfDescription ?? this.selfDescription,
      accountType: accountType ?? this.accountType,
      profileAvatarIcon: profileAvatarIcon ?? this.profileAvatarIcon,
      profileAvatarIconId: profileAvatarIconId ?? this.profileAvatarIconId,
      workReferenceImageUrls: workReferenceImageUrls ?? this.workReferenceImageUrls,
      activePostingIds: activePostingIds ?? this.activePostingIds,
      lastOnlineAt: lastOnlineAt ?? this.lastOnlineAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
