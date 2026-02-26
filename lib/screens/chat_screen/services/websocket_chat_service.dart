import 'dart:async';
import 'dart:convert';
import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../models/chat/chat_message.dart';
import '../../../models/chat/e_chat_message_status.dart';
import '../../../models/chat/file_notification_message.dart';
import '../../../models/chat/match_notification_message.dart';
import '../../../models/chat/message_status_update.dart';
import '../../../models/chat/read_receipt_notification.dart';
import '../../../models/chat/read_receipt_request.dart';
import '../../../services/crypto/crypto_service.dart';
import '../../../services/messaging/chat_notification_service.dart';

class WebSocketChatService {
  // Optional: Notification service for background notifications
  ChatNotificationService? _notificationService;
  WebSocketChannel? _channel;
  StreamController<ChatMessage> _messageController =
    StreamController<ChatMessage>.broadcast();

  // Stream for message status updates
  StreamController<MessageStatusUpdate> _statusUpdateController =
    StreamController<MessageStatusUpdate>.broadcast();

  // Stream for read receipt notifications
  StreamController<ReadReceiptNotification> _readReceiptController =
    StreamController<ReadReceiptNotification>.broadcast();

  // Callback when public key is received (for re-decryption of old messages)
  Function(String userId, String publicKey)? onPublicKeyReceived;

  CryptoService _cryptoService;
  SecureStorageService secureStorage = SecureStorageService();
  String _currentUserId;
  String _currentUserName;
  String _serverUrl;

  // Cache of contact public keys: userId -> base64 public key
  final Map<String, String> _publicKeyCache = {};

  Stream<ChatMessage> get messages => _messageController.stream;
  Stream<MessageStatusUpdate> get statusUpdates => _statusUpdateController.stream;
  Stream<ReadReceiptNotification> get readReceipts => _readReceiptController.stream;

  WebSocketChatService(this._cryptoService,
      this._currentUserId,
      this._currentUserName,
      this._serverUrl,
      {ChatNotificationService? notificationService})
      : _notificationService = notificationService;

  // Loads a contact's public key into cache if available
  // This is useful when initializing a chat session
  Future<void> loadContactPublicKey(String userId) async {
    // Check if already cached under the provided ID or normalized form
    if (_publicKeyCache.containsKey(userId)) {
      logDebug('@@@@@@@@@@@@ Public key already cached for: $userId');
      return;
    }
    
    // Also check if normalized form is cached
    final normalizedId = _normalizeUserId(userId);
    if (normalizedId != userId && _publicKeyCache.containsKey(normalizedId)) {
      // Copy from normalized to original form
      _publicKeyCache[userId] = _publicKeyCache[normalizedId]!;
      logDebug('@@@@@@@@@@@@ Public key copied from normalized cache ($normalizedId) to: $userId');
      return;
    }

    // Try loading with the provided ID
    final publicKey = await secureStorage.getContactPublicKey(userId);
    if (publicKey != null) {
      _publicKeyCache[userId] = publicKey;
      logDebug('@@@@@@@@@@@@ Preloaded public key from storage for: $userId');
      return;
    }
    
    // Try loading with normalized ID
    if (normalizedId != userId) {
      final normalizedKey = await secureStorage.getContactPublicKey(normalizedId);
      if (normalizedKey != null) {
        _publicKeyCache[userId] = normalizedKey;
        _publicKeyCache[normalizedId] = normalizedKey;
        logDebug('@@@@@@@@@@@@ Preloaded public key from storage (normalized $normalizedId) for: $userId');
        return;
      }
    }
    
    logDebug('@@@@@@@@@@@@ No cached public key found for: $userId');
  }

