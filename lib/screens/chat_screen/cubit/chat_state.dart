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
  final DateTime timestamp;
  
  ChatMessagesLoaded(super.messages) : timestamp = DateTime.now();
  
  @override
  List<Object> get props => [messages, timestamp];
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

class ChatTransactionInProgress extends ChatState {
  ChatTransactionInProgress() : super([]);
}

class ChatTransactionCompleted extends ChatState {
  final String transactionId;
  ChatTransactionCompleted(this.transactionId) : super([]);
  
  @override
  List<Object> get props => [transactionId];
}

class ChatTransactionError extends ChatState {
  final String error;
  ChatTransactionError(this.error) : super([]);
  
  @override
  List<Object> get props => [error];
}

// User moderation states
class ChatUserBlockInProgress extends ChatState {
  ChatUserBlockInProgress() : super([]);
}

class ChatUserBlockSuccess extends ChatState {
  ChatUserBlockSuccess() : super([]);
}

class ChatUserBlockError extends ChatState {
  final String error;
  ChatUserBlockError(this.error) : super([]);
  
  @override
  List<Object> get props => [error];
}

class ChatUserUnblockInProgress extends ChatState {
  ChatUserUnblockInProgress() : super([]);
}

class ChatUserUnblockSuccess extends ChatState {
  ChatUserUnblockSuccess() : super([]);
}

class ChatUserUnblockError extends ChatState {
  final String error;
  ChatUserUnblockError(this.error) : super([]);
  
  @override
  List<Object> get props => [error];
}

class ChatUserReportInProgress extends ChatState {
  ChatUserReportInProgress() : super([]);
}

class ChatUserReportSuccess extends ChatState {
  final String reportId;
  ChatUserReportSuccess(this.reportId) : super([]);
  
  @override
  List<Object> get props => [reportId];
}

class ChatUserReportError extends ChatState {
  final String error;
  ChatUserReportError(this.error) : super([]);
  
  @override
  List<Object> get props => [error];
}