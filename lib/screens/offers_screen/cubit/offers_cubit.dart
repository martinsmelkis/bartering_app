import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attributes_data.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/text_utils.dart';
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
          (e) => ParsedAttributeData(attribute: TextUtils.normalizeSnakeCase(e.attribute),
              relevancyScore: e.relevancyScore,
              uiStyleHint: e.uiStyleHint)).toList()));

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
      // Check if this offer exists in the allOffers list (case-insensitive)
      final matchIndex = state.allOffers.indexWhere(
            (offer) =>
            offer.attribute.toLowerCase().replaceAll("_", " ").trim() ==
                saved.attribute.toLowerCase().replaceAll("_", " ").trim(),
      );

      if (matchIndex != -1) {
        // It exists in predefined offers, select it
        selectedOffers.add(state.allOffers[matchIndex]);
      } else {
        // It's a custom keyword
        customKeywords.add(TextUtils.normalizeSnakeCase(saved.attribute));
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
        print('@@@@@@@@@@@ offersMap get offersMap ${entry.key} ${offersMap[entry.key]}');
        return ParsedAttributeData(
          attribute: entry.key,
          relevancyScore: 1.0 - (entry.value * 0.02),
          uiStyleHint: offersMap[entry.key] ?? 'user_defined', // User manually selected/added these
        );
      }).toList();

      _userRepository.offerings = offersData;

      final offersDataToSubmit = UserAttributesData(
        userId: _userRepository.userId!,
        attributesRelevancyData: offersMapToSubmit,
      );

      final submitResult = await _apiClient.parseOfferings(
          offersDataToSubmit, languageCode);

      print('@@@@@@@@@@@@ parse offers submitResult $submitResult');

      emit(state.copyWith(status: OffersStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: OffersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

}