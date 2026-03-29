/// Wallet summary response model
class WalletResponse {
  final String userId;
  final int availableBalance;
  final int lockedBalance;
  final int totalEarned;
  final int totalSpent;
  final int updatedAt;

  WalletResponse({
    required this.userId,
    required this.availableBalance,
    required this.lockedBalance,
    required this.totalEarned,
    required this.totalSpent,
    required this.updatedAt,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      userId: json['userId'] as String,
      availableBalance: json['availableBalance'] as int? ?? 0,
      lockedBalance: json['lockedBalance'] as int? ?? 0,
      totalEarned: json['totalEarned'] as int? ?? 0,
      totalSpent: json['totalSpent'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'availableBalance': availableBalance,
      'lockedBalance': lockedBalance,
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'updatedAt': updatedAt,
    };
  }
}

/// Wallet transaction response model
class WalletTransactionResponse {
  final String id;
  final String type;
  final int amount;
  final String? fromUserId;
  final String? toUserId;
  final String? externalRef;
  final String? metadataJson;
  final int createdAt;

  WalletTransactionResponse({
    required this.id,
    required this.type,
    required this.amount,
    this.fromUserId,
    this.toUserId,
    this.externalRef,
    this.metadataJson,
    required this.createdAt,
  });

  factory WalletTransactionResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionResponse(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int? ?? 0,
      fromUserId: json['fromUserId'] as String?,
      toUserId: json['toUserId'] as String?,
      externalRef: json['externalRef'] as String?,
      metadataJson: json['metadataJson'] as String?,
      createdAt: json['createdAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'externalRef': externalRef,
      'metadataJson': metadataJson,
      'createdAt': createdAt,
    };
  }
}

/// Request model for transferring coins
class TransferCoinsRequest {
  final String fromUserId;
  final String toUserId;
  final int amount;
  final String transactionType;
  final String? externalRef;
  final String? metadataJson;

  TransferCoinsRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.transactionType,
    this.externalRef,
    this.metadataJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'transactionType': transactionType,
      if (externalRef != null) 'externalRef': externalRef,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }
}

/// Wallet operation response model
class WalletOperationResponse {
  final bool success;
  final String message;

  WalletOperationResponse({
    required this.success,
    required this.message,
  });

  factory WalletOperationResponse.fromJson(Map<String, dynamic> json) {
    return WalletOperationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
