import 'dart:io' show Platform;

import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/router/app_router.dart';
import 'package:barter_app/services/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../configure_dependencies.dart';
import '../models/notifications/notification_models.dart';
import 'api_client.dart';

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Firebase initialized in background handler');
  } catch (e) {
    print('Firebase already initialized (this is normal): $e');
  }
  print('Background message received: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications = LocalNotificationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  
  RemoteMessage? _pendingInitialMessage;
  bool _hasHandledInitialMessage = false;
  bool _isRouterReady = false;

  /// Initialize Firebase and FCM
  Future<void> initialize() async {
    try {
      // Firebase is already initialized in main(), so we skip this
      print('✅ Skipping Firebase.initializeApp() (already done in main.dart)');

      // Initialize local notifications singleton (only once in app)
      await _localNotifications.initialize();

      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request permissions if needed
      //await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);

      // Handle foreground messages
      print('🔔 Setting up onMessage listener...');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📱📱📱 FOREGROUND MESSAGE LISTENER FIRED! 📱📱📱');
        _handleForegroundMessage(message);
      });

      // Handle notification taps (when app is in background)
      print('🔔 Setting up onMessageOpenedApp listener...');
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('📱📱📱 ON MESSAGE OPENED APP FIRED! 📱📱📱');
        print('Message: ${message.messageId}');
        print('Data: ${message.data}');
        
        // If router is ready, handle immediately
        if (_isRouterReady) {
          print('Router is ready, handling immediately');
          _handleNotificationTap(message);
        } else {
          // Router not ready yet (app is still initializing)
          // Store as pending and handle after router is ready
          print('⚠️ Router not ready yet, storing as pending message');
          _pendingInitialMessage = message;
          _hasHandledInitialMessage = false;
        }
      });

      // Check if app was opened from a notification (when app was terminated)
      print('🔔 Checking for initial message...');
      RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('📱📱📱 INITIAL MESSAGE FOUND (APP WAS TERMINATED)! 📱📱📱');
        print('Data: ${initialMessage.data}');
        // Store the initial message to handle after router is ready
        _pendingInitialMessage = initialMessage;
      } else {
        print('No initial message found');
      }

      print('✅ FCM initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
    }
  }

  /// Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      print('🔄 Attempting to get FCM token...');
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        print('✅ FCM Token acquired: $_fcmToken');
      } else {
        print('⚠️ FCM Token is null - this might be a transient issue');
      }
      return _fcmToken;
    } catch (e) {
      print('❌ Failed to get FCM token: $e');
      print('Error type: ${e.runtimeType}');
      
      // Retry logic for transient failures
      print('🔄 Retrying FCM token acquisition in 3 seconds...');
      await Future.delayed(const Duration(seconds: 3));
      
      try {
        _fcmToken = await _firebaseMessaging.getToken();
        if (_fcmToken != null) {
          print('✅ FCM Token acquired on retry: $_fcmToken');
        } else {
          print('⚠️ FCM Token still null after retry');
        }
        return _fcmToken;
      } catch (retryError) {
        print('❌ Failed to get FCM token on retry: $retryError');
        return null;
      }
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String newToken) async {
    print('📱 FCM Token refreshed: $newToken');
    _fcmToken = newToken;

    // Send new token to backend
    await sendTokenToBackend(newToken);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📱 Foreground message received');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Display local notification
    await _showLocalNotification(message);
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final channelId = message.data['channelId'] ?? 'default_channel';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'chat_messages' ? 'Chat Messages' : 'Notifications',
      channelDescription: 'Notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification', // Use the white/transparent notification icon
      largeIcon: notification.android?.imageUrl != null
          ? DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
          : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = _encodePayload(message.data);
    print('📱 Showing local notification with payload: $payload');
    
    await _localNotifications.plugin.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: payload,
    );
    
    print('📱 Local notification displayed successfully');
  }

  /// Mark router as ready and handle any pending messages
  /// Call this from your map screen or main screen after router is fully initialized
  void handlePendingInitialMessage() {
    print('🔔 Router is now ready, checking for pending messages...');
    _isRouterReady = true;
    
    if (!_hasHandledInitialMessage && _pendingInitialMessage != null) {
      print('📱 Handling pending initial message (delayed)');
      print('Pending message data: ${_pendingInitialMessage!.data}');
      _handleNotificationTap(_pendingInitialMessage!);
      _hasHandledInitialMessage = true;
      _pendingInitialMessage = null;
    } else {
      print('No pending messages to handle');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('📱📱📱 _handleNotificationTap CALLED! 📱📱📱');
    print('Message ID: ${message.messageId}');
    print('Data: ${message.data}');
    print('Notification: ${message.notification?.title}');

    final type = message.data['type'];
    print('Notification type: $type');

    // Navigate based on notification type
    switch (type) {
      case 'new_message':
        final senderId = message.data['senderId'];
        print('📍 Navigating to chat with sender: $senderId');
        _navigateToChat(senderId);
        break;
      case 'match':
      case 'wishlist_match':
        final matchId = message.data['matchId'];
        print('📍 Navigating to match: $matchId');
        _navigateToMatch(matchId);
        break;
      case 'new_posting':
        final postingId = message.data['postingId'];
        print('📍 Navigating to posting: $postingId');
        _navigateToPosting(postingId);
        break;
      default:
        print('📍 Navigating to home (unknown type)');
        _navigateToHome();
    }
  }

  // Navigation helpers using go_router
  void _navigateToChat(String? userId) {
    if (userId == null) {
      print('❌ Cannot navigate to chat: userId is null');
      return;
    }
    print('📍 Attempting to navigate to chat with user: $userId');
    try {
      AppRouter.navigateToChat(userId);
      print('✅ Navigation to chat succeeded');
    } catch (e) {
      print('❌ Navigation to chat failed: $e');
    }
  }

  void _navigateToMatch(String? matchId) {
    if (matchId == null) {
      print('❌ Cannot navigate to match: matchId is null');
      return;
    }
    print('📍 Attempting to navigate to match: $matchId');
    try {
      AppRouter.navigateToMatch(matchId);
      print('✅ Navigation to match succeeded');
    } catch (e) {
      print('❌ Navigation to match failed: $e');
    }
  }

  void _navigateToPosting(String? postingId) {
    if (postingId == null) {
      print('❌ Cannot navigate to posting: postingId is null');
      return;
    }
    print('📍 Attempting to navigate to posting: $postingId');
    try {
      AppRouter.navigateToPosting(postingId);
      print('✅ Navigation to posting succeeded');
    } catch (e) {
      print('❌ Navigation to posting failed: $e');
    }
  }

  void _navigateToHome() {
    print('📍 Attempting to navigate to home');
    try {
      AppRouter.navigateToHome();
      print('✅ Navigation to home succeeded');
    } catch (e) {
      print('❌ Navigation to home failed: $e');
    }
  }

  /// Encode data to payload string
  String _encodePayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  /// Send FCM token to backend
  Future<bool> sendTokenToBackend(String token) async {
    try {
      final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';

      final userId = await getIt<UserRepository>().userId ?? "";
      final ApiClient _notificationApi = getIt<ApiClient>();
      final response = await _notificationApi.addPushToken(
          AddPushTokenRequest(token: token, platform: platform, deviceId: userId + "_" + platform)
      );
      
      print('📤 Send token to backend: $token ($platform)');
      return response.success; // Replace with actual API call result
    } catch (e) {
      print('❌ Failed to send token to backend: $e');
      return false;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Failed to subscribe to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Failed to unsubscribe from topic: $e');
    }
  }
  
}