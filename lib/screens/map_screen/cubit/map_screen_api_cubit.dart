import 'dart:developer' show log;

import 'package:barter_app/services/api_client.dart';
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
      }

      final pois = await _apiClient.getPointsOfInterest(
          latitude, longitude, radius ?? 5000.0, userId);
      print('@@@@@@@@@@@ POIs loaded: $pois');
      emit(PoiLoaded(pois));
    } catch (e) {
      log("Failed to fetch POIs: ${e.toString()}");
      emit(PoiError("Failed to fetch POIs: ${e.toString()}"));
    }
  }

  /// Searches for profiles by keyword with configurable radius and weight
  Future<void> getProfilesByKeyword(String keyword, {double? radiusMeters, int? weight}) async {
    try {
      emit(PoiLoading());
      final location = await userRepository.getOwnLocation();
      double latitude = location?.isNotEmpty == true ?
      double.tryParse(location?.split(',')[0] ?? "") ?? 0.0 : 0.0;
      double longitude = location?.isNotEmpty == true ?
      double.tryParse(location?.split(',')[1] ?? "") ?? 0.0 : 0.0;
      final poi = await _apiClient.getProfilesByKeyword(
        userId ?? "", 
        keyword,
        latitude.toString(), 
        longitude.toString(),
        radiusMeters,
        weight,
      );
      poi.forEach((poi) => {
        print('@@@@@@@@@@@ POI loaded: ${poi.profile.userId} ${poi.matchRelevancyScore}')
      });
      emit(PoiLoaded(poi));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
    }
  }

  Future<void> getSimilarProfiles(String keyword) async {
    try {
      emit(PoiLoading());
      final poi = await _apiClient.findSimilarProfiles(userId ?? "");
      emit(PoiLoaded(poi));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
    }
  }

  Future<void> getComplementaryProfiles(String keyword) async {
    try {
      emit(PoiLoading());
      final poi = await _apiClient.findComplementaryProfiles(userId ?? "");
      emit(PoiLoaded(poi));
    } catch (e) {
      emit(PoiError("Failed to fetch POI with keyword $keyword: ${e.toString()}"));
    }
  }

  Future<void> getFavoriteProfiles(String keyword) async {
    try {
      emit(PoiLoading());
      final poi = await _apiClient.findFavoriteProfiles(userId ?? "");
      final mappedToPOI = poi.map((profile) => PointOfInterest(profile: profile, distanceKm: 0.0)).toList();
      emit(PoiLoaded(mappedToPOI));
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
    } catch (e) {
      log("Failed to fetch user profile: ${e.toString()}");
      emit(PoiError("Failed to fetch user profile: ${e.toString()}"));
    }
  }

}