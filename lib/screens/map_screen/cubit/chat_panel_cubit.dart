import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PanelView { none, chatsList, chat }

/// State for the chat panel
class ChatPanelState {
  final PanelView view;
  final String? selectedPoiId;
  final String? selectedPoiName;
  final PointOfInterest? selectedPoi; // Full POI object when available

  const ChatPanelState({
    this.view = PanelView.none,
    this.selectedPoiId,
    this.selectedPoiName,
    this.selectedPoi,
  });

  bool get isOpen => view != PanelView.none;

  bool get isChatsListOpen => view == PanelView.chatsList;

  bool get isChatOpen => view == PanelView.chat;

  ChatPanelState copyWith({
    PanelView? view,
    String? selectedPoiId,
    String? selectedPoiName,
    PointOfInterest? selectedPoi,
    bool? clearSelection,
  }) {
    if (clearSelection == true) {
      return const ChatPanelState();
    }
    return ChatPanelState(
      view: view ?? this.view,
      selectedPoiId: selectedPoiId ?? this.selectedPoiId,
      selectedPoiName: selectedPoiName ?? this.selectedPoiName,
      selectedPoi: selectedPoi ?? this.selectedPoi,
    );
  }
}

/// Cubit to manage chat panel state globally
class ChatPanelCubit extends Cubit<ChatPanelState> {
  ChatPanelCubit() : super(const ChatPanelState());

  /// Open chats list view
  void openChatsList() {
    emit(const ChatPanelState(view: PanelView.chatsList));
  }

  /// Open chat with a specific POI
  /// If chat is already open for a different POI, it will be replaced
  void openChat(String poiId, String poiName, {PointOfInterest? poi}) {
    emit(
      ChatPanelState(
        view: PanelView.chat,
        selectedPoiId: poiId,
        selectedPoiName: poiName,
        selectedPoi: poi,
      ),
    );
  }

  /// Check if a specific POI chat is already open
  bool isPoiChatOpen(String poiId) {
    return state.isChatOpen && state.selectedPoiId == poiId;
  }

  /// Close the chat panel
  void closePanel() {
    emit(const ChatPanelState());
  }

  /// Legacy method for backwards compatibility
  void closeChat() => closePanel();
}
