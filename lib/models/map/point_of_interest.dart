import 'package:barter_app/models/profile/user_profile_data.dart';
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

  PointOfInterest({
    required this.profile,
    required this.distanceKm,
    this.averageRating,
    this.totalReviews,
  });
  
  // Helper method to get online status from profile
  bool get isOnline => profile.isOnline;

  // Helper method to get away status from profile
  bool get isAway => profile.isAway;

  // Factory constructor for creating a new PointOfInterest instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory PointOfInterest.fromJson(Map<String, dynamic> json) =>
      _$PointOfInterestFromJson(json);

  // Method for converting a PointOfInterest instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$PointOfInterestToJson(this);

  PointOfInterest copyWith({
    UserProfileData? userProfileData,
    double? distanceKm,
    double? matchRelevancyScore,
    double? averageRating,
    int? totalReviews,
  }) {
    return PointOfInterest(
      profile: profile,
      distanceKm: distanceKm ?? this.distanceKm,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}