// Device Migration and Management Response Models
// These classes represent API responses for device management operations

/// Response from registering a migration target device
class RegisterMigrationTargetResponse {
  final bool success;
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;

  RegisterMigrationTargetResponse({
    required this.success,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
  });

  factory RegisterMigrationTargetResponse.fromJson(Map<String, dynamic> json) {
    return RegisterMigrationTargetResponse(
      success: json['success'] as bool? ?? false,
      sourceDeviceId: json['sourceDeviceId'] as String?,
      userId: json['userId'] as String?,
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? true,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Response from getting a migration public key
class GetMigrationPublicKeyResponse {
  final bool success;
  final String? publicKey;
  final String? errorMessage;

  GetMigrationPublicKeyResponse({
    required this.success,
    this.publicKey,
    this.errorMessage,
  });

  factory GetMigrationPublicKeyResponse.fromJson(Map<String, dynamic> json) {
    return GetMigrationPublicKeyResponse(
      success: json['success'] as bool? ?? false,
      publicKey: json['publicKey'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Response from confirming migration completion
class ConfirmMigrationResponse {
  final bool success;
  final String? errorMessage;

  ConfirmMigrationResponse({
    required this.success,
    this.errorMessage,
  });

  factory ConfirmMigrationResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmMigrationResponse(
      success: json['success'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Migration status response
class MigrationStatusResponse {
  final bool success;
  final String? sessionId;
  final String? status;
  final String? sourceDeviceId;
  final String? targetDeviceId;
  final String? targetPublicKey;
  final String? createdAt;
  final String? expiresAt;
  final String? errorMessage;

  MigrationStatusResponse({
    required this.success,
    this.sessionId,
    this.status,
    this.sourceDeviceId,
    this.targetDeviceId,
    this.targetPublicKey,
    this.createdAt,
    this.expiresAt,
    this.errorMessage,
  });

  factory MigrationStatusResponse.fromJson(Map<String, dynamic> json) {
    return MigrationStatusResponse(
      success: json['success'] as bool? ?? false,
      sessionId: json['sessionId'] as String?,
      status: json['status'] as String?,
      sourceDeviceId: json['sourceDeviceId'] as String?,
      targetDeviceId: json['targetDeviceId'] as String?,
      targetPublicKey: json['targetPublicKey'] as String?,
      createdAt: json['createdAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  /// Returns true if target device has joined
  bool get hasTargetJoined =>
    targetDeviceId != null &&
    targetDeviceId != 'PENDING' &&
    targetPublicKey != null;
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

  EncryptedMigrationPayloadResponse({
    required this.encryptedData,
    required this.ephemeralPublicKey,
    required this.signature,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.sessionId,
    this.keyVersion = 1,
  });

  factory EncryptedMigrationPayloadResponse.fromJson(Map<String, dynamic> json) {
    return EncryptedMigrationPayloadResponse(
      encryptedData: json['encryptedData'] as String,
      ephemeralPublicKey: json['ephemeralPublicKey'] as String,
      signature: json['signature'] as String,
      sourceDeviceId: json['sourceDeviceId'] as String,
      targetDeviceId: json['targetDeviceId'] as String,
      sessionId: json['sessionId'] as String,
      keyVersion: json['keyVersion'] as int? ?? 1,
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