  // Gets a contact's public key from cache
  // Returns null if not found
  String? getContactPublicKey(String userId) {
    // Try direct lookup first
    if (_publicKeyCache.containsKey(userId)) {
      return _publicKeyCache[userId];
    }
    // Try normalized form
    final normalizedId = _normalizeUserId(userId);
    if (normalizedId != userId && _publicKeyCache.containsKey(normalizedId)) {
      return _publicKeyCache[normalizedId];
    }
    return null;
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

  Future<void> connect(String authToken) async {
    if (_channel != null && _channel?.closeCode == null) {
      print("Already connected or connecting.");
      return;
    }
    try {
      final uri = Uri.parse("$_serverUrl?token=$authToken");
      _channel = WebSocketChannel.connect(uri);
      print("WebSocket: Connecting to $uri...");

      _channel!.stream.listen(
            (dynamic rawMessage) async {
          print("WebSocket: Received raw: $rawMessage");
          if (rawMessage?.toString().contains(" is offline") == true &&
              rawMessage?.toString().contains("ErrorMessage") == true) {
            return;
          }
          try {
            final Map<String, dynamic> messageJson = jsonDecode(rawMessage as String);

            // Handle public key exchange (from server auth response)
            if (messageJson['publicKey'] != null) {
              final receivedPublicKey = messageJson['publicKey'] as String;
              final senderId = messageJson['senderId'] as String?;
              
              // Log empty public key for debugging
              if (receivedPublicKey.isEmpty) {
                logDebug('⚠️ Empty public key received for sender: $senderId - federated relay may be missing key');
                return; // Skip processing empty keys
              }
              
              logDebug('@@@@@@@@@@@@ received message with ids $senderId for $_currentUserId');
              if (_currentUserId == senderId) {
                logDebug('@@@@@@@@@@ self-message received, skipping...');
                return;
              }

              logDebug('@@@@@@@@@ Other user(${senderId}) public key received: '
                  '${receivedPublicKey.substring(0, 20)}...');

              if (senderId != null && senderId.isNotEmpty) {
                // Cache the public key in memory (both original and normalized forms)
                _publicKeyCache[senderId] = receivedPublicKey;
                
                // Also store under normalized ID for federated users
                final normalizedSenderId = _normalizeUserId(senderId);
                if (normalizedSenderId != senderId) {
                  _publicKeyCache[normalizedSenderId] = receivedPublicKey;
                }

                // Persist with original federated ID - SecureStorageService handles the mapping
                await secureStorage.saveContactPublicKey(senderId, receivedPublicKey);
                logDebug('@@@@@@@@@@@@ Public key cached for user: $senderId');

                // Notify callback so messages can be re-decrypted
                onPublicKeyReceived?.call(senderId, receivedPublicKey);
                // Also notify with normalized ID
                if (normalizedSenderId != senderId) {
                  onPublicKeyReceived?.call(normalizedSenderId, receivedPublicKey);
                }
              }

              logDebug('@@@@@@@@@@@@ Public keys exchanged successfully');
              return; // Don't process this as a chat message
            }

            if (messageJson['messageType'] != null &&
                messageJson['messageType'].toString().contains('TransactionCreatedMessage')) {
              final transactionId = messageJson['transactionId'] as String?;
              if (transactionId != null) {
                logDebug('@@@@@@@@@ Transaction created: $transactionId');
                // Create a system message to display in chat
                final systemMessage = ChatMessage(
                  id: 'system_transaction_$transactionId',
                  senderId: messageJson['partnerId'] as String? ?? "System",
                  recipientId: _currentUserId,
                  encryptedTextPayload: '',
                  plainText: '🤝 Transaction created. Use top-right menu to complete Transaction.',
                  timestamp: DateTime.now(),
                  status: EChatMessageStatus.delivered,
                  transactionId: transactionId,
                  isSentByCurrentUser: false,
                );
                
                _messageController.add(systemMessage);
              }
              return;
            }

            // Handle MessageStatusUpdate (SENT/DELIVERED confirmation from server)
            // Check if messageType contains 'MessageStatusUpdate' (handles full package paths)
            if (messageJson['messageType']?.toString().contains('MessageStatusUpdate') == true) {
              try {
                logDebug('@@@@@@@@@ MessageStatusUpdate received: ${messageJson['messageType']}');
                final statusUpdate = MessageStatusUpdate.fromJson(messageJson);
                _statusUpdateController.add(statusUpdate);
                logDebug('@@@@@@@@@ Message ${statusUpdate.messageId} status: ${statusUpdate.status}');
                return;
              } catch (e) {
                logDebug('@@@@@@@@@ Error processing MessageStatusUpdate: $e');
              }
            }

            // Handle ReadReceiptNotification (recipient read/received the message)
            // Check if messageType contains 'ReadReceiptNotification' (handles full package paths)
            if (messageJson['messageType']?.toString().contains('ReadReceiptNotification') == true) {
              try {
                logDebug('@@@@@@@@@ ReadReceiptNotification received: ${messageJson['messageType']}');
                logDebug('@@@@@@@@@ Full notification: $messageJson');
                final readReceipt = ReadReceiptNotification.fromJson(messageJson);
                _readReceiptController.add(readReceipt);
                logDebug('@@@@@@@@@ Message ${readReceipt.messageId} status: ${readReceipt.status} by ${readReceipt.readerId}');
                return;
              } catch (e) {
                logDebug('@@@@@@@@@ Error processing ReadReceiptNotification: $e');
                logDebug('@@@@@@@@@ Stack trace: ${StackTrace.current}');
              }
            }

            // Handle match notifications (web platform or no notification contacts)
            // Match notifications come as direct JSON with matchId field
            if (messageJson['matchId'] != null && 
                messageJson['matchType'] != null &&
                messageJson['title'] != null) {
              logDebug('@@@@@@@@@ Match notification received via WebSocket!');
              try {
                final matchNotification = MatchNotificationMessage.fromJson(messageJson);
                
                logDebug('@@@@@@@@@ Match details: type=${matchNotification.matchType}, '
                    'matchId=${matchNotification.matchId}, score=${matchNotification.matchScore}');
                logDebug('@@@@@@@@@ Title: ${matchNotification.title}');
                logDebug('@@@@@@@@@ Body: ${matchNotification.body}');
                
                // Reload match history (same as Firebase push notification handling)
                try {
                  final notificationsCubit = getIt<NotificationsCubit>();
                  await notificationsCubit.loadMatchHistory();
                  logDebug('✅ Match history reloaded from WebSocket notification');
                } catch (e) {
                  logDebug('❌ Failed to reload match history: $e');
                }
                
                // Show local notification if available
                if (_notificationService != null) {
                  logDebug('📣 Showing local notification for match');
                  
                  // Normalize title and body to handle attribute IDs
                  final normalizedTitle = TextUtils.normalizeNotificationText(matchNotification.title);
                  final normalizedBody = TextUtils.normalizeNotificationText(matchNotification.body);
                  
                  // Create a system-like chat message for notification purposes
                  final notificationMessage = ChatMessage(
                    id: 'match_${matchNotification.matchId}',
                    senderId: 'system',
                    recipientId: _currentUserId,
                    plainText: normalizedBody,
                    encryptedTextPayload: '',
                    timestamp: DateTime.now(),
                    status: EChatMessageStatus.delivered,
                  );
                  
                  _notificationService!.handleIncomingMessage(
                    notificationMessage,
                    senderName: normalizedTitle,
                  );
                }
                
                logDebug('@@@@@@@@@ Match notification processed successfully');
                return;
              } catch (e) {
                logDebug('@@@@@@@@@ Error processing match notification: $e');
                logDebug('Stack trace: ${StackTrace.current}');
              }
            }

            // Handle file notifications
            if (messageJson['messageType'] != null &&
                messageJson['messageType'].toString().contains('FileNotificationMessage')) {
              logDebug('@@@@@@@@@ File notification received!');
              try {
                final fileNotification = FileNotificationMessage.fromJson(
                    messageJson);

                // Don't show file notification from self
                if (fileNotification.senderId == _currentUserId) {
                  logDebug('@@@@@@@@@ File notification from self, skipping...');
                  return;
                }

                logDebug('@@@@@@@@@ Creating chat message with file attachment');
                final chatMessage = ChatMessage(
                  id: fileNotification.fileId,
                  senderId: fileNotification.senderId,
                  recipientId: _currentUserId,
                  // Current user is recipient
                  plainText: "",
                  // No text for file-only messages
                  encryptedTextPayload: "",
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                      fileNotification.timestamp),
                  status: EChatMessageStatus.delivered,
                  fileAttachment: fileNotification.toFileAttachment(),
                  senderName: messageJson['senderName'] as String?,
                );

                logDebug('@@@@@@@@@ Adding file message to stream');
                _messageController.add(chatMessage);

                // Show notification if user is not in this chat
                if (_notificationService != null) {
                  final senderName = messageJson['senderName'] as String? ?? fileNotification.senderId;
                  _notificationService!.handleIncomingMessage(
                    chatMessage,
                    senderName: senderName,
                  );
                }

                logDebug('@@@@@@@@@ File notification processed successfully');
                return;
              } catch (e) {
                logDebug('@@@@@@@@@ Error processing file notification: $e');
              }
            }

            // Handle federated chat messages (from other servers)
            // These come wrapped in a "data" field with "encryptedPayload" instead of "text"
            if (messageJson['messageType']?.toString().contains('ClientChatMessage') == true &&
                messageJson['data'] != null) {
              try {
                final data = messageJson['data'] as Map<String, dynamic>;
                final encryptedPayload = data['encryptedPayload'] as String?;
                final senderId = data['senderId'] as String?;
                final senderName = data['senderName'] as String?;
                final recipientId = data['recipientId'] as String?;
                final messageId = data['id'] as String?;
                final timestampStr = data['timestamp'] as String?;
                final senderPublicKey = data['senderPublicKey'] as String?;

                if (encryptedPayload == null || senderId == null) {
                  logDebug('⚠️ Federated message missing required fields');
                  return;
                }

                // Normalize federated user IDs by removing server suffix
                final normalizedSenderId = _normalizeUserId(senderId);
                final normalizedRecipientId = recipientId != null 
                    ? _normalizeUserId(recipientId) 
                    : _currentUserId;

                logDebug('📨 Federated message received from $senderId (normalized: $normalizedSenderId)');
                
                // Store the sender's public key if provided (new in protocol)
                if (senderPublicKey != null && senderPublicKey.isNotEmpty) {
                  logDebug('🔑 Received sender public key in federated message: ${senderPublicKey.substring(0, 20)}...');
                  
                  // Cache in memory under both forms
                  _publicKeyCache[senderId] = senderPublicKey;
                  _publicKeyCache[normalizedSenderId] = senderPublicKey;
                  
                  // Persist for future sessions
                  await secureStorage.saveContactPublicKey(senderId, senderPublicKey);
                  logDebug('✅ Stored public key for federated sender: $senderId');
                  
                  // Also store the federated ID mapping
                  await secureStorage.saveFederatedIdMapping(senderId);
                } else {
                  // Fallback: store mapping without key (will need P2P exchange later)
                  if (normalizedSenderId != senderId) {
                    await secureStorage.saveFederatedIdMapping(senderId);
                    logDebug('🌐 Stored federated mapping (no key): $normalizedSenderId -> $senderId');
                  }
                }

                // Parse timestamp (comes as milliseconds string from federated messages)
                DateTime timestamp;
                if (timestampStr != null) {
                  final millis = int.tryParse(timestampStr);
                  timestamp = millis != null
                      ? DateTime.fromMillisecondsSinceEpoch(millis)
                      : DateTime.now();
                } else {
                  timestamp = DateTime.now();
                }

                // Decrypt using the sender's public key from cache
                // Try with normalized ID first, then original
                String? messageDecrypted;
                messageDecrypted = await decryptMessageText(encryptedPayload, normalizedSenderId);
                if (messageDecrypted == null && senderId != normalizedSenderId) {
                  // Fallback to original senderId if different
                  messageDecrypted = await decryptMessageText(encryptedPayload, senderId);
                }
                
                // If decryption failed, log it - key will be fetched when chat is opened
                if (messageDecrypted == null) {
                  logDebug('🔑 Failed to decrypt federated message - public key will be fetched when chat opens');
                }

                final chatMsg = ChatMessage(
                  id: messageId ?? DateTime.now().toIso8601String(),
                  senderId: normalizedSenderId,
                  recipientId: normalizedRecipientId,
                  plainText: messageDecrypted,
                  encryptedTextPayload: encryptedPayload,
                  timestamp: timestamp,
                  status: EChatMessageStatus.delivered,
                  senderName: senderName,
                );

                // Show notification if user is not in this chat
                if (_notificationService != null) {
                  _notificationService!.handleIncomingMessage(
                    chatMsg,
                    senderName: senderName ?? normalizedSenderId,
                  );
                }

                _messageController.add(chatMsg);
                logDebug('✅ Federated message processed successfully');
                return;
              } catch (e) {
                logDebug('❌ Error processing federated message: $e');
                logDebug('Stack trace: ${StackTrace.current}');
                return;
              }
            }

            // Handle regular chat messages
            if (messageJson['text'] != null) {
              final encryptedText = messageJson['text'] as String;
              final senderId = messageJson['senderId'] as String?;
              final transactionId = messageJson['transactionId'] as String?;

              debugPrint('@@@@@@@@@@@@@@ Encrypted message received: '
                  '${encryptedText.substring(0, 20)}...');

              if (transactionId != null) {
                logDebug('@@@@@@@@@@ Message has transactionId: $transactionId');
              }

              // Decrypt using the sender's public key from cache
              // Returns null if decryption fails (e.g., missing public key)
              String? messageDecrypted;
              if (senderId != null) {
                messageDecrypted = await decryptMessageText(encryptedText, senderId);
              } else {
                print("ERROR: No senderId in message");
              }

              logDebug('@@@@@@@@@@ messageDecrypted ${DateTime.now()}: $messageDecrypted');
              final networkMessage = ChatMessage.fromJson(messageJson);

              ChatMessage chatMsg = ChatMessage(
                id: messageJson['serverMessageId'] ??
                    DateTime.now().toIso8601String(),
                senderId: networkMessage.senderId,
                recipientId: networkMessage.recipientId,
                plainText: messageDecrypted,
                encryptedTextPayload: networkMessage.encryptedTextPayload,
                timestamp: networkMessage.timestamp,
                status: EChatMessageStatus.delivered,
                senderName: messageJson['senderName'] as String?,
                transactionId: transactionId,
              );

              // Show notification if user is not in this chat
              if (_notificationService != null && senderId != null) {
                final senderName = messageJson['senderName'] as String? ?? senderId;
                _notificationService!.handleIncomingMessage(
                  chatMsg,
                  senderName: senderName,
                );
              }

              _messageController.add(chatMsg);
            }
          } catch (e) {
            print("WebSocket: Error processing received message: $e");
          }
        },
        onDone: () {
          print("WebSocket: Connection closed by server. Close code: ${_channel?.closeCode}, Reason: ${_channel?.closeReason}");
          // Handle reconnection logic if needed
        },
        onError: (error) {
          print("WebSocket: Error in stream: $error");
          // Handle reconnection logic
        },
        cancelOnError: false, // Keep listening even if one message processing fails
      );
      print("WebSocket: Connection established.");
    } catch (e) {
      print("WebSocket: Connection error: $e");
    }
  }

