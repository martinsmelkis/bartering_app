/// Read receipt request sent from client to server when user reads a message
class ReadReceiptRequest {
  final String messageType = 'ReadReceiptRequest';
  final String messageId;
  final String senderId; // Original sender of the message
  final int timestamp;

  ReadReceiptRequest({
    required this.messageId,
    required this.senderId,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
        'messageType': messageType,
        'messageId': messageId,
        'senderId': senderId,
        'timestamp': timestamp,
      };

  factory ReadReceiptRequest.fromJson(Map<String, dynamic> json) {
    return ReadReceiptRequest(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      timestamp: json['timestamp'] as int,
    );
  }
}
