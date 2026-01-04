/// Transaction response model
class TransactionResponse {
  final String id;
  final String user1Id;
  final String user2Id;
  final int initiatedAt;
  final int? completedAt;
  final String status; // "pending", "done", "cancelled", "disputed", etc.
  final double? estimatedValue;
  final bool locationConfirmed;
  final double? riskScore;

  TransactionResponse({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.initiatedAt,
    this.completedAt,
    required this.status,
    this.estimatedValue,
    required this.locationConfirmed,
    this.riskScore,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      id: json['id'] as String,
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
      initiatedAt: json['initiatedAt'] as int,
      completedAt: json['completedAt'] as int?,
      status: json['status'] as String,
      estimatedValue: json['estimatedValue'] as double?,
      locationConfirmed: json['locationConfirmed'] as bool? ?? false,
      riskScore: json['riskScore'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'initiatedAt': initiatedAt,
      'completedAt': completedAt,
      'status': status,
      'estimatedValue': estimatedValue,
      'locationConfirmed': locationConfirmed,
      'riskScore': riskScore,
    };
  }
}

/// Request model for creating a transaction
class CreateTransactionRequest {
  final String user1Id;
  final String user2Id;
  final double? estimatedValue;

  CreateTransactionRequest({
    required this.user1Id,
    required this.user2Id,
    this.estimatedValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      if (estimatedValue != null) 'estimatedValue': estimatedValue,
    };
  }
}

/// Request model for updating transaction status
class UpdateTransactionStatusRequest {
  final String status;

  UpdateTransactionStatusRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

/// Response model for creating a transaction
class CreateTransactionResponse {
  final bool success;
  final String transactionId;

  CreateTransactionResponse({
    required this.success,
    required this.transactionId,
  });

  factory CreateTransactionResponse.fromJson(Map<String, dynamic> json) {
    return CreateTransactionResponse(
      success: json['success'] as bool,
      transactionId: json['transactionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'transactionId': transactionId,
    };
  }
}

/// Generic success response
class SuccessResponse {
  final bool success;
  final String? message;

  SuccessResponse({
    required this.success,
    this.message,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
    };
  }
}
