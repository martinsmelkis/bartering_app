import 'dart:async';
import 'dart:convert';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart' as pc;
import 'dart:math';

// --- TOP-LEVEL OR STATIC FUNCTION FOR ECC KEY GENERATION ---
Future<pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>> _generateEcKeyPairInBackground(Map<String, dynamic> params) async {
  final curveName = params['curveName'] ?? 'secp256r1'; // Default to P-256
  final domainParams = pc.ECDomainParameters(curveName);

  final secureRandom = pc.FortunaRandom();
  final random = Random.secure();
  final seed = List<int>.generate(32, (_) => random.nextInt(256));
  secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));

  final keyGen = pc.ECKeyGenerator();
  keyGen.init(pc.ParametersWithRandom(pc.ECKeyGeneratorParameters(domainParams), secureRandom));

  logDebug('@@@@@@@@@@@ Starting EC keyPair generation in background... ${DateTime.now().millisecondsSinceEpoch}');
  final pair = keyGen.generateKeyPair();
  logDebug('@@@@@@@@@@@ Finished EC keyPair generation in background ${DateTime.now().millisecondsSinceEpoch}');
  return pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(
      pair.publicKey as pc.ECPublicKey, pair.privateKey as pc.ECPrivateKey);
}

class CryptoService {
  pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>? _keyPair;
  bool _isInitialized = false; // Changed from static to instance variable
  pc.ECDomainParameters? _domainParameters; // Store the curve parameters
  SecureStorageService secureStorage = SecureStorageService();

  // For AES-GCM
  static const int AES_KEY_LENGTH_BYTES = 32; // 256-bit AES
  static const int IV_LENGTH_BYTES = 12; // Common for AES-GCM (96 bits)
  static const int TAG_LENGTH_BITS = 128; // AES-GCM authentication tag length
  static const int SALT_LENGTH_BYTES = 16; // Length for the randomised salt

  // Singleton instance
  static CryptoService? _instance;
  
  // Static lock to prevent concurrent initialization
  static Future<CryptoService>? _creatingInstance;

  CryptoService._();

  static Future<CryptoService> create({String curveName = 'secp256r1'}) async {
    logDebug("@@@@@@@@@@@ CryptoService.create() called - _instance=${_instance != null}, _creatingInstance=${_creatingInstance != null}");
    
    // Fast path: already initialized
    if (_instance != null && _instance!.isReady) {
      logDebug("@@@@@@@@@@@ Returning existing ready CryptoService instance");
      return _instance!;
    }
    
    // CRITICAL: Check again after any potential async gaps
    // This handles the race condition where two calls arrive simultaneously
    while (_creatingInstance != null) {
      logDebug("@@@@@@@@@@@ Another initialization in progress, waiting...");
      final result = await _creatingInstance!;
      // Double-check: did the completed initialization succeed?
      if (_instance != null && _instance!.isReady) {
        logDebug("@@@@@@@@@@@ Wait complete, returning ready instance");
        return _instance!;
      }
      // If the initialization failed, loop and try again
      logDebug("@@@@@@@@@@@ Previous initialization failed or incomplete, retrying...");
      if (_creatingInstance == null) break;
    }
    
    // If we get here, we're the one who should initialize
    // Check one more time in case another thread just completed
    if (_instance != null && _instance!.isReady) {
      return _instance!;
    }
    
    // Create a completer to act as our lock - this is synchronous
    logDebug("@@@@@@@@@@@ Acquiring creation lock");
    final completer = Completer<CryptoService>();
    _creatingInstance = completer.future;
    
    try {
      logDebug("@@@@@@@@@@@ Creating new CryptoService instance...");
      final service = CryptoService._();
      await service.initializeKeyPair(curveName: curveName);
      _instance = service;
      logDebug("@@@@@@@@@@@ CryptoService instance created: ${service.hashCode}");
      completer.complete(service);
      return service;
    } catch (e, stackTrace) {
      logDebugError("CryptoService creation failed", e);
      completer.completeError(e, stackTrace);
      rethrow;
    } finally {
      _creatingInstance = null;
      logDebug("@@@@@@@@@@@ Creation lock released");
    }
  }

