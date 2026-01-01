import 'package:json_annotation/json_annotation.dart';

part 'user_onboarding_data.g.dart'; // Import the generated part

@JsonSerializable()
class UserOnboardingData {
  final String userId;
  final Map<String, double> onboardingKeyNamesToWeights;

  const UserOnboardingData({
    required this.userId,
    required this.onboardingKeyNamesToWeights,
  });

  // Factory constructor for creating a new UserOnboardingData instance from a map.
  // Tell json_serializable to use this for deserialization.
  factory UserOnboardingData.fromJson(Map<String, dynamic> json) =>
      _$UserOnboardingDataFromJson(json);

  // Method for converting a UserOnboardingData instance into a map.
  // Tell json_serializable to use this for serialization.
  Map<String, dynamic> toJson() => _$UserOnboardingDataToJson(this);

  UserOnboardingData copyWith({
    String? userId,
    Map<String, double>? onboardingKeyNamesToWeights,
  }) {
    return UserOnboardingData(
      userId: userId ?? this.userId,
      onboardingKeyNamesToWeights: onboardingKeyNamesToWeights ?? this.onboardingKeyNamesToWeights,
    );
  }
}