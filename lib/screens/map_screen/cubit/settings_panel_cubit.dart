import 'package:flutter_bloc/flutter_bloc.dart';

/// State for the settings panel
class SettingsPanelState {
  final bool isOpen;

  const SettingsPanelState({
    this.isOpen = false,
  });

  SettingsPanelState copyWith({
    bool? isOpen,
  }) {
    return SettingsPanelState(
      isOpen: isOpen ?? this.isOpen,
    );
  }
}

/// Cubit to manage settings panel state globally
class SettingsPanelCubit extends Cubit<SettingsPanelState> {
  SettingsPanelCubit() : super(const SettingsPanelState());

  /// Open settings panel
  void openSettings() {
    emit(const SettingsPanelState(isOpen: true));
  }

  /// Close the settings panel
  void closeSettings() {
    emit(const SettingsPanelState(isOpen: false));
  }
}
