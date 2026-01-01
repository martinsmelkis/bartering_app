// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOnboardingData _$UserOnboardingDataFromJson(Map<String, dynamic> json) =>
    UserOnboardingData(
      userId: json['userId'] as String,
      onboardingKeyNamesToWeights:
          (json['onboardingKeyNamesToWeights'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
    );

Map<String, dynamic> _$UserOnboardingDataToJson(UserOnboardingData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'onboardingKeyNamesToWeights': instance.onboardingKeyNamesToWeights,
    };
