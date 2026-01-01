
class P2PAuthMessage {
  final String senderId;
  String encryptedTextPayload; // This is what's sent over the network
  String? publicKey; // For UI display after decryption, or for own sent messages
  final DateTime timestamp;

  P2PAuthMessage({
    required this.senderId,
    required this.encryptedTextPayload,
    this.publicKey, // Initially null for received messages
    required this.timestamp,
  });

  // Factory for creating a message to be sent (will be encrypted by cubit/service)
  factory P2PAuthMessage.prepareToSend({
    required String id,
    required String senderId,
    required String publicKey, // Plain text before encryption
    required DateTime timestamp,
  }) {
    return P2PAuthMessage(
      senderId: senderId,
      encryptedTextPayload: '', // Will be filled after encryption
      publicKey: publicKey, // Store plain text for sender's own view
      timestamp: timestamp
    );
  }

  // Factory for creating a message received from network (needs decryption)
  factory P2PAuthMessage.received({
    required String senderId,
    required String publicKey,
    required String encryptedPayload,
    required DateTime timestamp,
  }) {
    return P2PAuthMessage(
      senderId: senderId,
      encryptedTextPayload: encryptedPayload,
      publicKey: publicKey,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'encryptedTextPayload': encryptedTextPayload, // Only send encrypted payload
    'publicKey': publicKey, // For sender's own view
    'timestamp': timestamp.toIso8601String(),
  };

  factory P2PAuthMessage.fromJson(Map<String, dynamic> json) {
    final senderId = json['senderId'] as String;
    return P2PAuthMessage.received(
      senderId: senderId,
      publicKey: json['publicKey'] as String,
      encryptedPayload: json['encryptedTextPayload'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      // isSentByCurrentUser will be determined in Cubit based on senderId
    );
  }
}