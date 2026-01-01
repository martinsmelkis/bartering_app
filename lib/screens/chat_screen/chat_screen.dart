import 'package:barter_app/l10n/app_localizations.mapper.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/chat_notification_service.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/services/file_transfer_service.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:open_filex/open_filex.dart';
import 'dart:io';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/chat/e_chat_message_status.dart';
import '../../services/secure_storage_service.dart';
import '../chat_screen/cubit/chat_cubit.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/file_attachment.dart';

class ChatScreen extends StatefulWidget {
  final String? poiId; // Optional: ID of the POI that initiated the chat
  final String? poiName; // Optional: Name of the POI
  final bool showAppBar; // Whether to show the app bar (false for panel mode)

  const ChatScreen({
    super.key,
    this.poiId,
    this.poiName,
    this.showAppBar = true,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// In _ChatScreenState, you could use these parameters:
// @override
// void initState() {
//   super.initState();
//   if (widget.poiId != null) {
//     print("Chatting about POI: ${widget.poiName} (ID: ${widget.poiId})");
//     // You could use this ID to fetch specific chat history for this POI,
//     // or set the AppBar title, etc.
//     // For example, tell the cubit to load a chat for this POI:
//     // context.read<ChatCubit>().loadChatForPoi(widget.poiId!);
//   }
// }

class _ChatScreenState extends State<ChatScreen> {
  late ChatCubit _chatCubit;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    // Clear active chat when leaving screen
    try {
      final notificationService = getIt<ChatNotificationService>();
      notificationService.setActiveChat(null);
    } catch (e) {
      // Service might not be registered
    }

    _messages.clear();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(_messageController.text);
      _messageController.clear();
    }
  }

  Future<void> _pickAndSendFile() async {
    final l10n = AppLocalizations.of(context)!;

    // Get recipient public key from cubit
    var recipientPublicKey = _chatCubit.recipientPublicKey;

    print(
        '@@@@@@@@@ _pickAndSendFile - recipientPublicKey from cubit: ${recipientPublicKey !=
            null ? "${recipientPublicKey.substring(0, 20)}..." : "null"}');
    print('@@@@@@@@@ _pickAndSendFile - recipientUserId: ${_chatCubit
        .recipientUserId}');
    print('@@@@@@@@@ _pickAndSendFile - widget.poiId: ${widget.poiId}');

    // If not available from cubit, try loading directly from secure storage
    if (recipientPublicKey == null) {
      print(
          '@@@@@@@@@ Attempting to load recipient public key from storage...');
      final secureStorage = SecureStorageService();
      recipientPublicKey =
      await secureStorage.getContactPublicKey(_chatCubit.recipientUserId);

      if (recipientPublicKey != null) {
        print(
            '@@@@@@@@@ ✅ Loaded recipient public key from storage: ${recipientPublicKey
                .substring(0, 20)}...');
        // Update cubit with the loaded key
        _chatCubit.recipientPublicKey = recipientPublicKey;
      } else {
        print('@@@@@@@@@ ❌ Recipient public key not found in storage');
      }
    }

    if (recipientPublicKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot send file: Recipient public key not available'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              // Keys might have been exchanged by now
              _pickAndSendFile();
            },
          ),
        ),
      );
      return;
    }

    try {
      // Show bottom sheet with file options
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) =>
            SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ],
              ),
            ),
      );

      if (source == null) return;

      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) return;

      // Show uploading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Uploading file...'),
            ],
          ),
          duration: Duration(hours: 1), // Keep showing until we dismiss
        ),
      );

      // Upload file
      final fileTransferService = FileTransferService(getIt<ApiClient>(), CryptoService.instance!);
      final userRepository = getIt<UserRepository>();
      final currentUserId = await userRepository.getUserId();

      final fileAttachment = await fileTransferService.uploadFile(
        senderId: currentUserId!,
        recipientId: widget.poiId!,
        filePath: pickedFile.path,
        recipientPublicKey: recipientPublicKey,
      );

      // Dismiss uploading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (fileAttachment != null) {
        // Create message with file attachment
        final messageId = "client_${DateTime.now().millisecondsSinceEpoch}";
        final chatMessage = ChatMessage(
          id: messageId,
          senderId: currentUserId,
          recipientId: widget.poiId!,
          plainText: "",
          // Or add optional caption
          encryptedTextPayload: "",
          timestamp: DateTime.now(),
          status: EChatMessageStatus.sent,
          fileAttachment: fileAttachment,
        );

        // Send file message via cubit
        await _chatCubit.sendFileMessage(chatMessage);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final userRepository = getIt<UserRepository>();
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.currentUserId = await userRepository.getUserId() ?? "";
    _chatCubit.recipientUserId = widget.poiId ?? "";
    _chatCubit.initializeChatSession();

    // Recipient's public key will be loaded by the cubit
    // We'll get it from secure storage when needed

    // Set active chat to suppress notifications while in this screen
    try {
      final notificationService = getIt<ChatNotificationService>();
      notificationService.setActiveChat(widget.poiId);
      // Request notification permission for Android 13+
      await notificationService.requestNotificationPermission();
    } catch (e) {
      // Service might not be registered yet
    }
  }

  var _messages = List.empty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_messages.isEmpty) {
      _messages = context.select((ChatCubit cubit) => cubit.messages);
    }

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
        title: Text(widget.poiName ?? l10n.chat),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        foregroundColor: AppColors.background,
      )
          : null,
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatMessagesLoaded) {
            _messages = state.messages;
          }
          if (state is ChatMessagesLoaded ||
              state is ChatMessageSent ||
              state is ChatMessageSending) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollToBottom());
          }
          if (state is ChatKeysExchanged) {
            print('@@@@@@@@@@ Chat Keys Exchanged');
            // Public key is already updated in the cubit
            // Force UI refresh if needed
            setState(() {});
          }
          if (state is ChatError) {
            print('@@@@@@@@@@ Chat Error: ${state.message}');
            var errorText = state.message.contains("chatError_") ?
              Text(context.parseL10n(state.message)) : Text(state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: errorText,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Use smaller padding for web side-by-side view
          final bool isWebSideBySide = kIsWeb && !widget.showAppBar &&
              context.canShowSideBySide;
          final double listPadding = isWebSideBySide ? 4 : 10.w;

          return Column(
            children: [
              if (state is ChatMessagesLoading && _messages.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(listPadding),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              _buildMessageInputField(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // Check if message is from current user by comparing sender ID
    final bool isMe = message.senderId == _chatCubit.currentUserId;
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe ? AppColors.chatBubbleMe : AppColors.chatBubbleOther;
    final textColor = isMe ? Colors.grey[100] : Colors.black87;

    // Use much smaller sizes for web side-by-side view
    final bool isWebSideBySide = kIsWeb && !widget.showAppBar &&
        context.canShowSideBySide;
    final double messageFontSize = isWebSideBySide ? 14 : 15.sp;
    final double timeFontSize = isWebSideBySide ? 9 : 10.sp;
    final double verticalMargin = isWebSideBySide ? 4 : 4.h;
    final double horizontalMargin = isWebSideBySide ? 8 : 8.w;
    final double verticalPadding = isWebSideBySide ? 8 : 8.h;
    final double horizontalPadding = isWebSideBySide ? 6 : 8.w;
    final double borderRadius = isWebSideBySide ? 8 : 16.r;
    final double spacing = isWebSideBySide ? 4 : 4.h;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin, horizontal: horizontalMargin),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
              bottomLeft: isMe ? Radius.circular(borderRadius) : Radius
                  .circular(0),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(
                  borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ]),
        constraints: BoxConstraints(maxWidth: isWebSideBySide ? 250 : 0.75.sw),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // File attachment if present
            if (message.fileAttachment != null)
              _buildFileAttachment(
                  message.fileAttachment!, isMe, isWebSideBySide),
            // Text message
            if (message.plainText != null && message.plainText!.isNotEmpty) ...[
              if (message.fileAttachment != null) SizedBox(height: spacing),
              Text(
                message.plainText ?? "",
                style: TextStyle(color: textColor, fontSize: messageFontSize),
              ),
            ],
            SizedBox(height: spacing),
            Text(
              DateFormat('HH:mm').format(message.timestamp), // Example: 14:35
              style: TextStyle(
                color: isMe ? AppColors.background : Colors.black54,
                fontSize: timeFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachment(FileAttachment attachment, bool isMe,
      bool isWebSideBySide) {
    final iconSize = isWebSideBySide ? 32.0 : 40.0;
    final fontSize = isWebSideBySide ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => _handleFileAttachmentTap(attachment),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isWebSideBySide ? 200 : 0.6.sw,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview for images
            if (attachment.isImage && attachment.localPath != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.file(
                  File(attachment.localPath!),
                  width: double.infinity,
                  height: isWebSideBySide ? 150 : 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFileIcon(attachment, iconSize, fontSize, isMe);
                  },
                ),
              )
            else
              _buildFileIcon(attachment, iconSize, fontSize, isMe),

            // File info
            Padding(
              padding: EdgeInsets.all(isWebSideBySide ? 6 : 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.filename,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        attachment.fileSizeFormatted,
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.grey.shade600,
                        ),
                      ),
                      if (attachment.isDownloaded) ...[
                        SizedBox(width: 8),
                        Icon(
                          Icons.check_circle,
                          size: fontSize,
                          color: Colors.green,
                        ),
                      ] else
                        if (attachment.isUploading) ...[
                          SizedBox(width: 8),
                          SizedBox(
                            width: fontSize,
                            height: fontSize,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: attachment.uploadProgress,
                            ),
                          ),
                        ] else
                          ...[
                            SizedBox(width: 8),
                            Icon(
                              Icons.download,
                              size: fontSize,
                              color: isMe ? Colors.white70 : Colors.blue,
                            ),
                          ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileIcon(FileAttachment attachment, double iconSize,
      double fontSize, bool isMe) {
    IconData icon;
    Color iconColor;

    if (attachment.isImage) {
      icon = Icons.image;
      iconColor = Colors.blue;
    } else if (attachment.isVideo) {
      icon = Icons.videocam;
      iconColor = Colors.purple;
    } else if (attachment.isAudio) {
      icon = Icons.audiotrack;
      iconColor = Colors.orange;
    } else if (attachment.isDocument) {
      icon = Icons.description;
      iconColor = Colors.red;
    } else {
      icon = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Icon(
        icon,
        size: iconSize,
        color: isMe ? Colors.white70 : iconColor,
      ),
    );
  }

  Future<void> _handleFileAttachmentTap(FileAttachment attachment) async {
    if (attachment.isDownloaded && attachment.localPath != null) {
      // File already downloaded, open it
      print('@@@@@@@@@ File already downloaded, opening: ${attachment
          .localPath}');
      await _openFile(attachment.localPath!);
    } else if (!attachment.isUploading) {
      // Download the file
      print('@@@@@@@@@ File not downloaded, downloading...');
      await _downloadFile(attachment);
    } else {
      print('@@@@@@@@@ File is currently uploading, ignoring tap');
    }
  }

  Future<void> _downloadFile(FileAttachment attachment) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Downloading ${attachment.filename}...'),
            ],
          ),
          duration: Duration(hours: 1),
        ),
      );

      final fileTransferService = FileTransferService(
        getIt<ApiClient>(),
        await CryptoService.create(),
      );
      final userRepository = getIt<UserRepository>();
      final currentUserId = await userRepository.getUserId();

      // Get sender's public key (not our private key!)
      // The file was encrypted with our public key by the sender
      // We need sender's public key to derive the shared secret
      final secureStorage = SecureStorageService();
      final senderPublicKey = await secureStorage.getContactPublicKey(
          _chatCubit.recipientUserId);

      if (senderPublicKey == null) {
        throw Exception('Sender public key not found. Cannot decrypt file.');
      }

      print(
          '@@@@@@@@@ Downloading file with sender public key: ${senderPublicKey
              .substring(0, 20)}...');

      final localPath = await fileTransferService.downloadFile(
        fileId: attachment.fileId,
        userId: currentUserId!,
        filename: attachment.filename,
        senderPublicKey: senderPublicKey, // Changed parameter name for clarity
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (localPath != null) {
        // Update attachment with local path
        attachment.copyWith(
          localPath: localPath,
          isDownloaded: true,
        );

        setState(() {}); // Refresh UI

        // Automatically open the file
        await _openFile(localPath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openFile(String filePath) async {
    try {
      print('@@@@@@@@@ Opening file: $filePath');
      final result = await OpenFilex.open(filePath);

      print('@@@@@@@@@ OpenFilex result: ${result.type} - ${result.message}');

      // Handle the result based on result.type (int code)
      // 0 = done (success)
      // 1 = fileNotFound
      // 2 = noAppToOpen
      // 3 = permissionDenied
      // -1 = error

      if (result.type == ResultType.done) {
        // File opened successfully
        print('@@@@@@@@@ File opened successfully');
      } else if (result.type == ResultType.noAppToOpen) {
        // No app to open this file type
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No app found to open this file type'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Show Path',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File saved at: $filePath'),
                    duration: Duration(seconds: 5),
                  ),
                );
              },
            ),
          ),
        );
      } else if (result.type == ResultType.fileNotFound) {
        // File not found
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File not found: $filePath'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (result.type == ResultType.permissionDenied) {
        // Permission denied
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission denied to open file'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Other error (result.type == -1)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening file: ${result.message}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('@@@@@@@@@ Error opening file: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open file: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Show Path',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('File saved at: $filePath'),
                  duration: Duration(seconds: 5),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  Widget _buildMessageInputField() {
    final l10n = AppLocalizations.of(context)!;

    // Use much smaller sizes for web side-by-side view
    final bool isWebSideBySide = kIsWeb && !widget.showAppBar &&
        context.canShowSideBySide;
    final double horizontalPadding = isWebSideBySide ? 6 : 12.w;
    final double verticalPadding = isWebSideBySide ? 4 : 8.h;
    final double borderRadius = isWebSideBySide ? 12 : 25.r;
    final double contentHorizontalPadding = isWebSideBySide ? 8 : 16.w;
    final double contentVerticalPadding = isWebSideBySide ? 5 : 10.h;
    final double iconSize = isWebSideBySide ? 16 : 25.w;
    final double spacing = isWebSideBySide ? 4 : 8.w;
    final double fontSize = isWebSideBySide ? 11 : 14;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            iconSize: iconSize,
            icon: Icon(Icons.attach_file,
                color: Theme
                    .of(context)
                    .primaryColor),
            onPressed: _pickAndSendFile,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                hintText: l10n.typeAMessage,
                hintStyle: TextStyle(fontSize: fontSize),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: contentHorizontalPadding,
                    vertical: contentVerticalPadding),
                isDense: isWebSideBySide,
              ),
              //onSubmitted: (_) => _sendMessage(),
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: isWebSideBySide ? 3 : 5,
            ),
          ),
          SizedBox(width: spacing),
          IconButton(
            iconSize: iconSize,
            icon: Icon(Icons.send,
                color: Theme.of(context).primaryColor),
            onPressed: _sendMessage,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
