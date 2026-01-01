import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class SecurityUtils {
  // --- PBKDF2 Configuration ---
  static const int _iterations = 100000;
  static const int _saltLength = 16; // 16 bytes is a good default
  static const int _keyLength = 32; // 32 bytes for SHA-256

  /// Generates a secure random salt.
  static Uint8List _generateSalt() {
    final random = Random.secure();
    final salt = Uint8List(_saltLength);
    for (int i = 0; i < salt.length; i++) {
      salt[i] = random.nextInt(256);
    }
    return salt;
  }

  /// Hashes a password using PBKDF2 with SHA-256.
  /// The output format is: "pbkdf2-sha256:iterations:salt_in_base64:hash_in_base64"
  static String hashText(String text) {
    // 1. Generate a random salt
    final salt = _generateSalt();

    // 2. Set up the PBKDF2 key derivator with HMAC-SHA256
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, _iterations, _keyLength));

    // 3. Hash the text
    final key = pbkdf2.process(Uint8List.fromList(utf8.encode(text)));

    // 4. Encode salt and key to Base64
    final saltBase64 = base64.encode(salt);
    final keyBase64 = base64.encode(key);

    // 5. Return in a standard, parsable format
    return "pbkdf2-sha256:$_iterations:$saltBase64:$keyBase64";
  }

  /// Verifies a plain text password against a stored PBKDF2 hash string.
  static bool verifyHash(String plainText, String storedHash) {
    try {
      // 1. Parse the stored hash string
      final parts = storedHash.split(':');
      if (parts.length != 4 || parts[0] != 'pbkdf2-sha256') {
        throw ArgumentError('Invalid stored hash format.');
      }

      final iterations = int.parse(parts[1]);
      final salt = base64.decode(parts[2]);
      final storedKey = base64.decode(parts[3]);

      // 2. Re-hash the provided plainText with the same parameters
      final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
      pbkdf2.init(Pbkdf2Parameters(salt, iterations, storedKey.length));
      final newKey = pbkdf2.process(Uint8List.fromList(utf8.encode(plainText)));

      // 3. Compare the hashes in constant time to prevent timing attacks
      if (newKey.length != storedKey.length) {
        return false;
      }

      var diff = 0;
      for (int i = 0; i < newKey.length; i++) {
        diff |= newKey[i] ^ storedKey[i];
      }
      return diff == 0;

    } catch (e) {
      // If any error occurs during parsing or decoding, it's not a match.
      print('Error verifying hash: $e');
      return false;
    }
  }
}
