// Models for user blocking and reporting functionality

enum ReportReason {
  spam,
  harassment,
  inappropriateContent,
  scam,
  fakeProfile,
  impersonation,
  threateningBehavior,
  other;

  String get value {
    switch (this) {
      case ReportReason.spam:
        return 'spam';
      case ReportReason.harassment:
        return 'harassment';
      case ReportReason.inappropriateContent:
        return 'inappropriate_content';
      case ReportReason.scam:
        return 'scam';
      case ReportReason.fakeProfile:
        return 'fake_profile';
      case ReportReason.impersonation:
        return 'impersonation';
      case ReportReason.threateningBehavior:
        return 'threatening_behavior';
      case ReportReason.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.inappropriateContent:
        return 'Inappropriate Content';
      case ReportReason.scam:
        return 'Scam';
      case ReportReason.fakeProfile:
        return 'Fake Profile';
      case ReportReason.impersonation:
        return 'Impersonation';
      case ReportReason.threateningBehavior:
        return 'Threatening Behavior';
      case ReportReason.other:
        return 'Other';
    }
  }
}

enum ReportContextType {
  profile,
  posting,
  chat,
  review,
  general;

  String get value => name;
}

class UserReportRequest {
  final String reporterUserId;
  final String reportedUserId;
  final String reportReason;
  final String? description;
  final String? contextType;
  final String? contextId;

  UserReportRequest({
    required this.reporterUserId,
    required this.reportedUserId,
    required this.reportReason,
    this.description,
    this.contextType,
    this.contextId,
  });

  Map<String, dynamic> toJson() => {
        'reporterUserId': reporterUserId,
        'reportedUserId': reportedUserId,
        'reportReason': reportReason,
        'description': description,
        'contextType': contextType,
        'contextId': contextId,
      };
}

class RelationshipRequest {
  final String fromUserId;
  final String toUserId;
  final String relationshipType;

  RelationshipRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.relationshipType,
  });

  Map<String, dynamic> toJson() => {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'relationshipType': relationshipType,
      };
}

class UserReportStats {
  final String userId;
  final int totalReportsReceived;
  final int pendingReports;
  final int actionsTaken;
  final String? lastReportedAt;

  UserReportStats({
    required this.userId,
    required this.totalReportsReceived,
    required this.pendingReports,
    required this.actionsTaken,
    this.lastReportedAt,
  });

  factory UserReportStats.fromJson(Map<String, dynamic> json) {
    return UserReportStats(
      userId: json['userId'],
      totalReportsReceived: json['totalReportsReceived'],
      pendingReports: json['pendingReports'],
      actionsTaken: json['actionsTaken'],
      lastReportedAt: json['lastReportedAt'],
    );
  }
}
