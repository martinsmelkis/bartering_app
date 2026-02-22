import 'dart:async';
import 'dart:convert';
import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../models/chat/chat_message.dart';
import '../../models/chat/e_chat_message_status.dart';
import 'local_notification_service.dart';

/// Service to handle chat message notifications when user is not in chat screen
/// NOTE: This service uses the LocalNotificationService singleton
@singleton
class ChatNotificationService with WidgetsBindingObserver {
  final LocalNotificationService _notificationService = LocalNotificationService();
  final ApiClient _apiClient;

  // Track if user is currently viewing a specific chat
  String? _activeChatUserId;
  bool _isInForeground = true;

  // Notification tap callback - set this from your app to handle navigation
  Function(String userId)? onNotificationTap;
  
  bool _isInitialized = false;

  /// Constructor for dependency injection
  ChatNotificationService(this._apiClient);

  /// Initialize the notification service
  /// Uses the LocalNotificationService singleton which may already be initialized
  Future<void> initialize() async {
    if (!_isInitialized) {
      // Initialize the singleton (safe to call multiple times)
      await _notificationService.initialize();
      _isInitialized = true;
      logDebug('✅ Chat notification service initialized');
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
    // Don't show notification for messages that are already marked as read
    if (message.status == EChatMessageStatus.read) {
      debugPrint('🔕 Notification suppressed: Message already marked as read');
      return false;
    }

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
  /// GDPR-compliant: Records user consent via updateNotificationContacts when permission granted
  Future<bool?> requestNotificationPermission() async {
    if (!kIsWeb) {
      final androidImplementation = _notificationService.plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final permissionGranted = await androidImplementation?.requestNotificationsPermission();
      
      // GDPR: If permission granted, update backend to record user's explicit consent
      if (permissionGranted == true) {
        await _recordNotificationConsent();
      }
      
      return permissionGranted;
    }
    return null;
  }
  
  /// GDPR-compliant: Records user consent for push notifications to backend
  /// Called when user explicitly grants notification permission
  Future<void> _recordNotificationConsent() async {
    try {
      logDebug('🔔 Recording notification consent (GDPR-compliant)');
      
      await _apiClient.updateNotificationContacts(
        UpdateUserNotificationContactsRequest(
          notificationsEnabled: true,
        ),
      );
      
      logDebug('✅ Notification consent recorded successfully');
    } catch (e) {
      // Log but don't fail - permission was already granted locally
      logDebug('⚠️ Failed to record notification consent: $e');
    }
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
          // Make notification temporary when app is in foreground
          autoCancel: true, // Automatically remove when tapped
          ongoing: false, // Not an ongoing notification
          onlyAlertOnce: true, // Don't alert for updates
          //timeoutAfter: _isInForeground ? 5000 : null, // Auto-dismiss after 5s if in foreground
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

  /// Cancel notifications for a specific user (when messages are read)
  Future<void> cancelNotificationsForUser(String userId) async {
    try {
      await _notificationService.plugin.cancel(userId.hashCode);
      debugPrint('🔕 Cancelled notifications for user: $userId');
    } catch (e) {
      debugPrint('❌ Error cancelling notifications: $e');
    }
  }

  /// Cancel all chat notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.plugin.cancelAll();
      debugPrint('🔕 Cancelled all notifications');
    } catch (e) {
      debugPrint('❌ Error cancelling all notifications: $e');
    }
  }

  /// Cleanup
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

}