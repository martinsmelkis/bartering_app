// lib/screens/chat_screen/adaptive_chat_layout.dart
import 'package:flutter/material.dart';
import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:barter_app/screens/chat_screen/cubit/chat_cubit.dart';
import 'package:barter_app/screens/chat_screen/widgets/report_user_dialog.dart';
import 'package:barter_app/models/relationships/report_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Adaptive chat layout that shows chat or chats list as a side panel on large screens
/// and as a full screen on small screens
class AdaptiveChatLayout extends StatelessWidget {
  final Widget mainContent;
  final PanelView panelView;
  final String? selectedPoiId;
  final String? selectedPoiName;
  final VoidCallback? onClose;
  final Function(String poiId, String poiName)? onChatSelected;
  final bool suppressChatPanel;

  const AdaptiveChatLayout({
    super.key,
    required this.mainContent,
    this.panelView = PanelView.none,
    this.selectedPoiId,
    this.selectedPoiName,
    this.onClose,
    this.onChatSelected,
    this.suppressChatPanel = false,
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side (unless suppressed)
    if (context.canShowSideBySide && panelView != PanelView.none && !suppressChatPanel) {
      return Row(
        children: [
          // Main content takes remaining space
          Expanded(
            child: mainContent,
          ),
          // Panel on the right
          if (panelView == PanelView.chatsList)
            _ChatsListPanel(
              onClose: onClose,
              onChatSelected: onChatSelected,
            )
          else
            if (panelView == PanelView.chat && selectedPoiId != null)
              _ChatPanel(
                poiId: selectedPoiId!,
                poiName: selectedPoiName,
                onClose: onClose,
              ),
        ],
      );
    }

    // On small screens, just show main content
    // (navigation to chat screen happens via Navigator)
    return mainContent;
  }
}

/// Chats list panel widget for side-by-side layout
class _ChatsListPanel extends StatelessWidget {
  final VoidCallback? onClose;
  final Function(String poiId, String poiName)? onChatSelected;

  const _ChatsListPanel({
    this.onClose,
    this.onChatSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: context.panelWidth * 0.8,
      color: AppColors.background,
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: l10n.chats,
            onClose: onClose,
          ),
          // Chats list content
          Expanded(
            child: ChatsListScreen(
              showAppBar: false,
              onChatSelected: onChatSelected,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat panel widget for side-by-side layout
class _ChatPanel extends StatelessWidget {
  final String poiId;
  final String? poiName;
  final VoidCallback? onClose;

  const _ChatPanel({
    required this.poiId,
    this.poiName,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: context.panelWidth * 0.8,
      color: AppColors.background,
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: poiName ?? l10n.chat,
            onClose: onClose,
            showMenu: true,
            poiId: poiId,
          ),
          // Chat screen content
          Expanded(
            child: ChatScreen(
              poiId: poiId,
              poiName: poiName,
              showAppBar: false, // No app bar in panel mode
            ),
          ),
        ],
      ),
    );
  }
}

/// Header for the panel (used for both chat and chats list)
class _PanelHeader extends StatefulWidget {
  final String title;
  final VoidCallback? onClose;
  final bool showMenu;
  final String? poiId;

  const _PanelHeader({
    required this.title,
    this.onClose,
    this.showMenu = false,
    this.poiId,
  });

  @override
  State<_PanelHeader> createState() => _PanelHeaderState();
}

class _PanelHeaderState extends State<_PanelHeader> {
  bool _isUserBlocked = false;

  @override
  void initState() {
    super.initState();
    if (widget.showMenu && widget.poiId != null) {
      _checkIfUserBlocked();
    }
  }

  Future<void> _checkIfUserBlocked() async {
    // Get the blocked status from the chat cubit if available
    if (mounted) {
      final chatCubit = context.read<ChatCubit>();
      final blocked = await chatCubit.isUserBlocked(widget.poiId!);
      if (mounted) {
        setState(() {
          _isUserBlocked = blocked;
        });
      }
    }
  }

  Future<void> _handleFinishTransaction(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => PointerInterceptor(
        child: AlertDialog(
          title: Text(l10n.finishTransaction),
          content: Text(l10n.finishTransactionConfirmation),
          actions: [
            PointerInterceptor(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
            ),
            PointerInterceptor(
              child: ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.finishTransaction),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    // Call cubit to handle transaction
    context.read<ChatCubit>().finishTransaction();
  }

  Future<void> _handleReportUser(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.poiId == null) return;

    // Show report dialog with reason selection
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => PointerInterceptor(
        child: ReportUserDialog(
          targetUserName: widget.title,
        ),
      ),
    );

    if (result == null || !mounted) return;

    final ReportReason reason = result['reason'];
    final String? description = result['description'];

    // Report the user via cubit
    final reportId = await context.read<ChatCubit>().reportUser(
      reportedUserId: widget.poiId!,
      reason: reason,
      description: description,
      contextType: ReportContextType.chat,
      contextId: widget.poiId,
    );

    if (!mounted) return;

    if (reportId != null) {
      // Show success and offer to block
      final shouldBlock = await showDialog<bool>(
        context: context,
        builder: (context) => PointerInterceptor(
          child: AlertDialog(
            title: Text(l10n.userReported),
            content: Text(l10n.reportSubmittedOfferBlock),
            actions: [
              PointerInterceptor(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
              ),
              PointerInterceptor(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.blockUser),
                ),
              ),
            ],
          ),
        ),
      );

      if (shouldBlock == true && mounted) {
        await _handleBlockUser(context);
      }
    }
  }

