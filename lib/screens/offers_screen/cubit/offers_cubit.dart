import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attributes_data.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configure_dependencies.dart';
import '../../../repositories/user_repository.dart';

part 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final UserRepository _userRepository;
  final ApiClient _apiClient;

  OffersCubit(this._apiClient, this._userRepository)
      : super(OffersState.initial()) {
    _loadSavedOffers();
  }

  /// Loads and pre-selects the user's saved offers
  Future<void> _loadSavedOffers() async {
    final savedOffers = await _userRepository.getOfferings(loadFromStorage: true);
    if (savedOffers == null || savedOffers.isEmpty) return;

    emit(state.copyWith(allOffers: (await _userRepository.getOfferings())?.map(
          (e) => ParsedAttributeData(
              attributeKey: e.effectiveAttributeKey,
              attribute: e.attribute, // Pass through display name as-is, AttributeBubble handles translation
              relevancyScore: e.relevancyScore,
              uiStyleHint: e.uiStyleHint,
          )).toList()));

    // If allOffers is empty, all saved items are treated as custom
    if (state.allOffers.isEmpty) {
      final customKeywords = savedOffers.map((e) => e.attribute).toList();
      emit(state.copyWith(customKeywords: customKeywords));
      return;
    }

    // Find matches between saved offers and available allOffers
    final List<ParsedAttributeData> selectedOffers = [];
    final List<String> customKeywords = [];

    for (var saved in savedOffers) {
      // Check if this offer exists in the allOffers list using effectiveAttributeKey
      // for consistent matching across languages (attributeKey doesn't change with locale)
      final matchIndex = state.allOffers.indexWhere(
            (offer) =>
            offer.effectiveAttributeKey.toLowerCase().trim() ==
                saved.effectiveAttributeKey.toLowerCase().trim(),
      );

      if (matchIndex != -1) {
        // It exists in predefined offers, select it
        selectedOffers.add(state.allOffers[matchIndex]);
      } else {
        // It's a custom keyword - use display name as-is for UI
        customKeywords.add(saved.attribute);
      }
    }

    if (selectedOffers.isNotEmpty || customKeywords.isNotEmpty) {
      emit(state.copyWith(
        selectedOffers: selectedOffers,
        customKeywords: customKeywords,
      ));
    }
  }

  void toggleInterest(ParsedAttributeData offer) {
    final newSelectedOffers = List<ParsedAttributeData>.from(state.selectedOffers);
    if (newSelectedOffers.contains(offer)) {
      newSelectedOffers.remove(offer);
    } else {
      newSelectedOffers.add(offer);
    }
    emit(state.copyWith(selectedOffers: newSelectedOffers));
  }

  void addCustomKeyword(String keyword) {
    if (keyword.trim().isEmpty) return;
    final newCustomKeywords = List<String>.from(state.customKeywords);
    if (!newCustomKeywords.contains(keyword.trim())) {
      newCustomKeywords.add(keyword.trim());
      emit(state.copyWith(customKeywords: newCustomKeywords));
    }
  }

  void removeCustomKeyword(String keyword) {
    final newCustomKeywords = List<String>.from(state.customKeywords);
    newCustomKeywords.remove(keyword);
    emit(state.copyWith(customKeywords: newCustomKeywords));
  }

  Future<void> submitOffers(String languageCode) async {
    // Validate that at least one offer is selected (either from chips or custom keywords)
    if (state.selectedOffers.isEmpty && state.customKeywords.isEmpty) {
      emit(state.copyWith(
        status: OffersStatus.error,
        errorMessage: 'Please select at least one offer or add a custom keyword',
      ));
      return;
    }

    // Ensure userId is loaded from storage
    final userId = await _userRepository.getUserId();
    if (userId == null || userId.isEmpty) {
      emit(state.copyWith(
        status: OffersStatus.error,
        errorMessage: 'User not initialized. Please restart the app.',
      ));
      return;
    }

    emit(state.copyWith(status: OffersStatus.loading));
    try {
      final allOffers = {
        ...state.customKeywords,
        ...state.selectedOffers.map((offer) => offer.attribute)
      }.toList();

      final Map<String, String> offersMap = {};
      state.selectedOffers.forEach((offer) => offersMap[offer.attribute] = offer.uiStyleHint);

      final offersMapToSubmit = Map<String, double>();
      var idx = 0;
      for (var offer in allOffers) {
        offersMapToSubmit[offer] = 1.0 - (idx * 0.02);
        idx++;
      }

      // Convert to ParsedAttributeData for storage
      final offersData = offersMapToSubmit
          .entries
          .map((entry) {
        logDebug('@@@@@@@@@@@ offersMap get offersMap ${entry.key} ${offersMap[entry.key]}');
        // For custom user-entered attributes, preserve diacritics so "Zemeņu vākšana" 
        // can match between users who entered the same custom text
        final normalizedKey = TextUtils.normalizeCustomAttributeKey(entry.key);
        return ParsedAttributeData(
          attributeKey: normalizedKey.isNotEmpty ? normalizedKey : entry.key.toLowerCase().replaceAll(' ', '_'),
          attribute: entry.key, // Display name (user input - preserves diacritics)
          relevancyScore: 1.0 - (entry.value * 0.02),
          uiStyleHint: offersMap[entry.key] ?? 'user_defined', // User manually selected/added these
        );
      }).toList();

      _userRepository.offerings = offersData;

      final offersDataToSubmit = UserAttributesData(
        userId: userId,
        attributesRelevancyData: offersMapToSubmit,
      );

      final submitResult = await _apiClient.parseOfferings(
          offersDataToSubmit, languageCode);

      logDebug('@@@@@@@@@@@@ parse offers submitResult $submitResult');

      emit(state.copyWith(status: OffersStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: OffersStatus.error,
        errorMessage: _extractApiErrorMessage(e),
      ));
    }
  }

  String _extractApiErrorMessage(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;

      // Backend may return plain text (content-type: text/plain)
      if (responseData is String && responseData.trim().isNotEmpty) {
        return _toFriendlyErrorMessage(responseData.trim());
      }

      // JSON error formats
      if (responseData is Map<String, dynamic>) {
        final candidates = [
          responseData['message'],
          responseData['error'],
          responseData['detail'],
        ];

        for (final candidate in candidates) {
          if (candidate is String && candidate.trim().isNotEmpty) {
            return _toFriendlyErrorMessage(candidate.trim());
          }
        }
      }

      final statusCode = error.response?.statusCode;
      if (statusCode == 400) {
        return 'Your offers could not be processed. Please review and try again.';
      }
      if (statusCode == 429) {
        return 'Too many requests. Please wait a moment and try again.';
      }
      if (statusCode != null && statusCode >= 500) {
        return 'Server is temporarily unavailable. Please try again later.';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Network error. Please check your internet connection and try again.';
      }
    }

    return 'Could not process your offers. Please try again.';
  }

  String _toFriendlyErrorMessage(String message) {
    final normalized = message.toLowerCase();

    if (normalized.contains('too many attributes') &&
        normalized.contains('maximum allowed')) {
      final match = RegExp(r'maximum allowed:\s*(\d+)', caseSensitive: false)
          .firstMatch(message);
      final maxAllowed = match?.group(1);
      return maxAllowed != null
          ? 'You can select up to $maxAllowed offers. Please remove some and try again.'
          : 'You selected too many offers. Please remove some and try again.';
    }

    return message;
  }

}