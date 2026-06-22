import 'dart:math';

import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:injectable/injectable.dart';

part 'location_picker_state.dart';

@injectable
class LocationPickerCubit extends Cubit<LocationPickerState> {
  final ApiClient _apiClient;
  final UserRepository _userRepository;

  LocationPickerCubit(this._apiClient, this._userRepository) : super(LocationPickerState());

  void selectLocation(GeoPoint location) {
    emit(state.copyWith(status: LocationPickerStatus.initial));
  }

  Future<void> saveLocation(GeoPoint? position, {bool publishToMap = false}) async {
    if (position == null) {
      emit(state.copyWith(status: LocationPickerStatus.error, errorMessage: "Please select a location first."));
      return;
    }

    emit(state.copyWith(status: LocationPickerStatus.loading));

    try {
      await _userRepository.saveOwnLocation(
          "${position.latitude.toString()}"
              ", ${position.longitude.toString()}");

      final profileData = UserProfileData(
        userId: _userRepository.userId!,
        name: "",
        latitude: publishToMap ? position.latitude : null,
        longitude: publishToMap ? position.longitude : null,
        attributes: List.empty(growable: false),
        profileKeywordDataMap: await _userRepository.getProfileKeywordDataMap(),
        activePostingIds: List.empty(growable: false),
      );
      logDebug('@@@@@@@@@ profileData: $profileData');
      final userName = await _apiClient.updateProfileInfo(profileData);
      _userRepository.setUserName(userName);
      emit(state.copyWith(status: LocationPickerStatus.success));
    } catch (e) {
      logDebugError('Error saving location', e);
      emit(state.copyWith(status: LocationPickerStatus.error, errorMessage: e.toString()));
    }
  }
}
