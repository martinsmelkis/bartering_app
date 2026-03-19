import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/reviews/reputation_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_of_interest.g.dart';

@JsonSerializable() // Add this annotation
class PointOfInterest {
  final UserProfileData profile;
  final double? distanceKm;
  double? matchRelevancyScore;
  // Optional rating fields that can override profile values
  double? averageRating;
  int? totalReviews;
  final List<ReputationBadge>? badges;

  PointOfInterest({
    required this.profile,
    required this.distanceKm,
    this.averageRating,
    this.totalReviews,
    this.badges,
  });
  
  // Helper method to get online status from profile
  bool get isOnline => profile.isOnline;

  // Helper method to get away status from profile
  bool get isAway => profile.isAway;

  // Factory constructor for creating a new PointOfInterest instance from a map.
  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    final base = _$PointOfInterestFromJson(json);
    final rawBadges = json['badges'] as List<dynamic>?;

    return base.copyWith(
      badges: rawBadges
          ?.map((b) => ReputationBadge.fromString(b.toString()))
          .whereType<ReputationBadge>()
          .toList(),
    )..matchRelevancyScore = base.matchRelevancyScore;
  }

  // Method for converting a PointOfInterest instance into a map.
  Map<String, dynamic> toJson() {
    final json = _$PointOfInterestToJson(this);
    json['badges'] = badges?.map((b) => b.value).toList();
    return json;
  }

  PointOfInterest copyWith({
    UserProfileData? userProfileData,
    double? distanceKm,
    double? matchRelevancyScore,
    double? averageRating,
    int? totalReviews,
    List<ReputationBadge>? badges,
  }) {
    return PointOfInterest(
      profile: userProfileData ?? profile,
      distanceKm: distanceKm ?? this.distanceKm,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      badges: badges ?? this.badges,
    )..matchRelevancyScore =
        matchRelevancyScore ?? this.matchRelevancyScore;
  }
}