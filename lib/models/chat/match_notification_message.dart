/// Model for match notification messages received via WebSocket
/// Sent when a match occurs on web platform or when user has no notification contacts
class MatchNotificationMessage {
  final String matchId;
  final String title;
  final String body;
  final String matchType; // 'posting', 'user', 'attribute', or 'match'
  final double? matchScore;
  final String? postingId;
  final String? postingUserId;
  final String? postingTitle;
  final String? postingImageUrl;

  MatchNotificationMessage({
    required this.matchId,
    required this.title,
    required this.body,
    required this.matchType,
    this.matchScore,
    this.postingId,
    this.postingUserId,
    this.postingTitle,
    this.postingImageUrl,
  });

  factory MatchNotificationMessage.fromJson(Map<String, dynamic> json) {
    return MatchNotificationMessage(
      matchId: json['matchId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      matchType: json['matchType'] as String? ?? 'match',
      matchScore: (json['matchScore'] as num?)?.toDouble(),
      postingId: json['postingId'] as String?,
      postingUserId: json['postingUserId'] as String?,
      postingTitle: json['postingTitle'] as String?,
      postingImageUrl: json['postingImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'title': title,
      'body': body,
      'matchType': matchType,
      if (matchScore != null) 'matchScore': matchScore,
      if (postingId != null) 'postingId': postingId,
      if (postingUserId != null) 'postingUserId': postingUserId,
      if (postingTitle != null) 'postingTitle': postingTitle,
      if (postingImageUrl != null) 'postingImageUrl': postingImageUrl,
    };
  }
}
