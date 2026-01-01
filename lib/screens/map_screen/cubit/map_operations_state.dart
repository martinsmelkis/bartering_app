part of 'map_operations_cubit.dart';

abstract class MapOperationsState extends Equatable {
  const MapOperationsState();

  @override
  List<Object?> get props => [];
}

class MapOperationsInitial extends MapOperationsState {}

class MapOperationsLoading extends MapOperationsState {}

class MapOperationsMainClusteringSuccess extends MapOperationsState {
  final List<PoiClusterOsm> newMainClusters;

  const MapOperationsMainClusteringSuccess(this.newMainClusters);
}

class MapOperationsClusterUpdateSuccess extends MapOperationsState {
  final double id;

  const MapOperationsClusterUpdateSuccess(this.id);

  @override
  List<Object?> get props => [id];
}

class MapOperationsError extends MapOperationsState {
  final String message;

  const MapOperationsError(this.message);

  @override
  List<Object?> get props => [message];
}