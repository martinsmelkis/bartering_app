import 'package:barter_app/models/chat/e_chat_message_status.dart';

/// Read receipt notification sent from server to original sender
/// Notifies about status changes (DELIVERED or READ)
class ReadReceiptNotification {
  final String messageType = 'ReadReceiptNotification';
  final String messageId;
  final String readerId; // User who read/received the message
  final int timestamp;
  final EChatMessageStatus status;

  ReadReceiptNotification({
    required this.messageId,
    required this.readerId,
    required this.timestamp,
    required this.status,
  });

  factory ReadReceiptNotification.fromJson(Map<String, dynamic> json) {
    return ReadReceiptNotification(
      messageId: json['messageId'] as String,
      readerId: json['readerId'] as String,
      timestamp: json['timestamp'] as int,
      status: _statusFromString(json['status'] as String),
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
        'readerId': readerId,
        'timestamp': timestamp,
        'status': status.name.toUpperCase(),
      };
}
