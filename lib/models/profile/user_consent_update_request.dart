import 'package:json_annotation/json_annotation.dart';

part 'user_consent_update_request.g.dart';

@JsonSerializable()
class UserConsentUpdateRequest {
  final String userId;
  @JsonKey(includeIfNull: false)
  final bool? locationConsent;
  @JsonKey(includeIfNull: false)
  final bool? aiProcessingConsent;
  @JsonKey(includeIfNull: false)
  final bool? analyticsCookiesConsent;
  @JsonKey(includeIfNull: false)
  final bool? federationConsent;
  @JsonKey(includeIfNull: false)
  final String? privacyPolicyVersion;
  @JsonKey(includeIfNull: false)
  final String? termsConditionsVersion;

  const UserConsentUpdateRequest({
    required this.userId,
    this.locationConsent,
    this.aiProcessingConsent,
    this.analyticsCookiesConsent,
    this.federationConsent,
    this.privacyPolicyVersion,
    this.termsConditionsVersion,
  });

  factory UserConsentUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserConsentUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserConsentUpdateRequestToJson(this);
}
