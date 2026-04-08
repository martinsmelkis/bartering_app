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

/// Request model for claiming wallet award
class ClaimAwardRequest {
  final String userId;
  final String awardType;
  final String? externalRef;
  final String? metadataJson;

  ClaimAwardRequest({
    required this.userId,
    required this.awardType,
    this.externalRef,
    this.metadataJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'awardType': awardType,
      if (externalRef != null) 'externalRef': externalRef,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }
}

/// Response model for claiming wallet award
class ClaimAwardResponse {
  final bool success;
  final bool awarded;
  final String awardType;
  final int amount;
  final String externalRef;
  final String message;

  ClaimAwardResponse({
    required this.success,
    required this.awarded,
    required this.awardType,
    required this.amount,
    required this.externalRef,
    required this.message,
  });

  factory ClaimAwardResponse.fromJson(Map<String, dynamic> json) {
    return ClaimAwardResponse(
      success: json['success'] as bool? ?? false,
      awarded: json['awarded'] as bool? ?? false,
      awardType: json['awardType'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      externalRef: json['externalRef'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'awarded': awarded,
      'awardType': awardType,
      'amount': amount,
      'externalRef': externalRef,
      'message': message,
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

/// Request model for purchasing premium lifetime
class PurchasePremiumLifetimeRequest {
  final String userId;
  final String currency;
  final int amountMinor;
  final String? externalRef;
  final String? metadataJson;

  PurchasePremiumLifetimeRequest({
    required this.userId,
    required this.currency,
    required this.amountMinor,
    this.externalRef,
    this.metadataJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currency': currency,
      'amountMinor': amountMinor,
      if (externalRef != null) 'externalRef': externalRef,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }
}

/// Request model for purchasing a coin pack
class PurchaseCoinPackRequest {
  final String userId;
  final int coinAmount;
  final String currency;
  final int amountMinor;
  final String? externalRef;
  final String? metadataJson;

  PurchaseCoinPackRequest({
    required this.userId,
    required this.coinAmount,
    required this.currency,
    required this.amountMinor,
    this.externalRef,
    this.metadataJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'coinAmount': coinAmount,
      'currency': currency,
      'amountMinor': amountMinor,
      if (externalRef != null) 'externalRef': externalRef,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }
}

/// Request model for purchasing visibility boost
class PurchaseVisibilityBoostRequest {
  final String userId;
  final String boostType;
  final int costCoins;
  final String? metadataJson;

  PurchaseVisibilityBoostRequest({
    required this.userId,
    required this.boostType,
    required this.costCoins,
    this.metadataJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'boostType': boostType,
      'costCoins': costCoins,
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }
}

/// Purchase record response model
class PurchaseResponse {
  final String id;
  final String userId;
  final String purchaseType;
  final String status;
  final String currency;
  final int fiatAmountMinor;
  final int? coinAmount;
  final String? externalRef;
  final String? metadataJson;
  final String? fulfillmentRef;
  final int createdAt;
  final int updatedAt;

  PurchaseResponse({
    required this.id,
    required this.userId,
    required this.purchaseType,
    required this.status,
    required this.currency,
    required this.fiatAmountMinor,
    this.coinAmount,
    this.externalRef,
    this.metadataJson,
    this.fulfillmentRef,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseResponse(
      id: json['id'] as String,
      userId: json['userId'] as String,
      purchaseType: json['purchaseType'] as String,
      status: json['status'] as String,
      currency: json['currency'] as String? ?? '',
      fiatAmountMinor: json['fiatAmountMinor'] as int? ?? 0,
      coinAmount: json['coinAmount'] as int?,
      externalRef: json['externalRef'] as String?,
      metadataJson: json['metadataJson'] as String?,
      fulfillmentRef: json['fulfillmentRef'] as String?,
      createdAt: json['createdAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'purchaseType': purchaseType,
      'status': status,
      'currency': currency,
      'fiatAmountMinor': fiatAmountMinor,
      'coinAmount': coinAmount,
      'externalRef': externalRef,
      'metadataJson': metadataJson,
      'fulfillmentRef': fulfillmentRef,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Premium status response model
class PremiumStatusResponse {
  final String userId;
  final bool isPremium;
  final bool isLifetime;
  final int? grantedAt;
  final int? expiresAt;
  final int updatedAt;

  PremiumStatusResponse({
    required this.userId,
    required this.isPremium,
    required this.isLifetime,
    this.grantedAt,
    this.expiresAt,
    required this.updatedAt,
  });

  factory PremiumStatusResponse.fromJson(Map<String, dynamic> json) {
    return PremiumStatusResponse(
      userId: json['userId'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      isLifetime: json['isLifetime'] as bool? ?? false,
      grantedAt: json['grantedAt'] as int?,
      expiresAt: json['expiresAt'] as int?,
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isPremium': isPremium,
      'isLifetime': isLifetime,
      'grantedAt': grantedAt,
      'expiresAt': expiresAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Purchase operation response model
class PurchaseOperationResponse {
  final bool success;
  final String message;
  final PurchaseResponse? purchase;

  PurchaseOperationResponse({
    required this.success,
    required this.message,
    this.purchase,
  });

  factory PurchaseOperationResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseOperationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      purchase: json['purchase'] != null
          ? PurchaseResponse.fromJson(json['purchase'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (purchase != null) 'purchase': purchase!.toJson(),
    };
  }
}
