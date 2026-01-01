import 'dart:math';

import 'package:barter_app/models/user/user_registration_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:equatable/equatable.dart';
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
        print('@@@@@@@@@ Initialization complete: User ${_userRepository.userId} is authenticated.');
        emit(InitializeStateRegistered());
      } else {
        // This case should ideally not happen if init() is implemented correctly
        print('@@@@@@@@@@@ Initialization error: User onboarding is null after initialization.');
        await _userRepository.resetUserId();
        final String? userId = await _userRepository.getUserId();
        final cryptoService = await CryptoService.create();
        await cryptoService.disposeSingleton();
        await cryptoService.initializeKeyPair();
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
    } catch (e) {
      print('Initialization error: $e');
      emit(InitializeError('Failed to initialize application: ${e.toString()}'));
    }
  }
}
