import 'dart:convert';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/reviews/review_eligibility.dart';
import 'package:barter_app/models/reviews/review_submission.dart';
import 'package:barter_app/models/reviews/transaction_status.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/review_screen/models/risk_analysis_model.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final String otherUserId;
  final ReviewEligibilityResponse eligibility;
  final ApiClient _apiClient;
  final UserRepository _userRepository;

  int rating = 0;
  TransactionStatus? selectedStatus;
  String? reviewText;

  ReviewCubit({
    required this.otherUserId,
    required this.eligibility,
    ApiClient? apiClient,
    UserRepository? userRepository,
  })  : _apiClient = apiClient ?? getIt<ApiClient>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(const ReviewInitial());

  bool get isFormValid => rating > 0 && selectedStatus != null;

  void updateRating(int newRating) {
    rating = newRating;
  }

  void updateStatus(TransactionStatus? status) {
    selectedStatus = status;
  }

  void updateReviewText(String text) {
    reviewText = text.isEmpty ? null : text;
  }

  Future<void> submitReview({
    required String defaultErrorMessage,
  }) async {
    if (!isFormValid) return;

    // Check if scam warning is required
    if (selectedStatus == TransactionStatus.scam) {
      emit(const ReviewScamWarningRequired());
      return;
    }

    await _performSubmit(defaultErrorMessage: defaultErrorMessage);
  }

  Future<void> submitReviewAfterScamConfirmation({
    required String defaultErrorMessage,
  }) async {
    await _performSubmit(defaultErrorMessage: defaultErrorMessage);
  }

  void acknowledgeRiskAndProceed() {
    // After showing risk warning, mark as success
    emit(const ReviewSubmitSuccess());
  }

  void cancelAfterRisk() {
    // User cancelled after seeing risk warning
    emit(const ReviewInitial());
  }

  Future<void> _performSubmit({
    required String defaultErrorMessage,
  }) async {
    emit(const ReviewSubmitting());

    try {
      final currentUserId = await _userRepository.getUserId();

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final submission = SubmitReviewRequest(
        transactionId: eligibility.transactionId!,
        reviewerId: currentUserId,
        targetUserId: otherUserId,
        rating: rating,
        reviewText: reviewText,
        transactionStatus: selectedStatus!.value,
      );

      final response = await _apiClient.submitReview(submission);

      if (response.success) {
        // Check if response includes risk analysis
        if (response.riskAnalysisReport != null) {
          // Emit risk analysis state to show dialog
          emit(ReviewRiskAnalysisDetected(response.riskAnalysisReport!));
        } else {
          emit(const ReviewSubmitSuccess());
        }
      } else {
        emit(ReviewSubmitError(defaultErrorMessage));
      }
    } on DioException catch (e) {

      if (e.response?.statusCode == 403) {
        // Blocked by risk analysis
        emit(ReviewSubmitError('Transaction blocked'));
      }

      // Extract error message from API response
      String errorMessage = defaultErrorMessage;

      if (e.response?.data != null) {
        try {
          // Try to parse JSON response
          final data = e.response!.data;
          if (data is Map<String, dynamic> && data.containsKey('error')) {
            errorMessage = data['error'];
          } else if (data is String) {
            // Try to parse string as JSON
            final jsonData = jsonDecode(data);
            if (jsonData is Map<String, dynamic> && jsonData.containsKey('error')) {
              errorMessage = jsonData['error'];
            }
          }
        } catch (parseError) {
          // If parsing fails, use the default error message
          print('Error parsing error response: $parseError');
        }
      }

      emit(ReviewSubmitError(errorMessage));
    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }

}