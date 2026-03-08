import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class UserRepository {
  final SecureStorageService _secureStorageService;

  // Public properties to act as an in-memory cache
  String? userId;
  String? userName;
  String? publicKey;
  String? email;
  String? userLocation;
  Map<String, double>? profileKeywordDataMap;
  List<ParsedAttributeData>? userInterests;
  List<ParsedAttributeData>? userOfferings;

  UserRepository(this._secureStorageService);

  Future<List<ParsedAttributeData>?> getInterests({bool loadFromStorage = false}) async {
    return loadFromStorage ? await _secureStorageService.getOwnInterestsAttributes()
        : userInterests ?? await _secureStorageService.getOwnInterestsAttributes();
  }

  Future<List<ParsedAttributeData>?> getOfferings({bool loadFromStorage = false}) async {
    return loadFromStorage ? await _secureStorageService.getOwnOfferingsAttributes()
        : userOfferings ?? await _secureStorageService.getOwnOfferingsAttributes();
  }

  Future<Map<String, double>?> getProfileKeywordDataMap() async {
    return profileKeywordDataMap ??
        await _secureStorageService.getProfileKeywordDataMap();
  }

  /// Gets just the attribute keys as strings (for matching/communication purposes)
  /// Use this for API calls and matching, NOT for display (use localization instead)
  /// Backward compatible: derives keys from attributes for old stored data
  Future<List<String>> getInterestKeys() async {
    final interests = await getInterests();
    return interests?.map((e) => e.effectiveAttributeKey).toList() ?? [];
  }

  /// Gets just the offering keys as strings (for matching/communication purposes)
  /// Use this for API calls and matching, NOT for display (use localization instead)
  /// Backward compatible: derives keys from attributes for old stored data
  Future<List<String>> getOfferingKeys() async {
    final offerings = await getOfferings();
    return offerings?.map((e) => e.effectiveAttributeKey).toList() ?? [];
  }

  /// Gets just the attribute names as strings (for display purposes, localized)
  /// @deprecated Use getInterestKeys() for matching and localize for display instead
  Future<List<String>> getInterestNames() async {
    final interests = await getInterests();
    return interests?.map((e) => e.attribute).toList() ?? [];
  }

  /// Gets just the offering names as strings (for display purposes, localized)
  /// @deprecated Use getOfferingKeys() for matching and localize for display instead
  Future<List<String>> getOfferingNames() async {
    final offerings = await getOfferings();
    return offerings?.map((e) => e.attribute).toList() ?? [];
  }

  Map<String, double>? get getProfileKeywordData => profileKeywordDataMap;

  set interests(List<ParsedAttributeData> interests) {
    userInterests = interests;
    _secureStorageService.saveOwnInterestsAttributes(interests);
  }

  set offerings(List<ParsedAttributeData> offerings) {
    userOfferings = offerings;
    _secureStorageService.saveOwnOfferingsAttributes(offerings);
  }

  set profileKeywordData(Map<String, double> data) {
    profileKeywordDataMap = data;
    _secureStorageService.saveProfileKeywordDataMap(data);
  }

  Future<void> saveProfileKeywordDataMap(Map<String, double> data) async {
    profileKeywordDataMap = data;
    await _secureStorageService.saveProfileKeywordDataMap(data);
  }

  double get latitude => userLocation?.isNotEmpty == true ?
    double.tryParse(userLocation?.split(',')[0] ?? "") ?? 0.0 : 0.0;
  double get longitude => userLocation?.isNotEmpty == true ?
    double.tryParse(userLocation?.split(',')[1] ?? "") ?? 0.0 : 0.0;

  Future<String?> getUserId() async {
    if (userId == null) {
      logDebug('🔄 UserRepository: Loading userId from storage');
      userId = await _secureStorageService.getOwnUserId();
      logDebug('✅ UserRepository: Loaded userId: $userId');
    } else {
      // Verify cached value matches storage (in case of migration)
      final storedUserId = await _secureStorageService.getOwnUserId();
      if (storedUserId != userId) {
        logDebug('⚠️ UserRepository: Cache mismatch! Cached: $userId, Stored: $storedUserId');
        logDebug('🔄 UserRepository: Updating to stored value');
        userId = storedUserId;
      }
      logDebug('📦 UserRepository: Using cached userId: $userId');
    }
    return userId;
  }

  Future<String?> getUserName() async {
    userName = userName ?? await _secureStorageService.getOwnUserName();
    return userName;
  }

  Future<void> setUserName(String userName) async {
    this.userName = userName;
    await _secureStorageService.setOwnUserName(userName);
  }

  Future<String?> getPublicKey() async {
    publicKey ?? await _secureStorageService.getOwnPublicKey();
    return publicKey;
  }

  Future<String?> getPrivateKey() async {
    return await _secureStorageService.getOwnPrivateKey();
  }

  /// Initializes the repository by loading all necessary user data from storage.
  Future<void> init() async {
    // Load or create the user ID
    userId = userId ?? await _secureStorageService.getOwnUserId();
    if (userId == null || userId?.isEmpty == true) {
      userId = const Uuid().v4().toString();
      await _secureStorageService.saveOwnUserId(userId!);
    }

    publicKey = await _secureStorageService.getOwnPublicKey();
    userLocation = await _secureStorageService.getOwnLocation();
    profileKeywordDataMap = await _secureStorageService.getProfileKeywordDataMap();

    // Add any other data loading here (e.g., from SharedPreferences)
  }

  Future<void> resetUserId() async {
    await _secureStorageService.saveOwnPrivateKey("");
    await _secureStorageService.saveOwnPublicKey("");
    userId = const Uuid().v4().toString();
    await _secureStorageService.saveOwnUserId(userId!);
  }

  /// Clears the in-memory cache, forcing reload from storage on next access
  /// Call this after migration when user data has changed
  void clearCache() {
    logDebug('🧹 UserRepository.clearCache() called');
    logDebug('   Previous userId: $userId');
    userId = null;
    userName = null;
    publicKey = null;
    email = null;
    userLocation = null;
    profileKeywordDataMap = null;
    userInterests = null;
    userOfferings = null;
    logDebug('✅ UserRepository cache cleared');
  }

  Future<void> clearStorage() async {
    await _secureStorageService.clearStorage();
  }

}
