// lib/screens/user_profile_screen/adaptive_nested_panel_layout.dart
import 'package:flutter/material.dart';
import 'package:barter_app/screens/notifications_screen/notifications_screen.dart';
import 'package:barter_app/screens/match_history_screen/match_history_screen.dart';
import 'package:barter_app/screens/manage_postings_screen/manage_postings_screen.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/nested_panel_cubit.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/l10n/app_localizations.dart';

/// Adaptive nested panel layout that shows nested panels within profile screen
/// on large screens and as full screens on small screens
class AdaptiveNestedPanelLayout extends StatelessWidget {
  final Widget mainContent;
  final NestedPanelType panelType;
  final String? userId; // For manage postings
  final VoidCallback? onClose;

  const AdaptiveNestedPanelLayout({
    super.key,
    required this.mainContent,
    this.panelType = NestedPanelType.none,
    this.userId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side with nested panel on the RIGHT (within profile container)
    if (context.canShowSideBySide && panelType != NestedPanelType.none) {
      return Row(
        children: [
          // Main content takes remaining space
          Expanded(
            child: mainContent,
          ),
          // Nested panel on the RIGHT within profile container
          _NestedPanel(
            panelType: panelType,
            userId: userId,
            onClose: onClose,
          ),
        ],
      );
    }

    // On small screens, just show main content
    // (navigation to nested screens happens via Navigator)
    return mainContent;
  }
}

/// Nested panel widget for side-by-side layout within profile
class _NestedPanel extends StatelessWidget {
  final NestedPanelType panelType;
  final String? userId;
  final VoidCallback? onClose;

  const _NestedPanel({
    required this.panelType,
    this.userId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Nested panel is 60% of profile panel width
    final double nestedPanelWidth = context.profilePanelWidth * 0.6;

    Widget panelContent;
    String panelTitle;

    switch (panelType) {
      case NestedPanelType.notifications:
        panelContent = const NotificationsScreen(showAppBar: false);
        panelTitle = l10n.notificationPreferences;
        break;
      case NestedPanelType.matchHistory:
        panelContent = const MatchHistoryScreen(showAppBar: false);
        panelTitle = l10n.matchHistory;
        break;
      case NestedPanelType.managePostings:
        panelContent = ManagePostingsScreen(
          userId: userId ?? '',
          showAppBar: false,
        );
        panelTitle = l10n.managePostings;
        break;
      case NestedPanelType.none:
        return const SizedBox.shrink();
    }

    return Container(
      width: nestedPanelWidth,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0), // Shadow to the left
          ),
        ],
      ),
      child: Column(
        children: [
          // Custom header for the nested panel
          _PanelHeader(
            title: panelTitle,
            onClose: onClose,
          ),
          // Nested panel content
          Expanded(
            child: panelContent,
          ),
        ],
      ),
    );
  }
}

/// Header for the nested panel
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
              title,
              style: const TextStyle(
                color: AppColors.background,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.background, size: 16),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
