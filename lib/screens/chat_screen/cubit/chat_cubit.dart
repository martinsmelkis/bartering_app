import 'dart:async';
import 'dart:convert';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/file_transfer_service.dart';
import 'package:barter_app/services/image_cache_service.dart';
import 'package:barter_app/services/messaging/chat_notification_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../models/chat/auth_request.dart';
import '../../../models/chat/chat_message.dart';
import '../../../models/chat/e_chat_message_status.dart';
import '../../../models/chat/file_attachment.dart';
import '../../../models/profile/user_profile_data.dart';
import '../../../models/relationships/report_models.dart';
import '../../../models/reviews/transaction_response.dart';
import '../../../services/crypto/crypto_service.dart';
import '../../../services/secure_storage_service.dart';
import '../services/websocket_chat_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  String currentUserId;
  String currentUserName;
  String recipientUserId;
  String? _federatedRecipientId; // Original federated ID for cross-server routing
  final List<ChatMessage> messages = [];
  String? recipientPublicKey; // Exposed recipient's public key

  CryptoService? cryptoService;
  WebSocketChatService? _webSocketService;
  SecureStorageService secureStorage = SecureStorageService();
  ChatRepository? _chatRepository;
  String? _currentConversationId;

  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription? _dbMessagesSubscription;
  StreamSubscription? _statusUpdateSubscription;
  StreamSubscription? _readReceiptSubscription;
  
  // Track which files are currently being downloaded to avoid duplicates
  final Set<String> _downloadingFiles = {};
  
  // Global image cache service
  final ImageCacheService _imageCache = ImageCacheService();
  
  // Platform-specific limits for auto-download
  static const int _maxAutoDownloadWeb = 5; // Lower limit on web due to performance
  static const int _maxAutoDownloadNative = 20; // Higher limit on native
  
  // Debounce auto-download to prevent multiple rapid triggers
  Timer? _autoDownloadDebounce;
  bool _isAutoDownloading = false;
  
  // Track if chat screen is currently active/visible
  bool _isChatScreenActive = false;

  ChatCubit({
    required this.currentUserId,
    required this.currentUserName,
    required this.recipientUserId,
  }) : super(ChatInitial()) {}
  
  /// Set whether the chat screen is currently active/visible
  void setChatScreenActive(bool isActive) {
    _isChatScreenActive = isActive;
    logDebug('💬 Chat screen active state changed: $isActive');
  }

  /// Set the federated recipient ID for cross-server routing
  void setFederatedRecipientId(String? federatedId) {
    _federatedRecipientId = federatedId;
    logDebug('🌐 Federated recipient ID set: $federatedId');
  }

  void _listenToMessages(String conversationId) {
    // Listen to message status updates
    _statusUpdateSubscription = _webSocketService?.statusUpdates.listen((statusUpdate) async {
      logDebug('📬 Received status update: ${statusUpdate.messageId} -> ${statusUpdate.status}');
      
      // Update message status in database
      if (_chatRepository != null) {
        try {
          await _chatRepository!.updateMessageStatus(
            statusUpdate.messageId,
            statusUpdate.status,
          );
          logDebug('✅ Updated message ${statusUpdate.messageId} status to ${statusUpdate.status} in DB');
        } catch (e) {
          logDebug('❌ Error updating message status: $e');
        }
      } else {
        logDebug('⚠️ ChatRepository is null, cannot update status');
      }
    });

    // Listen to read receipt notifications
    _readReceiptSubscription = _webSocketService?.readReceipts.listen((readReceipt) async {
      logDebug('📬 Received read receipt: messageId=${readReceipt.messageId}, status=${readReceipt.status}, readerId=${readReceipt.readerId}');
      
      // Update message status in database
      if (_chatRepository != null) {
        try {
          await _chatRepository!.updateMessageStatus(
            readReceipt.messageId,
            readReceipt.status,
          );
          logDebug('✅ Updated message ${readReceipt.messageId} status to ${readReceipt.status} from read receipt in DB');
          
          // Emit a state to trigger UI rebuild if needed
          emit(ChatMessagesLoaded(List.from(messages)));
        } catch (e) {
          logDebug('❌ Error updating message status from read receipt: $e');
          logDebug('Stack trace: ${StackTrace.current}');
        }
      } else {
        logDebug('⚠️ ChatRepository is null, cannot update read receipt status');
      }
    });

    // Listen to WebSocket messages (but only save to DB, don't add to list)
    _messageSubscription =
        _webSocketService?.messages.listen((chatMessage) async {
          if (chatMessage.id.contains("chatError_")) {
            emit(ChatError(chatMessage.id));
            return;
          }
          if (chatMessage.id == "chatKeysExchanged") {
            // Refresh recipient public key
            recipientPublicKey =
            await secureStorage.getContactPublicKey(recipientUserId);
            logDebug(
                '@@@@@@@@@@ Keys exchanged! Recipient public key updated: ${recipientPublicKey !=
                    null}');
            emit(ChatKeysExchanged());
            return;
          }
          logDebug('@@@@@@@@@@@@@ message received ${chatMessage.toJson()}');

          // Skip empty messages UNLESS they have a file attachment
          if (chatMessage.plainText?.isEmpty == true &&
              chatMessage.fileAttachment == null) {
            logDebug('@@@@@@@@@ Skipping empty message without attachment');
            return;
          }

          // Save message to database ONLY - DB stream will update UI
          if (_chatRepository != null && _currentConversationId == conversationId) {
            try {
              logDebug(
                  '@@@@@@@@@@@@ Current chat recipientUserId: $recipientUserId, '
                      'message senderId: ${chatMessage.senderId}, '
                      'message recipientId: ${chatMessage.recipientId}, '
                      'currentUserId: $currentUserId, '
                      'current conversationId: $_currentConversationId');

              // Determine which conversation this message belongs to
              // A message belongs to the current conversation if:
              // 1. It's FROM the recipientUserId (they sent it to us), OR
              // 2. It's TO the recipientUserId (we sent it to them)
              // For federated users, normalize IDs before comparing
              final normalizedMessageSender = _normalizeUserId(chatMessage.senderId);
              final normalizedMessageRecipient = _normalizeUserId(chatMessage.recipientId);
              final normalizedCurrentRecipient = _normalizeUserId(recipientUserId);
              
              final isFromCurrentRecipient = normalizedMessageSender ==
                  normalizedCurrentRecipient;
              final isToCurrentRecipient = normalizedMessageRecipient ==
                  normalizedCurrentRecipient;

              if (isFromCurrentRecipient || isToCurrentRecipient) {
                // Message belongs to CURRENT conversation
                logDebug(
                    '✅ Message is part of current chat (from: $isFromCurrentRecipient, to: $isToCurrentRecipient), '
                        'saving to current conversation: $conversationId');
                await _chatRepository!.saveMessage(
                    chatMessage, conversationId);
                logDebug(
                    '✅ Message saved to CURRENT conversation (will appear in current chat)');
              } else {
                // Message is from/to a DIFFERENT user - find/create their conversation
                final otherUserId = chatMessage.senderId == currentUserId
                    ? chatMessage.recipientId
                    : chatMessage.senderId;

                final convId = await _getConversationFromDB(
                    currentUserId, otherUserId);
                final otherConversationId = convId?.conversationId ?? "Unknown";

                logDebug('⚠️ Message from/to different user ($otherUserId)! '
                    'Saving to conversation: $otherConversationId '
                    '(NOT current: $_currentConversationId)');

                await _chatRepository!.saveMessage(
                    chatMessage, otherConversationId);

                logDebug(
                    '✅ Message saved to OTHER conversation (will NOT appear in current chat)');
              }
            } catch (e) {
              logDebug('❌ @@@@@@@@ Error saving message to database: $e');
            }
          }
        }, onError: (error) {
          // Handle any errors from the message stream
          //emit(ChatError(List.from(state.messages),
          // "Error receiving messages: ${error.toString()}"));
        });

    // Database stream is the SINGLE SOURCE OF TRUTH for messages
    if (_chatRepository != null) {
      _dbMessagesSubscription = _chatRepository!
          .watchMessagesForConversation(conversationId)
          .listen((dbMessages) {
        // Ignore stale emissions from previous chat sessions.
        if (_currentConversationId != conversationId) {
          logDebug('⏭️ Ignoring stale DB stream emission for $conversationId (current: $_currentConversationId)');
          return;
        }

        // IMPORTANT: Only process messages for this bound conversation
        final filteredMessages = dbMessages.where((msg) =>
        msg.conversationId == conversationId
        ).toList();

          logDebug(
            '@@@@@@@@@ DB stream update: ${dbMessages.length} total messages, '
                '${filteredMessages
                .length} for current conversation $conversationId');

        // Convert DB messages to app messages
        final chatMessages = _chatRepository!.userChatsToChatMessages(
          filteredMessages,
          currentUserId,
        );

        // AUTO-MARK NEW UNREAD MESSAGES AS READ (only if chat screen is currently active)
        if (_isChatScreenActive) {
          // Find any new unread messages from the other user
          final newUnreadMessages = chatMessages.where(
            (msg) => !msg.isSentByCurrentUser && 
                     msg.status != EChatMessageStatus.read
          ).toList();
          
          if (newUnreadMessages.isNotEmpty) {
            logDebug('📖 Auto-marking ${newUnreadMessages.length} new unread message(s) as read (screen active)');
            // Mark as read asynchronously (don't wait)
            markMessagesAsRead(newUnreadMessages);
          }
        } else {
          logDebug('⏸️  Chat screen not active - skipping auto-mark as read');
        }

        // Update local list from DB
        messages.clear();
        messages.addAll(chatMessages);
        emit(ChatMessagesLoaded(List.from(messages)));

        // Auto-download recent image previews (debounced to prevent rapid triggers)
        _scheduleAutoDownload();
      });
    }
  }

  /// Schedule auto-download with debounce to prevent multiple rapid triggers
  void _scheduleAutoDownload() {
    // Cancel previous timer if exists
    _autoDownloadDebounce?.cancel();
    
    // Schedule new download after delay (only if not already downloading)
    _autoDownloadDebounce = Timer(
      Duration(milliseconds: kIsWeb ? 500 : 300), 
      () {
        if (!_isAutoDownloading) {
          _autoDownloadRecentImages();
        }
      },
    );
  }

  Future<void> initializeChatSession() async {
    emit(ChatLoading());

    try {
      // Reset previous realtime session to avoid stale listeners when switching chats.
      await _messageSubscription?.cancel();
      _messageSubscription = null;
      await _dbMessagesSubscription?.cancel();
      _dbMessagesSubscription = null;
      await _statusUpdateSubscription?.cancel();
      _statusUpdateSubscription = null;
      await _readReceiptSubscription?.cancel();
      _readReceiptSubscription = null;
      _webSocketService?.dispose();
      _webSocketService = null;

      try {
        _chatRepository = getIt<ChatRepository>();
          logDebug('✅ ChatRepository initialized');
      } catch (e) {
          logDebug('⚠️ ChatRepository not available: $e');
      }

      cryptoService = await CryptoService.create();
          logDebug('@@@@@@ CryptoService created, isReady: ${cryptoService?.isReady}');

      final pubKey = await secureStorage.getOwnPublicKey();
      final String? userId = await secureStorage.getOwnUserId()
          ?? getIt<UserRepository>().userId;

      if (userId == null) {
        emit(ChatError("User ID not found"));
        return;
      }
      if (pubKey == null) {
        emit(ChatError("Public key not found"));
        return;
      }
      if (cryptoService == null || !cryptoService!.isReady) {
        emit(ChatError("CryptoService initialization failed"));
        return;
      }

      // Get or create conversation
      if (_chatRepository != null) {
          logDebug('@@@@@ Getting chat session from DB with ${userId} ${recipientUserId}');
        final conversation = await _getConversationFromDB(userId, recipientUserId);
        _currentConversationId = conversation?.conversationId;
          logDebug('✅ Conversation ID: $_currentConversationId');

        // Try to get the federated ID for this recipient (for cross-server routing)
        final federatedId = await secureStorage.getFederatedId(recipientUserId);
        if (federatedId != null) {
          _federatedRecipientId = federatedId;
          logDebug('🌐 Found federated ID for $recipientUserId: $federatedId');
        } else {
          // Try reverse: check if recipientUserId IS a federated ID that was stored
          final contactKey = await secureStorage.getContactPublicKey(recipientUserId);
          if (contactKey != null) {
            // The key exists, so recipientUserId might already be the federated ID
            // Check if it has @ format
            if (recipientUserId.contains('@')) {
              _federatedRecipientId = recipientUserId;
              logDebug('🌐 Recipient is already federated ID: $recipientUserId');
            }
          }
        }

        // Load existing messages from database
        final existingMessages = await _chatRepository!.getRecentMessages(
          _currentConversationId!,
          limit: 100,
        );

          logDebug('@@@@@@@@@@ Loaded ${existingMessages.length} messages from database');
        if (existingMessages.isNotEmpty) {
          messages.clear();
          messages.addAll(
            _chatRepository!.userChatsToChatMessages(existingMessages, userId),
          );
          logDebug('✅ Added ${messages.length} messages from database');
        }
        emit(ChatLoaded(List.from(messages)));

        // Mark conversation as read
        await _chatRepository!.markConversationAsRead(_currentConversationId!);
      }

          logDebug('@@@@@@@@@@@@@ Init chat session - Creating chat-specific WebSocket');

      // Always create a chat-specific WebSocket connection for sending messages
      // The global WebSocket is only for receiving messages
      // This ensures proper key exchange via authentication
      logDebug('📡 Creating chat-specific WebSocket connection for sending messages');
      
      // Get notification service
      ChatNotificationService? notificationService;
      try {
        notificationService = getIt<ChatNotificationService>();
      } catch (e) {
        logDebug('⚠️ ChatNotificationService not available: $e');
      }

      // Get WebSocket URL from environment variables based on platform
      final wsUrl = kIsWeb 
          ? (dotenv.env['WSS_URL_WEB'] ?? 'ws://localhost:8081/chat')
          : (dotenv.env['WSS_URL_MOBILE'] ?? 'ws://10.0.2.2/chat');
      
      logDebug('🔌 Connecting to WebSocket: $wsUrl');
      
      _webSocketService = WebSocketChatService(
          cryptoService!,
          userId,
          currentUserName,
          wsUrl,
          notificationService: notificationService
      );

      // Register callback to re-decrypt messages when public key is received
      _webSocketService?.onPublicKeyReceived = (userId, publicKey) async {
        logDebug('🔑 Public key received for $userId, re-decrypting messages...');
        await _reDecryptMessages(userId, publicKey);
      };

      // Preload the recipient's public key if available
      await _webSocketService?.loadContactPublicKey(recipientUserId);

      // Load recipient's public key for file encryption
      recipientPublicKey = await secureStorage.getContactPublicKey(recipientUserId);
      logDebug('@@@@@@@@@@ Recipient public key loaded: ${recipientPublicKey != null}');

      _webSocketService?.connect(userId);
      if (_currentConversationId != null) {
        _listenToMessages(_currentConversationId!);
      }

      logDebug('@@@@@@@@@@@@@ Init chat session - Creating auth signature');
      logDebug('Key: $pubKey, userId: $userId, recipientUserId: $recipientUserId, federatedId: $_federatedRecipientId');

      // Use federated ID for auth if available (for cross-server federation)
      final effectivePeerUserId = _federatedRecipientId ?? recipientUserId;
      
      // Create timestamp and signature for authentication
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final messageToSign = "$timestamp.$userId.$effectivePeerUserId";

      logDebug('@@@@@@@@@@@@@ Message to sign: $messageToSign');
      final signature = cryptoService?.signMessage(messageToSign);

      if (signature == null) {
        emit(ChatError("Failed to generate authentication signature"));
        return;
      }

      logDebug('@@@@@@@@@@ Signature generated: ${signature.substring(0, 20)}...');

      final authRequest = AuthRequest(
        userId: userId,
        userName: currentUserName,
        peerUserId: effectivePeerUserId,
        publicKey: pubKey,
        timestamp: timestamp,
        signature: signature,
      );

      final authJson = jsonEncode(authRequest.toJson());
      logDebug('@@@@@@@@@@@@@ Sending auth request: $authJson');
      _webSocketService?.sendAuthMessage(authJson);

      emit(ChatLoaded(List.from(messages)));
    } catch (e) {
          logDebug('@@@@@@@@@@@@@ Chat initialization error: $e');
      emit(ChatError("Chat session initialization failed: ${e.toString()}"));
    }
  }

  Future<Conversation?> _getConversationFromDB(String userId, String recipientUserId) async {
    try {
      final conversation = await _chatRepository!.getOrCreateConversation(
        userId1: userId,
        userId2: recipientUserId,
      );
      return conversation;
    } catch (e) {
          logDebug('@@@@@@@@@@@@@ Error getting conversation ID: $e');
      return Future.value(null);
    }
  }

  Future<void> sendFileNotification(ChatMessage chatMessage) async {
    await _chatRepository?.saveMessage(chatMessage, _currentConversationId ?? "Unknown");
    // Use federated ID if available for cross-server routing
    final effectiveRecipientId = _federatedRecipientId ?? recipientUserId;
    _webSocketService?.sendMessage("", "", effectiveRecipientId);
  }

  Future<void> sendMessage(String text) async {
    // 1. Get the recipient's public key from cache or storage
          logDebug(
        '@@@@@@@@@ sendMessage - Getting recipient public key for: $recipientUserId');

    String? recipientPublicKeyBase64 = await secureStorage.getContactPublicKey(
        recipientUserId);

    if (recipientPublicKeyBase64 == null) {
      emit(ChatError(
          "Recipient's public key not found. Cannot encrypt message."));
      return;
    }

    final recipientPublicKey = cryptoService?.ecPublicKeyFromString(
        recipientPublicKeyBase64);

    if (recipientPublicKey == null) {
      emit(ChatError("Failed to parse recipient's public key."));
      return;
    }

    // 2. Encrypt the message using the recipient's public key
          logDebug('@@@@@@@@@ sendMessage ${cryptoService} ${cryptoService
        ?.getPublicKey()} ${text}');
    var encryptedPayload = cryptoService?.encrypt(text, recipientPublicKey);

    if (encryptedPayload == null) {
      emit(ChatError("Encryption failed. Message not sent."));
      return;
    }

    // 3. Save message to database first (with "sending" status)
    final messageId = "client_${DateTime.now().millisecondsSinceEpoch}";
    final chatMessage = ChatMessage(
      id: messageId,
      senderId: currentUserId,
      recipientId: recipientUserId,
      plainText: text,
      encryptedTextPayload: encryptedPayload,
      timestamp: DateTime.now(),
      status: EChatMessageStatus.sending,
    );

    if (_chatRepository != null && _currentConversationId != null) {
      try {
        await _chatRepository!.saveMessage(
            chatMessage, _currentConversationId!);
          logDebug('✅ Sent message saved to database');
      } catch (e) {
          logDebug('❌ Error saving sent message to database: $e');
      }
    }

    // 4. Send via WebSocket
    // Use federated ID if available for cross-server routing
    final effectiveRecipientId = _federatedRecipientId ?? recipientUserId;
    logDebug('🌐 Sending message to recipient: $recipientUserId (effective: $effectiveRecipientId)');
    _webSocketService?.sendMessage(text, encryptedPayload, effectiveRecipientId);

    // 5. Status will be updated automatically by server via MessageStatusUpdate
    // Don't hardcode status updates here - let the server notifications handle it
    logDebug('✅ Message sent via WebSocket, waiting for server status updates');
  }

  /// Send a file notification message
  Future<void> sendFileMessage(ChatMessage fileMessage) async {
    if (_chatRepository != null && _currentConversationId != null) {
      try {
        // Save to database
        await _chatRepository!.saveMessage(
            fileMessage, _currentConversationId!);
          logDebug('✅ File message saved to database');
      } catch (e) {
          logDebug('❌ Error saving file message: $e');
        emit(ChatError('Failed to send file message'));
      }
    }
  }

  /// Finish transaction - gets existing transaction from database or creates a new one
  Future<void> finishTransaction() async {
    emit(ChatTransactionInProgress());

    try {
      final apiClient = getIt<ApiClient>();
      final userRepository = getIt<UserRepository>();
      final userId = await userRepository.getUserId();

      if (userId == null) {
        emit(ChatTransactionError('User not authenticated'));
      }

      if (recipientUserId.isEmpty) {
        emit(ChatTransactionError('Invalid recipient user ID'));
      }

      if (_currentConversationId == null) {
        emit(ChatTransactionError('No active conversation'));
      }

      String? transactionId;
      if (_chatRepository != null) {
        transactionId = await _chatRepository!.getConversationTransactionId(
          _currentConversationId!,
        );
      }

      if (transactionId != null && transactionId.isNotEmpty) {
          logDebug('@@@@@@@@@ Found existing transaction ID: $transactionId');

        final updateRequest = UpdateTransactionStatusRequest(status: 'done');
        final updateResponse = await apiClient.updateTransactionStatus(
          transactionId,
          updateRequest,
        );

        if (!updateResponse.success) {
          emit(ChatTransactionError('Failed to update transaction status'));
        }

        logDebug('@@@@@@@@@ Transaction status updated to "done"');
        emit(ChatTransactionCompleted(transactionId));
      } else {
        emit(ChatTransactionError('Failed to update transaction status'));
      }
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, 'Failed to finish transaction');
      logDebug('@@@@@@@@@ Error finishing transaction: $errorMessage');
      emit(ChatTransactionError(errorMessage));
    } catch (e) {
      logDebug('@@@@@@@@@ Error finishing transaction: $e');
      emit(ChatTransactionError(e.toString()));
    }

  }

  // ============ USER MODERATION METHODS ============

  /// Block a user
  Future<bool> blockUser(String userIdToBlock) async {
    emit(ChatUserBlockInProgress());
    
    try {
      final apiClient = getIt<ApiClient>();
      
      final request = RelationshipRequest(
        fromUserId: currentUserId,
        toUserId: userIdToBlock,
        relationshipType: 'blocked',
      );

      final response = await apiClient.blockUser(request.toJson());
      final success = response.contains("error") == false;
      
      if (success) {
        emit(ChatUserBlockSuccess());
      } else {
        emit(ChatUserBlockError('Failed to block user'));
      }
      
      return success;
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, 'Failed to block user');
          logDebug('Error blocking user: $errorMessage');
      emit(ChatUserBlockError(errorMessage));
      return false;
    } catch (e) {
          logDebug('Error blocking user: $e');
      emit(ChatUserBlockError(e.toString()));
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(String userIdToUnblock) async {
    emit(ChatUserUnblockInProgress());
    
    try {
      final apiClient = getIt<ApiClient>();
      
      final request = RelationshipRequest(
        fromUserId: currentUserId,
        toUserId: userIdToUnblock,
        relationshipType: 'blocked',
      );

      final response = await apiClient.unblockUser(request.toJson());
      final success = response.contains("error") == false;
      
      if (success) {
        emit(ChatUserUnblockSuccess());
      } else {
        emit(ChatUserUnblockError('Failed to unblock user'));
      }
      
      return success;
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, 'Failed to unblock user');
          logDebug('Error unblocking user: $errorMessage');
      emit(ChatUserUnblockError(errorMessage));
      return false;
    } catch (e) {
          logDebug('Error unblocking user: $e');
      emit(ChatUserUnblockError(e.toString()));
      return false;
    }
  }

  /// Check if a user is blocked
  Future<bool> isUserBlocked(String otherUserId) async {
    try {
      final apiClient = getIt<ApiClient>();
      final response = await apiClient.isUserBlocked(currentUserId, otherUserId);
      return response == true;
    } catch (e) {
          logDebug('Error checking block status: $e');
      return false;
    }
  }

  /// Get list of blocked users
  Future<List<UserProfileData>> getBlockedUsers() async {
    try {
      final apiClient = getIt<ApiClient>();
      return await apiClient.getBlockedUsers(currentUserId);
    } catch (e) {
          logDebug('Error fetching blocked users: $e');
      return [];
    }
  }

  /// Re-decrypt encrypted messages after receiving the sender's public key
  Future<void> _reDecryptMessages(String userId, String publicKey) async {
    if (_chatRepository == null || _currentConversationId == null) {
      return;
    }

    try {
      // Get all encrypted messages from this sender without decrypted content
      final encryptedMessages = await _chatRepository!.getEncryptedMessages(
        conversationId: _currentConversationId!,
        senderId: userId,
      );

      if (encryptedMessages.isEmpty) {
        logDebug('🔑 No encrypted messages to re-decrypt for $userId');
        return;
      }

      logDebug('🔑 Re-decrypting ${encryptedMessages.length} messages for $userId');

      final keyPair = cryptoService?.ecPublicKeyFromString(publicKey);
      if (keyPair == null) {
        logDebug('❌ Failed to parse public key for re-decryption');
        return;
      }

      for (final msg in encryptedMessages) {
        try {
          final encryptedPayload = msg.encryptedContent.trim();
          if (encryptedPayload.isEmpty) {
            logDebug('⏭️ Skipping re-decrypt for ${msg.messageId}: empty encrypted payload');
            continue;
          }

          // Guard against non-ciphertext placeholders or malformed payloads.
          // AES-GCM payload format is: [salt(16) + iv(12) + ciphertext], so minimum is 28 bytes.
          Uint8List payloadBytes;
          try {
            payloadBytes = base64Decode(encryptedPayload);
          } catch (_) {
            logDebug('⏭️ Skipping re-decrypt for ${msg.messageId}: invalid base64 payload');
            continue;
          }
          if (payloadBytes.length < 28) {
            logDebug('⏭️ Skipping re-decrypt for ${msg.messageId}: payload too short (${payloadBytes.length} bytes)');
            continue;
          }

          final decryptedText = cryptoService?.decrypt(encryptedPayload, keyPair);

          if (decryptedText != null && decryptedText.isNotEmpty) {
            // Update message in database with decrypted text
            await _chatRepository!.updateMessageDecryptedContent(msg.messageId, decryptedText);
            logDebug('✅ Re-decrypted message ${msg.messageId.substring(0, 20)}...');
          }
        } catch (e) {
          logDebug('❌ Error re-decrypting message ${msg.messageId}: $e');
        }
      }

      logDebug('✅ Re-decryption complete for $userId');
    } catch (e) {
      logDebug('❌ Error during re-decryption: $e');
    }
  }

  /// Report a user
  Future<String?> reportUser({
    required String reportedUserId,
    required ReportReason reason,
    String? description,
    ReportContextType? contextType,
    String? contextId,
  }) async {
    emit(ChatUserReportInProgress());
    
    try {
      final apiClient = getIt<ApiClient>();
      
      final request = UserReportRequest(
        reporterUserId: currentUserId,
        reportedUserId: reportedUserId,
        reportReason: reason.value,
        description: description,
        contextType: contextType?.value,
        contextId: contextId,
      );

      final response = await apiClient.createReport(request.toJson());
      
      if (!response.contains("error")) {
        emit(ChatUserReportSuccess(response));
      } else {
        emit(ChatUserReportError('Failed to submit report'));
      }
      
      return response;
    } on DioException catch (e) {
      final errorMessage = DioErrorHandler.getErrorMessage(e, 'Failed to submit report');
          logDebug('Error reporting user: $errorMessage');
      emit(ChatUserReportError(errorMessage));
      return null;
    } catch (e) {
          logDebug('Error reporting user: $e');
      emit(ChatUserReportError(e.toString()));
      return null;
    }
  }

  /// Check if user has already reported another user
  Future<bool> hasReportedUser(String reportedUserId) async {
    try {
      final apiClient = getIt<ApiClient>();
      final response = await apiClient.checkReport(currentUserId, reportedUserId);
      return response == true;
    } catch (e) {
          logDebug('Error checking report status: $e');
      return false;
    }
  }

  /// Mark messages as read and send read receipts to the server
  Future<void> markMessagesAsRead(List<ChatMessage> messagesToMark) async {
    logDebug('📖 markMessagesAsRead called with ${messagesToMark.length} messages');
    
    // Track unique sender IDs to cancel notifications
    final Set<String> senderIds = {};
    int markedCount = 0;
    
    for (final message in messagesToMark) {
      // Only mark messages from other users that haven't been read yet
      if (!message.isSentByCurrentUser && message.status != EChatMessageStatus.read) {
        try {
          logDebug('📤 Sending read receipt for message ${message.id.substring(0, 20)}... to sender ${message.senderId.substring(0, 20)}...');
          
          senderIds.add(message.senderId);
          
          // Send read receipt to server
          await _webSocketService?.sendReadReceipt(
            message.id,
            message.senderId,
          );
          
          // Update local database to READ immediately (optimistic update)
          if (_chatRepository != null) {
            await _chatRepository!.updateMessageStatus(
              message.id,
              EChatMessageStatus.read,
            );
            markedCount++;
            logDebug('✅ Updated local DB: message ${message.id.substring(0, 20)}... -> READ');
          }
        } catch (e) {
          logDebug('❌ Error marking message ${message.id} as read: $e');
        }
      } else {
        logDebug('⏭️  Skipping message ${message.id.substring(0, 20)}... - isSentByMe: ${message.isSentByCurrentUser}, status: ${message.status}');
      }
    }
    
    // Update conversation unread count if any messages were marked as read
    if (markedCount > 0 && _currentConversationId != null && _chatRepository != null) {
      try {
        await _chatRepository!.markConversationAsRead(_currentConversationId!);
        logDebug('✅ Updated conversation unread count to 0');
      } catch (e) {
        logDebug('❌ Error updating conversation unread count: $e');
      }
    }
    
    // Cancel notifications for all senders whose messages were marked as read
    if (senderIds.isNotEmpty) {
      try {
        final notificationService = getIt<ChatNotificationService>();
        for (final senderId in senderIds) {
          await notificationService.cancelNotificationsForUser(senderId);
        }
        logDebug('🔕 Cancelled notifications for ${senderIds.length} sender(s)');
      } catch (e) {
        logDebug('⚠️ Could not cancel notifications: $e');
      }
    }
  }

  /// Mark a single message as read
  Future<void> markMessageAsRead(String messageId, String senderId) async {
    try {
      // Send read receipt to server
      await _webSocketService?.sendReadReceipt(messageId, senderId);
      
      // Update local database
      if (_chatRepository != null) {
        await _chatRepository!.updateMessageStatus(
          messageId,
          EChatMessageStatus.read,
        );
        
        // Update conversation unread count
        if (_currentConversationId != null) {
          await _chatRepository!.markConversationAsRead(_currentConversationId!);
          logDebug('✅ Updated conversation unread count to 0');
        }
      }
      
      logDebug('✅ Marked message $messageId as read');
    } catch (e) {
      logDebug('❌ Error marking message as read: $e');
    }
  }

  /// Auto-download recent small images for preview
  /// Limits: Web: 5 images, Native: 20 images, all < 5MB only
  /// Downloads incrementally to avoid UI freezing (especially on web)
  Future<void> _autoDownloadRecentImages() async {
    if (_isAutoDownloading) {
      logDebug('⏭️  Auto-download already in progress, skipping');
      return;
    }
    
    if (recipientPublicKey == null || cryptoService == null) {
      logDebug('⏭️  Skipping auto-download: keys not ready');
      return;
    }

    _isAutoDownloading = true;
    try {
      final fileTransferService = FileTransferService(
        getIt<ApiClient>(),
        cryptoService!,
      );

      // Platform-specific limits: fewer images on web for better performance
      final maxImages = kIsWeb ? _maxAutoDownloadWeb : _maxAutoDownloadNative;
      
      // Get recent messages with image attachments
      final recentMessages = messages.take(maxImages).toList();
      final imagesToDownload = <ChatMessage>[];

      for (final message in recentMessages) {
        final attachment = message.fileAttachment;
        if (attachment != null &&
            attachment.isSmallImage && // < 5MB
            !_imageCache.isCached(attachment.fileId) && // Check global cache - CRITICAL CHECK
            !attachment.isDownloading && // Not currently downloading
            !_downloadingFiles.contains(attachment.fileId)) {
          logDebug('📥 Image needs download: ${attachment.filename}');
          imagesToDownload.add(message);
        } else if (attachment != null && _imageCache.isCached(attachment.fileId)) {
          logDebug('✅ Image already cached in global cache: ${attachment.filename}');
        }
      }

      if (imagesToDownload.isEmpty) {
        logDebug('✅ No images need auto-download');
        return;
      }

      logDebug('🖼️  Auto-downloading ${imagesToDownload.length} image previews...');

      // Download images one at a time with delays to prevent UI freezing
      for (var i = 0; i < imagesToDownload.length; i++) {
        final message = imagesToDownload[i];
        final attachment = message.fileAttachment!;

        // CRITICAL: Skip if no recipient public key (can't decrypt)
        final key = recipientPublicKey;
        if (key == null || key.isEmpty) {
          logDebug('⚠️ Cannot download image ${attachment.filename}: no recipient public key');
          _updateMessageAttachment(
            message.id,
            attachment.copyWith(isDownloading: false),
          );
          continue;
        }

        // Mark as downloading to avoid duplicates
        _downloadingFiles.add(attachment.fileId);

        // Update UI to show download in progress
        _updateMessageAttachment(
          message.id,
          attachment.copyWith(isDownloading: true),
        );

        try {
          // Download and decrypt file (preview only, don't save to disk yet)
          final result = await fileTransferService.downloadFile(
            fileId: attachment.fileId,
            userId: currentUserId,
            filename: attachment.filename,
            senderPublicKey: key,  // Use the validated local variable
            saveToFile: false, // Only get bytes for preview
          );

          // Store in global image cache (persists across rebuilds)
          _imageCache.cacheImage(attachment.fileId, result.decryptedBytes);

          // Update message to remove downloading state (no need to store bytes)
          final updatedAttachment = attachment.copyWith(
            isDownloading: false,
          );

          _updateMessageAttachment(message.id, updatedAttachment);

          logDebug('✅ Cached preview for: ${attachment.filename} (${i + 1}/${imagesToDownload.length})');
          
          // CRITICAL: Add delay between downloads to prevent UI freezing
          // On web, decryption is CPU-intensive and blocks the main isolate
          // Longer delay on web, shorter on native (where we have better isolate support)
          if (i < imagesToDownload.length - 1) {
            await Future.delayed(
              Duration(milliseconds: kIsWeb ? 300 : 100),
            );
          }
        } catch (e) {
          logDebug('❌ Error downloading image ${attachment.filename}: $e');
          
          // Update to remove downloading state
          _updateMessageAttachment(
            message.id,
            attachment.copyWith(isDownloading: false),
          );
        } finally {
          _downloadingFiles.remove(attachment.fileId);
        }
      }
    } catch (e) {
      logDebug('❌ Error in auto-download: $e');
    } finally {
      _isAutoDownloading = false;
    }
  }

  /// Update a message's attachment in the messages list
  void _updateMessageAttachment(String messageId, FileAttachment updatedAttachment) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        fileAttachment: updatedAttachment,
      );
      emit(ChatMessagesLoaded(List.from(messages)));
    }
  }

  /// Normalize federated user ID by removing server suffix
  /// e.g., "userId@serverId" -> "userId"
  String _normalizeUserId(String userId) {
    final atIndex = userId.indexOf('@');
    if (atIndex != -1) {
      return userId.substring(0, atIndex);
    }
    return userId;
  }

  @override
  Future<void> close() {
    _autoDownloadDebounce?.cancel();
    _messageSubscription?.cancel();
    _dbMessagesSubscription?.cancel();
    _statusUpdateSubscription?.cancel();
    _readReceiptSubscription?.cancel();
    
    // Always dispose chat-specific WebSocket
    _webSocketService?.dispose();
    logDebug('🔌 Disposed chat-specific WebSocket connection');
    
    return super.close();
  }

}