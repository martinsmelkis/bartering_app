import 'dart:developer' show log;

import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // For value equality in states
import '../../../configure_dependencies.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../services/secure_storage_service.dart';

part 'map_screen_api_state.dart';

class PoiCubit extends Cubit<PoiState> {
  final ApiClient _apiClient;
  final userRepository = getIt<SecureStorageService>();
  String? userId;

  PoiCubit(this._apiClient) : super(PoiInitial());

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

  /// Fetches all points of interest.
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  Future<void> fetchPois({double? lat, double? lon, double? radius, String? excludeUserId}) async {
    try {
      emit(PoiLoading());

      final userRepository = getIt<SecureStorageService>();
      userId ??= await userRepository.getOwnUserId();

      double latitude;
      double longitude;

      // Check if explicit coordinates are provided (e.g., from map center)
      if (lat != null && lon != null) {
        latitude = lat;
        longitude = lon;
      } else {
        // Use user's saved location
        final location = await userRepository.getOwnLocation();
        latitude = location?.isNotEmpty == true ?
          double.tryParse(location?.split(',')[0] ?? "") ?? 0.0 : 0.0;
        longitude = location?.isNotEmpty == true ?
          double.tryParse(location?.split(',')[1] ?? "") ?? 0.0 : 0.0;
        
        // Check if location is not set (0.0, 0.0)
        if (latitude == 0.0 && longitude == 0.0) {
          log("⚠️ No valid location available - skipping POI fetch");
          emit(const PoiError("Please set your location in settings to find nearby users"));
          return;
        }
      }

      final pois = await _apiClient.getPointsOfInterest(
          latitude, longitude, radius ?? 5000.0, userId);
      final sortedPois = _sortPois(pois);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch POIs");
      log("Failed to fetch POIs: $errorMessage");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      log("Failed to fetch POIs: ${e.toString()}");
      emit(PoiError("Failed to fetch POIs: ${e.toString()}"));
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
      
      double latitude;
      double longitude;
      
      // Check if explicit coordinates are provided (e.g., from map center)
      if (lat != null && lon != null) {
        latitude = lat;
        longitude = lon;
      } else {
        // Use user's saved location
        final location = await userRepository.getOwnLocation();
        latitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[0] ?? "") ?? 0.0 : 0.0;
        longitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[1] ?? "") ?? 0.0 : 0.0;
        
        // Check if location is not set (0.0, 0.0)
        if (latitude == 0.0 && longitude == 0.0) {
          log("⚠️ No valid location available - skipping keyword search");
          emit(const PoiError("Please set your location in settings to search for users"));
          return;
        }
      }
      
      final poi = await _apiClient.getProfilesByKeyword(
        userId ?? "", 
        keyword,
        latitude.toString(), 
        longitude.toString(),
        radiusMeters,
        weight,
        seeking,
        offering,
      );
      poi.forEach((poi) {
        debugPrint('@@@@@@@@@@@ POI loaded: ${poi.profile.userId} ${poi.matchRelevancyScore}');
      });
      final sortedPois = _sortPois(poi);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch POI with keyword $keyword");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
    }
  }

  /// Fetches similar profiles.
  /// If lat/lon are provided, uses those coordinates (typically from map center when setting is enabled).
  /// Otherwise, uses user's saved location.
  Future<void> getSimilarProfiles(String keyword, {double? lat, double? lon, double? radiusMeters}) async {
    try {
      emit(PoiLoading());
      
      userId ??= await userRepository.getOwnUserId();
      
      double? latitude;
      double? longitude;
      
      // Check if explicit coordinates are provided (e.g., from map center)
      if (lat != null && lon != null) {
        latitude = lat;
        longitude = lon;
      } else {
        // Use user's saved location
        final location = await userRepository.getOwnLocation();
        latitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[0] ?? "") : null;
        longitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[1] ?? "") : null;
      }
      
      // Check if location is not set (0.0, 0.0) or null
      if ((latitude == null || longitude == null) || (latitude == 0.0 && longitude == 0.0)) {
        log("⚠️ No valid location available - skipping similar profiles fetch");
        emit(const PoiError("Please set your location in settings to find similar users"));
        return;
      }
      
      final poi = await _apiClient.findSimilarProfiles(
        userId ?? "",
        latitude,
        longitude,
        radiusMeters,
      );
      final sortedPois = _sortPois(poi);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch similar profiles");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
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
      
      double? latitude;
      double? longitude;
      
      // Check if explicit coordinates are provided (e.g., from map center)
      if (lat != null && lon != null) {
        latitude = lat;
        longitude = lon;
      } else {
        // Use user's saved location
        final location = await userRepository.getOwnLocation();
        latitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[0] ?? "") : null;
        longitude = location?.isNotEmpty == true ?
            double.tryParse(location?.split(',')[1] ?? "") : null;
      }
      
      // Check if location is not set (0.0, 0.0) or null
      if ((latitude == null || longitude == null) || (latitude == 0.0 && longitude == 0.0)) {
        log("⚠️ No valid location available - skipping complementary profiles fetch");
        emit(const PoiError("Please set your location in settings to find matching users"));
        return;
      }
      
      final poi = await _apiClient.findComplementaryProfiles(
        userId ?? "",
        latitude,
        longitude,
        radiusMeters,
      );
      
      // If no results and fallback is enabled, try nearby search
      if (poi.isEmpty && fallbackToNearby) {
        log("No complementary profiles found, falling back to nearby search");
        await fetchPois(lat: latitude, lon: longitude, radius: radiusMeters);
        return;
      }
      
      final sortedPois = _sortPois(poi);
      emit(PoiLoaded(sortedPois));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch complementary profiles");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      // If fallback is enabled, try nearby search
      if (fallbackToNearby) {
        log("Error fetching complementary profiles, falling back to nearby search: $errorMessage");
        try {
          await fetchPois(lat: lat, lon: lon, radius: radiusMeters);
        } catch (fallbackError) {
          emit(PoiError(errorMessage)); // If fallback also fails, emit original error
        }
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      // If fallback is enabled, try nearby search
      if (fallbackToNearby) {
        log("Error fetching complementary profiles, falling back to nearby search: ${e.toString()}");
        try {
          await fetchPois(lat: lat, lon: lon, radius: radiusMeters);
        } catch (fallbackError) {
          emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
        }
        return;
      }
      
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
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
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch favorite profiles");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
    }
  }

  /// Fetches a single user profile and displays it as a POI on the map
  Future<void> loadSingleUserProfile(String targetUserId) async {
    try {
      emit(PoiLoading());
      final profile = await _apiClient.getProfileInfo(targetUserId);
      final poi = PointOfInterest(profile: profile, distanceKm: 0.0);
      emit(PoiLoaded([poi]));
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, "Failed to fetch user profile");
      log("Failed to fetch user profile: $errorMessage");
      
      // Check for authentication errors
      if (_isAuthenticationError(e)) {
        log("Authentication error detected - clearing keys and navigating to welcome screen");
        emit(const PoiAuthenticationError("Authentication error: Please log in again"));
        return;
      }
      
      emit(PoiError(errorMessage));
    } catch (e) {
      log("Failed to fetch user profile: ${e.toString()}");
      emit(PoiError("Failed to fetch user profile: ${e.toString()}"));
    }
  }

  /// Checks if the DioException is an authentication error
  bool _isAuthenticationError(DioException e) {
    final errorString = e.error?.toString() ?? '';
    return errorString.contains('Authentication error') ||
        errorString.contains('Private key') ||
        errorString.contains('User ID not available');
  }

}