// lib/screens/user_profile_screen/adaptive_profile_layout.dart
import 'package:flutter/material.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/screens/user_profile_screen/user_profile_screen.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';

const String _kProfilePanelTitle = 'Profile';

/// Adaptive profile layout that shows profile as a left side panel on large screens
/// and as a full screen on small screens
class AdaptiveProfileLayout extends StatelessWidget {
  final Widget mainContent;
  final bool showProfilePanel;
  final String? userId;
  final String? userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;
  final VoidCallback? onClose;
  final bool hasNestedPanelOpen; // Whether a nested panel is open inside profile

  const AdaptiveProfileLayout({
    super.key,
    required this.mainContent,
    this.showProfilePanel = false,
    this.userId,
    this.userName,
    this.interests,
    this.offerings,
    this.onClose,
    this.hasNestedPanelOpen = false
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side with profile on the LEFT
    if (context.canShowSideBySide && showProfilePanel && userId != null && userName != null) {
      return Row(
        children: [
          // Profile panel on the LEFT
          _ProfilePanel(
            userId: userId!,
            userName: userName!,
            interests: interests,
            offerings: offerings,
            onClose: onClose,
            hasNestedPanelOpen: hasNestedPanelOpen
          ),
          // Main content takes remaining space
          Expanded(
            child: mainContent,
          ),
        ],
      );
    }

    // On small screens, just show main content
    // (navigation to profile screen happens via Navigator)
    return mainContent;
  }
}

/// Profile panel widget for side-by-side layout
class _ProfilePanel extends StatefulWidget {
  final String userId;
  final String userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;
  final VoidCallback? onClose;
  final bool hasNestedPanelOpen;

  const _ProfilePanel({
    required this.userId,
    required this.userName,
    this.interests,
    this.offerings,
    this.onClose,
    this.hasNestedPanelOpen = false
  });

  @override
  State<_ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<_ProfilePanel> {
  bool _localNestedPanelOpen = false;

  @override
  Widget build(BuildContext context) {
    // When nested panel is open, add its width to the total container width
    // Profile itself keeps its original width and doesn't shrink
    final bool isExpanded = widget.hasNestedPanelOpen || _localNestedPanelOpen;
    final double profileWidth = isExpanded
        ? context.profilePanelWidth + (context.profilePanelWidth * 0.82) // Original + nested panel width
        : context.profilePanelWidth;

    return Container(
      width: profileWidth,
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        children: [
          // Custom header for the panel
          _PanelHeader(
            title: _kProfilePanelTitle,
            onClose: widget.onClose,
          ),
          // Profile screen content
          Expanded(
            child: UserProfileScreen(
              userId: widget.userId,
              userName: widget.userName,
              interests: widget.interests,
              offerings: widget.offerings,
              showAppBar: false, // No app bar in panel mode
              onNestedPanelChanged: (isOpen) {
                setState(() {
                  _localNestedPanelOpen = isOpen;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Header for the profile panel
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
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

/// Wrapper widget that provides adaptive profile functionality
/// Use this to wrap your main screen to enable adaptive profile
class AdaptiveProfileWrapper extends StatefulWidget {
  final Widget child;

  const AdaptiveProfileWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AdaptiveProfileWrapper> createState() => AdaptiveProfileWrapperState();
}

class AdaptiveProfileWrapperState extends State<AdaptiveProfileWrapper> {
  bool _showProfilePanel = false;
  String? _userId;
  String? _userName;
  List<ParsedAttributeData>? _interests;
  List<ParsedAttributeData>? _offerings;

  /// Open profile in side panel (large screens) or navigate (small screens)
  void openProfile({
    required String userId,
    required String userName,
    List<ParsedAttributeData>? interests,
    List<ParsedAttributeData>? offerings,
  }) {
    if (context.canShowSideBySide) {
      // Show in side panel
      setState(() {
        _showProfilePanel = true;
        _userId = userId;
        _userName = userName;
        _interests = interests;
        _offerings = offerings;
      });
    } else {
      // Navigate to full screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => UserProfileScreen(
            userId: userId,
            userName: userName,
            interests: interests,
            offerings: offerings,
          ),
        ),
      );
    }
  }

  /// Close the side panel
  void closeProfile() {
    setState(() {
      _showProfilePanel = false;
      _userId = null;
      _userName = null;
      _interests = null;
      _offerings = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveProfileLayout(
      mainContent: widget.child,
      showProfilePanel: _showProfilePanel,
      userId: _userId,
      userName: _userName,
      interests: _interests,
      offerings: _offerings,
      onClose: closeProfile,
    );
  }
}
