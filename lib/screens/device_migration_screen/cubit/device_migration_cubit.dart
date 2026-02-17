import 'dart:convert';
import 'dart:io';

import 'package:barter_app/models/auth/device_management_models.dart';
import 'package:barter_app/screens/device_migration_screen/cubit/device_migration_state.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/device_fingerprint_service.dart';
import 'package:barter_app/services/device_migration_service.dart' as service;
import 'package:barter_app/services/device_migration_service.dart' show EncryptedMigrationPayload;
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceMigrationCubit extends Cubit<DeviceMigrationState> {
  final service.DeviceMigrationService _migrationService;
  final SecureStorageService _secureStorage;
  final ApiClient _apiClient;
  final DeviceFingerprintService _fingerprintService;

  DeviceMigrationCubit(
    this._migrationService,
    this._secureStorage,
    this._apiClient,
    this._fingerprintService,
  ) : super(const DeviceMigrationInitial());

  /// Initiates a migration session from the source device
  Future<MigrationSessionResult> initiateMigration() async {
    emit(const DeviceMigrationLoading());
    try {
      final result = await _migrationService.initiateMigration();
      if (result.success && result.sessionId != null) {
        emit(DeviceMigrationReady(
          sessionId: result.sessionId!,
          expiresAt: result.expiresAt!,
        ));
        return MigrationSessionResult.success(
          sessionId: result.sessionId!,
          expiresAt: result.expiresAt!,
        );
      } else {
        emit(DeviceMigrationError(result.errorMessage ?? 'Failed to initiate migration'));
        return MigrationSessionResult.error(result.errorMessage ?? 'Failed to initiate migration');
      }
    } catch (e) {
      logDebugError('Error initiating migration: $e');
      emit(DeviceMigrationError('Failed to initiate migration: $e'));
      return MigrationSessionResult.error('Failed to initiate migration: $e');
    }
  }

  /// Joins a migration session from the target device
  Future<service.MigrationJoinResult> joinMigrationSession(String sessionId) async {
    emit(const DeviceMigrationLoading());
    try {
      final result = await _migrationService.joinMigrationSession(sessionId);
      if (result.success) {
        emit(const DeviceMigrationAwaitingConfirmation());
      } else {
        emit(DeviceMigrationError(result.errorMessage ?? 'Failed to join migration'));
      }
      return result;
    } catch (e) {
      logDebugError('Error joining migration session: $e');
      emit(DeviceMigrationError('Failed to join migration: $e'));
      // Return a failed result using the factory method
      return service.MigrationJoinResult.error('Failed to join migration: $e');
    }
  }

  /// Polls for target device and shows confirmation dialog
  Future<Map<String, String>?> pollForTargetDeviceAndWait(String sessionId) async {
    logDebug('⏳ Polling for target device to join session: $sessionId');

    for (int attempt = 0; attempt < 60; attempt++) {
      try {
        // Check session status to see if target device has joined
        final response = await _apiClient.getMigrationStatus(sessionId);
        if (response.success && response.hasTargetJoined) {
          logDebug('✅ Target device found: ${response.targetDeviceId}');
          return {
            'targetDeviceId': response.targetDeviceId!,
            'targetPublicKey': response.targetPublicKey!,
          };
        }
      } catch (e) {
        logDebug('⏳ Waiting for target device, attempt ${attempt + 1}/60: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }

    return null;
  }

  /// Prepares and sends migration payload from source device
  /// Called when source device confirms migration (clicks "Allow")
  Future<bool> prepareAndSendMigrationPayload(
    String targetDeviceId,
    String targetPublicKey,
  ) async {
    emit(const DeviceMigrationTransferring());
    try {
      // Step 1: Prepare the encrypted payload
      logDebug('🔐 Preparing migration payload...');
      final payloadResult = await _migrationService.prepareMigrationPayload(
        targetDeviceId,
        targetPublicKey,
      );

      if (!payloadResult.success || payloadResult.payload == null) {
        emit(DeviceMigrationError(payloadResult.errorMessage ?? 'Failed to prepare migration payload'));
        return false;
      }

      final payload = payloadResult.payload!;

      // Step 2: Send payload to backend
      logDebug('📤 Sending migration payload to backend...');
      final response = await _apiClient.sendMigrationPayload({
        'sessionId': payload.sessionId,
        'encryptedPayload': {
          'encryptedData': payload.encryptedData,
          'ephemeralPublicKey': payload.ephemeralPublicKey,
          'signature': payload.signature,
          'sourceDeviceId': payload.sourceDeviceId,
          'targetDeviceId': payload.targetDeviceId,
          'sessionId': payload.sessionId,
          'keyVersion': payload.keyVersion,
          'sourceSigningPublicKey': payload.sourceSigningPublicKey,
        },
      });

      if (response.success) {
        logDebug('✅ Migration payload sent successfully');
        emit(const DeviceMigrationCompleted());
        return true;
      } else {
        emit(DeviceMigrationError(response.errorMessage ?? 'Failed to send migration payload'));
        return false;
      }
    } catch (e) {
      logDebugError('Error preparing and sending migration payload: $e');
      emit(DeviceMigrationError('Failed to send migration data: $e'));
      return false;
    }
  }

  /// Retrieves the encrypted migration payload from the backend
  Future<EncryptedMigrationPayloadResponse> getMigrationPayload(String sessionId) async {
    try {
      final response = await _apiClient.getMigrationPayload(sessionId);
      return response;
    } catch (e) {
      logDebugError('Error getting migration payload: $e');
      rethrow;
    }
  }

  /// Polls for session status and returns target device info when available
  Future<Map<String, dynamic>?> pollForTargetDevice(String sessionId, {
    int maxAttempts = 60,
    Duration pollInterval = const Duration(seconds: 5),
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        // Check session status via public key endpoint
        // If target device has joined, we can get its public key
        final response = await _apiClient.getMigrationPublicKey(sessionId, 'TARGET');
        if (response.success && response.publicKey != null) {
          // Target device has joined, return its info
          return {
            'targetPublicKey': response.publicKey,
            'targetDeviceId': 'TARGET', // Will be resolved from session
          };
        }
      } catch (e) {
        logDebug('⏳ Target device not joined yet, attempt ${attempt + 1}/$maxAttempts');
      }

      await Future.delayed(pollInterval);
    }
    return null;
  }

  /// Receives and processes migration data on the target device
  Future<MigrationReceiveResult> receiveMigrationData(
    EncryptedMigrationPayloadResponse payload,
  ) async {
    emit(const DeviceMigrationTransferring());
    try {
      // Convert API response to service payload format
      final servicePayload = EncryptedMigrationPayload(
        encryptedData: payload.encryptedData,
        ephemeralPublicKey: payload.ephemeralPublicKey,
        signature: payload.signature,
        sourceDeviceId: payload.sourceDeviceId,
        targetDeviceId: payload.targetDeviceId,
        sessionId: payload.sessionId,
        keyVersion: payload.keyVersion,
      );

      final result = await _migrationService.receiveMigrationData(servicePayload);
      if (result.success && result.data != null) {
        // Generate new key pair for this device after successful migration
        final cryptoService = await CryptoService.create();
        if (cryptoService.isReady) {
          // Register this new device with the backend
          await _registerNewDevice(
            result.data!.userId,
            cryptoService,
          );
        }
        emit(const DeviceMigrationCompleted());
      } else {
        emit(DeviceMigrationError(result.errorMessage ?? 'Failed to receive migration data'));
      }
      return MigrationReceiveResult(
        success: result.success,
        userId: result.data?.userId,
        userName: result.data?.userName,
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      logDebugError('Error receiving migration data: $e');
      emit(DeviceMigrationError('Failed to receive migration data: $e'));
      return MigrationReceiveResult(
        success: false,
        errorMessage: 'Failed to receive migration data: $e',
      );
    }
  }

  /// Confirms successful migration and invalidates the session
  Future<void> confirmMigrationComplete(String sessionId) async {
    try {
      final deviceId = await _getDeviceId();
      await _apiClient.confirmMigrationComplete({
        'sessionId': sessionId,
        'targetDeviceId': deviceId,
      });
      logDebug('✅ Migration completion confirmed');
    } catch (e) {
      logDebugError('Error confirming migration: $e');
      rethrow;
    }
  }

  /// Registers the new device with the backend after migration
  Future<void> _registerNewDevice(
    String userId,
    CryptoService cryptoService,
  ) async {
    try {
      final publicKey = cryptoService.ecPublicKeyToString(cryptoService.getPublicKey()!);
      final deviceId = await _getDeviceId();
      final deviceName = await _getDeviceName();
      
      // Platform detection that works on web and mobile
      String platform;
      if (kIsWeb) {
        platform = 'web';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        platform = 'android';
      }

      final response = await _apiClient.registerDevice({
        'userId': userId,
        'deviceId': deviceId,
        'publicKey': publicKey,
        'deviceName': deviceName,
        'deviceType': 'mobile',
        'platform': platform,
      });

      if (response.success) {
        logDebug('✅ Device registered successfully after migration');
      } else {
        logDebugError('Failed to register device: ${response.message}');
      }
    } catch (e) {
      logDebugError('Error registering device: $e');
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
    final existingId = await _secureStorage.getContactPublicKey('device_id');
    if (existingId != null) return existingId;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = base64Encode(List<int>.generate(8, (_) => timestamp % 256));
    final deviceId = 'device_${timestamp}_$random';
    await _secureStorage.saveContactPublicKey('device_id', deviceId);
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

  /// Clears migration state
  void reset() {
    emit(const DeviceMigrationInitial());
  }
}

/// Result of initiating a migration session
class MigrationSessionResult {
  final bool success;
  final String? sessionId;
  final DateTime? expiresAt;
  final String? errorMessage;

  MigrationSessionResult({
    required this.success,
    this.sessionId,
    this.expiresAt,
    this.errorMessage,
  });

  factory MigrationSessionResult.success({
    required String sessionId,
    required DateTime expiresAt,
  }) {
    return MigrationSessionResult(
      success: true,
      sessionId: sessionId,
      expiresAt: expiresAt,
    );
  }

  factory MigrationSessionResult.error(String message) {
    return MigrationSessionResult(
      success: false,
      errorMessage: message,
    );
  }
}

/// Result of joining a migration session
class MigrationJoinResult {
  final bool success;
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;

  MigrationJoinResult({
    required this.success,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
  });
}

/// Result of receiving migration data
class MigrationReceiveResult {
  final bool success;
  final String? userId;
  final String? userName;
  final String? errorMessage;

  MigrationReceiveResult({
    required this.success,
    this.userId,
    this.userName,
    this.errorMessage,
  });
}
