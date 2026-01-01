import 'dart:convert';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_onboarding_data.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:drift/drift.dart' as drift;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../repositories/user_repository.dart';

part 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final UserRepository _userRepository;

  OnboardingCubit(this._userRepository) : super(OnboardingState.initial());
  void answerQuestion(int questionIndex, double answer) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) return;

    final updatedQuestions = List<OnboardingQuestion>.from(state.questions);
    updatedQuestions[questionIndex] =
        updatedQuestions[questionIndex].copyWith(answer: answer);

    final allAnswered = updatedQuestions.every((q) => q.answer != null);

    emit(state.copyWith(
      questions: updatedQuestions,
      isCompleted: true,
      status: allAnswered
          ? OnboardingStatus.inProgress
          : OnboardingStatus.initial,
    ));
  }

  void initQuestions(List<OnboardingQuestion>? initialQuestions) {
    emit(state.copyWith(
      questions: initialQuestions,
      isCompleted: true,
      status: OnboardingStatus.initial,
    ));
  }

  Map<String, double> getProfileSummary() {
    final Map<String, double> summary = {};
    for (var question in state.questions) {
      summary[question.text] = question.answer ?? 0.5;
    }
    return summary;
  }

  Future<void> completeOnboarding(String languageCode) async {
    if (!state.isCompleted) {
      print("Onboarding not yet complete. Cannot submit.");
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(status: OnboardingStatus.submitting));

    try {
      Map<String, double>? profileData = getProfileSummary();
      if (profileData.isEmpty) {
        profileData = await _userRepository.getProfileKeywordData;
      }
      final userId = _userRepository.userId;

      if (userId == null) {
        throw Exception("User ID is null, cannot complete onboarding.");
      }

      _userRepository.profileKeywordDataMap = profileData;
      _userRepository.saveProfileKeywordDataMap(profileData!);

      // --- Save data to local Drift database ---
      final encodableProfileData = profileData.map((key, value) =>
          MapEntry(key.toString(), value));
      final onboardingJson = jsonEncode(encodableProfileData);
      final userCompanion = ProfilesCompanion(
        userId: drift.Value(userId),
        onboardingData: drift.Value(onboardingJson),
      );
      print("@@@@@@@@@ User data saved to local database 0.");
      final AppDatabase _appDatabase = getIt<AppDatabase>();
      print("@@@@@@@@@ User data saved to local database 1.");
      await _appDatabase.profiles.insertOne(
          userCompanion, mode: drift.InsertMode.insertOrReplace);
      print("@@@@@@@@@ User data saved to local database.");

      final usersData = await _appDatabase.profiles.select().get();
      print('@@@@@@@@@@ usersData in DB: ${ usersData}');

      print('@@@@@@@@@@@ Submit onboarding data: $profileData');
      // --- Call API ---
      UserOnboardingData user = UserOnboardingData(
          userId: userId, onboardingKeyNamesToWeights: profileData);

      final _apiClient = ApiClient.create();
      final interestsList = await _apiClient.getInterestsFromOnboardingData(
          user, languageCode);

      print('@@@@@@@@@@@ API Result: $interestsList');
      print('API Result: $interestsList');

      updateInterestsList(interestsList);

      // Check if cubit is still active before emitting
      if (!isClosed) {
        emit(state.copyWith(status: OnboardingStatus.success,
            interestsKeyList: interestsList));
      }
    } catch (e) {
      print('@@@@@@@@@ Error completing onboarding: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: OnboardingStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void updateInterestsList(List<ParsedAttributeData> parsedInterests) {
    _userRepository.userInterests = parsedInterests;
  }

}