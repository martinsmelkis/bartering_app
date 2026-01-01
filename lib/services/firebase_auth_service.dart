import 'dart:io';

import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/services/api_client.dart';

import '../configure_dependencies.dart';
import 'firebase_service.dart';

class FCMTokenService {
  final ApiClient _notificationApi = getIt<ApiClient>();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> onSessionStarted(String userId) async {
    // Get FCM token
    final token = _firebaseService.fcmToken;
    if (token == null) {
      print('⚠️ FCM token not available');
      return;
    }

    // Send to backend
    final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
    final success = await _notificationApi.addPushToken(
      AddPushTokenRequest(token: token, platform: platform, deviceId: userId + "_" + platform)
    );

    if (success.success != false) {
      print('✅ Push token registered for user: $userId');
    } else {
      print('❌ Failed to register push token');
    }

    // Subscribe to user-specific topics if needed
    await _firebaseService.subscribeToTopic('user_$userId');
  }

  Future<void> onSessionEnded(String userId) async {
    final token = _firebaseService.fcmToken;
    if (token != null) {
      await _notificationApi.removePushToken(
        token,
      );
    }

    // Unsubscribe from topics
    await _firebaseService.unsubscribeFromTopic('user_$userId');
  }
}