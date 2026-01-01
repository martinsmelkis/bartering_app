// lib/cubit/chat/chat_state.dart
part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message) : super(List.empty(growable: true));
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatLoading extends ChatState {
  ChatLoading() : super([]);
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  ChatLoaded(this.messages) : super(List.empty(growable: true));
}

class ChatMessagesLoading extends ChatState {
  ChatMessagesLoading(
      super.messages); // Can carry existing messages while loading new
}

class ChatMessagesLoaded extends ChatState {
  ChatMessagesLoaded(super.messages);
}

class ChatMessageSending extends ChatState {
  ChatMessageSending(super.messages);
}

class ChatMessageSent extends ChatState {
  ChatMessageSent(super.messages);
}

class ChatKeysExchanged extends ChatState {
  ChatKeysExchanged() : super([]);
}