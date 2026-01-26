import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/screens/chat_screen/widgets/chat_panel_header.dart';
import '../../models/map/point_of_interest.dart';

/// Adaptive POI layout that shows POI details as a side panel on large screens
/// and as a full screen on small screens
class AdaptivePoiLayout extends StatelessWidget {
  final Widget mainContent;
  final bool showPoiPanel;
  final PointOfInterest? selectedPoi;
  final VoidCallback? onClose;
  final VoidCallback? onChatButtonPressed;

  const AdaptivePoiLayout({
    super.key,
    required this.mainContent,
    this.showPoiPanel = false,
    this.selectedPoi,
    this.onClose,
    this.onChatButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    // On large screens, show side-by-side
    if (context.canShowSideBySide && showPoiPanel && selectedPoi != null) {
      return BlocBuilder<ChatPanelCubit, ChatPanelState>(
        builder: (context, chatState) {
          return Row(
            children: [
              // Main content takes remaining space
              Expanded(
                child: mainContent,
              ),
              // Panel on the right
              _PoiDetailsPanel(
                poi: selectedPoi!,
                onClose: onClose,
                onChatButtonPressed: onChatButtonPressed,
                showChatBelow: chatState.isChatOpen && chatState.selectedPoiId == selectedPoi!.profile.userId,
                chatPoiId: chatState.selectedPoiId,
                chatPoiName: chatState.selectedPoiName,
              ),
            ],
          );
        },
      );
    }

    // On small screens, just show main content
    // (navigation to POI details happens via bottom sheet)
    return mainContent;
  }
}

/// POI details panel widget for side-by-side layout
class _PoiDetailsPanel extends StatelessWidget {
  final PointOfInterest poi;
  final VoidCallback? onClose;
  final VoidCallback? onChatButtonPressed;
  final bool showChatBelow;
  final String? chatPoiId;
  final String? chatPoiName;

  const _PoiDetailsPanel({
    required this.poi,
    this.onClose,
    this.onChatButtonPressed,
    this.showChatBelow = false,
    this.chatPoiId,
    this.chatPoiName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.panelWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: showChatBelow && chatPoiId != null
          ? Column(
              children: [
                // POI Details - 40% of the height
                Expanded(
                  flex: 4,
                  child: PoiDetailsBottomSheet(
                    poi: poi,
                    isLargeScreen: true,
                    onClose: onClose,
                    onChatButtonPressed: onChatButtonPressed ?? () {},
                    showChatButton: false, // Hide chat button when chat is already shown
                  ),
                ),
                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                // Chat - 60% of the height
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      // Chat header with menu
                      ChatPanelHeader(
                        chatPoiName: chatPoiName,
                        chatPoiId: chatPoiId!,
                        onClose: () => context.read<ChatPanelCubit>().closePanel(),
                      ),
                      // Chat content
                      Expanded(
                        child: ChatScreen(
                          poiId: chatPoiId!,
                          poiName: chatPoiName,
                          showAppBar: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : PoiDetailsBottomSheet(
              poi: poi,
              isLargeScreen: true,
              onClose: onClose,
              onChatButtonPressed: onChatButtonPressed ?? () {},
            ),
    );
  }
}
