import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/services/secure_storage_service.dart';
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

  /// Gets just the attribute names as strings (for backward compatibility)
  Future<List<String>> getInterestNames() async {
    final interests = await getInterests();
    return interests?.map((e) => e.attribute).toList() ?? [];
  }

  /// Gets just the offering names as strings (for backward compatibility)
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
    userId = userId ?? await _secureStorageService.getOwnUserId();
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
    userId = const Uuid().v4().toString();
    await _secureStorageService.saveOwnUserId(userId!);
  }

}
