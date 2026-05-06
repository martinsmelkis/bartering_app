import 'dart:io' show Platform;

import 'package:barter_app/models/chat/chat_message.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/router/app_router.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../configure_dependencies.dart';
import '../../firebase_options.dart';
import '../../models/notifications/notification_models.dart';
import '../api_client.dart';
import 'local_notification_service.dart';

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logDebug('Firebase initialized in background handler');
  } catch (e) {
    logDebug('Firebase already initialized (this is normal): $e');
  }
  logDebug('📱 Background message received: ${message.messageId}');
  logDebug('Title: ${message.notification?.title}');
  logDebug('Body: ${message.notification?.body}');
  logDebug('Data: ${message.data}');
  
  // Handle chat messages in background
  final type = message.data['type'];
  if (type == 'new_message') {
    logDebug('💾 Saving chat message from background FCM...');
    // Note: In background handler, we can't easily access dependency injection
    // The message will be saved when the app is opened and syncs
    // Or we could initialize dependencies here if needed
    logDebug('⚠️ Message will be synced when app opens or via WebSocket');
  }
}

class FirebaseService with WidgetsBindingObserver {
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
  bool _isAppInForeground = true; // Track app lifecycle state
  
  // Reference to ChatsBadgeCubit for updating badge on FCM messages
  static ChatsBadgeCubit? _chatsBadgeCubit;
  
  /// Set the ChatsBadgeCubit instance to receive updates
  void setChatsBadgeCubit(ChatsBadgeCubit cubit) {
    _chatsBadgeCubit = cubit;
    logDebug('✅ ChatsBadgeCubit registered with FirebaseService');
  }

  /// Initialize Firebase and FCM
  Future<void> initialize() async {
    try {
      // Firebase is already initialized in main(), so we skip this
      logDebug('✅ Skipping Firebase.initializeApp() (already done in main.dart)');

      // Register as lifecycle observer
      WidgetsBinding.instance.addObserver(this);
      logDebug('✅ FirebaseService registered as lifecycle observer');

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
      logDebug('🔔 Setting up onMessage listener...');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logDebug('📱📱📱 FOREGROUND MESSAGE LISTENER FIRED! 📱📱📱');
        _handleForegroundMessage(message);
      });

      // Handle notification taps (when app is in background)
      logDebug('🔔 Setting up onMessageOpenedApp listener...');
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logDebug('📱📱📱 ON MESSAGE OPENED APP FIRED! 📱📱📱');
        logDebug('Message: ${message.messageId}');
        logDebug('Data: ${message.data}');
        
