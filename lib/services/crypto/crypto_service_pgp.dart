import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openpgp/openpgp.dart';

class CryptoServicePgp {
  // Store the armored representations of the keys
  String? _userPrivateKeyArmored;
  String? userPublicKey;
  String? recipientPublicKey;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _privateKeyStorageKey = 'pgp_user_private_key_armored_flutter_openpgp_v1';
  final String _publicKeyStorageKey = 'pgp_user_public_key_armored_flutter_openpgp_v1';

  bool get isInitialized => _userPrivateKeyArmored != null && userPublicKey != null;

  // --- Initialization and Key Management ---
  Future<bool> initialize({
    String name = 'User', // Example uses name/email in PGP user ID
    String email = 'user@example.com',
    String passphrase = 'test_very_strong_password',
  }) async {
    try {
      _userPrivateKeyArmored = await _secureStorage.read(key: _privateKeyStorageKey);
      userPublicKey = await _secureStorage.read(key: _publicKeyStorageKey);

      debugPrint("@@@@@@@@ public key ${userPublicKey}");

      if (_userPrivateKeyArmored != null && userPublicKey != null) {
        print("User PGP keys loaded from storage.");
        // We can try to get the KeyPairEntity to "validate" the key with the passphrase
        try {
          // NOTE: get from flutter_secure_storage ?
          /*
          KeyPair keyPair = await OpenPGP.getKeyPair(KeyOptions(
            privateKey: armoredPrivateKey,
            passphrase: passphrase,
          ));
           */
          //await PGPKeyHelper.getKeyPair(_userPrivateKeyArmored!, passphrase);
          print("Stored private key seems valid with the provided passphrase (or no passphrase if not set).");
        } catch (e) {
          print("Warning: Could not validate stored private key with passphrase: $e. Key might be corrupt or passphrase incorrect if it was set during generation.");
          // Depending on policy, you might want to clear keys or re-generate here.
          // For now, we'll assume the loaded armored strings are what we'll try to use.
        }
      } else {
        print("No stored PGP keys found. Generating new key pair...");
        // It takes name, email, and passphrase.
        // The options like rsaBits or curve are often defaults in such helpers or set elsewhere.
        // You might need to check PGPKeyHelper.generate or underlying OpenPGP settings
        // if you need specific key types (RSA vs ECC) or strengths.
        // For this example, we assume default generation parameters.
        KeyPair keyPairEntity = await generateKeyPair();

        _userPrivateKeyArmored = keyPairEntity.privateKey;
        userPublicKey = keyPairEntity.publicKey;

        await _secureStorage.write(key: _privateKeyStorageKey, value: _userPrivateKeyArmored);
        await _secureStorage.write(key: _publicKeyStorageKey, value: userPublicKey);
        print("New User PGP key pair generated and stored.");
      }
      return isInitialized;
    } catch (e) {
      print("Error during PGP initialization: $e");
      _userPrivateKeyArmored = null;
      userPublicKey = null;
      return false;
    }
  }
  
  Future<KeyPair> generateKeyPair() async {
    var keyOptions = KeyOptions()
    ..rsaBits = 2048
    ..algorithm = Algorithm.EDDSA;
    return await OpenPGP.generate(
    options: Options()
    ..name = 'test'
    ..email = 'test@test.com'
    //..passphrase = ''
    ..keyOptions = keyOptions);
  }

   Future<String?> getMyPublicKeyArmored() async {
    if (!isInitialized) {
      print("Error: CryptoServicePgp not initialized.");
      return null;
    }
    return userPublicKey;
  }

  Future<void> clearStoredKeys() async {
    await _secureStorage.delete(key: _privateKeyStorageKey);
    await _secureStorage.delete(key: _publicKeyStorageKey);
    _userPrivateKeyArmored = null;
    userPublicKey = null;
    print("Stored PGP keys cleared.");
  }

