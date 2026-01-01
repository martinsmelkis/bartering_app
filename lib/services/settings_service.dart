import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

/// Service for managing app settings using SharedPreferences
/// This is more appropriate than SecureStorage for non-sensitive settings
@singleton
@injectable
class SettingsService {
  static const String _useMapCenterKey = 'use_map_center_for_search';
  static const String _nearbyUsersRadiusKey = 'nearby_users_radius';
  static const String _keywordSearchRadiusKey = 'keyword_search_radius';
  static const String _keywordSearchWeightKey = 'keyword_search_weight';
  static const String _pinEnabledKey = 'pin_enabled';
  static const String _pinSetupCompletedKey = 'pin_setup_completed';

  // Default values
  static const double defaultNearbyUsersRadius = 50.0; // km
  static const double defaultKeywordSearchRadius = 100.0; // km
  static const int defaultKeywordSearchWeight = 50; // 10-100 range

  SharedPreferences? _prefs;

  /// Initialize the service (should be called at app startup)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensures preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// Save whether to use map center for search
  /// false = User Location (default), true = Map Center
  Future<bool> setUseMapCenterForSearch(bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(_useMapCenterKey, value);
  }

  /// Get whether to use map center for search
  /// Returns false (user location) by default
  Future<bool> getUseMapCenterForSearch() async {
    final prefs = await _preferences;
    return prefs.getBool(_useMapCenterKey) ?? false;
  }

  /// Get synchronously if already initialized (useful for performance)
  bool getUseMapCenterForSearchSync() {
    return _prefs?.getBool(_useMapCenterKey) ?? false;
  }

  // --- Nearby Users Radius Settings ---

  /// Save the search radius for nearby users (in kilometers)
  Future<bool> setNearbyUsersRadius(double radiusKm) async {
    final prefs = await _preferences;
    return await prefs.setDouble(_nearbyUsersRadiusKey, radiusKm);
  }

  /// Get the search radius for nearby users (in kilometers)
  /// Returns default value if not set
  Future<double> getNearbyUsersRadius() async {
    final prefs = await _preferences;
    return prefs.getDouble(_nearbyUsersRadiusKey) ?? defaultNearbyUsersRadius;
  }

  /// Get nearby users radius synchronously
  double getNearbyUsersRadiusSync() {
    return _prefs?.getDouble(_nearbyUsersRadiusKey) ?? defaultNearbyUsersRadius;
  }

  // --- Keyword Search Radius Settings ---

  /// Save the search radius for keyword search (in kilometers)
  Future<bool> setKeywordSearchRadius(double radiusKm) async {
    final prefs = await _preferences;
    return await prefs.setDouble(_keywordSearchRadiusKey, radiusKm);
  }

  /// Get the search radius for keyword search (in kilometers)
  /// Returns default value if not set
  Future<double> getKeywordSearchRadius() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keywordSearchRadiusKey) ?? defaultKeywordSearchRadius;
  }

  /// Get keyword search radius synchronously
  double getKeywordSearchRadiusSync() {
    return _prefs?.getDouble(_keywordSearchRadiusKey) ?? defaultKeywordSearchRadius;
  }

  // --- Keyword Search Weight Settings ---

  /// Save the weight parameter for keyword search (10-100)
  Future<bool> setKeywordSearchWeight(int weight) async {
    final prefs = await _preferences;
    return await prefs.setInt(_keywordSearchWeightKey, weight);
  }

  /// Get the weight parameter for keyword search (10-100)
  /// Returns default value if not set
  Future<int> getKeywordSearchWeight() async {
    final prefs = await _preferences;
    return prefs.getInt(_keywordSearchWeightKey) ?? defaultKeywordSearchWeight;
  }

  /// Get keyword search weight synchronously
  int getKeywordSearchWeightSync() {
    return _prefs?.getInt(_keywordSearchWeightKey) ?? defaultKeywordSearchWeight;
  }

  // --- PIN Settings ---

  /// Save whether PIN is enabled
  Future<bool> setPinEnabled(bool enabled) async {
    final prefs = await _preferences;
    return await prefs.setBool(_pinEnabledKey, enabled);
  }

  /// Get whether PIN is enabled
  Future<bool> isPinEnabled() async {
    final prefs = await _preferences;
    return prefs.getBool(_pinEnabledKey) ?? false;
  }

  /// Get PIN enabled synchronously
  bool isPinEnabledSync() {
    return _prefs?.getBool(_pinEnabledKey) ?? false;
  }

  /// Mark PIN setup as completed (user has seen the setup screen)
  Future<bool> setPinSetupCompleted(bool completed) async {
    final prefs = await _preferences;
    return await prefs.setBool(_pinSetupCompletedKey, completed);
  }

  /// Check if user has completed PIN setup flow (either set PIN or skipped)
  Future<bool> isPinSetupCompleted() async {
    final prefs = await _preferences;
    return prefs.getBool(_pinSetupCompletedKey) ?? false;
  }
}
