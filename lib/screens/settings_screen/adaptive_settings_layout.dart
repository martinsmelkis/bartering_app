// lib/screens/settings_screen/adaptive_settings_layout.dart
import 'package:flutter/material.dart';
import 'package:barter_app/screens/settings_screen/settings_screen.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/l10n/app_localizations.dart';

/// Adaptive settings layout that shows settings as a left side panel on large screens
/// and as a full screen on small screens
class AdaptiveSettingsLayout extends StatelessWidget {
  final Widget mainContent;
  final bool showSettingsPanel;
  final VoidCallback? onClose;

  const AdaptiveSettingsLayout({
    super.key,
    required this.mainContent,
    this.showSettingsPanel = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side with settings on the LEFT
    if (context.canShowSideBySide && showSettingsPanel) {
      return Row(
        children: [
          // Settings panel on the LEFT
          _SettingsPanel(
            onClose: onClose,
          ),
          // Main content takes remaining space
          Expanded(
            child: mainContent,
          ),
        ],
      );
    }

    // On small screens, just show main content
    // (navigation to settings screen happens via Navigator)
    return mainContent;
  }
}

/// Settings panel widget for side-by-side layout
class _SettingsPanel extends StatelessWidget {
  final VoidCallback? onClose;

  const _SettingsPanel({
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: context.settingsPanelWidth,
      color: AppColors.background,
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: l10n.settingsTitle,
            onClose: onClose,
          ),
          // Settings screen content
          Expanded(
            child: SettingsScreen(
              showAppBar: false, // No app bar in panel mode
            ),
          ),
        ],
      ),
    );
  }
}

/// Header for the settings panel
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
      color: Theme.of(context).primaryColor,
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
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

/// Wrapper widget that provides adaptive settings functionality
/// Use this to wrap your main screen to enable adaptive settings
class AdaptiveSettingsWrapper extends StatefulWidget {
  final Widget child;

  const AdaptiveSettingsWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AdaptiveSettingsWrapper> createState() => AdaptiveSettingsWrapperState();
}

class AdaptiveSettingsWrapperState extends State<AdaptiveSettingsWrapper> {
  bool _showSettingsPanel = false;

  /// Open settings in side panel (large screens) or navigate (small screens)
  void openSettings() {
    if (context.canShowSideBySide) {
      // Show in side panel
      setState(() {
        _showSettingsPanel = true;
      });
    } else {
      // Navigate to full screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        ),
      );
    }
  }

  /// Close the side panel
  void closeSettings() {
    setState(() {
      _showSettingsPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSettingsLayout(
      mainContent: widget.child,
      showSettingsPanel: _showSettingsPanel,
      onClose: closeSettings,
    );
  }
}