  Future<String?> decryptMessageText(String encryptedText, String senderId) async {
    String? messageDecrypted = null;
    String? senderPublicKeyBase64 = _publicKeyCache[senderId];

    // If not in cache, try normalized sender ID
    final normalizedSenderId = _normalizeUserId(senderId);
    if (senderPublicKeyBase64 == null && normalizedSenderId != senderId) {
      senderPublicKeyBase64 = _publicKeyCache[normalizedSenderId];
      logDebug('@@@@@@@@@@@@@@ Trying normalized sender ID: $normalizedSenderId (original: $senderId)');
    }

    // If not in cache, try loading from persistent storage
    if (senderPublicKeyBase64 == null) {
      senderPublicKeyBase64 = await secureStorage.getContactPublicKey(senderId);
      if (senderPublicKeyBase64 == null && normalizedSenderId != senderId) {
        senderPublicKeyBase64 = await secureStorage.getContactPublicKey(normalizedSenderId);
        if (senderPublicKeyBase64 != null) {
          logDebug('@@@@@@@@@@@@@@ Loaded public key from storage (normalized): $normalizedSenderId');
        }
      } else if (senderPublicKeyBase64 != null) {
        logDebug('@@@@@@@@@@@@@@ Loaded public key from storage for: $senderId');
      }
      
      if (senderPublicKeyBase64 != null) {
        // Cache under both forms
        _publicKeyCache[senderId] = senderPublicKeyBase64;
        if (normalizedSenderId != senderId) {
          _publicKeyCache[normalizedSenderId] = senderPublicKeyBase64;
        }
      }
    }

    if (senderPublicKeyBase64 != null) {
      final senderPublicKey = _cryptoService.ecPublicKeyFromString(
          senderPublicKeyBase64);
      if (senderPublicKey != null) {
        messageDecrypted =
            _cryptoService.decrypt(encryptedText, senderPublicKey);
        debugPrint(
            '@@@@@@@@@@@@@ Message decrypted: ${messageDecrypted ?? "FAILED"}');
      } else {
        print("ERROR: Failed to parse sender's public key");
      }
    } else {
      print(
          "ERROR: Sender's public key not found for user: $senderId");
    }
    return Future.value(messageDecrypted);
  }

