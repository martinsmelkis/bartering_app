import 'dart:convert';
import 'dart:math';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/services.dart';
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
  static const _suggestedInterestsKey = '124669gfyfdrjI'; // Server-suggested interests
  static const _suggestedOfferingsKey = '124670gfyfdrjJ'; // Server-suggested offerings
  static const _contactPublicKeyPrefix = 'contact_pubkey_';
  static const _federatedIdMappingPrefix = 'federated_mapping_';
  static const _securityQuestionKey = 'security_question';
  static const _securityAnswerKey = 'security_answer_hash';

  /// Safely reads from secure storage, handling keystore errors
  /// Returns null if key not found or keystore error occurs
  Future<String?> _safeRead(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } on PlatformException catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('key_not_found') ||
          errorStr.contains('badpaddingexception') ||
          errorStr.contains('bad_decrypt') ||
          (e.code?.toLowerCase() == 'read' && e.message == null)) {
        logDebug('Keystore error reading key $key - key may be invalidated. Returning null.');
        return null;
      }
      rethrow;
    }
  }

  Future<String> getDatabasePassword() async {
    var password = await _safeRead(_dbPasswordKey);
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
    return await _safeRead(_ownPublicKeyKey);
  }

  Future<void> saveOwnPrivateKey(String publicKey) async {
    await _secureStorage.write(key: _ownPrivateKeyKey, value: publicKey);
  }

  Future<String?> getOwnPrivateKey() async {
    return await _safeRead(_ownPrivateKeyKey);
  }

  Future<void> saveOwnUserId(String userId) async {
    await _secureStorage.write(key: _ownUserIdKey, value: userId);
  }

  Future<String?> getOwnUserId() async {
    final key = await _safeRead(_ownUserIdKey);
    return key;
  }

  Future<void> setOwnUserName(String userName) async {
    await _secureStorage.write(key: _ownUserNameKey, value: userName);
  }

  Future<String?> getOwnUserName() async {
    final key = await _safeRead(_ownUserNameKey);
    return key;
  }

  Future<void> saveOwnLocation(String publicKey) async {
    await _secureStorage.write(key: _ownLocationKey, value: publicKey);
  }

  Future<String?> getOwnLocation() async {
    return await _safeRead(_ownLocationKey);
  }

  Future<void> savePIN(String hashedPin) async {
    await _secureStorage.write(key: _pinKey, value: hashedPin);
  }

  Future<String?> getPIN(String hashedPin) async {
    return await _safeRead(_pinKey);
  }

  /// Saves interests with full metadata (attribute, relevancy, uiStyleHint)
  Future<void> saveOwnInterestsAttributes(
      List<ParsedAttributeData> interests) async {
    final jsonList = interests.map((e) => e.toJson()).toList();
    await _secureStorage.write(key: _interestsKey, value: jsonEncode(jsonList));
  }

  /// Retrieves interests with full metadata
  Future<List<ParsedAttributeData>?> getOwnInterestsAttributes() async {
    final jsonString = await _safeRead(_interestsKey);
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
    final jsonString = await _safeRead(_offeringsKey);
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
    final jsonString = await _safeRead(_profileKeywordDataMapKey);
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

  /// Saves server-suggested interests for quick search suggestions
  Future<void> saveSuggestedInterests(List<ParsedAttributeData> suggestions) async {
    final List<Map<String, dynamic>> jsonList = suggestions.map((attr) => {
      'attributeKey': attr.attributeKey,
      'attribute': attr.attribute,
      'relevancyScore': attr.relevancyScore,
      'uiStyleHint': attr.uiStyleHint,
    }).toList();
    await _secureStorage.write(
      key: _suggestedInterestsKey,
      value: jsonEncode(jsonList),
    );
  }

  /// Retrieves server-suggested interests
  Future<List<ParsedAttributeData>?> getSuggestedInterests() async {
    final jsonString = await _safeRead(_suggestedInterestsKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ParsedAttributeData(
        attributeKey: json['attributeKey'] as String?,
        attribute: json['attribute'] as String,
        relevancyScore: (json['relevancyScore'] as num).toDouble(),
        uiStyleHint: json['uiStyleHint'] as String,
      )).toList();
    } catch (e) {
      logDebugError('Error parsing suggested interests: $e');
      return null;
    }
  }

  /// Saves server-suggested offerings for quick search suggestions
  Future<void> saveSuggestedOfferings(List<ParsedAttributeData> suggestions) async {
    final List<Map<String, dynamic>> jsonList = suggestions.map((attr) => {
      'attributeKey': attr.attributeKey,
      'attribute': attr.attribute,
      'relevancyScore': attr.relevancyScore,
      'uiStyleHint': attr.uiStyleHint,
    }).toList();
    await _secureStorage.write(
      key: _suggestedOfferingsKey,
      value: jsonEncode(jsonList),
    );
  }

  /// Retrieves server-suggested offerings
  Future<List<ParsedAttributeData>?> getSuggestedOfferings() async {
    final jsonString = await _safeRead(_suggestedOfferingsKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ParsedAttributeData(
        attributeKey: json['attributeKey'] as String?,
        attribute: json['attribute'] as String,
        relevancyScore: (json['relevancyScore'] as num).toDouble(),
        uiStyleHint: json['uiStyleHint'] as String,
      )).toList();
    } catch (e) {
      logDebugError('Error parsing suggested offerings: $e');
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
    return await _safeRead(key);
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
    final key = await _safeRead('$_contactPublicKeyPrefix$userId');
    if (key != null) {
      return key;
    }
    
    // Check if this is a federated ID (has @) - try finding key directly
    if (userId.contains('@')) {
      return null; // No key stored for this federated user
    }
    
    // Check if there's a mapping for a federated version of this user
    final federatedId = await _safeRead(
      '$_federatedIdMappingPrefix$userId'
    );
    
    if (federatedId != null) {
      // Look up key using the original federated ID
      final key = await _safeRead(
        '$_contactPublicKeyPrefix$federatedId'
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
    return await _safeRead('$_federatedIdMappingPrefix$normalizedUserId');
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
    return await _safeRead(_securityQuestionKey);
  }

  /// Save security answer (hashed)
  Future<void> saveSecurityAnswer(String hashedAnswer) async {
    await _secureStorage.write(key: _securityAnswerKey, value: hashedAnswer);
  }

  /// Get security answer (hashed)
  Future<String?> getSecurityAnswer() async {
    return await _safeRead(_securityAnswerKey);
  }

  /// Check if security question is set up
  Future<bool> hasSecurityQuestion() async {
    final question = await getSecurityQuestion();
    final answer = await getSecurityAnswer();
    return question != null && answer != null;
  }

}
