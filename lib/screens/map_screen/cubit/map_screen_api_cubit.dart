import 'dart:developer' show log;

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // For value equality in states
import '../../../configure_dependencies.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../services/secure_storage_service.dart';
import '../../../services/settings_service.dart';
import '../../../application.dart';

part 'map_screen_api_state.dart';

class PoiCubit extends Cubit<PoiState> {
  final ApiClient _apiClient;
  final userRepository = getIt<SecureStorageService>();
  String? userId;

  PoiCubit(this._apiClient) : super(PoiInitial());

  AppLocalizations get _l10n {
    final locale = localeNotifier.value ?? const Locale('en');
    return lookupAppLocalizations(locale);
  }

  /// Sorts POIs by distance (ascending) and then by relevancy score (descending)
  List<PointOfInterest> _sortPois(List<PointOfInterest> pois) {
    final sorted = List<PointOfInterest>.from(pois);
    sorted.sort((a, b) {
      // First, sort by distance (ascending - closest first)
      final distanceA = a.distanceKm ?? double.maxFinite;
      final distanceB = b.distanceKm ?? double.maxFinite;
      final distanceComparison = distanceA.compareTo(distanceB);

      if (distanceComparison != 0) {
        return distanceComparison;
      }

      // If distances are equal, sort by relevancy score (descending - highest first)
      final relevancyA = a.matchRelevancyScore ?? 0.0;
      final relevancyB = b.matchRelevancyScore ?? 0.0;
      return relevancyB.compareTo(relevancyA);
    });
    return sorted;
  }

  bool _hasUsableCoordinates(PointOfInterest poi) {
    final latitude = poi.profile.latitude;
    final longitude = poi.profile.longitude;
    return latitude != null &&
        longitude != null &&
        !(latitude == 0.0 && longitude == 0.0);
  }

  List<PointOfInterest> _withFallbackCoordinates(
      List<PointOfInterest> pois,
      double? fallbackLatitude,
      double? fallbackLongitude,
      ) {
    if (fallbackLatitude == null ||
        fallbackLongitude == null ||
        (fallbackLatitude == 0.0 && fallbackLongitude == 0.0)) {
      return pois;
    }

    return pois
        .map(
          (poi) => _hasUsableCoordinates(poi)
          ? poi
          : poi.copyWith(
        userProfileData: poi.profile.copyWith(
          latitude: fallbackLatitude,
          longitude: fallbackLongitude,
        ),
      ),
    )
        .toList();
  }

  Future<(double?, double?)> _getSavedLocationCoordinates() async {
    final location = await userRepository.getOwnLocation();
    if (location?.isNotEmpty != true) return (null, null);

    final parts = location!.split(',');
    if (parts.length < 2) return (null, null);

    final latitude = double.tryParse(parts[0].trim());
    final longitude = double.tryParse(parts[1].trim());
    return (latitude, longitude);
  }

  /// Fetches all points of interest.
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  Future<void> fetchPois({double? lat, double? lon, double? radius, String? excludeUserId}) async {
    try {
      emit(PoiLoading());

      final userRepository = getIt<SecureStorageService>();
      userId ??= await userRepository.getOwnUserId();

      final settingsService = getIt<SettingsService>();
      final hasLocationConsent = await settingsService.hasLocationConsent();

      List<PointOfInterest> pois;
      double? latitude;
      double? longitude;

      if (hasLocationConsent) {

        // Check if explicit coordinates are provided (e.g., from map center)
        if (lat != null && lon != null) {
          latitude = lat;
          longitude = lon;
        } else {
          // Use user's saved location
          final (savedLatitude, savedLongitude) =
          await _getSavedLocationCoordinates();
          latitude = savedLatitude ?? 0.0;
          longitude = savedLongitude ?? 0.0;

          // Check if location is not set (0.0, 0.0)
          if (latitude == 0.0 && longitude == 0.0) {
            log("⚠️ No valid location available - skipping POI fetch");
            emit(const PoiError("Please set your location in settings to find nearby users"));
            return;
          }
        }

        pois = await _apiClient.getPointsOfInterest(
            latitude, longitude, radius ?? 5000.0, userId);
      } else {
        // Backend requires consent for geo-filtered nearby search.
        // Omit geo parameters when user has not consented.
        pois = await _apiClient.getPointsOfInterestNoGeo(userId);
      }
      final visiblePois = _withFallbackCoordinates(pois, latitude, longitude);
      final sortedPois = _sortPois(visiblePois);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
        e,
        _l10n,
        fallbackMessage: _l10n.apiErrorNearbyUsersFallback,
      );
      log("Failed to fetch POIs: $errorMessage");

      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(PoiAuthenticationError(_l10n.apiErrorAuthSessionExpired));
        return;
      }

