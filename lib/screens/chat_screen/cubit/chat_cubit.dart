import 'dart:async';
import 'dart:convert';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/messaging/chat_notification_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/chat/auth_request.dart';
import '../../../models/chat/chat_message.dart';
import '../../../models/chat/e_chat_message_status.dart';
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
  final List<ChatMessage> messages = [];
  String? recipientPublicKey; // Exposed recipient's public key

  CryptoService? cryptoService;
  WebSocketChatService? _webSocketService;
  SecureStorageService secureStorage = SecureStorageService();
  ChatRepository? _chatRepository;
  String? _currentConversationId;

  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription? _dbMessagesSubscription;

  ChatCubit({
    required this.currentUserId,
    required this.currentUserName,
    required this.recipientUserId,
  }) : super(ChatInitial()) {}

  void _listenToMessages() {
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
          if (_chatRepository != null && _currentConversationId != null) {
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
              final isFromCurrentRecipient = chatMessage.senderId ==
                  recipientUserId;
              final isToCurrentRecipient = chatMessage.recipientId ==
                  recipientUserId;

              if (isFromCurrentRecipient || isToCurrentRecipient) {
                // Message belongs to CURRENT conversation
                logDebug(
                    '✅ Message is part of current chat (from: $isFromCurrentRecipient, to: $isToCurrentRecipient), '
                        'saving to current conversation: $_currentConversationId');
                await _chatRepository!.saveMessage(
                    chatMessage, _currentConversationId!);
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
    if (_chatRepository != null && _currentConversationId != null) {
      _dbMessagesSubscription = _chatRepository!
          .watchMessagesForConversation(_currentConversationId!)
          .listen((dbMessages) {
        // IMPORTANT: Only process messages for the CURRENT conversation
        // Filter out any messages that don't belong to this conversation
        final filteredMessages = dbMessages.where((msg) =>
        msg.conversationId == _currentConversationId
        ).toList();

          logDebug(
            '@@@@@@@@@ DB stream update: ${dbMessages.length} total messages, '
                '${filteredMessages
                .length} for current conversation $_currentConversationId');

        // Convert DB messages to app messages
        final chatMessages = _chatRepository!.userChatsToChatMessages(
          filteredMessages,
          currentUserId,
        );

        // Update local list from DB
        messages.clear();
        messages.addAll(chatMessages);
        emit(ChatMessagesLoaded(List.from(messages)));
      });
    }
  }

  Future<void> initializeChatSession() async {
    emit(ChatLoading());

    try {
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

          logDebug('@@@@@@@@@@@@@ Init chat session - Connecting WebSocket');

      // Get notification service
      ChatNotificationService? notificationService;
      try {
        notificationService = getIt<ChatNotificationService>();
      } catch (e) {
          logDebug('⚠️ ChatNotificationService not available: $e');
      }

      _webSocketService = WebSocketChatService(
          cryptoService!,
          userId,
          currentUserName,
          kIsWeb ? "ws://localhost:8081/chat" : "ws://10.0.2.2:8081/chat",
          notificationService: notificationService
      );

      // Preload the recipient's public key if available
      await _webSocketService?.loadContactPublicKey(recipientUserId);

      // Load recipient's public key for file encryption
      recipientPublicKey =
      await secureStorage.getContactPublicKey(recipientUserId);
          logDebug('@@@@@@@@@@ Recipient public key loaded: ${recipientPublicKey !=
          null}');

      _webSocketService?.connect(userId);
      _listenToMessages();

          logDebug('@@@@@@@@@@@@@ Init chat session - Creating auth signature');
          logDebug('Key: $pubKey, userId: $userId, recipientUserId: $recipientUserId');

      // Create timestamp and signature for authentication
      final timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      final messageToSign = "$timestamp.$userId.$recipientUserId";

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
        peerUserId: recipientUserId,
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
    _webSocketService?.sendMessage("", "", recipientUserId);
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
    _webSocketService?.sendMessage(text, encryptedPayload, recipientUserId);

    // 5. Update status to "sent" after WebSocket send
    // (In production, you'd wait for server ACK)
    if (_chatRepository != null) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          await _chatRepository!.updateMessageStatus(
            messageId,
            EChatMessageStatus.sent,
          );
        } catch (e) {
          logDebug('❌ Error updating message status: $e');
        }
      });
    }
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
        throw Exception('User not authenticated');
      }

      if (recipientUserId.isEmpty) {
        throw Exception('Invalid recipient user ID');
      }

      if (_currentConversationId == null) {
        throw Exception('No active conversation');
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
          throw Exception('Failed to update transaction status');
        }

          logDebug('@@@@@@@@@ Transaction status updated to "done"');
        emit(ChatTransactionCompleted(transactionId));
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
      final success = response?.contains("error") == false;
      
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
      final success = response?.contains("error") == false;
      
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
      
      if (response != null && !response.contains("error")) {
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

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _dbMessagesSubscription?.cancel();
    return super.close();
  }

}