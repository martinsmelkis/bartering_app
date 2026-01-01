part of 'location_picker_cubit.dart';

enum LocationPickerStatus { initial, loading, success, error }

class LocationPickerState extends Equatable {
  final LocationPickerStatus status;
  GeoPoint? selectedLocation;
  final String? errorMessage;

  LocationPickerState({
    this.status = LocationPickerStatus.initial,
    this.errorMessage,
  });

  LocationPickerState copyWith({
    LocationPickerStatus? status,
    String? errorMessage,
  }) {
    return LocationPickerState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedLocation, errorMessage];
}
