import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'initialize_state.dart';

@injectable
class InitializeCubit extends Cubit<InitializeState> {
  final UserRepository _userRepository;

  InitializeCubit(this._userRepository) : super(InitializeInitial());

  Future<void> startInitialization() async {
    try {
      emit(const InitializeLoading(message: 'Initializing app...'));
      emit(const InitializeLoading(message: 'Loading user data...'));

      await _userRepository.init();
      final keyWordsFromStorage = await _userRepository.getProfileKeywordDataMap();

      if (keyWordsFromStorage != null) {
        logDebug('@@@@@@@@@ Initialization complete: User ${_userRepository.userId} is authenticated.');
        emit(InitializeStateRegistered());
      } else {
        // Defer expensive crypto/profile registration work until user explicitly
        // continues from Welcome -> Get Started -> GDPR consent.
        logDebug('@@@@@@@@@@@ No onboarding data found - routing to welcome for deferred registration.');
        emit(InitializeStateUnregistered());
      }
    } on PlatformException catch (e) {
      // Handle Android Keystore errors (KEY_NOT_FOUND, BadPaddingException, etc.)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('key_not_found') ||
          errorString.contains('badpaddingexception') ||
          errorString.contains('bad_decrypt') ||
          errorString.contains('cipher functions') ||
          (e.code.toLowerCase().contains('read') && e.message == null) ||
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

  /// Handles keystore key invalidation by clearing storage and resetting state.
  /// Expensive profile registration is deferred to welcome consent flow.
  Future<void> _handleKeystoreInvalidation() async {
    try {
      emit(const InitializeLoading(message: 'Resetting secure storage...'));

      // Clear secure storage to remove corrupted encrypted data
      await _userRepository.clearStorage();

      // Reset user state; onboarding/registration will happen after consent
      await _userRepository.resetUserId();

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