  Future<void> sendAuthMessage(String auth) async {
    if (_channel == null || _channel!.closeCode != null) {
      print("WebSocket: Not connected. Cannot send message.");
      // Optionally, queue the message and try to send after reconnecting
      return;
    }
    _channel!.sink.add(auth);
    print("WebSocket: Sent auth message to Server");
  }

  Future<void> sendMessage(String plainText, String text,
      String recipientId) async {
    if (_channel == null || _channel!.closeCode != null) {
      print("WebSocket: Not connected. Cannot send message.");
      connect("");
      // Optionally, queue the message and try to send after reconnecting
      return;
    }

    try {
      // 1. ENCRYPTION
      String? encryptedPayload = text.isEmpty == true ? "" : text;

      final messageId = "client_${DateTime.now().millisecondsSinceEpoch}";

      // 2. Construct message for the network
      // This is what the SERVER will parse
      final networkMessagePayload = {
        "type": "chat_message", // Differentiate message types
        "data": {
          "id": messageId,
          "senderId": _currentUserId,
          "senderName": _currentUserName,
          "recipientId": recipientId,
          "encryptedPayload": encryptedPayload,
          "timestamp": DateTime.now().toIso8601String(),
        }
      };

      _channel!.sink.add(jsonEncode(networkMessagePayload));
      print("WebSocket: Sent message to $recipientId");
    } catch (e) {
      print("WebSocket: Error sending message: $e");
      // Handle error, maybe update message status to "failed"
    }
  }

  /// Send a read receipt to the server when user reads a message
  Future<void> sendReadReceipt(String messageId, String originalSenderId) async {
    if (_channel == null || _channel!.closeCode != null) {
      logDebug("❌ WebSocket: Not connected. Cannot send read receipt.");
      return;
    }

    try {
      final readReceipt = ReadReceiptRequest(
        messageId: messageId,
        senderId: originalSenderId,
      );

      final jsonPayload = jsonEncode(readReceipt.toJson());
      _channel!.sink.add(jsonPayload);
      logDebug("📤 WebSocket: Sent read receipt for message $messageId to sender $originalSenderId");
      logDebug("📤 Payload: $jsonPayload");
    } catch (e) {
      logDebug("❌ WebSocket: Error sending read receipt: $e");
    }
  }

  /// Disconnect WebSocket without disposing streams (for reconnection)
  void disconnect() {
    print("WebSocket: Disconnecting...");
    _channel?.sink.close(status.goingAway);
    _channel = null;
  }

  /// Dispose service completely (closes streams too)
  void dispose() {
    print("WebSocket: Disposing service and closing connection.");
    _channel?.sink.close(status.goingAway);
    _messageController.close();
    _statusUpdateController.close();
    _readReceiptController.close();
  }

}