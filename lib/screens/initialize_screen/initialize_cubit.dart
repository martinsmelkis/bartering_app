import 'dart:math';

import 'package:barter_app/models/user/user_registration_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../services/crypto/crypto_service.dart';

part 'initialize_state.dart';

@injectable
class InitializeCubit extends Cubit<InitializeState> {
  final UserRepository _userRepository;
  final ApiClient _apiClient;

  InitializeCubit(this._userRepository, this._apiClient) : super(InitializeInitial());

  Future<void> startInitialization() async {
    try {
      emit(const InitializeLoading(message: 'Initializing app...'));
      emit(const InitializeLoading(message: 'Loading user data...'));

      var keyWordsFromStorage = await _userRepository.getProfileKeywordDataMap();
      await _userRepository.init();
      if (keyWordsFromStorage != null) {
        logDebug('@@@@@@@@@ Initialization complete: User ${_userRepository.userId} is authenticated.');
        emit(InitializeStateRegistered());
      } else {
        // This case should ideally not happen if init() is implemented correctly
        logDebug('@@@@@@@@@@@ Initialization error: User onboarding is null after initialization.');
        await _userRepository.resetUserId();
        final String? userId = await _userRepository.getUserId();
        
        // Clear any existing crypto state and create fresh keys
        // This ensures we don't have race conditions with disposed instances
        CryptoService.disposeSingletonStatic();
        
        // Create new crypto service - it will auto-generate keys since storage is empty
        final cryptoService = await CryptoService.create();
        final String? publicKey = cryptoService.ecPublicKeyToString(
            cryptoService.getPublicKey());

        await _apiClient.createProfile(UserRegistrationData(id: userId ?? "",
            name: "User_${userId?.substring(0, 8)
                ?? Random.secure().nextInt(100000)}",
            publicKey: publicKey ?? "",
            email: "",
            password: "User_${Random.secure().nextInt(100000)}"));

        emit(InitializeStateUnregistered());
      }
    } on PlatformException catch (e) {
      // Handle Android Keystore errors (KEY_NOT_FOUND, BadPaddingException, etc.)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('key_not_found') ||
          errorString.contains('badpaddingexception') ||
          errorString.contains('bad_decrypt') ||
          errorString.contains('cipher functions') ||
          (e.code?.toLowerCase().contains('read') == true && e.message == null) ||
          (e.message?.toLowerCase().contains('read') == true)) {
        logDebugError('Keystore error detected (key not found or invalid) - resetting app state', e);
        await _handleKeystoreInvalidation();
      } else {
        logDebugError('Platform error during initialization', e);
        emit(InitializeError('Failed to initialize application: ${e.message ?? e.code}'));
      }
    } catch (e) {
      logDebugError('Initialization error', e);
      // Check if it's a keystore-related error wrapped in another exception
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('key_not_found') ||
          errorString.contains('badpaddingexception') ||
          errorString.contains('bad_decrypt') ||
          errorString.contains('cipher functions') ||
          errorString.contains('keystore') ||
          errorString.contains('fluttersecurestorage')) {
        logDebugError('Keystore error detected in wrapped exception - resetting app state', e);
        await _handleKeystoreInvalidation();
      } else {
        emit(InitializeError('Failed to initialize application: ${e.toString()}'));
      }
    }
  }

  /// Handles keystore key invalidation by clearing storage and regenerating keys
  Future<void> _handleKeystoreInvalidation() async {
    try {
      emit(const InitializeLoading(message: 'Resetting secure storage...'));
      
      // Clear secure storage to remove corrupted encrypted data
      await _userRepository.clearStorage();
      
      // Reset user state
      await _userRepository.resetUserId();
      final String? userId = await _userRepository.getUserId();
      
      // Clear any existing crypto state and create fresh keys
      // This ensures we don't have race conditions with disposed instances
      CryptoService.disposeSingletonStatic();
      
      // Create new crypto service - it will auto-generate keys since storage is empty
      final cryptoService = await CryptoService.create();
      final String? publicKey = cryptoService.ecPublicKeyToString(
          cryptoService.getPublicKey());

      // Create new profile
      await _apiClient.createProfile(UserRegistrationData(
        id: userId ?? "",
        name: "User_${userId?.substring(0, 8) ?? Random.secure().nextInt(100000)}",
        publicKey: publicKey ?? "",
        email: "",
        password: "User_${Random.secure().nextInt(100000)}",
      ));

      logDebug('@@@@@@@@@ Successfully recovered from keystore invalidation');
      emit(InitializeStateUnregistered());
    } catch (recoveryError) {
      logDebugError('Failed to recover from keystore invalidation', recoveryError);
      emit(InitializeError(
        'Failed to initialize application: Secure storage error. Please clear app data in Settings > Apps and try again.'
      ));
    }
  }
}
