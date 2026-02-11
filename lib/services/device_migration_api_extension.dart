// lib/services/device_migration_api_extension.dart
// API extension methods for device migration
// Add these methods to your ApiClient class

import 'package:barter_app/services/device_migration_service.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'device_migration_api_extension.g.dart'; // Generate with build_runner

/// Extension of ApiClient with device migration endpoints
/// 
/// After adding this file, run:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
@RestApi()
abstract class DeviceMigrationApiClient {
  factory DeviceMigrationApiClient(Dio dio, {String baseUrl}) = _DeviceMigrationApiClient;

  /// Registers a target device for migration
  /// 
  /// POST /api/migration/target
  @POST('/api/migration/target')
  Future<RegisterMigrationTargetResponse> registerMigrationTarget(
    @Body() RegisterMigrationTargetRequest request,
  );

  /// Retrieves the signing public key of a device
  /// 
  /// GET /api/migration/public-key
  @GET('/api/migration/public-key')
  Future<GetMigrationPublicKeyResponse> getMigrationPublicKey(
    @Query('session_id') String sessionId,
    @Query('device_id') String deviceId,
  );

  /// Relays encrypted migration payload
  /// 
  /// POST /api/migration/payload
  @POST('/api/migration/payload')
  Future<ConfirmMigrationResponse> sendMigrationPayload(
    @Body() SendMigrationPayloadRequest request,
  );

  /// Confirms successful migration completion
  /// 
  /// POST /api/migration/complete
  @POST('/api/migration/complete')
  Future<ConfirmMigrationResponse> confirmMigrationComplete(
    @Body() ConfirmMigrationRequest request,
  );

  /// Checks migration session status
  /// 
  /// GET /api/migration/status/{sessionId}
  @GET('/api/migration/status/{sessionId}')
  Future<MigrationStatusResponse> getMigrationStatus(
    @Path('sessionId') String sessionId,
  );
}

// ============================================================================
// REQUEST/RESPONSE MODELS
// ============================================================================

class RegisterMigrationTargetRequest {
  final String sessionId;
  final String targetDeviceId;
  final String targetPublicKey;

  RegisterMigrationTargetRequest({
    required this.sessionId,
    required this.targetDeviceId,
    required this.targetPublicKey,
  });

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'target_device_id': targetDeviceId,
    'target_public_key': targetPublicKey,
  };
}

class SendMigrationPayloadRequest {
  final String sessionId;
  final EncryptedMigrationPayloadData payload;

  SendMigrationPayloadRequest({
    required this.sessionId,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'payload': payload.toJson(),
  };
}

class EncryptedMigrationPayloadData {
  final String encryptedData;
  final String ephemeralPublicKey;
  final String signature;
  final String sourceDeviceId;
  final String targetDeviceId;
  final String sessionId;
  final int keyVersion;

  EncryptedMigrationPayloadData({
    required this.encryptedData,
    required this.ephemeralPublicKey,
    required this.signature,
    required this.sourceDeviceId,
    required this.targetDeviceId,
    required this.sessionId,
    this.keyVersion = 1,
  });

  factory EncryptedMigrationPayloadData.fromDomain(EncryptedMigrationPayload payload) {
    return EncryptedMigrationPayloadData(
      encryptedData: payload.encryptedData,
      ephemeralPublicKey: payload.ephemeralPublicKey,
      signature: payload.signature,
      sourceDeviceId: payload.sourceDeviceId,
      targetDeviceId: payload.targetDeviceId,
      sessionId: payload.sessionId,
      keyVersion: payload.keyVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'encrypted_data': encryptedData,
    'ephemeral_public_key': ephemeralPublicKey,
    'signature': signature,
    'source_device_id': sourceDeviceId,
    'target_device_id': targetDeviceId,
    'session_id': sessionId,
    'key_version': keyVersion,
  };
}

class ConfirmMigrationRequest {
  final String sessionId;
  final String targetDeviceId;

