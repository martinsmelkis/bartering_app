import 'dart:convert';
import 'dart:io';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_onboarding_data.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/device_fingerprint_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:drift/drift.dart' as drift;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../repositories/user_repository.dart';

part 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final UserRepository _userRepository;
  final ApiClient _apiClient;
  final DeviceFingerprintService _fingerprintService;

  OnboardingCubit(
    this._userRepository,
    this._apiClient,
    this._fingerprintService,
  ) : super(OnboardingState.initial());
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
    logDebug('@@@@@@@@@@@ initQuestions called, setting status to initial');
    emit(state.copyWith(
      questions: initialQuestions,
      isCompleted: true,
      status: OnboardingStatus.initial,
    ));
  }

  void reset() {
    logDebug('@@@@@@@@@@@ Resetting cubit to initial state');
    if (!isClosed) {
      emit(OnboardingState.initial());
    }
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
      logDebug("Onboarding not yet complete. Cannot submit.");
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(status: OnboardingStatus.submitting));

    try {
      Map<String, double>? profileData = getProfileSummary();
      if (profileData.isEmpty) {
        profileData = await _userRepository.getProfileKeywordDataMap();
      }
      final userId = _userRepository.userId;

      if (userId == null) {
        throw Exception("User ID is null, cannot complete onboarding.");
      }

      if (profileData == null) {
        throw Exception("Profile data is null, cannot complete onboarding.");
      }

      _userRepository.profileKeywordDataMap = profileData;
      await _userRepository.saveProfileKeywordDataMap(profileData);

      // --- Check if this is initial onboarding (no prior profile exists) ---
      final AppDatabase _appDatabase = getIt<AppDatabase>();
      final existingProfileCount = await _appDatabase.profiles.count().getSingle();
      final isInitialOnboarding = existingProfileCount == 0;

      // --- Save data to local Drift database ---
      final encodableProfileData = profileData.map((key, value) =>
          MapEntry(key.toString(), value));
      final onboardingJson = jsonEncode(encodableProfileData);
      final userCompanion = ProfilesCompanion(
        userId: drift.Value(userId),
        onboardingData: drift.Value(onboardingJson),
      );
      logDebug("@@@@@@@@@ User data saved to local database 0.");
      logDebug("@@@@@@@@@ User data saved to local database 1.");
      await _appDatabase.profiles.insertOne(
          userCompanion, mode: drift.InsertMode.insertOrReplace);
      logDebug("@@@@@@@@@ User data saved to local database.");

      final usersData = await _appDatabase.profiles.select().get();
      logDebug('@@@@@@@@@@ usersData in DB: ${ usersData}');

      logDebug('@@@@@@@@@@@ Submit onboarding data: $profileData');
      // --- Call API ---
      UserOnboardingData user = UserOnboardingData(
          userId: userId, onboardingKeyNamesToWeights: profileData);

      final interestsList = await _apiClient.getInterestsFromOnboardingData(
          user, languageCode);

      logDebug('@@@@@@@@@@@ API Result: $interestsList');
      logDebug('API Result: $interestsList');

      updateInterestsList(interestsList);

      // --- Register device only on initial onboarding ---
      if (isInitialOnboarding) {
        await _registerDevice(userId);
      } else {
        logDebug('ℹ️ Skipping device registration - user profile already exists (re-onboarding)');
      }

      // Check if cubit is still active before emitting
      logDebug('@@@@@@@@@@@ About to emit success state. isClosed: $isClosed');
      if (!isClosed) {
        emit(state.copyWith(status: OnboardingStatus.success,
            interestsKeyList: interestsList));
        logDebug('@@@@@@@@@@@ Success state emitted');
      } else {
        logDebug('@@@@@@@@@@@ Cubit was closed, cannot emit success state');
      }
    } catch (e) {
      logDebugError('Error completing onboarding', e);
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

  /// Registers the device with the backend after successful onboarding
  Future<void> _registerDevice(String userId) async {
    try {
      // Get device fingerprint
      final deviceId = await _getDeviceId();
      
      // Get public key from crypto service
      final cryptoService = await CryptoService.create();
      final publicKey = cryptoService.ecPublicKeyToString(cryptoService.getPublicKey()!);
      
      // Platform detection
      String platform;
      if (kIsWeb) {
        platform = 'web';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        platform = 'android';
      }
      
      // Device name
      final deviceName = await _getDeviceName();

      final response = await _apiClient.registerDevice({
        'userId': userId,
        'deviceId': deviceId,
        'publicKey': publicKey,
        'deviceName': deviceName,
        'deviceType': 'mobile',
        'platform': platform,
      });

      if (response.success) {
        logDebug('✅ Device registered successfully after onboarding');
      } else {
        logDebugError('Failed to register device after onboarding: ${response.message}');
      }
    } catch (e) {
      // Don't fail onboarding if device registration fails
      logDebugError('Error registering device after onboarding: $e');
    }
  }

  /// Gets a unique device ID using fingerprint service with fallback
  Future<String> _getDeviceId() async {
    try {
      // Try to get hardware-based fingerprint first
      return await _fingerprintService.getDeviceFingerprint();
    } catch (e) {
      // Fallback for web or errors
      logDebug('Using fallback device ID generation: $e');
      return _generateFallbackDeviceId();
    }
  }

  /// Generates a fallback device ID when fingerprint service fails
  Future<String> _generateFallbackDeviceId() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = base64Encode(List<int>.generate(16, (_) => timestamp % 256));
    final deviceId = 'device_${timestamp}_$random';
    return deviceId;
  }

  /// Gets a friendly device name
  Future<String> _getDeviceName() async {
    try {
      String platformName;
      if (kIsWeb) {
        platformName = 'Web';
      } else if (Platform.isIOS) {
        platformName = 'iPhone';
      } else {
        platformName = 'Android';
      }
      return '$platformName Device';
    } catch (e) {
      return 'Mobile Device';
    }
  }
}