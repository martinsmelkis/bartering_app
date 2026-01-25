import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barter_app/screens/map_screen/widgets/poi_details_bottom_sheet.dart';
import 'package:barter_app/screens/map_screen/cubit/chat_panel_cubit.dart';
import 'package:barter_app/screens/chat_screen/chat_screen.dart';
import 'package:barter_app/screens/chat_screen/cubit/chat_cubit.dart';
import 'package:barter_app/screens/chat_screen/widgets/report_user_dialog.dart';
import 'package:barter_app/models/relationships/report_models.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      _ChatPanelHeader(
                        chatPoiName: chatPoiName,
                        chatPoiId: chatPoiId!,
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

/// Chat panel header with 3-point menu
class _ChatPanelHeader extends StatefulWidget {
  final String? chatPoiName;
  final String chatPoiId;

  const _ChatPanelHeader({
    this.chatPoiName,
    required this.chatPoiId,
  });

  @override
  State<_ChatPanelHeader> createState() => _ChatPanelHeaderState();
}

class _ChatPanelHeaderState extends State<_ChatPanelHeader> {
  bool _isUserBlocked = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserBlocked();
  }

  Future<void> _checkIfUserBlocked() async {
    if (mounted) {
      final chatCubit = context.read<ChatCubit>();
      final blocked = await chatCubit.isUserBlocked(widget.chatPoiId);
      if (mounted) {
        setState(() {
          _isUserBlocked = blocked;
        });
      }
    }
  }

  Future<void> _handleFinishTransaction(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
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
    context.read<ChatCubit>().finishTransaction();
  }

  Future<void> _handleReportUser(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Show report dialog with reason selection
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => PointerInterceptor(
        child: ReportUserDialog(
          targetUserName: widget.chatPoiName ?? l10n.unknownUser,
        ),
      ),
    );

    if (result == null || !mounted) return;

    final ReportReason reason = result['reason'];
    final String? description = result['description'];

    // Report the user via cubit
    final reportId = await context.read<ChatCubit>().reportUser(
      reportedUserId: widget.chatPoiId,
      reason: reason,
      description: description,
      contextType: ReportContextType.chat,
      contextId: widget.chatPoiId,
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

    final success = await context.read<ChatCubit>().blockUser(widget.chatPoiId);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isUserBlocked = true;
      });
    }
  }

  Future<void> _handleUnblockUser(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

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

    final success = await context.read<ChatCubit>().unblockUser(widget.chatPoiId);

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
        color: AppColors.primary,
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
              'Chat: ${widget.chatPoiName ?? 'User'}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PointerInterceptor(
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 18),
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
          PointerInterceptor(
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: () => context.read<ChatPanelCubit>().closePanel(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
