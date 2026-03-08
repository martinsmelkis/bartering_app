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
      if (result.success && result.sessionCode != null) {
        emit(DeviceMigrationReady(
          sessionId: result.sessionCode!,
          expiresAt: result.expiresAt!,
        ));
        return MigrationSessionResult.success(
          sessionId: result.sessionCode!,
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
  /// Uses session code (not UUID) to poll for status
  /// Returns target device info and sessionId (UUID) when target joins
  /// Also updates the migration service session to use UUID for signing
  Future<Map<String, String>?> pollForTargetDeviceAndWait(String sessionCode) async {
    logDebug('⏳ Polling for target device to join session: $sessionCode');
    String? sessionId; // UUID for API calls

    for (int attempt = 0; attempt < 60; attempt++) {
      try {
        // Check session status to see if target device has joined
        final response = await _apiClient.getMigrationStatus(sessionCode);
        if (response.success) {
          // Capture sessionId (UUID) from response for API calls
          sessionId ??= response.sessionId;
          
          if (response.hasTargetJoined && sessionId != null) {
            // Get target public key from response (needed for ECDH encryption)
            final targetPublicKey = response.targetPublicKey ?? '';
            
            logDebug('✅ Target device has joined session: $sessionCode');
            logDebug('   Session ID (UUID): $sessionId');
            logDebug('   Target public key: ${targetPublicKey.isNotEmpty ? "present (${targetPublicKey.length} chars)" : "MISSING!"}');
            
            // IMPORTANT: Update the migration service session to use UUID for signing
            // The payload must be signed with UUID (not sessionCode) so target can verify
            await _migrationService.updateSessionId(sessionId);
            
            return {
              'targetDeviceId': 'TARGET',
              'targetPublicKey': targetPublicKey, // Return actual key from backend
              'sessionId': sessionId, // Return UUID for payload API calls
            };
          }
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
  /// Uses sessionId (UUID) for API calls, not sessionCode
  Future<bool> prepareAndSendMigrationPayload(
    String targetDeviceId,
    String targetPublicKey,
    String sessionId, // UUID for API calls
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

      // Step 2: Send payload to backend using sessionId (UUID), not sessionCode
      logDebug('📤 Sending migration payload to backend with sessionId: $sessionId...');
      final response = await _apiClient.sendMigrationPayload({
        'sessionId': sessionId, // Use UUID here, not payload.sessionId
        'encryptedPayload': {
          'encryptedData': payload.encryptedData,
          'ephemeralPublicKey': payload.ephemeralPublicKey,
          'signature': payload.signature,
          'sourceDeviceId': payload.sourceDeviceId,
          'targetDeviceId': payload.targetDeviceId,
          'sessionId': sessionId, // Use UUID here too
          'keyVersion': payload.keyVersion,
          'sourceSigningPublicKey': payload.sourceSigningPublicKey,
        },
      });

      if (response.success) {
        logDebug('✅ Migration payload sent successfully');
        emit(const DeviceMigrationCompleted());
        return true;
      } else {
        emit(DeviceMigrationError(response.message ?? 'Failed to send migration payload'));
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

  /// Gets migration session status
  Future<MigrationStatusResponse> getMigrationStatus(String sessionCode) async {
    try {
      final response = await _apiClient.getMigrationStatus(sessionCode);
      return response;
    } catch (e) {
      logDebugError('Error getting migration status: $e');
      rethrow;
    }
  }

  /// Polls for session status and fetches payload when status is "transferring"
  /// Uses sessionId (UUID) for payload retrieval, not sessionCode
  Future<EncryptedMigrationPayloadResponse?> pollForMigrationPayload(
    String sessionCode,
    String sessionId, // UUID for API calls
  ) async {
    logDebug('⏳ Polling for migration payload with sessionId: $sessionId');

    for (int attempt = 0; attempt < 120; attempt++) { // 10 minutes max
      try {
        // Check session status - can use either sessionCode or sessionId for status
        final response = await _apiClient.getMigrationStatus(sessionCode);
        
        if (response.success) {
          logDebug('📊 Migration status: ${response.status}');
          
          // Wait for payload to be available
          if (response.status == 'transferring') {
            logDebug('✅ Payload ready! Fetching...');
            // Use sessionId (UUID) for payload retrieval, NOT sessionCode
            final payload = await _apiClient.getMigrationPayload(sessionId);
            return payload;
          }
          
          // Session completed without payload
          if (response.status == 'completed') {
            logDebug('⚠️ Session completed but no payload transferred');
            return null;
          }
          
          // Session expired or failed
          if (response.status == 'expired' || response.status == 'cancelled' || response.status == 'failed') {
            logDebugError('❌ Session ended with status: ${response.status}');
            return null;
          }
        }
      } catch (e) {
        logDebug('⏳ Waiting for payload, attempt ${attempt + 1}/120: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
    
    logDebugError('❌ Timeout waiting for migration payload');
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
        sourceSigningPublicKey: payload.sourceSigningPublicKey,
      );

      final result = await _migrationService.receiveMigrationData(servicePayload);
      if (result.success && result.data != null) {
        // Device registration is now handled by the completeMigration endpoint
        // which is called inside receiveMigrationData
        emit(const DeviceMigrationCompleted());
      } else {
        emit(DeviceMigrationError(result.errorMessage ?? 'Failed to receive migration data'));
      }
      return MigrationReceiveResult(
        success: result.success,
        userId: result.userId, // Use userId from server response
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
  final String? userId; // User ID from completeMigration response
  final String? userName;
  final String? errorMessage;

  MigrationReceiveResult({
    required this.success,
    this.userId,
    this.userName,
    this.errorMessage,
  });
}
