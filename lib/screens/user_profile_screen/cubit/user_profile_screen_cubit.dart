import 'dart:io';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/platform/platform.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/reviews/reputation_response.dart';
import 'package:barter_app/models/reviews/review_response.dart';
import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/messaging/firebase_auth_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../utils/debug_utils.dart';

class UserProfileScreenState {
  final ReputationResponse? reputationData;
  final List<BadgeDetail>? userBadges;
  final WalletResponse? walletData;
  final bool isLoadingReputation;
  final bool isLoadingBadges;
  final bool isLoadingWallet;
  final ExportResult? exportResult;
  final String? errorMessage;

  const UserProfileScreenState({
    this.reputationData,
    this.userBadges,
    this.walletData,
    this.isLoadingReputation = false,
    this.isLoadingBadges = false,
    this.isLoadingWallet = false,
    this.exportResult,
    this.errorMessage,
  });

  UserProfileScreenState copyWith({
    ReputationResponse? reputationData,
    List<BadgeDetail>? userBadges,
    WalletResponse? walletData,
    bool? isLoadingReputation,
    bool? isLoadingBadges,
    bool? isLoadingWallet,
    ExportResult? exportResult,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserProfileScreenState(
      reputationData: reputationData ?? this.reputationData,
      userBadges: userBadges ?? this.userBadges,
      walletData: walletData ?? this.walletData,
      isLoadingReputation: isLoadingReputation ?? this.isLoadingReputation,
      isLoadingBadges: isLoadingBadges ?? this.isLoadingBadges,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      exportResult: exportResult ?? this.exportResult,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class UserProfileScreenCubit extends Cubit<UserProfileScreenState> {
  final ApiClient _apiClient;

  UserProfileScreenCubit(this._apiClient) : super(const UserProfileScreenState());

  Future<ReputationResponse> fetchReputation(String userId) async {
    emit(state.copyWith(isLoadingReputation: true, clearError: true));
    try {
      final reputation = await _apiClient.getReputation(userId);
      emit(state.copyWith(
        reputationData: reputation,
        isLoadingReputation: false,
      ));
      return reputation;
    } catch (e) {
      emit(state.copyWith(
        isLoadingReputation: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  Future<List<BadgeDetail>> fetchUserBadges(String userId) async {
    emit(state.copyWith(isLoadingBadges: true, clearError: true));
    try {
      final badgesResponse = await _apiClient.getUserBadges(userId);
      emit(state.copyWith(
        userBadges: badgesResponse.badges,
        isLoadingBadges: false,
      ));
      return badgesResponse.badges;
    } catch (e) {
      emit(state.copyWith(
        isLoadingBadges: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  Future<WalletResponse> fetchWallet() async {
    emit(state.copyWith(isLoadingWallet: true, clearError: true));
    try {
      final wallet = await _apiClient.getWallet();
      emit(state.copyWith(
        walletData: wallet,
        isLoadingWallet: false,
      ));
      return wallet;
    } catch (e) {
      emit(state.copyWith(
        isLoadingWallet: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  Future<UserReviewsResponse> fetchUserReviews(String userId) {
    return _apiClient.getUserReviews(userId);
  }

  Future<ExportResult> requestGdprDataExport() async {
    emit(state.copyWith(clearError: true));
    try {
      final response = await _apiClient.requestGdprDataExport();
      emit(state.copyWith(exportResult: response));
      return response;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(clearError: true));
    try {
      await _apiClient.deleteUser(userId);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteProfile(String userId) async {
    emit(state.copyWith(clearError: true));

    try {
      final authService = FCMTokenService();
      try {
        await authService.onSessionEnded(userId);
      } catch (sessionEndError) {
        logDebug('⚠️ Session cleanup failed during profile deletion: $sessionEndError');
      }

      await _apiClient.deleteUser(userId);

      try {
        await getIt<ChatRepository>().clearAllChats();
      } catch (chatClearError) {
        logDebug('⚠️ Failed to clear local chats during profile deletion: $chatClearError');
      }

      try {
        await SecureStorageService().clearStorage();
      } catch (secureStorageError) {
        logDebug('⚠️ Failed to clear secure storage during profile deletion: $secureStorageError');
      }

      try {
        await getIt<SettingsService>().clearAll();
      } catch (settingsClearError) {
        logDebug('⚠️ Failed to clear settings during profile deletion: $settingsClearError');
      }

      try {
        final path = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(path.path, 'app.db.enc'));
        if (await dbFile.exists()) {
          await dbFile.delete();
        }
      } catch (dbError) {
        logDebug('⚠️ Failed to delete database file: $dbError');
      }

      if (kIsWeb) {
        try {
          await Platform.clearAllBrowserStorage();
        } catch (browserStorageError) {
          logDebug('⚠️ Failed to clear browser storage during profile deletion: $browserStorageError');
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    }
  }
}
