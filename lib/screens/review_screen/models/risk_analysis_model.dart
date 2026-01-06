class RiskAnalysisReport {
  final String transactionId;
  final String user1Id;
  final String user2Id;
  final double overallRiskScore;
  final String riskLevel;
  final double deviceRiskScore;
  final double ipRiskScore;
  final double locationRiskScore;
  final double behaviorRiskScore;
  final List<String> detectedPatterns;
  final List<String> recommendations;
  final bool requiresManualReview;
  final int analysisTimestamp;

  RiskAnalysisReport({
    required this.transactionId,
    required this.user1Id,
    required this.user2Id,
    required this.overallRiskScore,
    required this.riskLevel,
    required this.deviceRiskScore,
    required this.ipRiskScore,
    required this.locationRiskScore,
    required this.behaviorRiskScore,
    required this.detectedPatterns,
    required this.recommendations,
    required this.requiresManualReview,
    required this.analysisTimestamp,
  });

  factory RiskAnalysisReport.fromJson(Map<String, dynamic> json) {
    return RiskAnalysisReport(
      transactionId: json['transactionId'] as String,
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
      overallRiskScore: (json['overallRiskScore'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      deviceRiskScore: (json['deviceRiskScore'] as num).toDouble(),
      ipRiskScore: (json['ipRiskScore'] as num).toDouble(),
      locationRiskScore: (json['locationRiskScore'] as num).toDouble(),
      behaviorRiskScore: (json['behaviorRiskScore'] as num).toDouble(),
      detectedPatterns: List<String>.from(json['detectedPatterns'] as List),
      recommendations: List<String>.from(json['recommendations'] as List),
      requiresManualReview: json['requiresManualReview'] as bool,
      analysisTimestamp: json['analysisTimestamp'] as int,
    );
  }

  bool get isHighRisk => riskLevel == 'HIGH' || riskLevel == 'CRITICAL';
  bool get isCritical => riskLevel == 'CRITICAL';
}