/// Response model for review eligibility check
class ReviewEligibilityResponse {
  final bool eligible;
  final String? transactionId;
  final String? reason;
  final String otherUserName;
  final String? otherUserAvatarUrl;
  final int? transactionCompletedAt;

  ReviewEligibilityResponse({
    required this.eligible,
    this.transactionId,
    this.reason,
    required this.otherUserName,
    this.otherUserAvatarUrl,
    this.transactionCompletedAt,
  });

  factory ReviewEligibilityResponse.fromJson(Map<String, dynamic> json) {
    return ReviewEligibilityResponse(
      eligible: json['eligible'] as bool,
      transactionId: json['transactionId'] as String?,
      reason: json['reason'] as String?,
      otherUserName: json['otherUserName'] as String,
      otherUserAvatarUrl: json['otherUserAvatarUrl'] as String?,
      transactionCompletedAt: json['transactionCompletedAt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eligible': eligible,
      'transactionId': transactionId,
      'reason': reason,
      'otherUserName': otherUserName,
      'otherUserAvatarUrl': otherUserAvatarUrl,
      'transactionCompletedAt': transactionCompletedAt,
    };
  }
}

/// Legacy alias for backwards compatibility
typedef ReviewEligibility = ReviewEligibilityResponse;
