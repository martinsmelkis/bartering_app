class AuthRequest {
  final String userId;
  final String peerUserId;
  final String publicKey;
  final int timestamp; // Unix timestamp in milliseconds
  final String signature; // ECDSA signature of: "$timestamp.$userId.$peerUserId"

  AuthRequest({
    required this.userId,
    required this.peerUserId,
    required this.publicKey,
    required this.timestamp,
    required this.signature,
  });

  /// Converts this [AuthRequest] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'peerUserId': peerUserId,
      'publicKey': publicKey,
      'timestamp': timestamp,
      'signature': signature,
    };
  }

  /// Creates an [AuthRequest] instance from a JSON map.
  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    if (json['userId'] == null) {
      throw FormatException("Missing 'userId' in AuthRequest JSON: $json");
    }
    if (json['timestamp'] == null) {
      throw FormatException("Missing 'timestamp' in AuthRequest JSON: $json");
    }
    if (json['signature'] == null) {
      throw FormatException("Missing 'signature' in AuthRequest JSON: $json");
    }
    return AuthRequest(
      userId: json['userId'] as String,
      peerUserId: json['peerUserId'] as String,
      publicKey: json['publicKey'] as String,
      timestamp: json['timestamp'] as int,
      signature: json['signature'] as String,
    );
  }

  @override
  String toString() {
    return 'AuthRequest(userId: $userId, peerUserId: $peerUserId, timestamp: $timestamp)';
  }

  // Optional: For equality and hashCode, especially if used in collections or as BLoC states
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthRequest &&
        other.userId == userId &&
        other.peerUserId == peerUserId &&
        other.timestamp == timestamp &&
        other.signature == signature;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      peerUserId.hashCode ^
      timestamp.hashCode ^
      signature.hashCode;
}