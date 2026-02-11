// lib/services/device_migration_service.dart
// Secure Device Migration Framework for Barter App
// Handles cross-device user data synchronization with end-to-end encryption

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
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
  final String sessionId;
  final String sourceDeviceId;
  final String targetDeviceId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final MigrationStatus status;
  final String? errorMessage;
  final int attemptCount;

  MigrationSession({
    required this.sessionId,
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
    'timestamp': timestamp.toIso8601String(),
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
      timestamp: DateTime.parse(json['timestamp'] as String),
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

  EncryptedMigrationPayload({
    required this.encryptedData,
    required this.ephemeralPublicKey,
    required this.signature,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.sessionId,
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
    );
  }
}

// ============================================================================
// MAIN SERVICE IMPLEMENTATION
// ============================================================================

@injectable
class DeviceMigrationService {
  /*static const String _migrationSessionsKey = 'migration_sessions';
  static const String _migrationNonceKey = 'migration_nonce_';
  static const Duration _sessionExpiry = Duration(minutes: 15);
  static const Duration _confirmationTimeout = Duration(minutes: 5);
  static const int _maxAttempts = 3;

  final SecureStorageService _secureStorage;
  final ApiClient _apiClient;
  CryptoService? _cryptoService;

  MigrationSession? _currentSession;

  DeviceMigrationService(
    this._secureStorage,
    this._apiClient,
  );

  // ==========================================================================
  // PUBLIC API - Source Device (Export)
  // ==========================================================================

  /// Initiates a migration session from the source device
  /// Returns a session ID that the user must enter on the target device
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

      // 3. Generate unique session ID (10-character alphanumeric)
      final sessionId = _generateSessionId();

      // 4. Create device fingerprint for binding
      final deviceFingerprint = await _generateDeviceFingerprint();

      // 5. Generate ephemeral key pair for this session
      final ephemeralKeyPair = await _generateEphemeralKeyPair();

      // 6. Create migration session
      final session = MigrationSession(
        sessionId: sessionId,
        sourceDeviceId: deviceFingerprint,
        targetDeviceId: '', // Will be set when target connects
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(_sessionExpiry),
        status: MigrationStatus.initiating,
      );

      // 7. Store session data securely
      await _storeSession(session);
      await _storeEphemeralKeys(sessionId, ephemeralKeyPair);

      _currentSession = session;

      logDebug('✅ Migration initiated. Session ID: $sessionId');

      return MigrationInitiationResult.success(
        sessionId: sessionId,
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

      // 2. Serialize and encrypt data
      final payload = await _encryptMigrationData(
        migrationData: migrationData,
        targetDeviceId: targetDeviceId,
        targetPublicKey: targetPublicKey,
      );

      // 3. Update session status
      final updatedSession = MigrationSession(
        sessionId: session.sessionId,
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
  Future<MigrationJoinResult> joinMigrationSession(String sessionId) async {
    try {
      logDebug('🔐 Joining migration session: $sessionId');

      // 1. Initialize crypto on target device
      _cryptoService = await CryptoService.create();

      // 2. Generate target device fingerprint
      final deviceFingerprint = await _generateDeviceFingerprint();

      // 3. Get target device's public key
      final targetPublicKey = _cryptoService!.ecPublicKeyToString(
        _cryptoService!.getPublicKey()!,
      );

      // 4. Call API to register target device
      final response = await _apiClient.registerMigrationTarget(
        sessionId: sessionId,
        targetDeviceId: deviceFingerprint,
        targetPublicKey: targetPublicKey,
      );

      if (!response.success) {
        return MigrationJoinResult.error(
          response.errorMessage ?? 'Failed to join session',
        );
      }

      // 5. Store session info locally
      final session = MigrationSession(
        sessionId: sessionId,
        sourceDeviceId: response.sourceDeviceId!,
        targetDeviceId: deviceFingerprint,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(_confirmationTimeout),
        status: MigrationStatus.awaitingConfirmation,
      );
      await _storeSession(session);
      _currentSession = session;

      return MigrationJoinResult.success(
        sourceDeviceId: response.sourceDeviceId!,
        userId: response.userId!,
        requiresConfirmation: response.requiresConfirmation,
      );
    } catch (e) {
      logDebugError('Failed to join migration session: $e');
      return MigrationJoinResult.error('Join failed: $e');
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

      // 5. Notify backend of successful migration
      await _apiClient.confirmMigrationComplete(
        sessionId: payload.sessionId,
        targetDeviceId: payload.targetDeviceId,
      );

      return MigrationReceiveResult.success(migrationData);
    } catch (e) {
      logDebugError('Failed to receive migration data: $e');
      return MigrationReceiveResult.error('Receive failed: $e');
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

    // 6. Sign the encrypted payload with source device's main key
    final payloadToSign = '${session.sessionId}.${targetDeviceId}.${base64Encode(encryptedBytes)}';
    final signature = _cryptoService!.signMessage(payloadToSign);
    if (signature == null) {
      throw Exception('Failed to sign payload');
    }

    // 7. Construct final payload
    final ephemeralPubKeyStr = _cryptoService!.ecPublicKeyToString(
      ephemeralKeyPair.publicKey,
    );

    // Combine salt + iv + ciphertext
    final combinedPayload = Uint8List(salt.length + iv.length + encryptedBytes.length);
    combinedPayload.setAll(0, salt);
    combinedPayload.setAll(salt.length, iv);
    combinedPayload.setAll(salt.length + iv.length, encryptedBytes);

    return EncryptedMigrationPayload(
      encryptedData: base64Encode(combinedPayload),
      ephemeralPublicKey: ephemeralPubKeyStr,
      signature: signature,
      sourceDeviceId: session.sourceDeviceId,
      targetDeviceId: targetDeviceId,
      sessionId: session.sessionId,
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

      // We need the source device's public key - get it from the session
      final session = await _getSession(payload.sessionId);
      if (session == null) return false;

      // Get source device public key from backend
      final sourcePublicKeyResponse = await _apiClient.getMigrationPublicKey(
        sessionId: payload.sessionId,
        deviceId: payload.sourceDeviceId,
      );

      if (!sourcePublicKeyResponse.success) return false;

      final sourcePublicKey = _cryptoService!.ecPublicKeyFromString(
        sourcePublicKeyResponse.publicKey!,
      );
      if (sourcePublicKey == null) return false;

      // Verify signature
      return _cryptoService!.verifySignature(
        payloadToVerify,
        payload.signature,
        sourcePublicKey,
      );
    } catch (e) {
      logDebugError('Signature verification error: $e');
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

    return MigrationData(
      userId: userId,
      userName: userName,
      location: location,
      interests: interests,
      offerings: offerings,
      profileKeywordDataMap: keywordMap,
      publicKey: publicKey,
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

    // Note: We DON'T import the private key - new keypair is generated
    // The public key is stored for reference
    await _secureStorage.saveOwnPublicKey(data.publicKey);

    logDebug('✅ Migration data imported successfully');
  }

  /// Validates migration data integrity
  Future<bool> _validateMigrationData(MigrationData data) async {
    // Check required fields
    if (data.userId.isEmpty || data.userName.isEmpty) {
      logDebugError('Validation failed: Missing user ID or name');
      return false;
    }

    // Check timestamp (reject data older than session expiry)
    final age = DateTime.now().difference(data.timestamp);
    if (age > _sessionExpiry) {
      logDebugError('Validation failed: Data expired');
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

  // ==========================================================================
  // PRIVATE HELPERS - Key & Session Management
  // ==========================================================================

  /// Generates a unique session ID (10 chars: uppercase letters + numbers)
  String _generateSessionId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(10, (_) => chars[random.nextInt(chars.length)]).join();
  }

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
      _generateSecureRandom(16).join('_'),
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
      pair.publicKey as pc.ECPublicKey,
      pair.privateKey as pc.ECPrivateKey,
    );
  }

  Future<void> _storeSession(MigrationSession session) async {
    final key = '$_migrationSessionsKey_${session.sessionId}';
    final json = jsonEncode({
      'sessionId': session.sessionId,
      'sourceDeviceId': session.sourceDeviceId,
      'targetDeviceId': session.targetDeviceId,
      'createdAt': session.createdAt.toIso8601String(),
      'expiresAt': session.expiresAt.toIso8601String(),
      'status': session.status.index,
      'errorMessage': session.errorMessage,
      'attemptCount': session.attemptCount,
    });
    await _secureStorage._secureStorage.write(key: key, value: json);
  }

  Future<MigrationSession?> _getSession(String sessionId) async {
    final key = '$_migrationSessionsKey_$sessionId';
    final json = await _secureStorage._secureStorage.read(key: key);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return MigrationSession(
        sessionId: map['sessionId'] as String,
        sourceDeviceId: map['sourceDeviceId'] as String,
        targetDeviceId: map['targetDeviceId'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        expiresAt: DateTime.parse(map['expiresAt'] as String),
        status: MigrationStatus.values[map['status'] as int],
        errorMessage: map['errorMessage'] as String?,
        attemptCount: map['attemptCount'] as int? ?? 0,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _storeEphemeralKeys(
    String sessionId,
    pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey> keyPair,
  ) async {
    final prefix = _migrationNonceKey + sessionId;

    final privateKeyHex = keyPair.privateKey.d!.toRadixString(16);
    final publicKeyBase64 = _cryptoService!.ecPublicKeyToString(keyPair.publicKey);

    await _secureStorage._secureStorage.write(
      key: '${prefix}_priv',
      value: privateKeyHex,
    );
    await _secureStorage._secureStorage.write(
      key: '${prefix}_pub',
      value: publicKeyBase64,
    );
  }

  Future<pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>> _loadEphemeralKeys(
    String sessionId,
  ) async {
    final prefix = _migrationNonceKey + sessionId;

    final privateKeyHex = await _secureStorage._secureStorage.read(key: '${prefix}_priv');
    final publicKeyBase64 = await _secureStorage._secureStorage.read(key: '${prefix}_pub');

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
    final sessionKey = '$_migrationSessionsKey_$sessionId';
    final prefix = _migrationNonceKey + sessionId;

    await _secureStorage._secureStorage.delete(key: sessionKey);
    await _secureStorage._secureStorage.delete(key: '${prefix}_priv');
    await _secureStorage._secureStorage.delete(key: '${prefix}_pub');

    _currentSession = null;
    logDebug('🧹 Migration data cleared for session: $sessionId');
  }*/
}

// ============================================================================
// RESULT CLASSES
// ============================================================================

class MigrationInitiationResult {
  final bool success;
  final String? sessionId;
  final DateTime? expiresAt;
  final String? deviceFingerprint;
  final String? errorMessage;

  MigrationInitiationResult._({
    required this.success,
    this.sessionId,
    this.expiresAt,
    this.deviceFingerprint,
    this.errorMessage,
  });

  factory MigrationInitiationResult.success({
    required String sessionId,
    required DateTime expiresAt,
    required String deviceFingerprint,
  }) {
    return MigrationInitiationResult._(
      success: true,
      sessionId: sessionId,
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
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;

  MigrationJoinResult._({
    required this.success,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
  });

  factory MigrationJoinResult.success({
    required String sourceDeviceId,
    required String userId,
    required bool requiresConfirmation,
  }) {
    return MigrationJoinResult._(
      success: true,
      sourceDeviceId: sourceDeviceId,
      userId: userId,
      requiresConfirmation: requiresConfirmation,
    );
  }

  factory MigrationJoinResult.error(String message) {
    return MigrationInitiationResult._(
      success: false,
      errorMessage: message,
    ) as MigrationJoinResult;
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
  final String? errorMessage;

  MigrationReceiveResult._({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory MigrationReceiveResult.success(MigrationData data) {
    return MigrationReceiveResult._(success: true, data: data);
  }

  factory MigrationReceiveResult.error(String message) {
    return MigrationReceiveResult._(success: false, errorMessage: message);
  }
}

// ============================================================================
// API EXTENSION (Add these methods to ApiClient)
// ============================================================================

/// Extension methods that need to be added to ApiClient
abstract class MigrationApiMethods {
  Future<RegisterMigrationTargetResponse> registerMigrationTarget({
    required String sessionId,
    required String targetDeviceId,
    required String targetPublicKey,
  });

  Future<GetMigrationPublicKeyResponse> getMigrationPublicKey({
    required String sessionId,
    required String deviceId,
  });

  Future<ConfirmMigrationResponse> confirmMigrationComplete({
    required String sessionId,
    required String targetDeviceId,
  });
}

class RegisterMigrationTargetResponse {
  final bool success;
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;

  RegisterMigrationTargetResponse({
    required this.success,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
  });
}

class GetMigrationPublicKeyResponse {
  final bool success;
  final String? publicKey;
  final String? errorMessage;

  GetMigrationPublicKeyResponse({
    required this.success,
    this.publicKey,
    this.errorMessage,
  });
}

class ConfirmMigrationResponse {
  final bool success;
  final String? errorMessage;

  ConfirmMigrationResponse({
    required this.success,
    this.errorMessage,
  });
}
