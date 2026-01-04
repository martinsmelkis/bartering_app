import 'transaction_status.dart';

/// Request model for submitting a review
class SubmitReviewRequest {
  final String transactionId;
  final String reviewerId;
  final String targetUserId;
  final int rating;
  final String? reviewText;
  final String transactionStatus;

  SubmitReviewRequest({
    required this.transactionId,
    required this.reviewerId,
    required this.targetUserId,
    required this.rating,
    this.reviewText,
    required this.transactionStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'reviewerId': reviewerId,
      'targetUserId': targetUserId,
      'rating': rating,
      if (reviewText != null) 'reviewText': reviewText,
      'transactionStatus': transactionStatus,
    };
  }
}

/// Response model for review submission
class SubmitReviewResponse {
  final bool success;
  final String? reviewId;
  final String message;

  SubmitReviewResponse({
    required this.success,
    this.reviewId,
    required this.message,
  });

  factory SubmitReviewResponse.fromJson(Map<String, dynamic> json) {
    return SubmitReviewResponse(
      success: json['success'] as bool,
      reviewId: json['reviewId'] as String?,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'reviewId': reviewId,
      'message': message,
    };
  }
}

/// Legacy model for backwards compatibility
class ReviewSubmission {
  final String transactionId;
  final String reviewerId;
  final String targetUserId;
  final int rating;
  final String? reviewText;
  final TransactionStatus transactionStatus;

  ReviewSubmission({
    required this.transactionId,
    required this.reviewerId,
    required this.targetUserId,
    required this.rating,
    this.reviewText,
    required this.transactionStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'reviewerId': reviewerId,
      'targetUserId': targetUserId,
      'rating': rating,
      'reviewText': reviewText,
      'transactionStatus': transactionStatus.value,
    };
  }

  /// Convert to new request format
  SubmitReviewRequest toRequest() {
    return SubmitReviewRequest(
      transactionId: transactionId,
      reviewerId: reviewerId,
      targetUserId: targetUserId,
      rating: rating,
      reviewText: reviewText,
      transactionStatus: transactionStatus.value,
    );
  }
}

/// Legacy alias for backwards compatibility
typedef ReviewSubmissionResponse = SubmitReviewResponse;
