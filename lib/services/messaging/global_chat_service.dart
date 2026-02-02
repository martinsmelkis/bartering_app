import 'dart:async';
import 'dart:convert';
import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/chats_list_screen/cubit/chats_badge_cubit.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/messaging/chat_notification_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import '../../models/chat/auth_request.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/e_chat_message_status.dart';
import '../../screens/chat_screen/services/websocket_chat_service.dart';

/// Global chat service that maintains a WebSocket connection with "general" purpose
/// for receiving messages across the app without opening individual chats.
/// 
/// Multi-connection architecture:
/// - "general" connection: for global chat, notifications, background P2P auth
/// - "direct-chat" connection: for 1:1 conversations (created when entering a chat)
/// 
/// Platform behavior:
/// - Web: Always connected (efficient, no battery concerns)
/// - Mobile: Connected in foreground, disconnected in background (relies on push notifications)
@singleton
class GlobalChatService with WidgetsBindingObserver {
  WebSocketChatService? _webSocketService;
  CryptoService? _cryptoService;
  String? _currentUserId;
  String? _currentUserName;
  bool _isInitialized = false;
  bool _isConnected = false;
  bool _isInForeground = true;

  // Connection purpose constant
  static const String connectionPurpose = 'general';

  // Track processed messages to avoid duplicates
  final Set<String> _processedMessageIds = {};
  static const int _maxProcessedMessages = 100; // Keep last 100 message IDs

  StreamSubscription? _messageSubscription;
  StreamSubscription? _statusUpdateSubscription;
  StreamSubscription? _readReceiptSubscription;

  /// Initialize the global chat service
  /// This should be called after user authentication and map initialization
  Future<void> initialize() async {
    if (_isInitialized) {
      logDebug('🔌 Global chat service already initialized');
      return;
    }

    try {
      // Get user info
      final userRepository = getIt<UserRepository>();
      _currentUserId = await userRepository.getUserId();
      _currentUserName = await userRepository.getUserName();

      if (_currentUserId == null || _currentUserName == null) {
        logDebug('❌ Cannot initialize global chat: user not authenticated');
        return;
      }

      // Initialize crypto service
      _cryptoService = await CryptoService.create();
      if (_cryptoService == null || !_cryptoService!.isReady) {
        logDebug('❌ Cannot initialize global chat: crypto service failed');
        return;
      }

      // Register lifecycle observer for mobile
      if (!kIsWeb) {
        WidgetsBinding.instance.addObserver(this);
        logDebug('📱 Registered lifecycle observer for mobile');
      }

      _isInitialized = true;
      logDebug('✅ Global chat service initialized for user: $_currentUserId (purpose: $connectionPurpose)');

      // Auto-connect based on platform
      await _connectIfAppropriate();
    } catch (e) {
      logDebug('❌ Error initializing global chat service: $e');
    }
  }

  /// Connect to WebSocket if appropriate for the platform
  Future<void> _connectIfAppropriate() async {
    if (kIsWeb) {
      // Web: Always connect
      await connect();
    } else {
      // Mobile: Only connect if in foreground
      if (_isInForeground) {
        await connect();
      } else {
        logDebug('📱 App in background, skipping WebSocket connection (will use push notifications)');
      }
    }
  }

  /// Connect to the global WebSocket with "general" purpose
  Future<void> connect() async {
    if (_isConnected || !_isInitialized) {
      return;
    }

    try {
      logDebug('🔌 Connecting global WebSocket (purpose: $connectionPurpose)...');

      // Get notification service
      ChatNotificationService? notificationService;
      try {
        notificationService = getIt<ChatNotificationService>();
      } catch (e) {
        logDebug('⚠️ ChatNotificationService not available: $e');
      }

      // Get WebSocket URL from environment
      final wsUrl = kIsWeb 
          ? (dotenv.env['WSS_URL_WEB'] ?? 'ws://localhost:8081/chat')
          : (dotenv.env['WSS_URL_MOBILE'] ?? 'ws://10.0.2.2/chat');

      logDebug('🔌 Global WebSocket URL: $wsUrl');

      // Create WebSocket service
      _webSocketService = WebSocketChatService(
        _cryptoService!,
        _currentUserId!,
        _currentUserName!,
        wsUrl,
        notificationService: notificationService,
      );

      // Connect to WebSocket
      _webSocketService?.connect(_currentUserId!);

      // Authenticate with GLOBAL peer - this keeps the connection alive
      // The server will recognize this as a "general" purpose connection
      await _authenticate();

      // Listen to messages and save them to database
      _listenToMessages();

      _isConnected = true;
      logDebug('✅ Global WebSocket connected (purpose: $connectionPurpose)');
    } catch (e) {
      logDebug('❌ Error connecting global WebSocket: $e');
    }
  }

