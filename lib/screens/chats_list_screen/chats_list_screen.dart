import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/data/local/app_database.dart';
import 'package:barter_app/repositories/chat_repository.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class ChatsListScreen extends StatefulWidget {
  final bool showAppBar;
  final Function(String poiId, String poiName)? onChatSelected;

  const ChatsListScreen({
    super.key,
    this.showAppBar = true,
    this.onChatSelected,
  });

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final ChatRepository _chatRepository = getIt<ChatRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  String? _currentUserId;

  // Avatar SVG assets (dynamically generated)
  static const int _svgAssetCount = 25;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    _currentUserId = await _userRepository.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_currentUserId == null) {
      return Scaffold(
        appBar: widget.showAppBar ? AppBar(
          title: Text(l10n.chat),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          foregroundColor: AppColors.background,
        ) : null,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(l10n.chat),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        foregroundColor: AppColors.background,
      ) : null,
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Conversation>>(
        stream: _chatRepository.watchConversationsForUser(_currentUserId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text('${l10n.errorLoadingChats}: ${snapshot.error}'),
                ],
              ),
            );
          }

          final conversations = snapshot.data ?? [];

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.noChatsYet,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.startConversationFromMap,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) =>
                Divider(
                  height: 1,
                  indent: 80.w,
                  color: Colors.grey.shade300,
                ),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return Dismissible(
                key: Key(conversation.conversationId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                confirmDismiss: (direction) =>
                    _confirmDelete(context, conversation),
                onDismissed: (direction) => _deleteConversation(conversation),
                child: _ConversationTile(
                  conversation: conversation,
                  currentUserId: _currentUserId!,
                  svgAssetCount: _svgAssetCount,
                  onTap: () => _openChat(conversation),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openChat(Conversation conversation) async {
    final l10n = AppLocalizations.of(context)!;

    // Get the other participant's ID
    final participants = await _chatRepository.getConversationParticipants(
      conversation.conversationId,
      excludeUserId: _currentUserId,
    );

    if (participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotFindChatParticipant)),
      );
      return;
    }

    final otherUserId = participants.first;

    //If callback is provided (side-by-side mode), use it
    if (widget.onChatSelected != null) {
      widget.onChatSelected!(
        otherUserId,
        otherUserId,
      );
      return;
    }

    // Otherwise, navigate to chat screen (mobile/full-screen mode)
    context.push('/chat/$otherUserId');
  }

  Future<bool?> _confirmDelete(BuildContext context,
      Conversation conversation) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteConversation),
          content: Text(l10n.deleteConversationConfirmation),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteConversation(Conversation conversation) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await _chatRepository.deleteConversation(conversation.conversationId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.conversationDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorDeletingConversation}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final int svgAssetCount;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
    required this.svgAssetCount,
    required this.onTap,
  });

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/path$index.svg';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chatRepository = getIt<ChatRepository>();

    // Detect web side-by-side mode for smaller sizes
    final bool isWebSideBySide = kIsWeb && context.canShowSideBySide;

    // Adjust sizes for web side-by-side view
    final double avatarSize = isWebSideBySide ? 40 : 64.w;
    final double horizontalPadding = isWebSideBySide ? 8 : 16.w;
    final double verticalPadding = isWebSideBySide ? 2 : 4.h;
    final double spacing = isWebSideBySide ? 6 : 12.w;
    final double nameFontSize = isWebSideBySide ? 12 : 16.sp;
    final double timestampFontSize = isWebSideBySide ? 9 : 12.sp;
    final double messageFontSize = isWebSideBySide ? 10 : 14.sp;
    final double iconSize = isWebSideBySide ? 10 : 14.sp;
    final double badgeFontSize = isWebSideBySide ? 8 : 11.sp;
    final double badgeHorizontalPadding = isWebSideBySide ? 5 : 8.w;
    final double badgeVerticalPadding = isWebSideBySide ? 2 : 4.h;
    final double badgeRadius = isWebSideBySide ? 8 : 12.r;

    return FutureBuilder<List<String>>(
      future: chatRepository.getConversationParticipants(
        conversation.conversationId,
        excludeUserId: currentUserId,
      ),
      builder: (context, snapshot) {
        final otherUserId = snapshot.data?.firstOrNull ?? l10n.unknownUser;
        final isFromMe = conversation.lastMessageSenderId == currentUserId;

        return InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(otherUserId, avatarSize),
                SizedBox(width: spacing),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name and timestamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _formatUserId(otherUserId, context),
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.lastMessageTimestamp != null)
                            Text(
                              _formatTimestamp(
                                conversation.lastMessageTimestamp!,
                                context,
                              ),
                              style: TextStyle(
                                fontSize: timestampFontSize,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: isWebSideBySide ? 2 : 4.h),
                      // Last message
                      Row(
                        children: [
                          if (isFromMe)
                            Padding(
                              padding: EdgeInsets.only(
                                right: isWebSideBySide ? 2 : 4.w,
                              ),
                              child: Icon(
                                Icons.check,
                                size: iconSize,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              conversation.lastMessage ?? l10n.noMessagesYet,
                              style: TextStyle(
                                fontSize: messageFontSize,
                                color: conversation.unreadCount > 0
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                                fontWeight: conversation.unreadCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Unread badge
                if (conversation.unreadCount > 0) ...[
                  SizedBox(width: isWebSideBySide ? 4 : 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: badgeHorizontalPadding,
                      vertical: badgeVerticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(badgeRadius),
                    ),
                    child: Text(
                      conversation.unreadCount > 99
                          ? l10n.ninetyNinePlus
                          : conversation.unreadCount.toString(),
                      style: TextStyle(
                        fontSize: badgeFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String userId, double size) {
    // Use the userId to get a consistent random icon (same as map screen)
    final userIdHashCode = userId.hashCode;
    final index = userIdHashCode.abs() % svgAssetCount;
    final selectedIconPath = _getSvgAsset(index + 1); // 1-based index

    return FutureBuilder<String>(
      future: _loadAndModifySvg(selectedIconPath, userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return ClipOval(
          child: SvgPicture.string(
            snapshot.data!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  /// Loads an SVG asset and replaces color with consistent user color
  Future<String> _loadAndModifySvg(String assetPath, String userId) async {
    return AvatarColorUtils.loadAndColorSvgFromString(
      assetPath: assetPath,
      identifier: userId,
    );
  }

  String _formatUserId(String userId, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Shorten UUID for display
    if (userId.length > 20) {
      return '${l10n.userPrefix} ${userId.substring(0, 8)}...';
    }
    return userId;
  }

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      // Yesterday
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      // Within a week - show day name
      return DateFormat('EEE').format(timestamp);
    } else if (difference.inDays < 365) {
      // Within a year - show date
      return DateFormat('MMM d').format(timestamp);
    } else {
      // Older - show year
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
