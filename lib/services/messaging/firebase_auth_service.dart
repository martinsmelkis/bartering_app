import 'dart:io';

import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';

import '../../configure_dependencies.dart';
import 'firebase_service.dart';

class FCMTokenService {
  final ApiClient _notificationApi = getIt<ApiClient>();
  FirebaseService? _firebaseService;

  FirebaseService? get _firebase {
    if (kIsWeb) return null;
    _firebaseService ??= FirebaseService();
    return _firebaseService;
  }

  Future<void> onSessionStarted(String userId) async {
    // Skip FCM on web - uses WebSocket instead
    if (kIsWeb) {
      logDebug('🔔 Skipping FCM token registration on web (using WebSocket)');
      return;
    }

    // Get FCM token
    final token = _firebase?.fcmToken;
    if (token == null) {
      logDebug('⚠️ FCM token not available');
      return;
    }

    // Send to backend
    final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
    final success = await _notificationApi.addPushToken(
      AddPushTokenRequest(token: token, platform: platform, deviceId: userId + "_" + platform)
    );

    if (success.success != false) {
      logDebug('✅ Push token registered for user: $userId');
    } else {
      logDebug('❌ Failed to register push token');
    }

    // Subscribe to user-specific topics if needed
    await _firebase?.subscribeToTopic('user_$userId');
  }

  Future<void> onSessionEnded(String userId) async {
    // Skip FCM on web
    if (kIsWeb) return;

    final token = _firebase?.fcmToken;
    if (token != null) {
      await _notificationApi.removePushToken(
        token,
      );
    }

    // Unsubscribe from topics
    await _firebase?.unsubscribeFromTopic('user_$userId');
  }
}