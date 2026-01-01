// lib/screens/chat_screen/adaptive_chat_layout.dart
import 'package:flutter/material.dart';
import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/screens/chats_list_screen/chats_list_screen.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

/// Adaptive chat layout that shows chat or chats list as a side panel on large screens
/// and as a full screen on small screens
class AdaptiveChatLayout extends StatelessWidget {
  final Widget mainContent;
  final PanelView panelView;
  final String? selectedPoiId;
  final String? selectedPoiName;
  final VoidCallback? onClose;
  final Function(String poiId, String poiName)? onChatSelected;

  const AdaptiveChatLayout({
    super.key,
    required this.mainContent,
    this.panelView = PanelView.none,
    this.selectedPoiId,
    this.selectedPoiName,
    this.onClose,
    this.onChatSelected,
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side
    if (context.canShowSideBySide && panelView != PanelView.none) {
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
    return Container(
      width: context.panelWidth,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: 'Chats',
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
    return Container(
      width: context.panelWidth,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: poiName ?? 'Chat',
            onClose: onClose,
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
class _PanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _PanelHeader({
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .primaryColor,
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
              title,
              style: const TextStyle(
                color: AppColors.background,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(
                  Icons.close, color: AppColors.background, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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
