
// senderId, recipientId, encryptedPayload, timestamp, messageId, status: sending/sent/delivered/read
import 'e_chat_message_status.dart';
import 'file_attachment.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String recipientId;
  String encryptedTextPayload; // This is what's sent over the network
  String? plainText; // For UI display after decryption / own sent messages
  final DateTime timestamp;
  EChatMessageStatus? status;
  bool isSentByCurrentUser; // UI helper
  FileAttachment? fileAttachment; // Optional file attachment

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.encryptedTextPayload,
    this.plainText, // Initially null for received messages
    required this.timestamp,
    this.status,
    this.isSentByCurrentUser = false,
    this.fileAttachment,
  });

  // Factory for creating a message to be sent (will be encrypted by cubit/service)
  factory ChatMessage.prepareToSend({
    required String id,
    required String senderId,
    required String recipientId,
    required String encryptedTextPayload,
    required String textToSend, // Plain text before encryption
    required DateTime timestamp,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      recipientId: recipientId,
      encryptedTextPayload: encryptedTextPayload, // Will be filled after encryption
      plainText: textToSend, // Store plain text for sender's own view
      timestamp: timestamp,
      status: EChatMessageStatus.sending,
      isSentByCurrentUser: false,
    );
  }

  // Factory for creating a message received from network (needs decryption)
  factory ChatMessage.received({
    required String id,
    required String senderId,
    required String recipientId,
    required String encryptedPayload,
    required DateTime timestamp,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      recipientId: recipientId,
      encryptedTextPayload: encryptedPayload,
      timestamp: timestamp,
      isSentByCurrentUser: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'recipientId': recipientId,
    'encryptedTextPayload': encryptedTextPayload, // Only send encrypted payload
    'plainText': plainText, // For sender's own view
    'status': status,
    'timestamp': timestamp.toIso8601String(),
    'fileAttachment': fileAttachment?.toJson(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final senderId = json['senderId'] as String;
    final recipientId = json['recipientId'] as String;
    final chatMsgText = json['text'] as String;
    return ChatMessage.received(
      id: DateTime.now().toIso8601String(),
      senderId: senderId,
      recipientId: recipientId,
      encryptedPayload: chatMsgText,
      timestamp: DateTime.now(),
      // isSentByCurrentUser will be determined in Cubit based on senderId
    );
  }
}