  /// Authenticate with the WebSocket server with GLOBAL purpose
  Future<void> _authenticate() async {
    try {
      final secureStorage = SecureStorageService();
      final pubKey = await secureStorage.getOwnPublicKey();

      if (pubKey == null) {
        logDebug('❌ Cannot authenticate: public key not found');
        return;
      }

      // Create auth signature
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Message to sign for global connection identification
      final messageToSign = "$timestamp.$_currentUserId.GLOBAL";
      final signature = _cryptoService?.signMessage(messageToSign);

      if (signature == null) {
        logDebug('❌ Failed to generate authentication signature');
        return;
      }

      final authRequest = AuthRequest(
        userId: _currentUserId!,
        userName: _currentUserName!,
        peerUserId: 'GLOBAL', // Special identifier for global connection
        publicKey: pubKey,
        timestamp: timestamp,
        signature: signature,
      );

      final authJson = jsonEncode(authRequest.toJson());
      _webSocketService?.sendAuthMessage(authJson);

      logDebug('✅ Global WebSocket authenticated (purpose: $connectionPurpose)');
    } catch (e) {
      logDebug('❌ Error authenticating global WebSocket: $e');
    }
  }

  /// Listen to incoming messages and save them to database
  void _listenToMessages() {
    // Listen to message status updates
    _statusUpdateSubscription = _webSocketService?.statusUpdates.listen((statusUpdate) async {
      logDebug('📬 Global [$connectionPurpose]: Received status update: ${statusUpdate.messageId} -> ${statusUpdate.status}');

      try {
        final chatRepository = getIt<ChatRepository>();
        await chatRepository.updateMessageStatus(
          statusUpdate.messageId,
          statusUpdate.status,
        );
        logDebug('✅ Global [$connectionPurpose]: Updated message status in DB');
      } catch (e) {
        logDebug('❌ Global [$connectionPurpose]: Error updating message status: $e');
      }
    });

    // Listen to read receipts
    _readReceiptSubscription = _webSocketService?.readReceipts.listen((readReceipt) async {
      logDebug('📬 Global [$connectionPurpose]: Received read receipt: ${readReceipt.messageId}');
      
      try {
        final chatRepository = getIt<ChatRepository>();
        await chatRepository.updateMessageStatus(
          readReceipt.messageId,
          readReceipt.status,
        );
        logDebug('✅ Global [$connectionPurpose]: Updated message status from read receipt in DB');
      } catch (e) {
        logDebug('❌ Global [$connectionPurpose]: Error updating read receipt status: $e');
      }
    });

    // Listen to incoming messages
    _messageSubscription = _webSocketService?.messages.listen((chatMessage) async {
      if (chatMessage.id.contains("chatError_")) {
        logDebug('⚠️ Global [$connectionPurpose]: Chat error received: ${chatMessage.id}');
        return;
      }

      if (chatMessage.id == "chatKeysExchanged") {
        logDebug('🔑 Global [$connectionPurpose]: Keys exchanged');
        return;
      }

      // Skip duplicate messages
      if (_processedMessageIds.contains(chatMessage.id)) {
        logDebug('⏭️ Global [$connectionPurpose]: Skipping duplicate message: ${chatMessage.id}');
        return;
      }

      // Add to processed messages and cleanup old ones
      _processedMessageIds.add(chatMessage.id);
      if (_processedMessageIds.length > _maxProcessedMessages) {
        _processedMessageIds.remove(_processedMessageIds.first);
      }

      // Skip empty messages without attachments or encrypted content
      if (chatMessage.encryptedTextPayload.isEmpty &&
          (chatMessage.plainText?.isEmpty == true || chatMessage.plainText == null) &&
          chatMessage.fileAttachment == null) {
        logDebug('⏭️ Global [$connectionPurpose]: Skipping empty message');
        return;
      }

      logDebug('📨 Global [$connectionPurpose]: Message received from ${chatMessage.senderId}');

      // Skip messages sent by current user - those are already saved by chat cubit
      if (chatMessage.senderId == _currentUserId) {
        logDebug('⏭️ Global [$connectionPurpose]: Skipping own message (already saved by chat cubit)');
        return;
      }

      // When we receive an encrypted message (still has encryptedText, no plainText),
      // check if we need to request the sender's public key
      final secureStorage = SecureStorageService();
      final senderPublicKey = await secureStorage.getContactPublicKey(chatMessage.senderId);
      
      if (chatMessage.encryptedTextPayload.isNotEmpty && 
          chatMessage.plainText == null && 
          senderPublicKey == null) {
        // We received an encrypted message but don't have the sender's public key
        logDebug('🔑 Missing public key for ${chatMessage.senderId.substring(0, 20)}... - will fetch on next chat open');
        
        // The public key will be fetched when the user opens a chat with this sender
        // For now, just save the encrypted message (it will be decrypted when keys are available)
      }

      // Save message to database
      try {
        final chatRepository = getIt<ChatRepository>();

        // Determine which conversation this message belongs to
        final otherUserId = chatMessage.senderId == _currentUserId
            ? chatMessage.recipientId
            : chatMessage.senderId;

        logDebug('📊 Global [$connectionPurpose]: Getting/creating conversation: current=$_currentUserId, other=$otherUserId');

        // Get or create conversation
        final conversation = await chatRepository.getOrCreateConversation(
          userId1: _currentUserId!,
          userId2: otherUserId,
        );

        logDebug('📊 Global [$connectionPurpose]: Conversation: ${conversation?.conversationId}, unread count: ${conversation?.unreadCount}');

        if (conversation != null) {
          // Set isSentByCurrentUser based on sender comparison for proper badge counting
          final messageWithProperFlags = ChatMessage(
            id: chatMessage.id,
            senderId: chatMessage.senderId,
            recipientId: chatMessage.recipientId,
            encryptedTextPayload: chatMessage.encryptedTextPayload,
            plainText: chatMessage.plainText,
            timestamp: chatMessage.timestamp,
            status: chatMessage.status ?? EChatMessageStatus.delivered,
            isSentByCurrentUser: chatMessage.senderId == _currentUserId,
            fileAttachment: chatMessage.fileAttachment,
            senderName: chatMessage.senderName,
            transactionId: chatMessage.transactionId,
          );

          try {
            await chatRepository.saveMessage(messageWithProperFlags, conversation.conversationId);
            // Refresh unread count after save to verify it was updated
            final updatedUnread = await chatRepository.getTotalUnreadCount(_currentUserId!);
            logDebug('✅ Global [$connectionPurpose]: Message saved. Total unread count: ${conversation.unreadCount} -> $updatedUnread (before -> after)');
          } catch (e) {
            logDebug('❌ Global [$connectionPurpose]: Error saving message: $e');
            return;
          }

          // Manually refresh badge since the watch stream might not emit updates on web
          if (chatMessage.senderId != _currentUserId) {
            try {
              final badgeCubit = getIt<ChatsBadgeCubit>();
              await badgeCubit.refresh();
              logDebug('📬 Global [$connectionPurpose]: Badge manually refreshed (incoming message)');
            } catch (e) {
              logDebug('⚠️ Global [$connectionPurpose]: Could not refresh badge: $e');
            }
          }
        }
      } catch (e) {
        logDebug('❌ Global [$connectionPurpose]: Error saving message: $e');
      }
    });
  }

