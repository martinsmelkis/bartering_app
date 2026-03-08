// Device Migration and Management Response Models
// These classes represent API responses for device management operations

/// Response from initiating a device-to-device migration session
class InitiateMigrationResponse {
  final bool success;
  final String? sessionCode;
  final String? errorMessage;
  final String? expiresAt;

  InitiateMigrationResponse({
    required this.success,
    this.sessionCode,
    this.errorMessage,
    this.expiresAt,
  });

  factory InitiateMigrationResponse.fromJson(Map<String, dynamic> json) {
    return InitiateMigrationResponse(
      success: json['success'] as bool? ?? false,
      sessionCode: json['sessionCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      expiresAt: json['expiresAt'] as String?,
    );
  }
}

/// Response from registering a migration target device
class RegisterMigrationTargetResponse {
  final bool success;
  final String? sessionId; // UUID for API calls
  final String? sourceDeviceId;
  final String? userId;
  final String? errorMessage;

  RegisterMigrationTargetResponse({
    required this.success,
    this.sessionId,
    this.sourceDeviceId,
    this.userId,
    this.errorMessage,
  });

  factory RegisterMigrationTargetResponse.fromJson(Map<String, dynamic> json) {
    return RegisterMigrationTargetResponse(
      success: json['success'] as bool? ?? false,
      sessionId: json['sessionId'] as String?,
      sourceDeviceId: json['sourceDeviceId'] as String?,
      userId: json['userId'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Response from completing migration
class CompleteMigrationResponse {
  final bool success;
  final String? userId;
  final String? message;
  final String? warning;

  CompleteMigrationResponse({
    required this.success,
    this.userId,
    this.message,
    this.warning,
  });

  factory CompleteMigrationResponse.fromJson(Map<String, dynamic> json) {
    return CompleteMigrationResponse(
      success: json['success'] as bool? ?? false,
      userId: json['userId'] as String?,
      message: json['message'] as String?,
      warning: json['warning'] as String?,
    );
  }
}

/// Response from cancelling migration
class CancelMigrationResponse {
  final bool success;
  final String? message;

  CancelMigrationResponse({
    required this.success,
    this.message,
  });

  factory CancelMigrationResponse.fromJson(Map<String, dynamic> json) {
    return CancelMigrationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

/// Response from initiating email recovery
class InitiateRecoveryResponse {
  final bool success;
  final String? sessionId;
  final String? message;
  final String? emailMasked;
  final String? expiresAt;
  final String? errorMessage;

  InitiateRecoveryResponse({
    required this.success,
    this.sessionId,
    this.message,
    this.emailMasked,
    this.expiresAt,
    this.errorMessage,
  });

  factory InitiateRecoveryResponse.fromJson(Map<String, dynamic> json) {
    return InitiateRecoveryResponse(
      success: json['success'] as bool? ?? false,
      sessionId: json['sessionId'] as String?,
      message: json['message'] as String?,
      emailMasked: json['emailMasked'] as String?,
      expiresAt: json['expiresAt'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Response from verifying recovery code
class VerifyRecoveryCodeResponse {
  final bool success;
  final String? message;
  final String? errorMessage;

  VerifyRecoveryCodeResponse({
    required this.success,
    this.message,
    this.errorMessage,
  });

  factory VerifyRecoveryCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyRecoveryCodeResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Simple confirm response for migration operations
class ConfirmMigrationResponse {
  final bool success;
  final String? message;
  final String? errorMessage;

  ConfirmMigrationResponse({
    required this.success,
    this.message,
    this.errorMessage,
  });

  factory ConfirmMigrationResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmMigrationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Migration status response
class MigrationStatusResponse {
  final bool success;
  final String? sessionId;
  final String? type; // 'device_to_device' or 'email_recovery'
  final String? status;
  final String? targetPublicKey; // Target device's ephemeral public key for ECDH
  final int? attemptsRemaining;
  final String? expiresAt;
  final String? errorMessage;

  MigrationStatusResponse({
    required this.success,
    this.sessionId,
    this.type,
    this.status,
    this.targetPublicKey,
    this.attemptsRemaining,
    this.expiresAt,
    this.errorMessage,
  });

  factory MigrationStatusResponse.fromJson(Map<String, dynamic> json) {
    return MigrationStatusResponse(
      success: json['success'] as bool? ?? false,
      sessionId: json['sessionId'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      targetPublicKey: json['targetPublicKey'] as String?,
      attemptsRemaining: json['attemptsRemaining'] as int?,
      expiresAt: json['expiresAt'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  /// Returns true if target device has joined (for device-to-device)
  bool get hasTargetJoined =>
    status == 'awaiting_confirmation' ||
    status == 'transferring' ||
    status == 'verified';
}

/// Encrypted migration payload response
class EncryptedMigrationPayloadResponse {
  final String encryptedData;
  final String ephemeralPublicKey;
  final String signature;
  final String sourceDeviceId;
  final String targetDeviceId;
  final String sessionId;
  final int keyVersion;
  final String? sourceSigningPublicKey;

  EncryptedMigrationPayloadResponse({
    required this.encryptedData,
    required this.ephemeralPublicKey,
    required this.signature,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.sessionId,
    this.keyVersion = 1,
    this.sourceSigningPublicKey,
  });

  factory EncryptedMigrationPayloadResponse.fromJson(Map<String, dynamic> json) {
    // Backend wraps payload in 'encryptedPayload' object
    final payload = json['encryptedPayload'] as Map<String, dynamic>? ?? json;
    
    return EncryptedMigrationPayloadResponse(
      encryptedData: payload['encryptedData'] as String,
      ephemeralPublicKey: payload['ephemeralPublicKey'] as String,
      signature: payload['signature'] as String,
      sourceDeviceId: payload['sourceDeviceId'] as String,
      targetDeviceId: payload['targetDeviceId'] as String,
      sessionId: payload['sessionId'] as String,
      keyVersion: payload['keyVersion'] as int? ?? 1,
      sourceSigningPublicKey: payload['sourceSigningPublicKey'] as String?,
    );
  }
}

/// Response from registering a new device
class RegisterDeviceResponse {
  final bool success;
  final String? deviceKeyId;
  final String? message;
  final bool? deviceLimitReached;

  RegisterDeviceResponse({
    required this.success,
    this.deviceKeyId,
    this.message,
    this.deviceLimitReached,
  });

  factory RegisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceResponse(
      success: json['success'] as bool? ?? false,
      deviceKeyId: json['deviceKeyId'] as String?,
      message: json['message'] as String?,
      deviceLimitReached: json['deviceLimitReached'] as bool?,
    );
  }
}

/// Information about a registered device key
class DeviceKeyInfo {
  final String id;
  final String userId;
  final String deviceId;
  final String publicKey;
  final String? deviceName;
  final String? deviceType;
  final String? platform;
  final bool isActive;
  final String? createdAt;
  final String? deactivatedAt;
  final String? deactivationReason;

  DeviceKeyInfo({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.publicKey,
    this.deviceName,
    this.deviceType,
    this.platform,
    required this.isActive,
    this.createdAt,
    this.deactivatedAt,
    this.deactivationReason,
  });

  factory DeviceKeyInfo.fromJson(Map<String, dynamic> json) {
    return DeviceKeyInfo(
      id: json['id'] as String,
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      publicKey: json['publicKey'] as String,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      platform: json['platform'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
      deactivatedAt: json['deactivatedAt'] as String?,
      deactivationReason: json['deactivationReason'] as String?,
    );
  }
}

/// Response containing list of user's devices
class UserDevicesResponse {
  final bool success;
  final List<DeviceKeyInfo>? devices;
  final int? activeDeviceCount;
  final int? totalDeviceCount;

  UserDevicesResponse({
    required this.success,
    this.devices,
    this.activeDeviceCount,
    this.totalDeviceCount,
  });

  factory UserDevicesResponse.fromJson(Map<String, dynamic> json) {
    return UserDevicesResponse(
      success: json['success'] as bool? ?? false,
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => DeviceKeyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeDeviceCount: json['activeDeviceCount'] as int?,
      totalDeviceCount: json['totalDeviceCount'] as int?,
    );
  }
}

/// Response from revoking a device
class RevokeDeviceResponse {
  final bool success;
  final String? message;

  RevokeDeviceResponse({
    required this.success,
    this.message,
  });

  factory RevokeDeviceResponse.fromJson(Map<String, dynamic> json) {
    return RevokeDeviceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

/// Response from updating a device
class UpdateDeviceResponse {
  final bool success;
  final String? message;

  UpdateDeviceResponse({
    required this.success,
    this.message,
  });

  factory UpdateDeviceResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDeviceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

/// Response from migrating a device
class MigrateDeviceResponse {
  final bool success;
  final String? newDeviceKeyId;
  final bool? sourceDeviceDeactivated;
  final String? message;

  MigrateDeviceResponse({
    required this.success,
    this.newDeviceKeyId,
    this.sourceDeviceDeactivated,
    this.message,
  });

  factory MigrateDeviceResponse.fromJson(Map<String, dynamic> json) {
    return MigrateDeviceResponse(
      success: json['success'] as bool? ?? false,
      newDeviceKeyId: json['newDeviceKeyId'] as String?,
      sourceDeviceDeactivated: json['sourceDeviceDeactivated'] as bool?,
      message: json['message'] as String?,
    );
  }
}
