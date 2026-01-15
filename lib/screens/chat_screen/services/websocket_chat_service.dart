import 'dart:async';
import 'dart:convert';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../models/chat/chat_message.dart';
import '../../../models/chat/e_chat_message_status.dart';
import '../../../models/chat/file_notification_message.dart';
import '../../../services/crypto/crypto_service.dart';
import '../../../services/messaging/chat_notification_service.dart';

class WebSocketChatService {
  // Optional: Notification service for background notifications
  ChatNotificationService? _notificationService;
  WebSocketChannel? _channel;
  StreamController<ChatMessage> _messageController =
    StreamController<ChatMessage>.broadcast();
  CryptoService _cryptoService;
  SecureStorageService secureStorage = SecureStorageService();
  String _currentUserId;
  String _currentUserName;
  String _serverUrl;

  // Cache of contact public keys: userId -> base64 public key
  final Map<String, String> _publicKeyCache = {};

  Stream<ChatMessage> get messages => _messageController.stream;

  WebSocketChatService(this._cryptoService,
      this._currentUserId,
      this._currentUserName,
      this._serverUrl,
      {ChatNotificationService? notificationService})
      : _notificationService = notificationService;

  // Loads a contact's public key into cache if available
  // This is useful when initializing a chat session
  Future<void> loadContactPublicKey(String userId) async {
    if (_publicKeyCache.containsKey(userId)) {
      logDebug('@@@@@@@@@@@@ Public key already cached for: $userId');
      return;
    }

    final publicKey = await secureStorage.getContactPublicKey(userId);
    if (publicKey != null) {
      _publicKeyCache[userId] = publicKey;
      logDebug('@@@@@@@@@@@@ Preloaded public key from storage for: $userId');
    } else {
      logDebug('@@@@@@@@@@@@ No cached public key found for: $userId');
    }
  }

  // Gets a contact's public key from cache
  // Returns null if not found
  String? getContactPublicKey(String userId) {
    return _publicKeyCache[userId];
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
            if (messageJson['publicKey'] != null &&
                messageJson['publicKey'] as String != "") {
              final receivedPublicKey = messageJson['publicKey'] as String;
              final senderId = messageJson['senderId'] as String?;
              logDebug('@@@@@@@@@@@@ received message with ids $senderId for $_currentUserId');
              if (_currentUserId == senderId) {
                logDebug('@@@@@@@@@@ self-message received, skipping...');
                return;
              }

              logDebug('@@@@@@@@@ Other user(${senderId}) public key received: '
                  '${receivedPublicKey.substring(0, 20)}...');

              if (senderId != null && senderId.isNotEmpty) {
                // Cache the public key in memory
                _publicKeyCache[senderId] = receivedPublicKey;

                // Also persist it for future sessions
                await secureStorage.saveContactPublicKey(senderId, receivedPublicKey);
                logDebug('@@@@@@@@@@@@ Public key cached for user: $senderId');
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

            // Handle chat messages
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
              String? messageDecrypted;
              if (senderId != null) {
                // Try to get from cache first
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

  Future<String> decryptMessageText(String encryptedText, String senderId) async {

    String? messageDecrypted = "";
    String? senderPublicKeyBase64 = _publicKeyCache[senderId];

    // If not in cache, try loading from persistent storage
    if (senderPublicKeyBase64 == null) {
      senderPublicKeyBase64 =
          await secureStorage.getContactPublicKey(senderId);
      if (senderPublicKeyBase64 != null) {
        _publicKeyCache[senderId] = senderPublicKeyBase64;
        logDebug('@@@@@@@@@@@@@@ Loaded public key from storage for: $senderId');
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

  void dispose() {
    print("WebSocket: Disposing service and closing connection.");
    _channel?.sink.close(status.goingAway);
    _messageController.close();
  }

}