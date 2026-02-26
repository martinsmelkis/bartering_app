import 'dart:convert';
import 'dart:math';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/utils/debug_utils.dart';
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
  static const _contactPublicKeyPrefix = 'contact_pubkey_';
  static const _federatedIdMappingPrefix = 'federated_mapping_';
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
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) =>
          ParsedAttributeData.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      logDebugError('Error parsing interests attributes: $e');
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
      logDebugError('Error parsing offerings attributes: $e');
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
      logDebugError('Error parsing profile keyword data map: $e');
      return null;
    }
  }

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
  }

  // --- Generic Storage Operations ---

  /// Writes a value directly to secure storage
  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Reads a value directly from secure storage
  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  /// Deletes a value from secure storage
  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  // --- Contact Public Key Management ---

  /// Saves a contact's public key for persistent storage
  /// This allows the app to remember encryption keys across sessions
  /// For federated users, stores mapping from normalized to original ID
  Future<void> saveContactPublicKey(String userId, String publicKey) async {
    // For federated users, store mapping from normalized -> original
    final normalizedId = _normalizeUserId(userId);
    if (normalizedId != userId) {
      await _secureStorage.write(
        key: '$_federatedIdMappingPrefix$normalizedId',
        value: userId, // Store original federated ID
      );
    }
    
    // Save key with original ID
    await _secureStorage.write(
      key: '$_contactPublicKeyPrefix$userId',
      value: publicKey,
    );
  }

  /// Retrieves a contact's public key from persistent storage
  /// For federated users, looks up the original ID first using the mapping
  Future<String?> getContactPublicKey(String userId) async {
    // Try direct lookup first
    final key = await _secureStorage.read(key: '$_contactPublicKeyPrefix$userId');
    if (key != null) {
      return key;
    }
    
    // Check if this is a federated ID (has @) - try finding key directly
    if (userId.contains('@')) {
      return null; // No key stored for this federated user
    }
    
    // Check if there's a mapping for a federated version of this user
    final federatedId = await _secureStorage.read(
      key: '$_federatedIdMappingPrefix$userId'
    );
    
    if (federatedId != null) {
      // Look up key using the original federated ID
      final key = await _secureStorage.read(
        key: '$_contactPublicKeyPrefix$federatedId'
      );
      if (key != null) {
        return key;
      }
    }
    
    // FALLBACK: Try to find any key that starts with this userId (for pre-fix keys)
    // Read all keys and find one matching contact_pubkey_{userId}@
    try {
      final allKeys = await _secureStorage.readAll();
      for (final entry in allKeys.entries) {
        if (entry.key.startsWith('$_contactPublicKeyPrefix$userId@')) {
          // Found a federated key matching this normalized userId
          return entry.value;
        }
      }
    } catch (e) {
      logDebug('⚠️ Error reading secure storage keys: $e');
    }
    
    return null;
  }

  /// Normalize federated user ID by removing server suffix
  /// e.g., "userId@serverId" -> "userId"
  String _normalizeUserId(String userId) {
    final atIndex = userId.indexOf('@');
    if (atIndex != -1) {
      return userId.substring(0, atIndex);
    }
    return userId;
  }

  /// Gets the federated ID for a normalized user ID
  /// Returns null if no mapping exists
  Future<String?> getFederatedId(String normalizedUserId) async {
    return await _secureStorage.read(
      key: '$_federatedIdMappingPrefix$normalizedUserId'
    );
  }
  
  /// Saves just the federated ID mapping without a public key
  /// This is used when we receive a federated message but don't have the key yet
  Future<void> saveFederatedIdMapping(String federatedUserId) async {
    final normalizedId = _normalizeUserId(federatedUserId);
    if (normalizedId != federatedUserId) {
      await _secureStorage.write(
        key: '$_federatedIdMappingPrefix$normalizedId',
        value: federatedUserId,
      );
      logDebug('🌐 Saved federated mapping: $normalizedId -> $federatedUserId');
    }
  }
  
  /// Also removes the federated ID mapping if present
  Future<void> deleteContactPublicKey(String userId) async {
    // Delete with original ID
    await _secureStorage.delete(key: '$_contactPublicKeyPrefix$userId');
    
    // Delete any mapping for normalized ID
    final normalizedId = _normalizeUserId(userId);
    if (normalizedId != userId) {
      await _secureStorage.delete(key: '$_federatedIdMappingPrefix$normalizedId');
    } else {
      // This is a normalized ID - try to find and delete the mapping too
      await _secureStorage.delete(key: '$_federatedIdMappingPrefix$userId');
    }
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
