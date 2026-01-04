/// Reputation response model
class ReputationResponse {
  final String userId;
  final double averageRating; // 0.0-5.0
  final int totalReviews;
  final int verifiedReviews;
  final double tradeDiversityScore; // 0.0-1.0
  final String trustLevel; // "new", "emerging", "established", "trusted", "verified"
  final List<String> badges;
  final int lastUpdated;

  ReputationResponse({
    required this.userId,
    required this.averageRating,
    required this.totalReviews,
    required this.verifiedReviews,
    required this.tradeDiversityScore,
    required this.trustLevel,
    required this.badges,
    required this.lastUpdated,
  });

  factory ReputationResponse.fromJson(Map<String, dynamic> json) {
    final badgesList = json['badges'] as List<dynamic>? ?? [];
    return ReputationResponse(
      userId: json['userId'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      verifiedReviews: json['verifiedReviews'] as int,
      tradeDiversityScore: (json['tradeDiversityScore'] as num).toDouble(),
      trustLevel: json['trustLevel'] as String,
      badges: badgesList.map((b) => b.toString()).toList(),
      lastUpdated: json['lastUpdated'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'verifiedReviews': verifiedReviews,
      'tradeDiversityScore': tradeDiversityScore,
      'trustLevel': trustLevel,
      'badges': badges,
      'lastUpdated': lastUpdated,
    };
  }

  /// Get trust level display text
  String getTrustLevelDisplay() {
    switch (trustLevel) {
      case 'new':
        return 'New Trader';
      case 'emerging':
        return 'Emerging Trader';
      case 'established':
        return 'Established Trader';
      case 'trusted':
        return 'Trusted Trader';
      case 'verified':
        return 'Verified Trader';
      default:
        return trustLevel;
    }
  }
}

/// Badge detail model
class BadgeDetail {
  final String type;
  final String name;
  final String description;
  final int earnedAt;

  BadgeDetail({
    required this.type,
    required this.name,
    required this.description,
    required this.earnedAt,
  });

  factory BadgeDetail.fromJson(Map<String, dynamic> json) {
    return BadgeDetail(
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      earnedAt: json['earnedAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'description': description,
      'earnedAt': earnedAt,
    };
  }
}

/// User badges response model
class UserBadgesResponse {
  final String userId;
  final List<BadgeDetail> badges;

  UserBadgesResponse({
    required this.userId,
    required this.badges,
  });

  factory UserBadgesResponse.fromJson(Map<String, dynamic> json) {
    final badgesList = json['badges'] as List<dynamic>? ?? [];
    return UserBadgesResponse(
      userId: json['userId'] as String,
      badges: badgesList.map((b) => BadgeDetail.fromJson(b as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'badges': badges.map((b) => b.toJson()).toList(),
    };
  }
}
