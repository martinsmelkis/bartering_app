import 'package:barter_app/models/chat/e_chat_message_status.dart';

/// Message status update sent from server to sender
/// Confirms message was sent/delivered
class MessageStatusUpdate {
  final String messageType = 'MessageStatusUpdate';
  final String messageId;
  final EChatMessageStatus status;
  final int timestamp;

  MessageStatusUpdate({
    required this.messageId,
    required this.status,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory MessageStatusUpdate.fromJson(Map<String, dynamic> json) {
    return MessageStatusUpdate(
      messageId: json['messageId'] as String,
      status: _statusFromString(json['status'] as String),
      timestamp: json['timestamp'] as int,
    );
  }

  static EChatMessageStatus _statusFromString(String status) {
    switch (status.toUpperCase()) {
      case 'SENT':
        return EChatMessageStatus.sent;
      case 'DELIVERED':
        return EChatMessageStatus.delivered;
      case 'READ':
        return EChatMessageStatus.read;
      default:
        return EChatMessageStatus.sent;
    }
  }

  Map<String, dynamic> toJson() => {
        'messageType': messageType,
        'messageId': messageId,
        'status': status.name.toUpperCase(),
        'timestamp': timestamp,
      };
}
