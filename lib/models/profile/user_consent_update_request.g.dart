// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_consent_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConsentUpdateRequest _$UserConsentUpdateRequestFromJson(
  Map<String, dynamic> json,
) => UserConsentUpdateRequest(
  userId: json['userId'] as String,
  locationConsent: json['locationConsent'] as bool?,
  aiProcessingConsent: json['aiProcessingConsent'] as bool?,
  analyticsCookiesConsent: json['analyticsCookiesConsent'] as bool?,
  federationConsent: json['federationConsent'] as bool?,
  privacyPolicyVersion: json['privacyPolicyVersion'] as String?,
  termsConditionsVersion: json['termsConditionsVersion'] as String?,
);

Map<String, dynamic> _$UserConsentUpdateRequestToJson(
  UserConsentUpdateRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'locationConsent': ?instance.locationConsent,
  'aiProcessingConsent': ?instance.aiProcessingConsent,
  'analyticsCookiesConsent': ?instance.analyticsCookiesConsent,
  'federationConsent': ?instance.federationConsent,
  'privacyPolicyVersion': ?instance.privacyPolicyVersion,
  'termsConditionsVersion': ?instance.termsConditionsVersion,
};
