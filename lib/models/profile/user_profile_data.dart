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
  final double? longitude;
  final double? latitude;
  final List<UserAttributeEntryData>? attributes;
  final Map<String, double>? profileKeywordDataMap;
  final List<String>? activePostingIds;
  @JsonKey(includeIfNull: false)
  final String? preferredLanguage;
  @JsonKey(includeIfNull: false)
  final int? lastOnlineAt; // Timestamp in milliseconds when user was last online
  @JsonKey(includeIfNull: false)
  final double? averageRating; // Average rating score (0.0 to 5.0)
  @JsonKey(includeIfNull: false)
  final int? totalReviews; // Total number of reviews received

  const UserProfileData({
    required this.userId,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.attributes,
    required this.profileKeywordDataMap,
    required this.activePostingIds,
    this.preferredLanguage,
    this.lastOnlineAt,
    this.averageRating,
    this.totalReviews,
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
    
    // Create a modified JSON with the parsed map
    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['profileKeywordDataMap'] = parsedKeywordMap;
    
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
    List<String>? activePostingIds,
    String? preferredLanguage,
    int? lastOnlineAt,
    double? averageRating,
    int? totalReviews,
  }) {
    return UserProfileData(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      attributes: attributes ?? this.attributes,
      profileKeywordDataMap: profileKeywordDataMap ?? this.profileKeywordDataMap,
      activePostingIds: activePostingIds ?? this.activePostingIds,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      lastOnlineAt: lastOnlineAt ?? this.lastOnlineAt,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}
