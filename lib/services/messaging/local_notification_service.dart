import 'dart:convert';
import 'dart:io' show Platform;

import 'package:barter_app/router/app_router.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Singleton service to manage local notifications
/// This ensures only ONE initialization of FlutterLocalNotificationsPlugin
/// Note: Web is not supported by flutter_local_notifications
class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  FlutterLocalNotificationsPlugin get plugin => _notifications;

  /// Check if local notifications are supported on this platform
  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  /// Initialize local notifications (call only once in app)
  Future<void> initialize() async {
    // Skip on web - not supported
    if (kIsWeb) {
      logDebug('🔔 Local notifications not supported on web, skipping initialization');
      return;
    }

    if (_isInitialized) {
      logDebug('⚠️ Local notifications already initialized, skipping...');
      return;
    }

    logDebug('🔔 Initializing local notifications...');

    const androidSettings = AndroidInitializationSettings('ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

      logDebug('🔔 Setting up notification tap handler...');
    final bool? initialized;
    try {
      initialized = await (_notifications as dynamic).initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          logDebug('🔔🔔🔔 NOTIFICATION TAP RECEIVED IN HANDLER! 🔔🔔🔔');
          logDebug('Response: ${response.payload}');
          _onNotificationTap(response);
        },
      ) as bool?;
    } catch (_) {
      initialized = await (_notifications as dynamic).initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          logDebug('🔔🔔🔔 NOTIFICATION TAP RECEIVED IN HANDLER! 🔔🔔🔔');
          logDebug('Response: ${response.payload}');
          _onNotificationTap(response);
        },
      ) as bool?;
    }

      logDebug('🔔 Notification initialization result: $initialized');

    // Create notification channels for Android (not on web)
    if (!kIsWeb && Platform.isAndroid) {
      await _createNotificationChannels();
    }

    _isInitialized = true;
    logDebug('✅ Local notifications initialized successfully');
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'General notifications',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'chat_messages',
        'Chat Messages',
        description: 'New message notifications',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('default'),
      ),
      AndroidNotificationChannel(
        'matches',
        'Matches',
        description: 'Match notifications',
        importance: Importance.high,
      ),
    ];

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      for (final channel in channels) {
        await androidImplementation.createNotificationChannel(channel);
      }
    }
  }

  /// Unified notification tap handler
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;

      logDebug('📱 Local notification tapped!');
      logDebug('Payload: ${response.payload}');

    try {
      // Try to parse as query string (FCM format: type=xxx&senderId=yyy)
      if (response.payload!.contains('=')) {
        final data = _decodeQueryString(response.payload!);
        logDebug('📱 FCM notification tapped: $data');
        _handleFCMNotification(data);
        return;
      }

      // Try to parse as JSON (Chat format: {"userId":"xxx","action":"open_chat"})
      if (response.payload!.startsWith('{')) {
        final Map<String, dynamic> data = json.decode(response.payload!);
        logDebug('📱 Chat notification tapped: $data');
        _handleChatNotification(data);
        return;
      }

      // Handle deep link format (barter://chat/xxx)
      if (response.payload!.startsWith('barter://')) {
        final uri = Uri.parse(response.payload!);
        if (uri.pathSegments.isNotEmpty) {
          final userId = uri.pathSegments.last;
          logDebug('📱 Deep link notification tapped: userId=$userId');
          AppRouter.navigateToChat(userId);
        }
        return;
      }

      logDebug('⚠️ Unknown payload format: ${response.payload}');
    } catch (e) {
      logDebug('❌ Error handling notification tap: $e');
    }
  }

  /// Handle FCM notification tap
  void _handleFCMNotification(Map<String, String> data) {
    final type = data['type'];

    switch (type) {
      case 'new_message':
        final senderId = data['senderId'];
        if (senderId != null) {
          logDebug('📍 Navigating to chat: $senderId');
          AppRouter.navigateToChat(senderId);
        }
        break;
      case 'match':
      case 'wishlist_match':
        final matchId = data['matchId'];
        if (matchId != null) {
          logDebug('📍 Navigating to match: $matchId');
          AppRouter.navigateToMatch(matchId);
        }
        break;
      case 'new_posting':
        final postingId = data['postingId'];
        if (postingId != null) {
          logDebug('📍 Navigating to posting: $postingId');
          AppRouter.navigateToPosting(postingId);
        }
        break;
      default:
        logDebug('📍 Navigating to home');
        AppRouter.navigateToHome();
    }
  }

  /// Handle chat notification tap
  void _handleChatNotification(Map<String, dynamic> data) {
    final userId = data['userId'] as String?;
    if (userId != null) {
      logDebug('📍 Navigating to chat: $userId');
      AppRouter.navigateToChat(userId);
    }
  }

  /// Decode query string payload (e.g., "type=new_message&senderId=123")
  Map<String, String> _decodeQueryString(String payload) {
    final map = <String, String>{};
    for (final pair in payload.split('&')) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }
}