  /// Request P2P public key exchange with a user
  /// This should be called when opening a chat with a user whose public key is missing
  Future<void> requestKeyExchange(String userId) async {
    if (_webSocketService == null) {
      logDebug('⚠️ Cannot request key exchange - WebSocket service not available');
      return;
    }
    
    // The WebSocket service handles P2P key exchange when connecting to a peer
    try {
      _webSocketService?.loadContactPublicKey(userId);
    } catch (e) {
      logDebug('⚠️ Error during key exchange: $e');
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    if (!_isConnected) {
      return;
    }

    logDebug('🔌 Disconnecting global WebSocket (purpose: $connectionPurpose)...');

    await _messageSubscription?.cancel();
    await _statusUpdateSubscription?.cancel();
    await _readReceiptSubscription?.cancel();
    
    _messageSubscription = null;
    _statusUpdateSubscription = null;
    _readReceiptSubscription = null;

    _webSocketService?.disconnect();
    // Don't null out the service, just disconnect it for potential reconnection
    _isConnected = false;

    logDebug('✅ Global WebSocket disconnected (purpose: $connectionPurpose)');
  }

  /// Handle app lifecycle changes (mobile only)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) return; // Ignore on web

    switch (state) {
      case AppLifecycleState.resumed:
        _isInForeground = true;
        logDebug('📱 App resumed - reconnecting global WebSocket (purpose: $connectionPurpose)');
        _connectIfAppropriate();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _isInForeground = false;
        logDebug('📱 App backgrounded - disconnecting global WebSocket (purpose: $connectionPurpose)');
        disconnect();
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Check if currently connected
  bool get isConnected => _isConnected;

  /// Dispose and cleanup
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    logDebug('🗑️ Global chat service disposed (purpose: $connectionPurpose)');
  }
}
