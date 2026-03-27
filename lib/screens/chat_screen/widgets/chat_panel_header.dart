import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../configure_dependencies.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../models/relationships/report_models.dart';
import '../../../router/app_router.dart';
import '../../../services/api_client.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/debug_utils.dart';
import '../cubit/chat_cubit.dart';
import 'report_user_dialog.dart';

/// Chat panel header with 3-point menu and optional close button
class ChatPanelHeader extends StatefulWidget {
  final String? chatPoiName;
  final String chatPoiId;
  final VoidCallback? onClose;

  const ChatPanelHeader({
    super.key,
    this.chatPoiName,
    required this.chatPoiId,
    this.onClose
  });

  @override
  State<ChatPanelHeader> createState() => _ChatPanelHeaderState();
}

class _ChatPanelHeaderState extends State<ChatPanelHeader> {
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
    // Use chatPoiName when available, otherwise fallback to generic label
    final displayName = widget.chatPoiName?.isNotEmpty == true
        ? widget.chatPoiName
        : l10n.unknownUser;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Chat: $displayName',
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
          PointerInterceptor(
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 18),
              onSelected: (value) {
                if (value == 'finish_transaction') {
                  _handleFinishTransaction(context);
                } else if (value == 'view_profile') {
                  // Fetch profile info if POI is not available, then navigate to map
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    PointOfInterest? poi;
                    try {
                      final apiClient = getIt<ApiClient>();
                      final userProfile = await apiClient.getProfileInfo(widget.chatPoiId);
                      poi = PointOfInterest(
                        profile: userProfile,
                        distanceKm: null,
                      );
                      logDebug('@@@@@@@@@ ChatScreen view_profile - fetched profile for userId: ${widget.chatPoiId}');
                    } catch (e) {
                      logDebugError('Failed to fetch profile for view_profile', e);
                    }
                    if (poi != null) {
                      final List<PointOfInterest> pois = List.empty(growable: true);
                      pois.add(poi);
                      AppRouter.navigateToMapWithPois(pois);
                    }
                  });
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
                  value: 'view_profile',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurface),
                      SizedBox(width: 8.w),
                      Text(l10n.viewProfile),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'finish_transaction',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.onSurface),
                      SizedBox(width: 8.w),
                      Text(l10n.finishTransaction),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'report_user',
                  child: Row(
                    children: [
                      Icon(Icons.report_outlined, color: Theme.of(context).colorScheme.onSurface),
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
