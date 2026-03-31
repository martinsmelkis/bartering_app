import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'dart:ui' as ui;

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
  static const String _showSearchResultsAsListKey = 'show_search_results_as_list';
  static const String _preferredLanguageKey = 'preferred_language';
  static const String _enableGpsLocationKey = 'enable_gps_location';
  static const String _gdprConsentVersionKey = 'gdpr_consent_version';
  static const String _gdprConsentTimestampKey = 'gdpr_consent_timestamp';
  static const String _gdprLocationConsentKey = 'gdpr_location_consent';
  static const String _gdprAiProcessingConsentKey = 'gdpr_ai_processing_consent';
  static const String _gdprAnalyticsCookiesConsentKey = 'gdpr_analytics_cookies_consent';

  // Default values
  static const double defaultNearbyUsersRadius = 50.0; // km
  static const double defaultKeywordSearchRadius = 90.0; // km
  static const int defaultKeywordSearchWeight = 50; // 10-100 range
  static const String defaultSearchType = 'complementary'; // 'complementary', 'similar', 'nearby'

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
  /// false = User Location, true = Map Center (default)
  Future<bool> setUseMapCenterForSearch(bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(_useMapCenterKey, value);
  }

  /// Get whether to use map center for search
  /// Returns true (map center) by default
  Future<bool> getUseMapCenterForSearch() async {
    final prefs = await _preferences;
    return prefs.getBool(_useMapCenterKey) ?? true;
  }

  /// Get synchronously if already initialized (useful for performance)
  bool getUseMapCenterForSearchSync() {
    return _prefs?.getBool(_useMapCenterKey) ?? true;
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

  // --- Search Results Display Settings ---

  /// Save whether to show search results as list instead of map
  Future<bool> setShowSearchResultsAsList(bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(_showSearchResultsAsListKey, value);
  }

  /// Get whether to show search results as list
  /// Defaults to true on desktop web, false on mobile and mobile-sized web
  Future<bool> getShowSearchResultsAsList() async {
    final prefs = await _preferences;
    return prefs.getBool(_showSearchResultsAsListKey) ?? _defaultShowSearchResultsAsList();
  }

  /// Get synchronously if already initialized
  /// Defaults to true on desktop web, false on mobile and mobile-sized web
  bool getShowSearchResultsAsListSync() {
    return _prefs?.getBool(_showSearchResultsAsListKey) ?? _defaultShowSearchResultsAsList();
  }

  bool _defaultShowSearchResultsAsList() {
    if (!kIsWeb) return false;

    // Disable by default on mobile-sized web viewports.
    final width = ui.PlatformDispatcher.instance.views.first.physicalSize.width /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return width >= 840;
  }

  // --- Language Settings ---

  /// Save the preferred language code
  Future<bool> setPreferredLanguage(String languageCode) async {
    final prefs = await _preferences;
    return await prefs.setString(_preferredLanguageKey, languageCode);
  }

  /// Get the preferred language code
  /// Returns null if not set (will use system default)
  Future<String?> getPreferredLanguage() async {
    final prefs = await _preferences;
    return prefs.getString(_preferredLanguageKey);
  }

  /// Get preferred language synchronously
  String? getPreferredLanguageSync() {
    return _prefs?.getString(_preferredLanguageKey);
  }

  // --- GPS Location Settings ---

  /// Save whether GPS location is enabled
  /// When false, the app will not request location permissions
  Future<bool> setEnableGpsLocation(bool enabled) async {
    final prefs = await _preferences;
    return await prefs.setBool(_enableGpsLocationKey, enabled);
  }

  /// Get whether GPS location is enabled
  /// Returns false by default (location disabled)
  Future<bool> isGpsLocationEnabled() async {
    final prefs = await _preferences;
    return prefs.getBool(_enableGpsLocationKey) ?? false;
  }

  /// Get GPS location enabled synchronously
  bool isGpsLocationEnabledSync() {
    return _prefs?.getBool(_enableGpsLocationKey) ?? false;
  }

  /// Get GDPR location consent value
  /// Returns false by default when consent is not set.
  Future<bool> hasLocationConsent() async {
    final prefs = await _preferences;
    return prefs.getBool(_gdprLocationConsentKey) ?? false;
  }

  /// Get GDPR location consent synchronously
  bool hasLocationConsentSync() {
    return _prefs?.getBool(_gdprLocationConsentKey) ?? false;
  }

  /// Save GDPR consent choices with versioning and timestamp
  Future<void> setGdprConsent({
    required String version,
    required bool locationConsent,
    required bool aiProcessingConsent,
    bool? analyticsCookiesConsent,
    DateTime? timestamp,
  }) async {
    final prefs = await _preferences;
    final consentTimestamp = (timestamp ?? DateTime.now()).toUtc().toIso8601String();

    await prefs.setString(_gdprConsentVersionKey, version);
    await prefs.setString(_gdprConsentTimestampKey, consentTimestamp);
    await prefs.setBool(_gdprLocationConsentKey, locationConsent);
    await prefs.setBool(_gdprAiProcessingConsentKey, aiProcessingConsent);
    if (analyticsCookiesConsent != null) {
      await prefs.setBool(_gdprAnalyticsCookiesConsentKey, analyticsCookiesConsent);
    }
  }

  /// Returns true when user has already completed GDPR consent flow for a given version
  Future<bool> hasAcceptedGdprConsentVersion(String version) async {
    final prefs = await _preferences;
    return prefs.getString(_gdprConsentVersionKey) == version;
  }

  /// Clear all settings from SharedPreferences
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.clear();
  }
}
