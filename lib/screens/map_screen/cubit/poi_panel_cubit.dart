import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/map/point_of_interest.dart';

/// State for the POI details panel
class PoiPanelState {
  final bool isOpen;
  final PointOfInterest? selectedPoi;

  const PoiPanelState({
    this.isOpen = false,
    this.selectedPoi,
  });

  PoiPanelState copyWith({
    bool? isOpen,
    PointOfInterest? selectedPoi,
    bool? clearSelection,
  }) {
    if (clearSelection == true) {
      return const PoiPanelState();
    }
    return PoiPanelState(
      isOpen: isOpen ?? this.isOpen,
      selectedPoi: selectedPoi ?? this.selectedPoi,
    );
  }
}

/// Cubit to manage POI details panel state globally
class PoiPanelCubit extends Cubit<PoiPanelState> {
  PoiPanelCubit() : super(const PoiPanelState());

  /// Open POI details panel with a specific POI
  void openPoiDetails(PointOfInterest poi) {
    emit(PoiPanelState(
      isOpen: true,
      selectedPoi: poi,
    ));
  }

  /// Close the POI details panel
  void closePanel() {
    emit(const PoiPanelState());
  }
}
