import 'package:flutter_bloc/flutter_bloc.dart';

enum PanelView { none, chatsList, chat }

/// State for the chat panel
class ChatPanelState {
  final PanelView view;
  final String? selectedPoiId;
  final String? selectedPoiName;

  const ChatPanelState({
    this.view = PanelView.none,
    this.selectedPoiId,
    this.selectedPoiName,
  });

  bool get isOpen => view != PanelView.none;

  bool get isChatsListOpen => view == PanelView.chatsList;

  bool get isChatOpen => view == PanelView.chat;

  ChatPanelState copyWith({
    PanelView? view,
    String? selectedPoiId,
    String? selectedPoiName,
    bool? clearSelection,
  }) {
    if (clearSelection == true) {
      return const ChatPanelState();
    }
    return ChatPanelState(
      view: view ?? this.view,
      selectedPoiId: selectedPoiId ?? this.selectedPoiId,
      selectedPoiName: selectedPoiName ?? this.selectedPoiName,
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
  void openChat(String poiId, String poiName) {
    emit(
      ChatPanelState(
        view: PanelView.chat,
        selectedPoiId: poiId,
        selectedPoiName: poiName,
      ),
    );
  }

  /// Close the chat panel
  void closePanel() {
    emit(const ChatPanelState());
  }

  /// Legacy method for backwards compatibility
  void closeChat() => closePanel();
}