  // --- Encryption ---
  Future<String?> encrypt(
      String plainText, {
        String? userPassphrase, // Passphrase for current user's private key (for signing)
      }) async {
    if (!isInitialized) {
      print("Error: CryptoServicePgp not initialized for encryption.");
      return null;
    }
    if (_userPrivateKeyArmored == null) {
      print("Error: User private key not available for signing.");
      return null;
    }

    try {
      // The encrypt method takes armored keys directly.
      // Signing is done by providing the signer's private key and passphrase.
      print('"@@@@@@@@@@@@@ pgp key of recipient ${recipientPublicKey}');
      String encryptedMessage = await OpenPGP.encrypt(
        plainText,
        recipientPublicKey ?? "",
        //signed: new Entity()..publicKey = userPublicKey..privateKey = _userPrivateKeyArmored..passphrase = null,
      );
      return encryptedMessage; // This is already the armored encrypted string
    } catch (e) {
      debugPrintStack();
      print("PGP Encryption error: $e");
      return null;
    }
  }

  // --- Decryption ---
  Future<String?> decrypt(
      String armoredEncryptedMessage, {
        String? senderPublicKeyArmored, // For signature verification
        String? userPassphrase, // Passphrase for current user's private key (for decryption)
      }) async {
    if (_userPrivateKeyArmored == null) {
      print("Error: CryptoServicePgp (User's private key) not initialized for decryption.");
      return null;
    }
    debugPrint('@@@@@@@@@@@@@ pgp key original ${_userPrivateKeyArmored}');

    print('@@@@@@@@@@@ message ${armoredEncryptedMessage}');

    //try {
      // The decrypt method handles both decryption and signature verification.
      String decryptedResult = await OpenPGP.decrypt(
        armoredEncryptedMessage,
        _userPrivateKeyArmored!, // Decrypt with our key
        userPassphrase ?? "",    // Passphrase for our private key. API might expect empty string if no passphrase.
      );

      String decryptedResultArmored = await OpenPGP.armorEncode("PGP MESSAGE",
          Uint8List.fromList(decryptedResult.codeUnits));

      ArmorMetadata decryptedResultA = await OpenPGP.armorDecode(decryptedResultArmored);
      String plainText = utf8.decode(decryptedResultA.body, allowMalformed: true);
      debugPrint('@@@@@@@@@@@ decryptedResultA ${base64Encode(decryptedResultA.body)} \n\n ${plainText}');

      decryptedResult = await OpenPGP.decrypt(
        plainText,
        _userPrivateKeyArmored!, // Decrypt with our key
        userPassphrase ?? "",    // Passphrase for our private key. API might expect empty string if no passphrase.
      );

      return decryptedResult; // This should be the plaintext string
    //} catch (e) {
      //print("PGP Decryption error: $e");
      // The library might throw specific exceptions for incorrect passphrases or other issues.
      // e.g. if (e.toString().toLowerCase().contains("incorrect passphrase")) { ... }
      //return null;
    //}
  }

  Future<Uint8List?> decryptBytes(
      Uint8List armoredEncryptedMessage, {
        String? senderPublicKeyArmored, // For signature verification
        String? userPassphrase, // Passphrase for current user's private key (for decryption)
      }) async {
    if (_userPrivateKeyArmored == null) {
      print("Error: CryptoServicePgp (User's private key) not initialized for decryption.");
      return null;
    }

    try {
      // The decrypt method handles both decryption and signature verification.
      Uint8List decryptedResult = await OpenPGP.decryptBytes(
        armoredEncryptedMessage,
        _userPrivateKeyArmored!, // Decrypt with our key
        userPassphrase ?? "",    // Passphrase for our private key. API might expect empty string if no passphrase.
      );

      return decryptedResult; // This should be the plaintext string
    } catch (e) {
      print("PGP Decryption error: $e");
      // The library might throw specific exceptions for incorrect passphrases or other issues.
      // e.g. if (e.toString().toLowerCase().contains("incorrect passphrase")) { ... }
      return null;
    }
  }
}