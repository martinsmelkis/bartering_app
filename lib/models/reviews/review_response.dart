/// Review response model
class ReviewResponse {
  final String id;
  final String transactionId;
  final String reviewerId;
  final String targetUserId;
  final int rating; // 1-5
  final String? reviewText;
  final String transactionStatus;
  final double reviewWeight;
  final bool isVisible;
  final int submittedAt;
  final int? revealedAt;
  final bool isVerified;
  final String? moderationStatus;

  ReviewResponse({
    required this.id,
    required this.transactionId,
    required this.reviewerId,
    required this.targetUserId,
    required this.rating,
    this.reviewText,
    required this.transactionStatus,
    required this.reviewWeight,
    required this.isVisible,
    required this.submittedAt,
    this.revealedAt,
    required this.isVerified,
    this.moderationStatus,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      reviewerId: json['reviewerId'] as String,
      targetUserId: json['targetUserId'] as String,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String?,
      transactionStatus: json['transactionStatus'] as String,
      reviewWeight: (json['reviewWeight'] as num).toDouble(),
      isVisible: json['isVisible'] as bool,
      submittedAt: json['submittedAt'] as int,
      revealedAt: json['revealedAt'] as int?,
      isVerified: json['isVerified'] as bool,
      moderationStatus: json['moderationStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'reviewerId': reviewerId,
      'targetUserId': targetUserId,
      'rating': rating,
      'reviewText': reviewText,
      'transactionStatus': transactionStatus,
      'reviewWeight': reviewWeight,
      'isVisible': isVisible,
      'submittedAt': submittedAt,
      'revealedAt': revealedAt,
      'isVerified': isVerified,
      'moderationStatus': moderationStatus,
    };
  }
}

/// User reviews response model
class UserReviewsResponse {
  final String userId;
  final List<ReviewResponse> reviews;
  final int totalCount;
  final double averageRating;

  UserReviewsResponse({
    required this.userId,
    required this.reviews,
    required this.totalCount,
    required this.averageRating,
  });

  factory UserReviewsResponse.fromJson(Map<String, dynamic> json) {
    final reviewsList = json['reviews'] as List<dynamic>? ?? [];
    return UserReviewsResponse(
      userId: json['userId'] as String,
      reviews: reviewsList.map((r) => ReviewResponse.fromJson(r as Map<String, dynamic>)).toList(),
      totalCount: json['totalCount'] as int,
      averageRating: (json['averageRating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'totalCount': totalCount,
      'averageRating': averageRating,
    };
  }
}
