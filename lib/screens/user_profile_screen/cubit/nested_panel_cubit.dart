import 'package:flutter_bloc/flutter_bloc.dart';

/// Type of nested panel to show within the profile screen
enum NestedPanelType { none, notifications, matchHistory, managePostings }

/// State for the nested panel within profile screen
class NestedPanelState {
  final NestedPanelType panelType;
  final String? userId; // For manage postings

  const NestedPanelState({
    this.panelType = NestedPanelType.none,
    this.userId,
  });

  bool get isOpen => panelType != NestedPanelType.none;

  NestedPanelState copyWith({
    NestedPanelType? panelType,
    String? userId,
  }) {
    return NestedPanelState(
      panelType: panelType ?? this.panelType,
      userId: userId ?? this.userId,
    );
  }
}

/// Cubit to manage nested panel state within profile screen
class NestedPanelCubit extends Cubit<NestedPanelState> {
  NestedPanelCubit() : super(const NestedPanelState());

  /// Open notifications panel
  void openNotifications() {
    emit(const NestedPanelState(panelType: NestedPanelType.notifications));
  }

  /// Open match history panel
  void openMatchHistory() {
    emit(const NestedPanelState(panelType: NestedPanelType.matchHistory));
  }

  /// Open manage postings panel
  void openManagePostings(String userId) {
    emit(NestedPanelState(
      panelType: NestedPanelType.managePostings,
      userId: userId,
    ));
  }

  /// Close the nested panel
  void closePanel() {
    emit(const NestedPanelState(panelType: NestedPanelType.none));
  }
}
