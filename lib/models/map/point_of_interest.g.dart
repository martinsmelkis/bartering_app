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
      badges: (json['badges'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ReputationBadgeEnumMap, e))
          .toList(),
    )..matchRelevancyScore = (json['matchRelevancyScore'] as num?)?.toDouble();

Map<String, dynamic> _$PointOfInterestToJson(
  PointOfInterest instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'distanceKm': instance.distanceKm,
  'matchRelevancyScore': instance.matchRelevancyScore,
  'averageRating': instance.averageRating,
  'totalReviews': instance.totalReviews,
  'badges': instance.badges?.map((e) => _$ReputationBadgeEnumMap[e]!).toList(),
};

const _$ReputationBadgeEnumMap = {
  ReputationBadge.VETERAN_TRADER: 'VETERAN_TRADER',
  ReputationBadge.TOP_RATED: 'TOP_RATED',
  ReputationBadge.QUICK_RESPONDER: 'QUICK_RESPONDER',
  ReputationBadge.COMMUNITY_CONNECTOR: 'COMMUNITY_CONNECTOR',
  ReputationBadge.PREMIUM_USER: 'PREMIUM_USER',
  ReputationBadge.TOP_1000: 'TOP_1000',
  ReputationBadge.DISPUTE_FREE: 'DISPUTE_FREE',
  ReputationBadge.FAST_TRADER: 'FAST_TRADER',
  ReputationBadge.IDENTITY_VERIFIED: 'IDENTITY_VERIFIED',
  ReputationBadge.VERIFIED_BUSINESS: 'VERIFIED_BUSINESS',
};
