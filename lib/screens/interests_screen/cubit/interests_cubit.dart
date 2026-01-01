import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attributes_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../configure_dependencies.dart';

part 'interests_state.dart';

@injectable
class InterestsCubit extends Cubit<InterestsState> {
  ApiClient? _apiClient;
  final UserRepository _userRepository;
  //List<ParsedAttributeData>? initialInterests = getIt(instanceName: 'initialInterests');

  InterestsCubit(this._apiClient, this._userRepository)
      : super(InterestsState.initial()) {
    _loadSavedInterests();
  }

  /// Loads and pre-selects the user's saved interests
  Future<void> _loadSavedInterests() async {
    final savedInterests = await _userRepository.getInterests(loadFromStorage: true);
    if (savedInterests == null || savedInterests.isEmpty) return;

    emit(state.copyWith(allInterests: await _userRepository.getInterests()));

    // If allInterests is empty, all saved items are treated as custom
    if (state.allInterests.isEmpty) {
      final customKeywords = savedInterests.map((e) => e.attribute).toList();
      emit(state.copyWith(customKeywords: customKeywords));
      return;
    }

    // Find matches between saved interests and available allInterests
    final List<ParsedAttributeData> selectedInterests = [];
    final List<String> customKeywords = [];

    for (var saved in savedInterests) {
      // Check if this interest exists in the allInterests list (case-insensitive)
      final matchIndex = state.allInterests.indexWhere(
            (interest) =>
        interest.attribute.toLowerCase().replaceAll("_", " ").trim() ==
            saved.attribute.toLowerCase().replaceAll("_", " ").trim(),
      );

      if (matchIndex != -1) {
        // It exists in predefined interests, select it
        selectedInterests.add(state.allInterests[matchIndex]);
      } else {
        // It's a custom keyword
        customKeywords.add(TextUtils.normalizeSnakeCase(saved.attribute));
      }
    }

    if (selectedInterests.isNotEmpty || customKeywords.isNotEmpty) {
      emit(state.copyWith(
        selectedInterests: selectedInterests,
        customKeywords: customKeywords,
      ));
    }
  }

  void toggleInterest(ParsedAttributeData interest) {
    final newSelectedInterests = List<ParsedAttributeData>.from(state.selectedInterests);
    if (newSelectedInterests.contains(interest)) {
      newSelectedInterests.remove(interest);
    } else {
      newSelectedInterests.add(interest);
    }
    emit(state.copyWith(selectedInterests: newSelectedInterests));
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

  Future<void> submitInterests(String languageCode) async {
    emit(state.copyWith(status: InterestsStatus.loading));
    try {
      if (state.selectedInterests!.isEmpty) {
        emit(state.copyWith(status: InterestsStatus.initial, selectedInterests: await _userRepository.getInterests()));
      }
      final allInterests = {
        ...state.customKeywords,
        ...state.selectedInterests.map((interest) => interest.attribute)
      }.toList();

      final Map<String, String> interestsMap = {};
      state.selectedInterests.forEach((offer) => interestsMap[offer.attribute] = offer.uiStyleHint);

      // User-defined attributes have weight 1, decreasing slightly for each
      final interestsMapToSubmit = Map<String, double>();
      var idx = 0;
      for (var interest in allInterests) {
        interestsMapToSubmit[interest] = 1.0 - (idx * 0.02);
        idx++;
      }

      // Convert to ParsedAttributeData for storage (user-defined, so no specific category)
      final interestsData = interestsMapToSubmit
          .entries
          .map((entry) {
        return ParsedAttributeData(
          attribute: entry.key,
          relevancyScore: 1.0 - (entry.value * 0.02),
          uiStyleHint: interestsMap[entry.key] ?? 'user_defined', // User manually selected/added these
        );
      }).toList();

      print('@@@@@@@@@ saved interestsData: $interestsData');
      _userRepository.interests = interestsData;

      final interestsDataForApi = UserAttributesData(
          userId: _userRepository.userId!,
          attributesRelevancyData: interestsMapToSubmit
      );

      final offersList = await _apiClient?.parseInterestsToGetOfferings(
          interestsDataForApi, languageCode);
      updateOffersList(offersList ?? []);
      //_userRepository.offerings = offersList ?? [];

      emit(state.copyWith(status: InterestsStatus.success,
          offersKeyList: offersList));
    } catch (e) {
      emit(state.copyWith(
        status: InterestsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateOffersList(List<ParsedAttributeData> parsedOffers) {
    _userRepository.userOfferings = parsedOffers;
  }

}