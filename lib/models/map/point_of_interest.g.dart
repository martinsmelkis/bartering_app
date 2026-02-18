// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_of_interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointOfInterest _$PointOfInterestFromJson(Map<String, dynamic> json) =>
    PointOfInterest(
      profile: UserProfileData.fromJson(
        json['profile'] as Map<String, dynamic>,
      ),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
    )..matchRelevancyScore = (json['matchRelevancyScore'] as num?)?.toDouble();

Map<String, dynamic> _$PointOfInterestToJson(PointOfInterest instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'distanceKm': instance.distanceKm,
      'matchRelevancyScore': instance.matchRelevancyScore,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
    };