      emit(PoiError(errorMessage));
    } catch (e) {
      log("Failed to fetch POIs: ${e.toString()}");
      emit(PoiError(_l10n.apiErrorNearbyUsersFallback));
    }
  }

  /// Searches for profiles by keyword with configurable radius and weight
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  Future<void> getProfilesByKeyword(String keyword, {double? radiusMeters,
    int? weight, String? seeking, String? offering, double? lat, double? lon}) async {
    try {
      emit(PoiLoading());

      userId ??= await userRepository.getOwnUserId();

      final settingsService = getIt<SettingsService>();
      final hasLocationConsent = await settingsService.hasLocationConsent();

      List<PointOfInterest> poi;
      double? parsedLatitude;
      double? parsedLongitude;

      if (hasLocationConsent) {

        // Check if explicit coordinates are provided (e.g., from map center)
        if (lat != null && lon != null) {
          parsedLatitude = lat;
          parsedLongitude = lon;
        } else {
          // Use user's saved location
          final (savedLatitude, savedLongitude) =
          await _getSavedLocationCoordinates();
          parsedLatitude = savedLatitude ?? 0.0;
          parsedLongitude = savedLongitude ?? 0.0;

          // Check if location is not set (0.0, 0.0)
          if (parsedLatitude == 0.0 && parsedLongitude == 0.0) {
            log("⚠️ No valid location available - skipping keyword search");
            emit(const PoiError("Please set your location in settings to search for users"));
            return;
          }
        }

        poi = await _apiClient.getProfilesByKeyword(
          userId ?? "",
          keyword,
          parsedLatitude.toString(),
          parsedLongitude.toString(),
          radiusMeters,
          weight,
          seeking,
          offering,
        );
      } else {
        // Backend requires consent for geo-filtered search.
        // Omit geo parameters when user has not consented.
        poi = await _apiClient.getProfilesByKeywordNoGeo(
          userId ?? "",
          keyword,
          weight,
          seeking,
          offering,
        );
      }
      poi.forEach((poi) {
        debugPrint('@@@@@@@@@@@ POI loaded: ${poi.profile.userId} ${poi.matchRelevancyScore}');
      });
      final visiblePois = _withFallbackCoordinates(
        poi,
        hasLocationConsent ? parsedLatitude : null,
        hasLocationConsent ? parsedLongitude : null,
      );
      final sortedPois = _sortPois(visiblePois);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
        e,
        _l10n,
        fallbackMessage: _l10n.apiErrorSearchUsersFallback,
      );

      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(PoiAuthenticationError(_l10n.apiErrorAuthSessionExpired));
        return;
      }

      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError(_l10n.apiErrorSearchUsersFallback));
    }
  }

  /// Fetches similar profiles.
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  Future<void> getSimilarProfiles(String keyword, {double? lat, double? lon, double? radiusMeters}) async {
    try {
      emit(PoiLoading());

      userId ??= await userRepository.getOwnUserId();

      final settingsService = getIt<SettingsService>();
      final hasLocationConsent = await settingsService.hasLocationConsent();

      List<PointOfInterest> poi;
      double? latitude;
      double? longitude;

      if (hasLocationConsent) {

        // Check if explicit coordinates are provided (e.g., from map center)
        if (lat != null && lon != null) {
          latitude = lat;
          longitude = lon;
        } else {
          // Use user's saved location
          final (savedLatitude, savedLongitude) =
          await _getSavedLocationCoordinates();
          latitude = savedLatitude;
          longitude = savedLongitude;
        }

        // Check if location is not set (0.0, 0.0) or null
        if ((latitude == null || longitude == null) || (latitude == 0.0 && longitude == 0.0)) {
          log("⚠️ No valid location available - skipping similar profiles fetch");
          emit(const PoiError("Please set your location in settings to find similar users"));
          return;
        }

        poi = await _apiClient.findSimilarProfiles(
          userId ?? "",
          latitude,
          longitude,
          radiusMeters,
        );
      } else {
        // Backend requires consent for geo-filtered search.
        // Omit geo parameters when user has not consented.
        poi = await _apiClient.findSimilarProfiles(
          userId ?? "",
          null,
          null,
          null,
        );
      }
      final visiblePois = _withFallbackCoordinates(
        poi,
        hasLocationConsent ? latitude : null,
        hasLocationConsent ? longitude : null,
      );
      final sortedPois = _sortPois(visiblePois);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
        e,
        _l10n,
        fallbackMessage: _l10n.apiErrorSimilarUsersFallback,
      );

      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(PoiAuthenticationError(_l10n.apiErrorAuthSessionExpired));
        return;
      }

      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError(_l10n.apiErrorSimilarUsersFallback));
    }
  }

  /// Fetches complementary profiles.
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  /// Falls back to nearby search if no complementary profiles are found.
  Future<void> getComplementaryProfiles(String keyword, {double? lat, double? lon, double? radiusMeters, bool fallbackToNearby = true}) async {
    try {
      emit(PoiLoading());

      userId ??= await userRepository.getOwnUserId();

      final settingsService = getIt<SettingsService>();
      final hasLocationConsent = await settingsService.hasLocationConsent();

      double? latitude;
      double? longitude;
      List<PointOfInterest> poi;

      if (hasLocationConsent) {
        // Check if explicit coordinates are provided (e.g., from map center)
        if (lat != null && lon != null) {
          latitude = lat;
          longitude = lon;
        } else {
          // Use user's saved location
          final (savedLatitude, savedLongitude) =
          await _getSavedLocationCoordinates();
          latitude = savedLatitude;
          longitude = savedLongitude;
        }

        // Check if location is not set (0.0, 0.0) or null
        if ((latitude == null || longitude == null) || (latitude == 0.0 && longitude == 0.0)) {
          log("⚠️ No valid location available - skipping complementary profiles fetch");
          emit(const PoiError("Please set your location in settings to find matching users"));
          return;
        }

        poi = await _apiClient.findComplementaryProfiles(
          userId ?? "",
          latitude,
          longitude,
          radiusMeters,
        );
      } else {
        // Backend requires consent for geo-filtered search.
        // Omit geo parameters when user has not consented.
        poi = await _apiClient.findComplementaryProfiles(
          userId ?? "",
          null,
          null,
          null,
        );
      }

      // If no results and fallback is enabled, try nearby search
      if (poi.isEmpty && fallbackToNearby) {
        log("No complementary profiles found, falling back to nearby search");
        await fetchPois(
          lat: hasLocationConsent ? latitude : null,
          lon: hasLocationConsent ? longitude : null,
          radius: hasLocationConsent ? radiusMeters : null,
        );
        return;
      }

      final visiblePois = _withFallbackCoordinates(
        poi,
        hasLocationConsent ? latitude : null,
        hasLocationConsent ? longitude : null,
      );
      final sortedPois = _sortPois(visiblePois);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
        e,
        _l10n,
        fallbackMessage: _l10n.apiErrorMatchingUsersFallback,
      );

      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(PoiAuthenticationError(_l10n.apiErrorAuthSessionExpired));
        return;
      }

      // If fallback is enabled, try nearby search
      if (fallbackToNearby) {
        log("Error fetching complementary profiles, falling back to nearby search: $errorMessage");
        try {
          final settingsService = getIt<SettingsService>();
          final hasLocationConsent = await settingsService.hasLocationConsent();
          await fetchPois(
            lat: hasLocationConsent ? lat : null,
            lon: hasLocationConsent ? lon : null,
            radius: hasLocationConsent ? radiusMeters : null,
          );
        } catch (fallbackError) {
          emit(PoiError(errorMessage)); // If fallback also fails, emit original error
        }
        return;
      }

      emit(PoiError(errorMessage));
    } catch (e) {
      final genericMessage = _l10n.apiErrorMatchingUsersFallback;

      // If fallback is enabled, try nearby search
      if (fallbackToNearby) {
        log("Error fetching complementary profiles, falling back to nearby search: ${e.toString()}");
        try {
          final settingsService = getIt<SettingsService>();
          final hasLocationConsent = await settingsService.hasLocationConsent();
          await fetchPois(
            lat: hasLocationConsent ? lat : null,
            lon: hasLocationConsent ? lon : null,
            radius: hasLocationConsent ? radiusMeters : null,
          );
        } catch (fallbackError) {
          emit(PoiError(genericMessage));
        }
        return;
      }

      emit(PoiError(genericMessage));
    }
  }

  Future<void> getFavoriteProfiles(String keyword) async {
    try {
      emit(PoiLoading());
      final poi = await _apiClient.findFavoriteProfiles(userId ?? "");
      final mappedToPOI = poi.map((profile) => PointOfInterest(profile: profile, distanceKm: 0.0)).toList();
      final sortedPois = _sortPois(mappedToPOI);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
        e,
        _l10n,
        fallbackMessage: _l10n.apiErrorFavoriteUsersFallback,
      );

      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(PoiAuthenticationError(_l10n.apiErrorAuthSessionExpired));
        return;
      }

      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError(_l10n.apiErrorFavoriteUsersFallback));
    }
  }

  /// Checks if the DioException is an authentication error
  bool _isAuthenticationError(DioException e) {
    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return true;
    }

    final errorString = e.error?.toString() ?? '';
    return errorString.contains('Authentication error') ||
        errorString.contains('Private key') ||
        errorString.contains('User ID not available');
  }

}