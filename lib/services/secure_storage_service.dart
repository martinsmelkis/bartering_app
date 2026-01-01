import 'dart:convert';
import 'dart:math';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _secureStorage = const FlutterSecureStorage();

  static const _ownPrivateKeyKey = '4554JUiugjdf';
  static const _ownPublicKeyKey = '4554HHiugjdf';
  static const _ownUserIdKey = '4545634gfyrjH';
  static const _ownUserNameKey = '9945634gfyrjH';
  static const _ownLocationKey = '4543344gfyrjH';
  static const _dbPasswordKey = 'databasePasswordKey';
  static const _pinKey = '4545384gfyrjH';
  static const _interestsKey = '1243344gfyfdrjH';
  static const _offeringsKey = '124667gfyfdrjH';
  static const _profileKeywordDataMapKey = '124668gfyfdrjH';
  static const _contactPublicKeyPrefix =
      'contact_pubkey_'; // Prefix for contact public keys
  static const _securityQuestionKey = 'security_question';
  static const _securityAnswerKey = 'security_answer_hash';

  Future<String> getDatabasePassword() async {
    var password = await _secureStorage.read(key: _dbPasswordKey);
    if (password == null) {
      final random = Random.secure();
      final passwordBytes = List<int>.generate(32, (_) => random.nextInt(256));
      password = base64Url.encode(passwordBytes);
      await _secureStorage.write(key: _dbPasswordKey, value: password);
    }
    return password;
  }

  // TODO save string, use pkcs12?
  // https://dev-crypto.bouncycastle.narkive.com/mTDBPlpx/save-ec-public-private-keys-to-database-for-reuse
  Future<void> saveOwnPublicKey(String publicKey) async {
    await _secureStorage.write(key: _ownPublicKeyKey, value: publicKey);
  }

  Future<String?> getOwnPublicKey() async {
    return await _secureStorage.read(key: _ownPublicKeyKey);
  }

  Future<void> saveOwnPrivateKey(String publicKey) async {
    await _secureStorage.write(key: _ownPrivateKeyKey, value: publicKey);
  }

  Future<String?> getOwnPrivateKey() async {
    return await _secureStorage.read(key: _ownPrivateKeyKey);
  }

  Future<void> saveOwnUserId(String userId) async {
    await _secureStorage.write(key: _ownUserIdKey, value: userId);
  }

  Future<String?> getOwnUserId() async {
    final key = await _secureStorage.read(key: _ownUserIdKey);
    return key;
  }

  Future<void> setOwnUserName(String userName) async {
    await _secureStorage.write(key: _ownUserNameKey, value: userName);
  }

  Future<String?> getOwnUserName() async {
    final key = await _secureStorage.read(key: _ownUserNameKey);
    return key;
  }

  Future<void> saveOwnLocation(String publicKey) async {
    await _secureStorage.write(key: _ownLocationKey, value: publicKey);
  }

  Future<String?> getOwnLocation() async {
    return await _secureStorage.read(key: _ownLocationKey);
  }

  Future<void> savePIN(String hashedPin) async {
    await _secureStorage.write(key: _pinKey, value: hashedPin);
  }

  Future<String?> getPIN(String hashedPin) async {
    return await _secureStorage.read(key: _pinKey);
  }

  /// Saves interests with full metadata (attribute, relevancy, uiStyleHint)
  Future<void> saveOwnInterestsAttributes(
      List<ParsedAttributeData> interests) async {
    final jsonList = interests.map((e) => e.toJson()).toList();
    await _secureStorage.write(key: _interestsKey, value: jsonEncode(jsonList));
  }

  /// Retrieves interests with full metadata
  Future<List<ParsedAttributeData>?> getOwnInterestsAttributes() async {
    final jsonString = await _secureStorage.read(key: _interestsKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      print('@@@@@@@@@@ jsonString: $jsonString');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) =>
          ParsedAttributeData.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error parsing interests attributes: $e');
      return null;
    }
  }

  /// Saves offerings with full metadata (attribute, relevancy, uiStyleHint)
  Future<void> saveOwnOfferingsAttributes(
      List<ParsedAttributeData> offerings) async {
    final jsonList = offerings.map((e) => e.toJson()).toList();
    await _secureStorage.write(key: _offeringsKey, value: jsonEncode(jsonList));
  }

  /// Retrieves offerings with full metadata
  Future<List<ParsedAttributeData>?> getOwnOfferingsAttributes() async {
    final jsonString = await _secureStorage.read(key: _offeringsKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) =>
          ParsedAttributeData.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error parsing offerings attributes: $e');
      return null;
    }
  }

  /// Saves profile keyword data map (keyword -> relevancy score)
  Future<void> saveProfileKeywordDataMap(
      Map<String, double> keywordDataMap) async {
    await _secureStorage.write(
      key: _profileKeywordDataMapKey,
      value: jsonEncode(keywordDataMap),
    );
  }

  /// Retrieves profile keyword data map
  Future<Map<String, double>?> getProfileKeywordDataMap() async {
    final jsonString = await _secureStorage.read(
        key: _profileKeywordDataMapKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      // Convert dynamic values to double
      return jsonMap.map((key, value) =>
          MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      print('Error parsing profile keyword data map: $e');
      return null;
    }
  }

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
  }

  // --- Contact Public Key Management ---

  /// Saves a contact's public key for persistent storage
  /// This allows the app to remember encryption keys across sessions
  Future<void> saveContactPublicKey(String userId, String publicKey) async {
    await _secureStorage.write(
      key: '$_contactPublicKeyPrefix$userId',
      value: publicKey,
    );
  }

  /// Retrieves a contact's public key from persistent storage
  Future<String?> getContactPublicKey(String userId) async {
    return await _secureStorage.read(key: '$_contactPublicKeyPrefix$userId');
  }

  /// Removes a contact's public key from storage
  Future<void> deleteContactPublicKey(String userId) async {
    await _secureStorage.delete(key: '$_contactPublicKeyPrefix$userId');
  }

  // --- Security Question Management ---

  /// Save security question
  Future<void> saveSecurityQuestion(String question) async {
    await _secureStorage.write(key: _securityQuestionKey, value: question);
  }

  /// Get security question
  Future<String?> getSecurityQuestion() async {
    return await _secureStorage.read(key: _securityQuestionKey);
  }

  /// Save security answer (hashed)
  Future<void> saveSecurityAnswer(String hashedAnswer) async {
    await _secureStorage.write(key: _securityAnswerKey, value: hashedAnswer);
  }

  /// Get security answer (hashed)
  Future<String?> getSecurityAnswer() async {
    return await _secureStorage.read(key: _securityAnswerKey);
  }

  /// Check if security question is set up
  Future<bool> hasSecurityQuestion() async {
    final question = await getSecurityQuestion();
    final answer = await getSecurityAnswer();
    return question != null && answer != null;
  }

}