        // If router is ready, handle immediately
        if (_isRouterReady) {
          logDebug('Router is ready, handling immediately');
          _handleNotificationTap(message);
        } else {
          // Router not ready yet (app is still initializing)
          // Store as pending and handle after router is ready
          logDebug('⚠️ Router not ready yet, storing as pending message');
          _pendingInitialMessage = message;
          _hasHandledInitialMessage = false;
        }
      });

      // Check if app was opened from a notification (when app was terminated)
      logDebug('🔔 Checking for initial message...');
      RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        logDebug('📱📱📱 INITIAL MESSAGE FOUND (APP WAS TERMINATED)! 📱📱📱');
        logDebug('Data: ${initialMessage.data}');
        // Store the initial message to handle after router is ready
        _pendingInitialMessage = initialMessage;
      } else {
        logDebug('No initial message found');
      }

      logDebug('✅ FCM initialized successfully');
    } catch (e) {
      logDebug('❌ Firebase initialization failed: $e');
    }
  }

  /// Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isAppInForeground = true;
        logDebug('📱 App resumed (foreground)');
        
        // Refresh chat badge when app comes to foreground
        // This catches any messages that arrived while in background
        if (_chatsBadgeCubit != null) {
          _chatsBadgeCubit!.refresh().then((_) {
            logDebug('✅ Chat badge refreshed on app resume');
          }).catchError((error) {
            logDebug('❌ Failed to refresh chat badge on resume: $error');
          });
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _isAppInForeground = false;
        logDebug('📱 App paused/inactive (background)');
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _isAppInForeground = false;
        logDebug('📱 App detached/hidden');
        break;
    }
  }

  /// Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      logDebug('🔄 Attempting to get FCM token...');
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        logDebug('✅ FCM Token acquired: $_fcmToken');
      } else {
        logDebug('⚠️ FCM Token is null - this might be a transient issue');
      }
      return _fcmToken;
    } catch (e) {
      logDebug('❌ Failed to get FCM token: $e');
      logDebug('Error type: ${e.runtimeType}');
      
      // Retry logic for transient failures
      logDebug('🔄 Retrying FCM token acquisition in 3 seconds...');
      await Future.delayed(const Duration(seconds: 3));
      
      try {
        _fcmToken = await _firebaseMessaging.getToken();
        if (_fcmToken != null) {
          logDebug('✅ FCM Token acquired on retry: $_fcmToken');
        } else {
          logDebug('⚠️ FCM Token still null after retry');
        }
        return _fcmToken;
      } catch (retryError) {
        logDebug('❌ Failed to get FCM token on retry: $retryError');
        return null;
      }
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String newToken) async {
    logDebug('📱 FCM Token refreshed: $newToken');
    _fcmToken = newToken;

    // Send new token to backend
    await sendTokenToBackend(newToken);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    logDebug('📱 Foreground message received');
    logDebug('Title: ${message.notification?.title}');
    logDebug('Body: ${message.notification?.body}');
    logDebug('Data: ${message.data}');

    final type = message.data['type'];
    
    // Check if this is a match notification
    if (type == 'match' || type == 'wishlist_match') {
      logDebug('📱 Match notification received, reloading match history...');
      try {
        final notificationsCubit = getIt<NotificationsCubit>();
        await notificationsCubit.loadMatchHistory();
        logDebug('✅ Match history reloaded');
      } catch (e) {
        logDebug('❌ Failed to reload match history: $e');
      }
    }
    
    // Check if this is a chat message notification
    if (type == 'new_message') {
      logDebug('📱 Chat message notification received via FCM');
      
      // Save the message to the database first
      await _saveChatMessageFromFCM(message.data);
      
      // Then refresh the badge ONLY if app is in foreground
      // (when in background, badge will be updated when app resumes)
      if (_isAppInForeground && _chatsBadgeCubit != null) {
        try {
          await _chatsBadgeCubit!.refresh();
          logDebug('✅ Chat badge refreshed after saving FCM message (foreground)');
        } catch (e) {
          logDebug('❌ Failed to refresh chat badge: $e');
        }
      } else if (!_isAppInForeground) {
        logDebug('ℹ️ App in background, skipping chat badge refresh (will update on resume)');
      } else {
        logDebug('⚠️ ChatsBadgeCubit not registered with FirebaseService');
      }
    }

    // Display local notification
    await _showLocalNotification(message);
  }

  /// Save chat message from FCM data to local database
  Future<void> _saveChatMessageFromFCM(Map<String, dynamic> data) async {
    try {
      logDebug('💾 Attempting to save FCM chat message to database...');
      
      // Extract message data from FCM payload
      final messageId = data['messageId'] as String?;
      final senderId = data['senderId'] as String?;
      final recipientId = data['recipientId'] as String?;
      final encryptedContent = data['encryptedContent'] as String?;
      final timestampMs = data['timestamp'] as String?;
      
      // Validate required fields
      if (messageId == null || senderId == null || recipientId == null || encryptedContent == null) {
        logDebug('⚠️ Missing required fields in FCM message data');
        logDebug('messageId: $messageId, senderId: $senderId, recipientId: $recipientId, encrypted: ${encryptedContent != null}');
        return;
      }
      
      // Get current user ID
      final userRepository = getIt<UserRepository>();
      final currentUserId = await userRepository.getUserId();
      
      if (currentUserId == null) {
        logDebug('❌ Current user ID not available, cannot save message');
        return;
      }
      
      // Parse timestamp
      DateTime timestamp;
      if (timestampMs != null) {
        try {
          timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(timestampMs));
        } catch (e) {
          timestamp = DateTime.now();
        }
      } else {
        timestamp = DateTime.now();
      }
      
      // Create ChatMessage object
      final chatMessage = ChatMessage(
        id: messageId,
        senderId: senderId,
        recipientId: recipientId,
        encryptedTextPayload: encryptedContent,
        plainText: null, // Will be decrypted when user opens chat
        timestamp: timestamp,
        isSentByCurrentUser: senderId == currentUserId,
      );
      
      // Get or create conversation
      final chatRepository = getIt<ChatRepository>();
      final conversation = await chatRepository.getOrCreateConversation(
        userId1: currentUserId,
        userId2: senderId == currentUserId ? recipientId : senderId,
      );
      
      // Save message to database
      await chatRepository.saveMessage(chatMessage, conversation.conversationId);
      
      logDebug('✅ FCM chat message saved to database successfully');
      logDebug('   Message ID: $messageId');
      logDebug('   Conversation ID: ${conversation.conversationId}');
      logDebug('   Sender: $senderId');
      
    } catch (e) {
      logDebug('❌ Error saving FCM chat message to database: $e');
      logDebug('Stack trace: ${StackTrace.current}');
    }
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final channelId = message.data['channelId'] ?? 'default_channel';

    // Only make notification temporary if app is in foreground
    // When app goes to background, notification should persist normally
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
      // Make notification temporary ONLY when app is in foreground
      autoCancel: true, // Automatically remove when tapped
      ongoing: true, // Not an ongoing notification
      onlyAlertOnce: true, // Don't alert for updates
      //timeoutAfter: _isAppInForeground ? 5000 : null, // Auto-dismiss after 5s only in foreground
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
    final notificationType = _isAppInForeground ? 'temporary (5s auto-dismiss)' : 'persistent';
    logDebug('📱 Showing $notificationType local notification with payload: $payload');
    
    // Normalize title and body to handle attribute IDs
    final normalizedTitle = TextUtils.normalizeNotificationText(notification.title);
    final normalizedBody = TextUtils.normalizeNotificationText(notification.body);
    
    final plugin = _localNotifications.plugin as dynamic;
    try {
      await Function.apply(
        plugin.show,
        [message.hashCode, normalizedTitle, normalizedBody, details],
        {#payload: payload},
      );
    } catch (_) {
      await Function.apply(
        plugin.show,
        [],
        {
          #id: message.hashCode,
          #title: normalizedTitle,
          #body: normalizedBody,
          #notificationDetails: details,
          #payload: payload,
        },
      );
    }
    
    logDebug('📱 Local notification displayed: $notificationType');
  }

  /// Mark router as ready and handle any pending messages
  /// Call this from your map screen or main screen after router is fully initialized
  void handlePendingInitialMessage() {
    logDebug('🔔 Router is now ready, checking for pending messages...');
    _isRouterReady = true;
    
    if (!_hasHandledInitialMessage && _pendingInitialMessage != null) {
      logDebug('📱 Handling pending initial message (delayed)');
      logDebug('Pending message data: ${_pendingInitialMessage!.data}');
      _handleNotificationTap(_pendingInitialMessage!);
      _hasHandledInitialMessage = true;
      _pendingInitialMessage = null;
    } else {
      logDebug('No pending messages to handle');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    logDebug('📱📱📱 _handleNotificationTap CALLED! 📱📱📱');
    logDebug('Message ID: ${message.messageId}');
    logDebug('Data: ${message.data}');
    logDebug('Notification: ${message.notification?.title}');

    final type = message.data['type'];
    logDebug('Notification type: $type');

    // Navigate based on notification type
    switch (type) {
      case 'new_message':
        final senderId = message.data['senderId'];
        logDebug('📍 Navigating to chat with sender: $senderId');
        _navigateToChat(senderId);
        break;
      case 'match':
      case 'wishlist_match':
        final matchId = message.data['matchId'];
        logDebug('📍 Navigating to match: $matchId');
        _navigateToMatch(matchId);
        break;
      case 'new_posting':
        final postingId = message.data['postingId'];
        logDebug('📍 Navigating to posting: $postingId');
        _navigateToPosting(postingId);
        break;
      default:
        logDebug('📍 Navigating to home (unknown type)');
        _navigateToHome();
    }
  }

  // Navigation helpers using go_router
  void _navigateToChat(String? userId) {
    if (userId == null) {
      logDebug('❌ Cannot navigate to chat: userId is null');
      return;
    }
    logDebug('📍 Attempting to navigate to chat with user: $userId');
    try {
      AppRouter.navigateToChat(userId);
      logDebug('✅ Navigation to chat succeeded');
    } catch (e) {
      logDebug('❌ Navigation to chat failed: $e');
    }
  }

  void _navigateToMatch(String? matchId) {
    if (matchId == null) {
      logDebug('❌ Cannot navigate to match: matchId is null');
      return;
    }
    logDebug('📍 Attempting to navigate to match: $matchId');
    try {
      AppRouter.navigateToMatch(matchId);
      logDebug('✅ Navigation to match succeeded');
    } catch (e) {
      logDebug('❌ Navigation to match failed: $e');
    }
  }

  void _navigateToPosting(String? postingId) {
    if (postingId == null) {
      logDebug('❌ Cannot navigate to posting: postingId is null');
      return;
    }
    logDebug('📍 Attempting to navigate to posting: $postingId');
    try {
      AppRouter.navigateToPosting(postingId);
      logDebug('✅ Navigation to posting succeeded');
    } catch (e) {
      logDebug('❌ Navigation to posting failed: $e');
    }
  }

  void _navigateToHome() {
    logDebug('📍 Attempting to navigate to home');
    try {
      AppRouter.navigateToHome();
      logDebug('✅ Navigation to home succeeded');
    } catch (e) {
      logDebug('❌ Navigation to home failed: $e');
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
      
      logDebug('📤 Send token to backend: $token ($platform)');
      return response.success; // Replace with actual API call result
    } catch (e) {
      logDebug('❌ Failed to send token to backend: $e');
      return false;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      logDebug('✅ Subscribed to topic: $topic');
    } catch (e) {
      logDebug('❌ Failed to subscribe to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      logDebug('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      logDebug('❌ Failed to unsubscribe from topic: $e');
    }
  }

  /// Cleanup
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
  
}