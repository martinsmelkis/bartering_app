part of 'map_screen_api_cubit.dart';

abstract class PoiState extends Equatable {
  const PoiState();

  @override
  List<Object?> get props => [];
}

class PoiInitial extends PoiState {}

class PoiLoading extends PoiState {}

class PoiLoaded extends PoiState {
  final List<PointOfInterest> pois;

  const PoiLoaded(this.pois);

  @override
  List<Object?> get props => [pois];
}

class PoiDetailLoaded extends PoiState {
  final PointOfInterest poi;

  const PoiDetailLoaded(this.poi);

  @override
  List<Object?> get props => [poi];
}

class PoiError extends PoiState {
  final String message;

  const PoiError(this.message);

  @override
  List<Object?> get props => [message];
}