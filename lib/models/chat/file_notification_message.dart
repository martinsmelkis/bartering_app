import 'file_attachment.dart';

/// WebSocket message for file upload notification
class FileNotificationMessage {
  final String fileId;
  final String senderId;
  final String? recipientId; // Optional - server may not send this
  final String filename;
  final String mimeType;
  final int fileSize;
  final int expiresAt;
  final int timestamp;

  FileNotificationMessage({
    required this.fileId,
    required this.senderId,
    this.recipientId,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.expiresAt,
    required this.timestamp,
  });

  factory FileNotificationMessage.fromJson(Map<String, dynamic> json) {
    return FileNotificationMessage(
      fileId: json['fileId'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String?,
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: json['fileSize'] as int,
      expiresAt: json['expiresAt'] as int,
      timestamp: json['timestamp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'senderId': senderId,
      if (recipientId != null) 'recipientId': recipientId,
      'filename': filename,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'expiresAt': expiresAt,
      'timestamp': timestamp,
    };
  }

  /// Convert to FileAttachment for display in chat
  FileAttachment toFileAttachment() {
    return FileAttachment(
      fileId: fileId,
      filename: filename,
      mimeType: mimeType,
      fileSize: fileSize,
      expiresAt: expiresAt,
      isDownloaded: false,
    );
  }
}
