import 'package:barter_app/screens/review_screen/models/risk_analysis_model.dart';

class SubmitReviewResult {
  final bool success;
  final String? reviewId;
  final String? message;
  final bool blocked;
  final bool requiresVerification;
  final String? blockReason;
  final RiskAnalysisReport? riskReport;

  SubmitReviewResult._({
    required this.success,
    this.reviewId,
    this.message,
    this.blocked = false,
    this.requiresVerification = false,
    this.blockReason,
    this.riskReport,
  });

  factory SubmitReviewResult.success({
    required String reviewId,
    required String message,
  }) {
    return SubmitReviewResult._(
      success: true,
      reviewId: reviewId,
      message: message,
    );
  }

  factory SubmitReviewResult.blocked({
    required String reason,
    RiskAnalysisReport? riskReport,
  }) {
    return SubmitReviewResult._(
      success: false,
      blocked: true,
      blockReason: reason,
      riskReport: riskReport,
    );
  }

  factory SubmitReviewResult.requiresVerification({
    required RiskAnalysisReport riskReport,
  }) {
    return SubmitReviewResult._(
      success: false,
      requiresVerification: true,
      riskReport: riskReport,
    );
  }
}