  ConfirmMigrationRequest({
    required this.sessionId,
    required this.targetDeviceId,
  });

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'target_device_id': targetDeviceId,
  };
}

// ============================================================================
// RESPONSE MODELS
// ============================================================================

@JsonSerializable()
class RegisterMigrationTargetResponse {
  final bool success;
  final String? sourceDeviceId;
  final String? userId;
  final bool requiresConfirmation;
  final String? errorMessage;
  final int? expiresInSeconds;

  RegisterMigrationTargetResponse({
    required this.success,
    this.sourceDeviceId,
    this.userId,
    this.requiresConfirmation = true,
    this.errorMessage,
    this.expiresInSeconds,
  });

  factory RegisterMigrationTargetResponse.fromJson(Map<String, dynamic> json) =>
      RegisterMigrationTargetResponse(
        success: json['success'] as bool,
        sourceDeviceId: json['source_device_id'] as String?,
        userId: json['user_id'] as String?,
        requiresConfirmation: json['requires_confirmation'] as bool? ?? true,
        errorMessage: json['error_message'] as String?,
        expiresInSeconds: json['expires_in_seconds'] as int?,
      );
}

@JsonSerializable()
class GetMigrationPublicKeyResponse {
  final bool success;
  final String? publicKey;
  final String? errorMessage;

  GetMigrationPublicKeyResponse({
    required this.success,
    this.publicKey,
    this.errorMessage,
  });

  factory GetMigrationPublicKeyResponse.fromJson(Map<String, dynamic> json) =>
      GetMigrationPublicKeyResponse(
        success: json['success'] as bool,
        publicKey: json['public_key'] as String?,
        errorMessage: json['error_message'] as String?,
      );
}

@JsonSerializable()
class ConfirmMigrationResponse {
  final bool success;
  final String? errorMessage;
  final DateTime? completedAt;

  ConfirmMigrationResponse({
    required this.success,
    this.errorMessage,
    this.completedAt,
  });

  factory ConfirmMigrationResponse.fromJson(Map<String, dynamic> json) =>
      ConfirmMigrationResponse(
        success: json['success'] as bool,
        errorMessage: json['error_message'] as String?,
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
      );
}

@JsonSerializable()
class MigrationStatusResponse {
  final bool success;
  final String? sessionId;
  final String? status;
  final String? sourceDeviceId;
  final String? targetDeviceId;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? errorMessage;

  MigrationStatusResponse({
    required this.success,
    this.sessionId,
    this.status,
    this.sourceDeviceId,
    this.targetDeviceId,
    this.createdAt,
    this.expiresAt,
    this.errorMessage,
  });

  factory MigrationStatusResponse.fromJson(Map<String, dynamic> json) =>
      MigrationStatusResponse(
        success: json['success'] as bool,
        sessionId: json['session_id'] as String?,
        status: json['status'] as String?,
        sourceDeviceId: json['source_device_id'] as String?,
        targetDeviceId: json['target_device_id'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'] as String)
            : null,
        errorMessage: json['error_message'] as String?,
      );
}

// ============================================================================
// MIGRATION EVENT (for push notifications)
// ============================================================================

/// Represents a migration-related event sent via push notification
class MigrationPushEvent {
  final String type; // 'migration_requested', 'migration_approved', 'migration_rejected', 'migration_completed'
  final String sessionId;
  final String? sourceDeviceId;
  final String? targetDeviceId;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  MigrationPushEvent({
    required this.type,
    required this.sessionId,
    this.sourceDeviceId,
    this.targetDeviceId,
    required this.timestamp,
    this.metadata,
  });

  factory MigrationPushEvent.fromJson(Map<String, dynamic> json) {
    return MigrationPushEvent(
      type: json['type'] as String,
      sessionId: json['session_id'] as String,
      sourceDeviceId: json['source_device_id'] as String?,
      targetDeviceId: json['target_device_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'session_id': sessionId,
    'source_device_id': sourceDeviceId,
    'target_device_id': targetDeviceId,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}
