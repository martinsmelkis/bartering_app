// Secure Device Migration Framework for Barter App
// Handles cross-device user data synchronization with end-to-end encryption

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/device_fingerprint_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart' as pc;

// ============================================================================
// DATA MODELS FOR MIGRATION
// ============================================================================

/// Represents the state of a device migration process
enum MigrationStatus {
  idle,
  initiating,
  awaitingConfirmation,
  transferring,
  verifying,
  completed,
  failed,
  expired,
}

/// Represents a migration session between two devices
class MigrationSession {
  final String sessionId; // UUID for API calls
  final String? sessionCode; // 10-char code for user display (nullable for email recovery)
  final String sourceDeviceId;
  final String targetDeviceId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final MigrationStatus status;
  final String? errorMessage;
  final int attemptCount;

  MigrationSession({
    required this.sessionId,
    this.sessionCode,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.createdAt,
    required this.expiresAt,
    this.status = MigrationStatus.idle,
    this.errorMessage,
    this.attemptCount = 0,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive =>
      status == MigrationStatus.initiating ||
      status == MigrationStatus.awaitingConfirmation ||
      status == MigrationStatus.transferring;
}

/// Encapsulates user data that needs to be migrated
class MigrationData {
  final String userId;
  final String userName;
  final String? location;
  final List<ParsedAttributeData> interests;
  final List<ParsedAttributeData> offerings;
  final Map<String, double> profileKeywordDataMap;
  final String publicKey;
  final String privateKey; // Private key for authentication on target device
  final DateTime timestamp;
  final String deviceFingerprint;

  MigrationData({
    required this.userId,
    required this.userName,
    this.location,
    required this.interests,
    required this.offerings,
    required this.profileKeywordDataMap,
    required this.publicKey,
    required this.privateKey,
    required this.timestamp,
    required this.deviceFingerprint,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'location': location,
    'interests': interests.map((e) => e.toJson()).toList(),
    'offerings': offerings.map((e) => e.toJson()).toList(),
    'profileKeywordDataMap': profileKeywordDataMap,
    'publicKey': publicKey,
    'privateKey': privateKey,
    'timestamp': timestamp.toUtc().toIso8601String(),
    'deviceFingerprint': deviceFingerprint,
  };

  factory MigrationData.fromJson(Map<String, dynamic> json) {
    return MigrationData(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      location: json['location'] as String?,
      interests: (json['interests'] as List<dynamic>)
          .map((e) => ParsedAttributeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      offerings: (json['offerings'] as List<dynamic>)
          .map((e) => ParsedAttributeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileKeywordDataMap: (json['profileKeywordDataMap'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      publicKey: json['publicKey'] as String,
      privateKey: json['privateKey'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String).toLocal(),
      deviceFingerprint: json['deviceFingerprint'] as String,
    );
  }
}

/// Encrypted migration payload with all security metadata
class EncryptedMigrationPayload {
  final String encryptedData;
  final String ephemeralPublicKey;
  final String signature;
  final String sourceDeviceId;
  final String targetDeviceId;
  final String sessionId;
  final int keyVersion;
  /// The source device's main signing public key (not the ephemeral ECDH key)
  /// This is used by the backend to verify the payload signature
  final String? sourceSigningPublicKey;

  EncryptedMigrationPayload({
    required this.encryptedData,
    required this.ephemeralPublicKey,
    required this.signature,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.sessionId,
    this.sourceSigningPublicKey,
    this.keyVersion = 1,
  });

  Map<String, dynamic> toJson() => {
    'encryptedData': encryptedData,
    'ephemeralPublicKey': ephemeralPublicKey,
    'signature': signature,
    'sourceDeviceId': sourceDeviceId,
    'targetDeviceId': targetDeviceId,
    'sessionId': sessionId,
    'keyVersion': keyVersion,
    'sourceSigningPublicKey': sourceSigningPublicKey,
  };

  factory EncryptedMigrationPayload.fromJson(Map<String, dynamic> json) {
    return EncryptedMigrationPayload(
      encryptedData: json['encryptedData'] as String,
      ephemeralPublicKey: json['ephemeralPublicKey'] as String,
      signature: json['signature'] as String,
      sourceDeviceId: json['sourceDeviceId'] as String,
      targetDeviceId: json['targetDeviceId'] as String,
      sessionId: json['sessionId'] as String,
      keyVersion: json['keyVersion'] as int? ?? 1,
      sourceSigningPublicKey: json['sourceSigningPublicKey'] as String?,
    );
  }
}

// ============================================================================
// MAIN SERVICE IMPLEMENTATION
// ============================================================================

@injectable
class DeviceMigrationService {
  static const String _migrationSessionsKey = 'migration_sessions';
  static const String _migrationNonceKey = 'migration_nonce_';
  static const Duration _sessionExpiry = Duration(minutes: 15);
  static const Duration _confirmationTimeout = Duration(minutes: 5);
  static const Duration _joinSessionTimeout = Duration(seconds: 15);

  final SecureStorageService _secureStorage;
  final ApiClient _apiClient;
  final UserRepository _userRepository;
  final DeviceFingerprintService _fingerprintService;
  CryptoService? _cryptoService;

  MigrationSession? _currentSession;
  String? _recoverySessionId; // Store sessionId from email recovery initiation

  DeviceMigrationService(
    this._secureStorage,
    this._apiClient,
    this._userRepository,
    this._fingerprintService,
  );

  /// Updates the current session to use UUID instead of sessionCode
  /// This is called when target joins and we receive the UUID from backend
  Future<void> updateSessionId(String sessionId) async {
    if (_currentSession == null) return;
    
    // Only update if the sessionId is different (UUID vs sessionCode)
    if (_currentSession!.sessionId != sessionId) {
      logDebug('🔄 Updating session ID from ${_currentSession!.sessionId} to $sessionId');
      
      // Create updated session with UUID
      final updatedSession = MigrationSession(
        sessionId: sessionId, // Use UUID
        sessionCode: _currentSession!.sessionCode ?? _currentSession!.sessionId, // Keep original code
        sourceDeviceId: _currentSession!.sourceDeviceId,
        targetDeviceId: _currentSession!.targetDeviceId,
        createdAt: _currentSession!.createdAt,
        expiresAt: _currentSession!.expiresAt,
        status: _currentSession!.status,
        attemptCount: _currentSession!.attemptCount,
      );
      
      // Update current session
      _currentSession = updatedSession;
      
      // Persist updated session
      await _storeSession(updatedSession);
      
      logDebug('✅ Session ID updated to UUID: $sessionId');
    }
  }

  // ==========================================================================
  // PUBLIC API - Source Device (Export)
  // ==========================================================================

  /// Initiates a migration session from the source device
  /// Returns a session code that the user must enter on the target device
  Future<MigrationInitiationResult> initiateMigration() async {
    try {
      logDebug('🔐 Initializing device migration...');

      // 1. Verify crypto service is ready
      _cryptoService = await CryptoService.create();
      if (!_cryptoService!.isReady) {
        return MigrationInitiationResult.error(
          'Crypto service not initialized',
        );
      }

      // 2. Get current device data
      final userId = await _secureStorage.getOwnUserId();
      final userName = await _secureStorage.getOwnUserName();

      if (userId == null || userName == null) {
        return MigrationInitiationResult.error(
          'User not authenticated on this device',
        );
      }

      // 3. Create device fingerprint and get source public key
      final deviceFingerprint = await _generateDeviceFingerprint();
      final sourcePublicKey = _cryptoService!.ecPublicKeyToString(
        _cryptoService!.getPublicKey()!,
      );

      // 4. Call backend to create migration session
      final response = await _apiClient.initiateDeviceMigration({
        'userId': userId,
        'sourceDeviceId': deviceFingerprint,
        'sourcePublicKey': sourcePublicKey,
      });

      if (!response.success || response.sessionCode == null) {
        return MigrationInitiationResult.error(
          response.errorMessage ?? 'Failed to initiate migration session',
        );
      }

      final sessionCode = response.sessionCode!;

      // 5. Generate ephemeral key pair for this session
      final ephemeralKeyPair = await _generateEphemeralKeyPair();

      // 6. Create migration session
      final session = MigrationSession(
        sessionId: sessionCode, // Using session code as ID
        sourceDeviceId: deviceFingerprint,
        targetDeviceId: '', // Will be set when target connects
        createdAt: DateTime.now(),
        expiresAt: DateTime.parse(response.expiresAt!),
        status: MigrationStatus.initiating,
      );

      // 7. Store session data securely
      await _storeSession(session);
      await _storeEphemeralKeys(sessionCode, ephemeralKeyPair);

      _currentSession = session;

      logDebug('✅ Migration initiated. Session Code: $sessionCode');

      return MigrationInitiationResult.success(
        sessionCode: sessionCode,
        expiresAt: session.expiresAt,
        deviceFingerprint: deviceFingerprint,
      );
    } catch (e, stackTrace) {
      logDebugError('Failed to initiate migration: $e');
      if (kDebugMode) {
        logDebug(stackTrace.toString());
      }
      return MigrationInitiationResult.error('Migration initiation failed: $e');
    }
  }

  /// Prepares encrypted migration data for transfer
  /// Called when target device confirms the migration request
  Future<MigrationPayloadResult> prepareMigrationPayload(
    String targetDeviceId,
    String targetPublicKey,
  ) async {
    try {
      if (_currentSession == null || _currentSession!.isExpired) {
        return MigrationPayloadResult.error('No active migration session');
      }

      final session = _currentSession!;

      // 1. Gather all user data
      final migrationData = await _gatherMigrationData(session.sourceDeviceId);

      // 2. Serialize and encrypt data using target's public key
      // Note: targetPublicKey may be URL-safe Base64, ecPublicKeyFromString handles both
      final keyPreview = targetPublicKey.length > 30 
          ? targetPublicKey.substring(0, 30) 
          : targetPublicKey;
      logDebug('🔑 Parsing target public key: $keyPreview... (${targetPublicKey.length} chars)');
      
      if (targetPublicKey.isEmpty) {
        throw Exception('Target public key is empty - cannot encrypt payload');
      }
      
      final payload = await _encryptMigrationData(
        migrationData: migrationData,
        targetDeviceId: targetDeviceId,
        targetPublicKey: targetPublicKey,
      );

      // 3. Send payload using sessionId (UUID) if available, otherwise sessionCode
      final apiSessionId = session.sessionId; // This is the UUID for API calls
      logDebug('📤 Sending migration payload with sessionId: $apiSessionId');

      // 4. Update session status
      final updatedSession = MigrationSession(
        sessionId: session.sessionId,
        sessionCode: session.sessionCode,
        sourceDeviceId: session.sourceDeviceId,
        targetDeviceId: targetDeviceId,
        createdAt: session.createdAt,
        expiresAt: session.expiresAt,
        status: MigrationStatus.transferring,
        attemptCount: session.attemptCount,
      );
      await _storeSession(updatedSession);
      _currentSession = updatedSession;

      return MigrationPayloadResult.success(payload);
    } catch (e) {
      logDebugError('Failed to prepare migration payload: $e');
      return MigrationPayloadResult.error('Payload preparation failed: $e');
    }
  }

  // ==========================================================================
  // PUBLIC API - Target Device (Import)
  // ==========================================================================

  /// Attempts to join a migration session from the target device
  /// Uses session code (10-char alphanumeric) to identify the session
  /// Stores sessionId (UUID) from response for API calls
  Future<MigrationJoinResult> joinMigrationSession(String sessionCode) async {
    try {
      logDebug('🔐 Joining migration session: $sessionCode');

      // 1. Initialize crypto on target device
      _cryptoService = await CryptoService.create();

      // 2. Generate ephemeral key pair for this session (for ECDH)
      logDebug('🔑 Generating ephemeral key pair for session...');
      final ephemeralKeyPair = await _generateEphemeralKeyPair();
      await _storeEphemeralKeys(sessionCode, ephemeralKeyPair);
      final ephemeralPublicKey = _cryptoService!.ecPublicKeyToString(
        ephemeralKeyPair.publicKey,
      );

      // 3. Generate target device fingerprint
      final deviceFingerprint = await _generateDeviceFingerprint();

      // 4. Call API to register target device with session code
      final response = await _apiClient.registerMigrationTarget({
        'sessionCode': sessionCode,
        'targetDeviceId': deviceFingerprint,
        'targetPublicKey': ephemeralPublicKey,
      }).timeout(_joinSessionTimeout);

      if (!response.success || response.sessionId == null) {
        return MigrationJoinResult.error(
          response.errorMessage ?? 'Invalid migration code. Please check the code and try again.',
        );
      }

      // 5. Store session info locally - use sessionId (UUID) for API calls
      // but keep sessionCode for reference
      final session = MigrationSession(
        sessionId: response.sessionId!, // UUID for API calls
        sessionCode: sessionCode, // 10-char code for display
        sourceDeviceId: response.sourceDeviceId!,
        targetDeviceId: deviceFingerprint,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(_confirmationTimeout),
        status: MigrationStatus.awaitingConfirmation,
      );
      await _storeSession(session);
      _currentSession = session;

      logDebug('✅ Joined migration session successfully');
      logDebug('   Session Code: $sessionCode');
      logDebug('   Session ID (UUID): ${response.sessionId}');

      return MigrationJoinResult.success(
        sessionId: response.sessionId!,
        sourceDeviceId: response.sourceDeviceId!,
        userId: response.userId!,
        requiresConfirmation: true,
      );
    } on TimeoutException {
      logDebugError('Timed out joining migration session');
      return MigrationJoinResult.error(
        'Migration code check timed out. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      logDebugError('Failed to join migration session: $e');
      return MigrationJoinResult.error(_getMigrationJoinErrorMessage(e));
    } catch (e) {
      logDebugError('Failed to join migration session: $e');
      return MigrationJoinResult.error(
        'Unable to check this migration code. Please try again.',
      );
    }
  }

  /// Receives and decrypts migration data on the target device
  Future<MigrationReceiveResult> receiveMigrationData(
    EncryptedMigrationPayload payload,
  ) async {
    try {
      // 1. Verify the payload signature
      final isSignatureValid = await _verifyPayloadSignature(payload);
      if (!isSignatureValid) {
        return MigrationReceiveResult.error(
          'Invalid signature - data may be tampered',
        );
      }

      // 2. Decrypt the migration data
      final migrationData = await _decryptMigrationData(payload);
      if (migrationData == null) {
        return MigrationReceiveResult.error('Failed to decrypt migration data');
      }

      // 3. Validate data integrity
      final isValid = await _validateMigrationData(migrationData);
      if (!isValid) {
        return MigrationReceiveResult.error('Data validation failed');
      }

      // 4. Import data to secure storage
      await _importMigrationData(migrationData);

      // 5. Complete migration - use stored sessionId (UUID) for API call
      // Get current device info
      final deviceFingerprint = await _generateDeviceFingerprint();
      
      // Use the imported source device's public key for device registration
      // This ensures the device key matches user_registration_data.public_key
      final sourcePublicKey = migrationData.publicKey;
      
      // Use the stored sessionId (UUID) not the payload sessionId (which might be sessionCode)
      final apiSessionId = _currentSession?.sessionId ?? payload.sessionId;
      logDebug('📤 Completing migration with sessionId: $apiSessionId');
      logDebug('   Using source public key for device registration: ${sourcePublicKey.substring(0, 30)}...');
      
      // Call complete migration and get the response with userId
      final response = await _apiClient.completeMigration({
        'sessionId': apiSessionId,
        'newDeviceId': deviceFingerprint,
        'devicePublicKey': sourcePublicKey, // Use imported source key, not new key
        'deviceName': await _getDeviceName(),
      });
      
      // IMPORTANT: Use the userId from the server response, not from payload
      // This ensures we use the canonical user ID from the database
      final migratedUserId = response.userId;
      if (migratedUserId != null && migratedUserId.isNotEmpty) {
        logDebug('✅ Migration completed. User ID from server: $migratedUserId');
        
        // ALWAYS clear the UserRepository cache to ensure we load the correct userId
        // This is critical for chat authentication to work
        logDebug('🔄 Updating stored userId to: $migratedUserId');
        await _secureStorage.saveOwnUserId(migratedUserId);
        
        // CRITICAL: Clear the UserRepository cache so it loads the new userId
        // Must happen AFTER saving to storage, BEFORE any API calls
        _userRepository.clearCache();
        logDebug('🧹 UserRepository cache cleared - will reload from storage on next access');
        
        // Force immediate reload to verify
        final reloadedUserId = await _userRepository.getUserId();
        logDebug('🔄 UserRepository reloaded userId: $reloadedUserId');
        
        // Verify the update worked
        final verifyUserId = await _secureStorage.getOwnUserId();
        logDebug('✅ Verified stored userId: $verifyUserId');
      } else {
        logDebugError('⚠️ No userId in migration response - using payload userId');
      }

      return MigrationReceiveResult.success(migrationData, migratedUserId ?? migrationData.userId);
    } catch (e) {
      logDebugError('Failed to receive migration data: $e');
      return MigrationReceiveResult.error('Receive failed: $e');
    }
  }

  // ==========================================================================
  // EMAIL RECOVERY - For when source device is lost/broken
  // ==========================================================================

  /// Initiates email-based account recovery
  Future<EmailRecoveryInitiationResult> initiateEmailRecovery(String email) async {
    try {
      logDebug('📧 Initiating email recovery for: $email');

      // 1. Initialize crypto service on the new device
      _cryptoService = await CryptoService.create();
      if (!_cryptoService!.isReady) {
        return EmailRecoveryInitiationResult.error('Crypto service not initialized');
      }

      // 2. Get device fingerprint and public key
      final deviceFingerprint = await _getDeviceFingerprint();
      final publicKey = _cryptoService!.ecPublicKeyToString(
        _cryptoService!.getPublicKey()!,
      );

      logDebug('🔑 New device fingerprint: $deviceFingerprint');
      logDebug('🔑 New device public key: ${publicKey.substring(0, 30)}...');

      // 3. Call backend with email, device ID, and public key
      final response = await _apiClient.initiateEmailRecovery({
        'email': email,
        'newDeviceId': deviceFingerprint,
        'newDevicePublicKey': publicKey,
      });

      if (response.success) {
        logDebug('✅ Recovery code sent to: ${response.emailMasked}');
        // Store sessionId for verification step
        _recoverySessionId = response.sessionId;
        logDebug('🔑 Recovery sessionId stored: $_recoverySessionId');
        return EmailRecoveryInitiationResult.success(
          maskedEmail: response.emailMasked ?? '***@***.***',
          expiresAt: response.expiresAt != null 
              ? DateTime.parse(response.expiresAt!) 
              : DateTime.now().add(Duration(minutes: 15)),
        );
      } else {
        logDebugError('❌ Failed to initiate email recovery: ${response.message}');
        return EmailRecoveryInitiationResult.error(response.message ?? 'Failed to initiate recovery');
      }
    } on DioException catch (e) {
      // Handle DioException with user-friendly messages
      String userMessage = _getUserFriendlyErrorMessage(e);
      logDebugError('❌ Email recovery DioException: $userMessage');
      return EmailRecoveryInitiationResult.error(userMessage);
    } catch (e) {
      logDebugError('❌ Error initiating email recovery: $e');
      return EmailRecoveryInitiationResult.error('Failed to initiate recovery: $e');
    }
  }

  /// Converts migration join failures to user-friendly error messages.
  String _getMigrationJoinErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final serverMessage = data['errorMessage'] ?? data['message'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return serverMessage;
      }
    }

    switch (statusCode) {
      case 400:
      case 404:
        return 'Invalid migration code. Please check the code and try again.';
      case 408:
      case 504:
        return 'Migration code check timed out. Please check your connection and try again.';
      case 429:
        return 'Too many attempts. Please wait a few minutes and try again.';
      default:
        return 'Unable to check this migration code. Please try again.';
    }
  }

  /// Converts DioException to user-friendly error message
  String _getUserFriendlyErrorMessage(DioException e) {
    final response = e.response;
    
    // Try to extract server message first
    if (response != null && response.data != null) {
      try {
        final data = response.data as Map<String, dynamic>?;
        if (data != null && data['message'] != null) {
          return data['message'] as String;
        }
      } catch (_) {
        // Fall through to status code handling
      }
    }
    
    // Map status codes to user-friendly messages
    switch (response?.statusCode) {
      case 400:
        return 'Invalid request. Please check your email address.';
      case 404:
        return 'No account found with this email address.';
      case 429:
        return 'Too many attempts. Please wait a few minutes and try again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        return 'Connection error. Please check your internet connection.';
    }
  }

  /// Verifies recovery code and completes account recovery
  Future<EmailRecoveryCompleteResult> verifyRecoveryCodeAndRecover(String code) async {
    try {
      logDebug('🔐 Verifying recovery code...');

      // Get device info for verification request
      final deviceFingerprint = await _getDeviceFingerprint();
      final publicKey = _cryptoService?.ecPublicKeyToString(
        _cryptoService!.getPublicKey()!,
      ) ?? await _secureStorage.getOwnPublicKey() ?? '';

      logDebug('📱 Device ID: $deviceFingerprint');
      logDebug('🔑 Public key: ${publicKey.substring(0, min(30, publicKey.length))}...');

      // Step 1: Verify the recovery code with all required fields
      final verifyResponse = await _apiClient.verifyRecoveryCode({
        'sessionId': _recoverySessionId,
        'recoveryCode': code,
        'newDeviceId': deviceFingerprint,
        'newDevicePublicKey': publicKey,
      });

      if (!verifyResponse.success) {
        logDebugError('❌ Invalid recovery code');
        return EmailRecoveryCompleteResult.error('Invalid recovery code');
      }

      logDebug('✅ Recovery code verified');
      logDebug('   Session ID: $_recoverySessionId');

      // Step 2: Complete the migration directly (no payload for email recovery)
      // Email recovery doesn't have a payload since the old device is lost/broken
      final deviceName = await _getDeviceName();
      final completeResponse = await _apiClient.completeMigration({
        'sessionId': _recoverySessionId,
        'newDeviceId': deviceFingerprint,
        'devicePublicKey': publicKey,
        'deviceName': deviceName,
      });

      if (!completeResponse.success) {
        logDebugError('❌ Failed to complete migration: ${completeResponse.message}');
        return EmailRecoveryCompleteResult.error(
          completeResponse.message ?? 'Failed to complete account recovery',
        );
      }

      // Get userId from response - this is the recovered user's ID
      final recoveredUserId = completeResponse.userId;
      if (recoveredUserId == null || recoveredUserId.isEmpty) {
        logDebugError('❌ No userId in complete migration response');
        return EmailRecoveryCompleteResult.error('Recovery incomplete - no user data');
      }

      logDebug('✅ Email recovery completed successfully');
      logDebug('   User ID: $recoveredUserId');

      // Step 3: Set up the new device with recovered user data
      // Save the user ID to secure storage
      await _secureStorage.saveOwnUserId(recoveredUserId);

      // Save the device's public key for authentication
      await _secureStorage.saveOwnPublicKey(publicKey);

      // Step 4: Fetch user profile from server and populate local storage
      logDebug('🔄 Fetching user profile from server...');
      try {
        final profileData = await _apiClient.getProfileInfo(recoveredUserId);

        // Save profile data to secure storage
        await _secureStorage.setOwnUserName(profileData.name);

        if (profileData.latitude != null && profileData.longitude != null) {
          await _secureStorage.saveOwnLocation(
            '${profileData.latitude},${profileData.longitude}',
          );
        }

        // Parse and save attributes (interests and offerings)
        final attributes = profileData.attributes;
        final interests = attributes
            .where((a) => a.type == 0) // 0 = interest type
            .map((a) => ParsedAttributeData(
                  attributeKey: a.attributeId,
                  attribute: a.description ?? a.attributeId,
                  relevancyScore: a.relevancy,
                  uiStyleHint: a.uiStyleHint ?? 'general',
                ))
            .toList();
        final offerings = attributes
            .where((a) => a.type == 1) // 1 = offering type
            .map((a) => ParsedAttributeData(
                  attributeKey: a.attributeId,
                  attribute: a.description ?? a.attributeId,
                  relevancyScore: a.relevancy,
                  uiStyleHint: a.uiStyleHint ?? 'general',
                ))
            .toList();
        
        await _secureStorage.saveOwnInterestsAttributes(interests);
        await _secureStorage.saveOwnOfferingsAttributes(offerings);
        
        // Save keyword data map
        if (profileData.profileKeywordDataMap != null) {
          await _secureStorage.saveProfileKeywordDataMap(
            profileData.profileKeywordDataMap!,
          );
        }
        
        logDebug('✅ User profile loaded and saved:');
        logDebug('   Name: ${profileData.name}');
        logDebug('   Location: ${profileData.latitude}, ${profileData.longitude}');
        logDebug('   Interests: ${interests.length}');
        logDebug('   Offerings: ${offerings.length}');
        
        // Update repository cache with loaded data
        _userRepository.userId = recoveredUserId;
        _userRepository.userName = profileData.name;
        _userRepository.userLocation = profileData.latitude != null 
            ? '${profileData.latitude},${profileData.longitude}' 
            : null;
        _userRepository.userInterests = interests;
        _userRepository.userOfferings = offerings;
        _userRepository.profileKeywordDataMap = profileData.profileKeywordDataMap;

      } catch (e) {
        logDebugError('⚠️ Failed to fetch user profile: $e');
        // Continue with recovery even if profile fetch fails
        // User can manually refresh later
      }

      // Clear the stored recovery sessionId
      _recoverySessionId = null;

      logDebug('✅ Email recovery completed successfully');
      logDebug('   User ID: $recoveredUserId');

      return EmailRecoveryCompleteResult.success(recoveredUserId);
    } on DioException catch (e) {
      String userMessage = _getUserFriendlyErrorMessage(e);
      logDebugError('❌ Email recovery verification DioException: $userMessage');
      return EmailRecoveryCompleteResult.error(userMessage);
    } catch (e) {
      logDebugError('❌ Error in email recovery verification: $e');
      return EmailRecoveryCompleteResult.error('Recovery failed: $e');
    }
  }

  // ==========================================================================
  // PRIVATE HELPERS - Encryption & Security
  // ==========================================================================

  /// Encrypts migration data using ephemeral key exchange
  Future<EncryptedMigrationPayload> _encryptMigrationData({
    required MigrationData migrationData,
    required String targetDeviceId,
    required String targetPublicKey,
  }) async {
    final session = _currentSession!;

    // 1. Load ephemeral keys
    final ephemeralKeyPair = await _loadEphemeralKeys(session.sessionId);

    // 2. Parse target public key
    final targetPubKey = _cryptoService!.ecPublicKeyFromString(targetPublicKey);
    if (targetPubKey == null) {
      throw Exception('Invalid target public key');
    }

    // 3. Derive shared secret using ECDH
    final sharedSecret = _deriveSharedSecret(
      ephemeralKeyPair.privateKey,
      targetPubKey,
    );

    // 4. Derive encryption key using HKDF
    final salt = _generateSecureRandom(16);
    final encryptionKey = _deriveSymmetricKey(sharedSecret, salt);

    // 5. Serialize and encrypt data
    final plaintext = jsonEncode(migrationData.toJson());
    final iv = _generateSecureRandom(12);

    final cipher = pc.GCMBlockCipher(pc.AESEngine());
    cipher.init(
      true,
      pc.AEADParameters(
        pc.KeyParameter(encryptionKey),
        128,
        iv,
        Uint8List(0),
      ),
    );

    final encryptedBytes = cipher.process(utf8.encode(plaintext));

    // 6. Combine salt + iv + ciphertext BEFORE signing
    final combinedPayload = Uint8List(salt.length + iv.length + encryptedBytes.length);
    combinedPayload.setAll(0, salt);
    combinedPayload.setAll(salt.length, iv);
    combinedPayload.setAll(salt.length + iv.length, encryptedBytes);

    // 7. Sign the combined payload
    final payloadToSign = '${session.sessionId}.$targetDeviceId.${base64Encode(combinedPayload)}';
    logDebug('📝 Signing payload: ${payloadToSign.substring(0, min(50, payloadToSign.length))}...');
    final signature = _cryptoService!.signMessage(payloadToSign);
    if (signature == null) {
      throw Exception('Failed to sign payload');
    }
    logDebug('✍️ Generated signature: ${signature.substring(0, min(50, signature.length))}...');

    // Get the source device's signing public key for backend verification
    final sourceSigningPublicKey = _cryptoService!.ecPublicKeyToString(
      _cryptoService!.getPublicKey()!,
    );

    // 8. Construct final payload
    final ephemeralPubKeyStr = _cryptoService!.ecPublicKeyToString(
      ephemeralKeyPair.publicKey,
    );

    return EncryptedMigrationPayload(
      encryptedData: base64Encode(combinedPayload),
      ephemeralPublicKey: ephemeralPubKeyStr,
      signature: signature,
      sourceDeviceId: session.sourceDeviceId,
      targetDeviceId: targetDeviceId,
      sessionId: session.sessionId,
      sourceSigningPublicKey: sourceSigningPublicKey,
    );
  }

  /// Decrypts migration data on the target device
  Future<MigrationData?> _decryptMigrationData(
    EncryptedMigrationPayload payload,
  ) async {
    try {
      // 1. Load ephemeral keys
      final ephemeralKeyPair = await _loadEphemeralKeys(payload.sessionId);

      // 2. Parse ephemeral public key from source
      final sourceEphemeralPubKey = _cryptoService!.ecPublicKeyFromString(
        payload.ephemeralPublicKey,
      );
      if (sourceEphemeralPubKey == null) {
        throw Exception('Invalid ephemeral public key');
      }

      // 3. Derive shared secret using ECDH
      final sharedSecret = _deriveSharedSecret(
        ephemeralKeyPair.privateKey,
        sourceEphemeralPubKey,
      );

      // 4. Extract salt, IV, and ciphertext
      final combinedPayload = base64Decode(payload.encryptedData);
      if (combinedPayload.length < 28) {
        throw Exception('Invalid payload size');
      }

      final salt = combinedPayload.sublist(0, 16);
      final iv = combinedPayload.sublist(16, 28);
      final ciphertext = combinedPayload.sublist(28);

      // 5. Derive encryption key
      final encryptionKey = _deriveSymmetricKey(sharedSecret, salt);

      // 6. Decrypt
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      cipher.init(
        false,
        pc.AEADParameters(
          pc.KeyParameter(encryptionKey),
          128,
          iv,
          Uint8List(0),
        ),
      );

      final decryptedBytes = cipher.process(ciphertext);
      final plaintext = utf8.decode(decryptedBytes);

      // 7. Parse migration data
      final json = jsonDecode(plaintext) as Map<String, dynamic>;
      return MigrationData.fromJson(json);
    } on pc.InvalidCipherTextException {
      logDebugError('Decryption failed: Authentication tag mismatch');
      return null;
    } catch (e) {
      logDebugError('Decryption error: $e');
      return null;
    }
  }

  /// Verifies the signature on a migration payload
  Future<bool> _verifyPayloadSignature(EncryptedMigrationPayload payload) async {
    try {
      // Parse the encrypted data for verification
      final encryptedBytes = base64Decode(payload.encryptedData);

      // Reconstruct what was signed
      final payloadToVerify = '${payload.sessionId}.${payload.targetDeviceId}.${base64Encode(encryptedBytes)}';

      // Get the source device's signing public key from the payload
      // This was added by the source device during payload creation
      final sourceSigningPublicKey = payload.sourceSigningPublicKey;
      if (sourceSigningPublicKey == null) {
        logDebugError('Signature verification: No source signing public key in payload');
        return false;
      }

      logDebug('🔑 Source signing public key from payload: $sourceSigningPublicKey');
      logDebug('📝 Payload to verify: ${payloadToVerify.substring(0, min(50, payloadToVerify.length))}...');
      logDebug('✍️ Signature: ${payload.signature.substring(0, min(50, payload.signature.length))}...');

      final sourcePublicKey = _cryptoService!.ecPublicKeyFromString(
        sourceSigningPublicKey,
      );
      if (sourcePublicKey == null) {
        logDebugError('Signature verification: Failed to parse public key');
        return false;
      }

      // Verify signature
      final result = _cryptoService!.verifySignature(
        payloadToVerify,
        payload.signature,
        sourcePublicKey,
      );
      
      logDebug('✅ Signature verification result: $result');
      return result;
    } catch (e, stackTrace) {
      logDebugError('Signature verification error: $e');
      logDebugError('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Derives shared secret using ECDH
  Uint8List _deriveSharedSecret(
    pc.ECPrivateKey privateKey,
    pc.ECPublicKey publicKey,
  ) {
    final agreement = pc.ECDHBasicAgreement();
    agreement.init(privateKey);
    final sharedBigInt = agreement.calculateAgreement(publicKey);

    // Convert to 32 bytes (for P-256)
    final bytes = Uint8List(32);
    var temp = sharedBigInt;
    for (var i = 31; i >= 0; i--) {
      bytes[i] = temp.toUnsigned(8).toInt();
      temp = temp >> 8;
    }
    return bytes;
  }

  /// Derives symmetric key using HKDF
  Uint8List _deriveSymmetricKey(Uint8List sharedSecret, Uint8List salt) {
    final info = utf8.encode('BarterApp Migration Key v1');
    final hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
    hkdf.init(pc.HkdfParameters(sharedSecret, 32, salt, info));
    return hkdf.process(Uint8List(32));
  }

  // ==========================================================================
  // PRIVATE HELPERS - Data Management
  // ==========================================================================

  /// Gathers all user data for migration
  Future<MigrationData> _gatherMigrationData(String deviceFingerprint) async {
    final userId = (await _secureStorage.getOwnUserId())!;
    final userName = (await _secureStorage.getOwnUserName())!;
    final location = await _secureStorage.getOwnLocation();
    final interests = await _secureStorage.getOwnInterestsAttributes() ?? [];
    final offerings = await _secureStorage.getOwnOfferingsAttributes() ?? [];
    final keywordMap = await _secureStorage.getProfileKeywordDataMap() ?? {};
    final publicKey = (await _secureStorage.getOwnPublicKey())!;
    
    // Get private key from secure storage
    final privateKey = await _secureStorage.getOwnPrivateKey();
    if (privateKey == null) {
      throw Exception('Private key not found - cannot migrate without authentication key');
    }

    return MigrationData(
      userId: userId,
      userName: userName,
      location: location,
      interests: interests,
      offerings: offerings,
      profileKeywordDataMap: keywordMap,
      publicKey: publicKey,
      privateKey: privateKey,
      timestamp: DateTime.now(),
      deviceFingerprint: deviceFingerprint,
    );
  }

  /// Imports migration data to local secure storage
  Future<void> _importMigrationData(MigrationData data) async {
    await _secureStorage.saveOwnUserId(data.userId);
    await _secureStorage.setOwnUserName(data.userName);
    if (data.location != null) {
      await _secureStorage.saveOwnLocation(data.location!);
    }
    await _secureStorage.saveOwnInterestsAttributes(data.interests);
    await _secureStorage.saveOwnOfferingsAttributes(data.offerings);
    await _secureStorage.saveProfileKeywordDataMap(data.profileKeywordDataMap);

    // Import the source device's keys for authentication
    // This allows the target device to act as the source user
    await _secureStorage.saveOwnPublicKey(data.publicKey);
    await _secureStorage.saveOwnPrivateKey(data.privateKey);
    
    // CRITICAL: Reload CryptoService with the imported keys
    // The singleton may still have old cached keys in memory
    logDebug('🔄 Reloading CryptoService with imported keys...');
    await _cryptoService!.reloadKeyPairFromStorage();
    
    logDebug('✅ Migration data imported successfully');
    logDebug('   Keys imported: publicKey present, privateKey present');
  }

  /// Validates migration data integrity
  Future<bool> _validateMigrationData(MigrationData data) async {
    // Check required fields
    if (data.userId.isEmpty || data.userName.isEmpty) {
      logDebugError('Validation failed: Missing user ID or name');
      return false;
    }

    // Check timestamp (reject data older than session expiry)
    // Use UTC comparison to avoid timezone issues
    final now = DateTime.now().toUtc();
    final timestampUtc = data.timestamp.toUtc();
    final age = now.difference(timestampUtc);
    logDebug('🕐 Migration data age: ${age.inMinutes} minutes (UTC)');
    logDebug('🕐 Migration data timestamp (UTC): $timestampUtc');
    logDebug('🕐 Current time (UTC): $now');
    
    // Allow some buffer time for network delays (2x session expiry)
    if (age > _sessionExpiry * 2) {
      logDebugError('Validation failed: Data expired (age: ${age.inMinutes} min)');
      return false;
    }

    // Validate public key format
    final pubKey = _cryptoService!.ecPublicKeyFromString(data.publicKey);
    if (pubKey == null) {
      logDebugError('Validation failed: Invalid public key');
      return false;
    }

    return true;
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

  /// Gets the device fingerprint for identification
  Future<String> _getDeviceFingerprint() async {
    try {
      return await _fingerprintService.getDeviceFingerprint();
    } catch (e) {
      logDebug('Using fallback device ID generation: $e');
      // Fallback: generate a device ID based on timestamp
      final existingId = await _secureStorage.getContactPublicKey('device_id');
      if (existingId != null) return existingId;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = base64Encode(List<int>.generate(8, (_) => timestamp % 256));
      final deviceId = 'device_${timestamp}_$random';
      await _secureStorage.saveContactPublicKey('device_id', deviceId);
      return deviceId;
    }
  }

  // ==========================================================================
  // PRIVATE HELPERS - Key & Session Management
  // ==========================================================================

  /// Generates cryptographically secure random bytes
  Uint8List _generateSecureRandom(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Generates a device fingerprint for binding
  Future<String> _generateDeviceFingerprint() async {
    // Combine multiple device characteristics
    final components = <String>[
      // Device info from DeviceValidationService can be incorporated here
      DateTime.now().millisecondsSinceEpoch.toString(),
      base64Encode(_generateSecureRandom(16)),
    ];

    // Hash the components
    final digest = pc.SHA256Digest();
    final input = utf8.encode(components.join('|'));
    final hash = digest.process(Uint8List.fromList(input));
    return base64Encode(hash).substring(0, 32); // Take first 32 chars
  }

  /// Generates ephemeral ECDH key pair for a session
  Future<pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>>
      _generateEphemeralKeyPair() async {
    final domainParams = pc.ECDomainParameters('secp256r1');

    final secureRandom = pc.FortunaRandom();
    final random = Random.secure();
    final seed = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));

    final keyGen = pc.ECKeyGenerator();
    keyGen.init(
      pc.ParametersWithRandom(
        pc.ECKeyGeneratorParameters(domainParams),
        secureRandom,
      ),
    );

    final pair = keyGen.generateKeyPair();
    return pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(
      pair.publicKey,
      pair.privateKey,
    );
  }

  Future<void> _storeSession(MigrationSession session) async {
    final key = '$_migrationSessionsKey${session.sessionId}';
    final json = jsonEncode({
      'sessionId': session.sessionId,
      'sessionCode': session.sessionCode,
      'sourceDeviceId': session.sourceDeviceId,
      'targetDeviceId': session.targetDeviceId,
      'createdAt': session.createdAt.toIso8601String(),
      'expiresAt': session.expiresAt.toIso8601String(),
      'status': session.status.index,
      'errorMessage': session.errorMessage,
      'attemptCount': session.attemptCount,
    });
    await _secureStorage.write(key: key, value: json);
  }

  Future<void> _storeEphemeralKeys(
    String sessionId,
    pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey> keyPair,
  ) async {
    final prefix = _migrationNonceKey + sessionId;

    final privateKeyHex = keyPair.privateKey.d!.toRadixString(16);
    final publicKeyBase64 = _cryptoService!.ecPublicKeyToString(keyPair.publicKey);

    await _secureStorage.write(
      key: '${prefix}_priv',
      value: privateKeyHex,
    );
    await _secureStorage.write(
      key: '${prefix}_pub',
      value: publicKeyBase64,
    );
  }

  Future<pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>> _loadEphemeralKeys(
    String sessionId,
  ) async {
    // Try loading with sessionId first (could be UUID or sessionCode)
    final prefix = _migrationNonceKey + sessionId;

    var privateKeyHex = await _secureStorage.read(key: '${prefix}_priv');
    var publicKeyBase64 = await _secureStorage.read(key: '${prefix}_pub');
    
    // If not found and we have a session with sessionCode, try that
    if ((privateKeyHex == null || publicKeyBase64 == null) && 
        _currentSession?.sessionCode != null &&
        _currentSession?.sessionCode != sessionId) {
      final fallbackPrefix = _migrationNonceKey + _currentSession!.sessionCode!;
      privateKeyHex = await _secureStorage.read(key: '${fallbackPrefix}_priv');
      publicKeyBase64 = await _secureStorage.read(key: '${fallbackPrefix}_pub');
      
      if (privateKeyHex != null && publicKeyBase64 != null) {
        logDebug('🔑 Loaded ephemeral keys using sessionCode fallback');
      }
    }

    if (privateKeyHex == null || publicKeyBase64 == null) {
      throw Exception('Ephemeral keys not found for session');
    }

    final domainParams = pc.ECDomainParameters('secp256r1');
    final privateKey = pc.ECPrivateKey(
      BigInt.parse(privateKeyHex, radix: 16),
      domainParams,
    );
    final publicKeyBytes = base64Decode(publicKeyBase64);
    final point = domainParams.curve.decodePoint(publicKeyBytes);
    final publicKey = pc.ECPublicKey(point, domainParams);

    return pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(
      publicKey,
      privateKey,
    );
  }

  /// Clears all migration-related data
  Future<void> clearMigrationData(String sessionId) async {
    final sessionKey = '$_migrationSessionsKey$sessionId';
    final prefix = _migrationNonceKey + sessionId;

    await _secureStorage.delete(key: sessionKey);
    await _secureStorage.delete(key: '${prefix}_priv');
    await _secureStorage.delete(key: '${prefix}_pub');

    _currentSession = null;
    logDebug('🧹 Migration data cleared for session: $sessionId');
  }
}

// ============================================================================
// RESULT CLASSES
// ============================================================================

class MigrationInitiationResult {
  final bool success;
  final String? sessionCode;
  final DateTime? expiresAt;
  final String? deviceFingerprint;
  final String? errorMessage;

  MigrationInitiationResult._({
    required this.success,
    this.sessionCode,
    this.expiresAt,
    this.deviceFingerprint,
    this.errorMessage,
  });

  factory MigrationInitiationResult.success({
    required String sessionCode,
    required DateTime expiresAt,
    required String deviceFingerprint,
  }) {
    return MigrationInitiationResult._(
      success: true,
      sessionCode: sessionCode,
      expiresAt: expiresAt,
      deviceFingerprint: deviceFingerprint,
    );
  }

  factory MigrationInitiationResult.error(String message) {
    return MigrationInitiationResult._(
      success: false,
      errorMessage: message,
    );
  }
}

class MigrationJoinResult {
  final bool success;
  final String? sessionId; // UUID for API calls
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;

  MigrationJoinResult._({
    required this.success,
    this.sessionId,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
  });

  factory MigrationJoinResult.success({
    required String sessionId,
    required String sourceDeviceId,
    required String userId,
    required bool requiresConfirmation,
  }) {
    return MigrationJoinResult._(
      success: true,
      sessionId: sessionId,
      sourceDeviceId: sourceDeviceId,
      userId: userId,
      requiresConfirmation: requiresConfirmation,
    );
  }

  factory MigrationJoinResult.error(String message) {
    return MigrationJoinResult._(
      success: false,
      errorMessage: message,
    );
  }
}

class MigrationPayloadResult {
  final bool success;
  final EncryptedMigrationPayload? payload;
  final String? errorMessage;

  MigrationPayloadResult._({
    required this.success,
    this.payload,
    this.errorMessage,
  });

  factory MigrationPayloadResult.success(EncryptedMigrationPayload payload) {
    return MigrationPayloadResult._(success: true, payload: payload);
  }

  factory MigrationPayloadResult.error(String message) {
    return MigrationPayloadResult._(success: false, errorMessage: message);
  }
}

class MigrationReceiveResult {
  final bool success;
  final MigrationData? data;
  final String? userId; // User ID from completeMigration response
  final String? errorMessage;

  MigrationReceiveResult._({
    required this.success,
    this.data,
    this.userId,
    this.errorMessage,
  });

  factory MigrationReceiveResult.success(MigrationData data, String userId) {
    return MigrationReceiveResult._(success: true, data: data, userId: userId);
  }

  factory MigrationReceiveResult.error(String message) {
    return MigrationReceiveResult._(success: false, errorMessage: message);
  }
}

/// Result of initiating email recovery
class EmailRecoveryInitiationResult {
  final bool success;
  final String? maskedEmail;
  final DateTime? expiresAt;
  final String? errorMessage;

  EmailRecoveryInitiationResult._({
    required this.success,
    this.maskedEmail,
    this.expiresAt,
    this.errorMessage,
  });

  factory EmailRecoveryInitiationResult.success({
    required String maskedEmail,
    required DateTime expiresAt,
  }) {
    return EmailRecoveryInitiationResult._(
      success: true,
      maskedEmail: maskedEmail,
      expiresAt: expiresAt,
    );
  }

  factory EmailRecoveryInitiationResult.error(String message) {
    return EmailRecoveryInitiationResult._(success: false, errorMessage: message);
  }
}

/// Result of email recovery (verify code + receive data)
class EmailRecoveryCompleteResult {
  final bool success;
  final String? userId;
  final String? errorMessage;

  EmailRecoveryCompleteResult._({
    required this.success,
    this.userId,
    this.errorMessage,
  });

  factory EmailRecoveryCompleteResult.success(String userId) {
    return EmailRecoveryCompleteResult._(success: true, userId: userId);
  }

  factory EmailRecoveryCompleteResult.error(String message) {
    return EmailRecoveryCompleteResult._(success: false, errorMessage: message);
  }
}