  // Method to get the singleton instance if it exists
  static CryptoService? get instance => _instance;

  // Helper method to avoid code duplication
  Future<void> _generateAndSaveNewKeyPair(String curveName) async {
    // Double-check: another instance might have saved keys while we were waiting
    final existingKey = await secureStorage.getOwnPrivateKey();
    if (existingKey != null && existingKey.isNotEmpty) {
      logDebug("@@@@@@@@@@@ Keys already exist in storage (race condition detected), skipping generation");
      // Re-initialize with existing key
      try {
        final privateKey = ecPrivateKeyFromString(existingKey);
        _domainParameters ??= pc.ECDomainParameters(curveName);
        final Q = _domainParameters!.G * privateKey.d!;
        final publicKey = pc.ECPublicKey(Q, _domainParameters);
        _keyPair = pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(publicKey, privateKey);
        _isInitialized = true;
        logDebug("@@@@@@@@@@@ Loaded existing keys instead of generating new ones");
        return;
      } catch (e) {
        logDebug("Failed to load existing key, will generate new: $e");
        // Fall through to generate new key
      }
    }
    
    // For web/WASM, run key generation directly (compute doesn't spawn threads on web)
    // For native platforms, use compute to avoid blocking UI
    if (kIsWeb) {
      // Run directly on web - compute() doesn't help on WASM and may cause stack issues
      final domainParams = pc.ECDomainParameters(curveName);
      final secureRandom = pc.FortunaRandom();
      final random = Random.secure();
      final seed = List<int>.generate(32, (_) => random.nextInt(256));
      secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));
      
      final keyGen = pc.ECKeyGenerator();
      keyGen.init(pc.ParametersWithRandom(pc.ECKeyGeneratorParameters(domainParams), secureRandom));
      
      logDebug('@@@@@@@@@@@ Starting EC keyPair generation on web...');
      final pair = keyGen.generateKeyPair();
      logDebug('@@@@@@@@@@@ Finished EC keyPair generation on web');
      
