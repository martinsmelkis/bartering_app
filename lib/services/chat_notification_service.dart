import 'dart:async';
import 'dart:convert';
import 'package:barter_app/services/local_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../models/chat/chat_message.dart';

/// Service to handle chat message notifications when user is not in chat screen
/// NOTE: This service uses the LocalNotificationService singleton
@singleton
class ChatNotificationService with WidgetsBindingObserver {
  final LocalNotificationService _notificationService = LocalNotificationService();

  // Track if user is currently viewing a specific chat
  String? _activeChatUserId;
  bool _isInForeground = true;

  // Notification tap callback - set this from your app to handle navigation
  Function(String userId)? onNotificationTap;
  
  bool _isInitialized = false;

  /// Initialize the notification service
  /// Uses the LocalNotificationService singleton which may already be initialized
  Future<void> initialize() async {
    if (!_isInitialized) {
      // Initialize the singleton (safe to call multiple times)
      await _notificationService.initialize();
      _isInitialized = true;
      print('✅ Chat notification service initialized');
    }

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  /// Set the currently active chat (when user opens a chat screen)
  void setActiveChat(String? userId) {
    _activeChatUserId = userId;
    debugPrint('📱 Active chat set to: $userId');
  }

  /// Check if we should show notification for this message
  bool _shouldShowNotification(ChatMessage message) {
    // Don't show if app is in foreground and user is viewing this specific chat
    if (_isInForeground && _activeChatUserId == message.senderId) {
      debugPrint('🔕 Notification suppressed: User is in chat with ${message
          .senderId}');
      return false;
    }

    // Don't show notification for messages sent by current user
    if (message.isSentByCurrentUser) {
      return false;
    }

    return true;
  }

  /// Handle incoming chat message and show notification if appropriate
  Future<void> handleIncomingMessage(ChatMessage message,
      {String? senderName}) async {
    if (!_shouldShowNotification(message)) {
      return;
    }

    final title = senderName ?? 'New Message';
    final body = message.plainText ?? 'You have a new message';

    await _showNotification(
      title: title,
      body: body,
      userId: message.senderId,
    );

    debugPrint('🔔 Notification shown for message from ${message.senderId}');
  }

  /// Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isInForeground = true;
        debugPrint('📱 App resumed');
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _isInForeground = false;
        debugPrint('📱 App backgrounded');
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Request notification permissions
  Future<bool?> requestNotificationPermission() async {
    if (!kIsWeb) {
      final androidImplementation = _notificationService.plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      return await androidImplementation?.requestNotificationsPermission();
    }
    return null;
  }

  /// Show local notification
  Future<void> _showNotification({
    required String title,
    required String body,
    required String userId,
  }) async {
    await _notificationService.plugin.show(
      userId.hashCode,
      // Use userId hash as notification ID (replaces old notifications from same user)
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_messages',
          'Chat Messages',
          channelDescription: 'Notifications for new chat messages',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_notification',
          enableVibration: true,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode({'userId': userId, 'action': 'open_chat'}),
    );
  }



  /// Cleanup
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

}