  Future<void> _handleBlockUser(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.poiId == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => PointerInterceptor(
        child: AlertDialog(
          title: Text(l10n.blockUser),
          content: Text(l10n.blockUserConfirmation),
          actions: [
            PointerInterceptor(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
            ),
            PointerInterceptor(
              child: ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.block),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    // Block the user via cubit
    final success = await context.read<ChatCubit>().blockUser(widget.poiId!);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isUserBlocked = true;
      });
    }
  }

  Future<void> _handleUnblockUser(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.poiId == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => PointerInterceptor(
        child: AlertDialog(
          title: Text(l10n.unblockUser),
          content: Text(l10n.unblockUserConfirmation),
          actions: [
            PointerInterceptor(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
            ),
            PointerInterceptor(
              child: ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.unblock),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    // Unblock the user via cubit
    final success = await context.read<ChatCubit>().unblockUser(widget.poiId!);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isUserBlocked = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userUnblocked)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.showMenu)
            PointerInterceptor(
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.background, size: 18),
                onSelected: (value) {
                  if (value == 'finish_transaction') {
                    _handleFinishTransaction(context);
                  } else if (value == 'report_user') {
                    _handleReportUser(context);
                  } else if (value == 'block_user') {
                    _handleBlockUser(context);
                  } else if (value == 'unblock_user') {
                    _handleUnblockUser(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'finish_transaction',
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline),
                        SizedBox(width: 8.w),
                        Text(l10n.finishTransaction),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'report_user',
                    child: Row(
                      children: [
                        const Icon(Icons.report_outlined),
                        SizedBox(width: 8.w),
                        Text(l10n.reportUser),
                      ],
                    ),
                  ),
                  if (_isUserBlocked)
                    PopupMenuItem<String>(
                      value: 'unblock_user',
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle),
                          SizedBox(width: 8.w),
                          Text(l10n.unblockUser),
                        ],
                      ),
                    )
                  else
                    PopupMenuItem<String>(
                      value: 'block_user',
                      child: Row(
                        children: [
                          const Icon(Icons.block),
                          SizedBox(width: 8.w),
                          Text(l10n.blockUser),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          if (widget.onClose != null)
            PointerInterceptor(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: widget.onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper method to open chat adaptively
/// On large screens: Updates the layout state to show side panel
/// On small screens: Navigates to full-screen chat
class AdaptiveChatNavigation {
  static void openChat({
    required BuildContext context,
    required String poiId,
    String? poiName,
  }) {
    if (context.canShowSideBySide) {
      // For side panel, we need to update state in the parent widget
      // This is typically handled by a state management solution
      // For now, we'll just navigate normally but could be extended
      _navigateToChat(context, poiId, poiName);
    } else {
      // Navigate to full screen chat
      _navigateToChat(context, poiId, poiName);
    }
  }

  static void _navigateToChat(BuildContext context,
      String poiId,
      String? poiName,) {
    context.push('/chat/$poiId');
  }
}

/// Wrapper widget that provides adaptive chat functionality
/// Use this to wrap your main screen to enable adaptive chat
class AdaptiveChatWrapper extends StatefulWidget {
  final Widget child;

  const AdaptiveChatWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AdaptiveChatWrapper> createState() => AdaptiveChatWrapperState();
}

class AdaptiveChatWrapperState extends State<AdaptiveChatWrapper> {
  String? _selectedPoiId;
  String? _selectedPoiName;

  /// Open chat in side panel (large screens) or navigate (small screens)
  void openChat(String poiId, {String? poiName}) {
    if (context.canShowSideBySide) {
      // Show in side panel
      setState(() {
        _selectedPoiId = poiId;
        _selectedPoiName = poiName;
      });
    } else {
      // Navigate to full screen
      context.push('/chat/$poiId');
    }
  }

  /// Close the side panel
  void closeChat() {
    setState(() {
      _selectedPoiId = null;
      _selectedPoiName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveChatLayout(
      mainContent: widget.child,
      selectedPoiId: _selectedPoiId,
      selectedPoiName: _selectedPoiName,
      onClose: closeChat,
    );
  }
}