      _keyPair = pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(
          pair.publicKey as pc.ECPublicKey, pair.privateKey as pc.ECPrivateKey);
    } else {
      // Use isolate on native platforms
      _keyPair = await compute(_generateEcKeyPairInBackground, {'curveName': curveName});
    }
    _isInitialized = true;

    if (_keyPair != null) {
      // Save the new private and public keys
      await secureStorage.saveOwnPrivateKey(ecPrivateKeyToString(getPrivateKey()!));
      await secureStorage.saveOwnPublicKey(ecPublicKeyToString(getPublicKey()));
      logDebug("@@@@@@@@@@@ New key pair generated and saved.");
    }
  }

  Future<void> initializeKeyPair({String curveName = 'secp256r1'}) async {
    if (_isInitialized) return;
    
    // Prevent re-initialization on disposed instances
    if (_instance != this && _instance != null) {
      logDebug("@@@@@@@@@@@ WARNING: initializeKeyPair() called on non-singleton instance, aborting");
      throw StateError('Cannot initializeKeyPair() on a disposed CryptoService instance. Use CryptoService.create() instead.');
    }

    _domainParameters = pc.ECDomainParameters(curveName);

    // 1. Try to load the private key from secure storage
    final privateKeyHex = await secureStorage.getOwnPrivateKey();

    if (privateKeyHex != null && privateKeyHex.isNotEmpty) {
      // 2. If it exists, reconstruct the private and public keys
      logDebug("@@@@@@@@@@@ Found existing private key. Loading from storage...");
      try {
        final privateKey = ecPrivateKeyFromString(privateKeyHex);

        // Re-derive the public key from the private key and curve parameters
        final Q = _domainParameters!.G * privateKey.d!;
        final publicKey = pc.ECPublicKey(Q, _domainParameters);

        _keyPair = pc.AsymmetricKeyPair<pc.ECPublicKey, pc.ECPrivateKey>(publicKey, privateKey);
        _isInitialized = true;
        logDebug("@@@@@@@@@@@ Key pair successfully loaded from storage.");
      } catch (e) {
        logDebug("ERROR: Failed to load key from storage, will generate a new one. Error: $e");
        // Fallback to generating a new key if loading fails
        await _generateAndSaveNewKeyPair(curveName);
      }
    } else {
      // 3. If it doesn't exist, generate a new one and save it
      debugPrint("@@@@@@@@@@@ No private key found. Generating a new key pair...");
      await _generateAndSaveNewKeyPair(curveName);
    }

    if (isReady) {
      logDebug("My EC Public Key: ${ecPublicKeyToString(getPublicKey()!)}");
    } else {
      logDebug("ERROR: EC Key pair initialization failed.");
    }
  }

  bool get isReady => _isInitialized && _keyPair != null && _domainParameters != null;

  pc.ECPublicKey? getPublicKey() => _keyPair?.publicKey;
  pc.ECPrivateKey? getPrivateKey() => _keyPair?.privateKey;

  // --- ECDH Shared Secret ---
  /// Derive shared secret using ECDH - exposed for FileTransferService chunked decryption
  Uint8List? deriveSharedSecret(pc.ECPublicKey otherPublicKey) {
    return _deriveSharedSecret(getPrivateKey()!, otherPublicKey);
  }

  Uint8List? _deriveSharedSecret(pc.ECPrivateKey myPrivateKey, pc.ECPublicKey otherPublicKey) {
    if (!isReady) return null;
    try {
      final agreement = pc.ECDHBasicAgreement();
      agreement.init(myPrivateKey);
      final sharedBigInt = agreement.calculateAgreement(otherPublicKey);
      // Convert BigInt to fixed-size Uint8List (e.g., for P-256, it's 32 bytes)
      // This needs a robust conversion that matches on both sides.
      // The size of x or y coordinate of a point on the curve.
      int fieldSize = (_domainParameters!.curve.fieldSize / 8).ceil();
      return _bigIntToBytes(sharedBigInt, fieldSize);
    } catch (e) {
      logDebug("Error deriving shared secret: $e");
      return null;
    }
  }

  // Helper for BigInt to fixed-size byte array
  Uint8List _bigIntToBytes(BigInt number, int byteLength) {
    final bytes = Uint8List(byteLength);
    for (var i = byteLength - 1; i >= 0; i--) {
      bytes[i] = number.toUnsigned(8).toInt();
      number = number >> 8;
    }
    // A simpler but potentially less standard way for positive numbers:
    // final hex = number.toRadixString(16).padLeft(byteLength * 2, '0');
    // if (hex.length > byteLength * 2) throw ArgumentError("BigInt too large for specified byteLength");
    // return Uint8List.fromList(hex.decode(hex));
    return bytes;
  }

  // --- HKDF for Symmetric Key Derivation ---
  Uint8List _deriveSymmetricKey(Uint8List sharedSecret, Uint8List salt) {
    // Info string can be used to bind the key to a specific context/purpose
    final infoBytes = utf8.encode("E2EE Chat Symmetric Key");

    final hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
    hkdf.init(pc.HkdfParameters(sharedSecret, AES_KEY_LENGTH_BYTES, salt, infoBytes));
    return hkdf.process(Uint8List(AES_KEY_LENGTH_BYTES));
  }

  String? encrypt(String plainText, pc.ECPublicKey recipientPublicKey) {
    if (!isReady) {
      logDebug("Encryption failed: Service not ready. isReady=$isReady");
      return null;
    }

    logDebug(
        "@@@@@@@@@@@ Encrypting message with recipient key: ${ecPublicKeyToString(
            recipientPublicKey).substring(0, 20)}...");
    final sharedSecret = _deriveSharedSecret(
        getPrivateKey()!, recipientPublicKey);
    if (sharedSecret == null) {
      logDebug("Encryption failed: Could not derive shared secret.");
      return null;
    }

    // --- Generate a unique, random salt for each encryption ---
    final secureRandom = pc.FortunaRandom()..seed(pc.KeyParameter(
        Uint8List.fromList(List<int>.generate(32, (_) =>
            Random.secure().nextInt(256)))));

    final salt = secureRandom.nextBytes(SALT_LENGTH_BYTES);
    // Use a unique salt for each key derivation if possible, or a well-defined one.
    // For simplicity, using a fixed salt here, but ideally, this could be
    // related to the session or exchanged.
    final symmetricKey = _deriveSymmetricKey(sharedSecret, salt);

    // Generate a unique IV for each message
    //final secureRandom = pc.FortunaRandom()..seed(pc.KeyParameter(Uint8List.fromList(List<int>.generate(32, (_) => Random.secure().nextInt(256)))));
    final iv = secureRandom.nextBytes(IV_LENGTH_BYTES);

    try {
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      cipher.init(true, pc.AEADParameters(pc.KeyParameter(symmetricKey), TAG_LENGTH_BITS, iv, Uint8List(0)));

      final plainTextBytes = utf8.encode(plainText);
      final encryptedBytes = cipher.process(plainTextBytes);

      // --- FIX: Prepend BOTH the salt and the IV to the ciphertext ---
      // New structure: [ Salt (16 bytes) | IV (12 bytes) | Ciphertext ]
      final payloadWithSaltAndIv = Uint8List(salt.length + iv.length + encryptedBytes.length);
      payloadWithSaltAndIv.setAll(0, salt);
      payloadWithSaltAndIv.setAll(salt.length, iv);
      payloadWithSaltAndIv.setAll(salt.length + iv.length, encryptedBytes);

      return base64Encode(payloadWithSaltAndIv);
    } catch (e) {
      logDebug("AES-GCM Encryption error: $e");
      return null;
    }
  }

  // --- Decryption (AES-GCM) ---
  String? decrypt(String base64PayloadWithSaltAndIv, pc.ECPublicKey? senderPublicKey) {
    if (!isReady) {
      logDebug("Decryption failed: Service not ready.");
      return null;
    }

    if (senderPublicKey == null) {
      logDebug("Decryption failed: Sender's public key is null");
      return null;
    }

    logDebug(
        "@@@@@@@@@@@ Decrypting message with sender key: ${ecPublicKeyToString(
            senderPublicKey).substring(0, 20)}...");
    logDebug("@@@@@@@@@@@ My private key exists: ${getPrivateKey() != null}");

    final sharedSecret = _deriveSharedSecret(getPrivateKey()!, senderPublicKey);
    if (sharedSecret == null) {
      logDebug(
          "Decryption failed: Could not derive shared secret with sender's key.");
      return null;
    }

    try {

      final payloadWithSaltAndIv = base64Decode(base64PayloadWithSaltAndIv);

      if (payloadWithSaltAndIv.length < SALT_LENGTH_BYTES + IV_LENGTH_BYTES) {
        logDebug("Decryption failed: Payload too short to contain salt and IV.");
        return null;
      }

      // --- Extract Salt and IV from the beginning of the payload ---
      final salt = payloadWithSaltAndIv.sublist(0, SALT_LENGTH_BYTES);
      final iv = payloadWithSaltAndIv.sublist(SALT_LENGTH_BYTES, SALT_LENGTH_BYTES + IV_LENGTH_BYTES);
      final encryptedBytes = payloadWithSaltAndIv.sublist(SALT_LENGTH_BYTES + IV_LENGTH_BYTES);

      // --- Re-derive the key using the extracted salt ---
      final symmetricKey = _deriveSymmetricKey(sharedSecret, salt);

      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      cipher.init(false, pc.AEADParameters(pc.KeyParameter(symmetricKey), TAG_LENGTH_BITS, iv, Uint8List(0)));

      final decryptedBytes = cipher.process(encryptedBytes);
      return utf8.decode(decryptedBytes);
    } on pc.InvalidCipherTextException { // This is crucial for GCM
      logDebug("Decryption failed: Ciphertext authentication failed (tampered, wrong key, or wrong IV).");
      return null;
    } catch (e) {
      logDebug("AES-GCM Decryption error: $e");
      return null;
    }
  }

  // --- ECC Public Key String Conversion (Using Uncompressed SEC1 format for simplicity) ---
  // In production, consider compressed format for smaller size.
  String ecPublicKeyToString(pc.ECPublicKey? publicKey) {
    // .Q is the ECPoint. getEncoded(false) gives uncompressed SEC1 format.
    return base64Encode(publicKey!.Q!.getEncoded(false));
  }

  pc.ECPublicKey? ecPublicKeyFromString(String base64Str) {
    try {
      Uint8List encodedPoint = base64Decode(base64Str);
      _domainParameters ??= pc.ECDomainParameters('secp256r1');
      // Create an ECPoint from the decoded bytes and the domain parameters (curve)
      pc.ECPoint? point = _domainParameters!.curve.decodePoint(encodedPoint);
      if (point == null) return null;
      return pc.ECPublicKey(point, _domainParameters);
    } catch (e) {
      logDebug("Error parsing EC public key from string: $e");
      return null;
    }
  }

  String ecPrivateKeyToString(pc.ECPrivateKey privateKey) {
    // The private key is the big integer 'd'.
    // Convert it to a hex string for storage.
    return privateKey.d!.toRadixString(16);
  }

  pc.ECPrivateKey ecPrivateKeyFromString(String hexStr) {
    // Convert the hex string back to a BigInt and reconstruct the private key.
    final d = BigInt.parse(hexStr, radix: 16);
    _domainParameters = pc.ECDomainParameters('secp256r1');
    return pc.ECPrivateKey(d, _domainParameters);
  }

  // --- ECDSA Signature Generation ---
  /// Signs a message using ECDSA with SHA-256
  /// Returns the signature as a base64-encoded string
  String? signMessage(String message) {
    logDebug(
        "@@@@@@@@@@@ signMessage called - isReady: $isReady, _isInitialized: $_isInitialized, _keyPair: ${_keyPair !=
            null}, _domainParameters: ${_domainParameters != null}");
    if (!isReady || _keyPair == null) {
      logDebug("Signing failed: Service not ready. isReady=$isReady, _keyPair=${_keyPair == null}");
      return null;
    }

    try {
      final signer = pc.ECDSASigner(pc.SHA256Digest());
      final privateKey = getPrivateKey()!;

      // Generate secure random for k value
      final secureRandom = pc.FortunaRandom();
      final random = Random.secure();
      final seed = List<int>.generate(32, (_) => random.nextInt(256));
      secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));

      signer.init(true, pc.ParametersWithRandom(
        pc.PrivateKeyParameter<pc.ECPrivateKey>(privateKey),
        secureRandom,
      ));

      final messageBytes = utf8.encode(message);
      final signature = signer.generateSignature(messageBytes) as pc
          .ECSignature;

      // Encode signature as DER format (standard for ECDSA)
      final signatureBytes = _encodeECDSASignature(signature);
      return base64Encode(signatureBytes);
    } catch (e) {
      logDebug("Signing error: $e");
      return null;
    }
  }

  // --- ECDSA Signature Verification ---
  /// Verifies a signature using ECDSA with SHA-256
  bool verifySignature(String message, String base64Signature,
      pc.ECPublicKey publicKey) {
    if (!isReady) {
      logDebug("Verification failed: Service not ready.");
      return false;
    }

    try {
      final signer = pc.ECDSASigner(pc.SHA256Digest());
      signer.init(false, pc.PublicKeyParameter<pc.ECPublicKey>(publicKey));

      final messageBytes = utf8.encode(message);
      final signatureBytes = base64Decode(base64Signature);
      final signature = _decodeECDSASignature(signatureBytes);

      return signer.verifySignature(messageBytes, signature);
    } catch (e) {
      logDebug("Verification error: $e");
      return false;
    }
  }

  // Helper to encode ECDSA signature to DER format
  Uint8List _encodeECDSASignature(pc.ECSignature signature) {
    // Simple DER encoding for ECDSA signature
    // SEQUENCE { r INTEGER, s INTEGER }
    final rBytes = _bigIntToUnsignedBytes(signature.r);
    final sBytes = _bigIntToUnsignedBytes(signature.s);

    final rLength = rBytes.length;
    final sLength = sBytes.length;

    final totalLength = 2 + rLength + 2 + sLength;
    final encoded = Uint8List(2 + totalLength);

    var index = 0;
    encoded[index++] = 0x30; // SEQUENCE tag
    encoded[index++] = totalLength;

    encoded[index++] = 0x02; // INTEGER tag for r
    encoded[index++] = rLength;
    encoded.setAll(index, rBytes);
    index += rLength;

    encoded[index++] = 0x02; // INTEGER tag for s
    encoded[index++] = sLength;
    encoded.setAll(index, sBytes);

    return encoded;
  }

  // Helper to decode ECDSA signature from DER format
  pc.ECSignature _decodeECDSASignature(Uint8List encoded) {
    var index = 0;

    // Skip SEQUENCE tag and length
    if (encoded[index++] != 0x30) throw FormatException(
        "Invalid DER signature: missing SEQUENCE tag");
    index++; // Skip total length

    // Read r
    if (encoded[index++] != 0x02) throw FormatException(
        "Invalid DER signature: missing INTEGER tag for r");
    final rLength = encoded[index++];
    final rBytes = encoded.sublist(index, index + rLength);
    index += rLength;

    // Read s
    if (encoded[index++] != 0x02) throw FormatException(
        "Invalid DER signature: missing INTEGER tag for s");
    final sLength = encoded[index++];
    final sBytes = encoded.sublist(index, index + sLength);

    final r = _bytesToBigInt(rBytes);
    final s = _bytesToBigInt(sBytes);

    return pc.ECSignature(r, s);
  }

  // Helper to convert BigInt to unsigned bytes (with padding if needed)
  Uint8List _bigIntToUnsignedBytes(BigInt number) {
    final hex = number.toRadixString(16);
    final paddedHex = hex.length.isOdd ? '0$hex' : hex;
    final bytes = Uint8List(paddedHex.length ~/ 2);

    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(paddedHex.substring(i * 2, i * 2 + 2), radix: 16);
    }

    // Add padding byte if high bit is set (to ensure positive integer in DER)
    if (bytes[0] >= 0x80) {
      final padded = Uint8List(bytes.length + 1);
      padded[0] = 0x00;
      padded.setAll(1, bytes);
      return padded;
    }

    return bytes;
  }

  // Helper to convert bytes to BigInt
  BigInt _bytesToBigInt(Uint8List bytes) {
    BigInt result = BigInt.zero;
    for (var byte in bytes) {
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }

  // --- File Encryption/Decryption Methods ---

  /// Encrypt bytes (for file encryption)
  /// Returns encrypted bytes with salt and IV prepended
  Future<Uint8List> encryptBytes(Uint8List plainBytes,
      String recipientPublicKeyString) async {
    if (!isReady) {
      throw Exception("Encryption failed: Service not ready");
    }

    final recipientPublicKey = ecPublicKeyFromString(recipientPublicKeyString);
    if (recipientPublicKey == null) {
      throw Exception("Invalid recipient public key");
    }

    logDebug("@@@@@@@@@@@ Encrypting ${plainBytes.length} bytes");
    final sharedSecret = _deriveSharedSecret(
        getPrivateKey()!, recipientPublicKey);
    if (sharedSecret == null) {
      throw Exception("Could not derive shared secret");
    }

    // Generate random salt and IV
    final secureRandom = pc.FortunaRandom()
      ..seed(pc.KeyParameter(
          Uint8List.fromList(
              List<int>.generate(32, (_) => Random.secure().nextInt(256)))));

    final salt = secureRandom.nextBytes(SALT_LENGTH_BYTES);
    final symmetricKey = _deriveSymmetricKey(sharedSecret, salt);
    final iv = secureRandom.nextBytes(IV_LENGTH_BYTES);

    try {
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      cipher.init(true, pc.AEADParameters(
          pc.KeyParameter(symmetricKey), TAG_LENGTH_BITS, iv, Uint8List(0)));

      final encryptedBytes = cipher.process(plainBytes);

      // Prepend salt and IV: [ Salt (16 bytes) | IV (12 bytes) | Ciphertext ]
      final payloadWithSaltAndIv = Uint8List(
          salt.length + iv.length + encryptedBytes.length);
      payloadWithSaltAndIv.setAll(0, salt);
      payloadWithSaltAndIv.setAll(salt.length, iv);
      payloadWithSaltAndIv.setAll(salt.length + iv.length, encryptedBytes);

      logDebug("@@@@@@@@@@@ Encrypted to ${payloadWithSaltAndIv.length} bytes");
      return payloadWithSaltAndIv;
    } catch (e) {
      logDebug("AES-GCM bytes encryption error: $e");
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypt bytes (for file decryption)
  /// Expects encrypted bytes with salt and IV prepended
  Future<Uint8List> decryptBytes(Uint8List encryptedPayload,
      String senderPublicKeyString) async {
    if (!isReady) {
      throw Exception("Decryption failed: Service not ready");
    }

    final senderPublicKey = ecPublicKeyFromString(senderPublicKeyString);
    if (senderPublicKey == null) {
      throw Exception("Invalid sender public key");
    }

    logDebug("@@@@@@@@@@@ Decrypting ${encryptedPayload.length} bytes");
    final sharedSecret = _deriveSharedSecret(getPrivateKey()!, senderPublicKey);
    if (sharedSecret == null) {
      throw Exception("Could not derive shared secret");
    }

    try {
      if (encryptedPayload.length < SALT_LENGTH_BYTES + IV_LENGTH_BYTES) {
        throw Exception("Payload too short to contain salt and IV");
      }

      // Extract salt, IV, and ciphertext
      final salt = encryptedPayload.sublist(0, SALT_LENGTH_BYTES);
      final iv = encryptedPayload.sublist(
          SALT_LENGTH_BYTES, SALT_LENGTH_BYTES + IV_LENGTH_BYTES);
      final encryptedBytes = encryptedPayload.sublist(
          SALT_LENGTH_BYTES + IV_LENGTH_BYTES);

      // Re-derive the key using the extracted salt
      final symmetricKey = _deriveSymmetricKey(sharedSecret, salt);

      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      cipher.init(false, pc.AEADParameters(
          pc.KeyParameter(symmetricKey), TAG_LENGTH_BITS, iv, Uint8List(0)));

      final decryptedBytes = cipher.process(encryptedBytes);
      logDebug("@@@@@@@@@@@ Decrypted to ${decryptedBytes.length} bytes");
      return decryptedBytes;
    } on pc.InvalidCipherTextException {
      logDebug("Decryption failed: Ciphertext authentication failed");
      throw Exception("Decryption failed: Authentication failed");
    } catch (e) {
      logDebug("AES-GCM bytes decryption error: $e");
      throw Exception("Decryption failed: $e");
    }
  }

  /// Dispose of the CryptoService and clear all sensitive data
  /// This resets the singleton instance and clears keys from memory
  void dispose() {
    logDebug("@@@@@@@@@@@ Disposing CryptoService instance");

    // Clear sensitive data from memory
    _keyPair = null;
    _domainParameters = null;
    _isInitialized = false;

    // Clear singleton instance
    _instance = null;

    logDebug("@@@@@@@@@@@ CryptoService disposed successfully");
  }

  /// Static method to dispose the singleton instance
  Future<void> disposeSingleton() async {
    if (_instance != null) {
      await secureStorage.saveOwnPrivateKey("");
      await secureStorage.saveOwnPublicKey("");
      _instance!.dispose();
    }
  }

  /// Static method to clear singleton without async (for atomic reset operations)
  static void disposeSingletonStatic() {
    if (_instance != null) {
      _instance!.dispose();
    }
    _creatingInstance = null;
    logDebug("@@@@@@@@@@@ CryptoService singleton statically cleared");
  }

}