import '../../screens/review_screen/models/risk_analysis_model.dart';
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
  final RiskAnalysisReport? riskAnalysisReport;

  SubmitReviewResponse({
    required this.success,
    this.reviewId,
    required this.message,
    this.riskAnalysisReport
  });

  factory SubmitReviewResponse.fromJson(Map<String, dynamic> json) {
    return SubmitReviewResponse(
      success: json['success'] as bool,
      reviewId: json['reviewId'] as String?,
      message: json['message'] as String,
      riskAnalysisReport: json['riskAnalysisReport'] != null
          ? RiskAnalysisReport.fromJson(json['riskAnalysisReport'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'reviewId': reviewId,
      'message': message,
      'riskAnalysisReport': riskAnalysisReport,
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

class EvidenceItem {
  final String type;
  final String reference;
  final String? description;

  EvidenceItem({
    required this.type,
    required this.reference,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'reference': reference,
      if (description != null) 'description': description,
    };
  }
}

class SubmitReviewAppealRequest {
  final String reviewId;
  final String appealedBy;
  final String reason;
  final List<EvidenceItem> evidenceItems;

  SubmitReviewAppealRequest({
    required this.reviewId,
    required this.appealedBy,
    required this.reason,
    this.evidenceItems = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'appealedBy': appealedBy,
      'reason': reason,
      'evidenceItems': evidenceItems.map((item) => item.toJson()).toList(),
    };
  }
}

class SubmitReviewAppealResponse {
  final bool success;
  final String appealId;
  final String message;

  SubmitReviewAppealResponse({
    required this.success,
    required this.appealId,
    required this.message,
  });

  factory SubmitReviewAppealResponse.fromJson(Map<String, dynamic> json) {
    return SubmitReviewAppealResponse(
      success: json['success'] as bool,
      appealId: json['appealId'] as String,
      message: json['message'] as String,
    );
  }
}

/// Legacy alias for backwards compatibility
typedef ReviewSubmissionResponse = SubmitReviewResponse;
