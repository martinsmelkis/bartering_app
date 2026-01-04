import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../configure_dependencies.dart';
import '../../../l10n/app_localizations.dart';

class MatchHistoryTab extends StatefulWidget {
  const MatchHistoryTab({super.key});

  @override
  State<MatchHistoryTab> createState() => _MatchHistoryTabState();
}

class _MatchHistoryTabState extends State<MatchHistoryTab> {
  bool _unviewedOnly = false;

  @override
  void initState() {
    super.initState();
    // Load match history when tab is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<NotificationsCubit>()
          .loadMatchHistory(unviewedOnly: _unviewedOnly);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final matchHistory = state.matchHistory;

        return Column(
          children: [
            // Filter controls
            Container(
              padding: EdgeInsets.all(12.w),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      matchHistory != null
                          ? '${matchHistory.matches.length} ${l10n.matches} (${matchHistory.unviewedCount} ${l10n.unviewed})'
                          : l10n.matches,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  FilterChip(
                    label: Text(l10n.unviewedOnly),
                    selected: _unviewedOnly,
                    onSelected: (value) {
                      setState(() => _unviewedOnly = value);
                      context
                          .read<NotificationsCubit>()
                          .loadMatchHistory(unviewedOnly: value);
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),

            // Match list
            Expanded(
              child: matchHistory == null
                  ? const Center(child: CircularProgressIndicator())
                  : matchHistory.matches.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                _unviewedOnly
                                    ? l10n.noUnviewedMatches
                                    : l10n.noMatchesYet,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => context
                              .read<NotificationsCubit>()
                              .loadMatchHistory(unviewedOnly: _unviewedOnly),
                          child: ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: matchHistory.matches.length,
                            itemBuilder: (context, index) {
                              final match = matchHistory.matches[index];
                              return _MatchHistoryCard(match: match);
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _MatchHistoryCard extends StatelessWidget {
  final MatchHistoryItem match;

  const _MatchHistoryCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: match.viewed ? 1 : 3,
      color: match.viewed
          ? Colors.white
          : AppColors.primary.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => _viewMatch(context, match),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getMatchTypeIcon(match.matchType),
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _getMatchTypeLabel(l10n, match.matchType),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!match.viewed)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        l10n.newBadge,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'view') {
                        _viewMatch(context, match);
                      } else if (value == 'dismiss') {
                        _dismissMatch(context, match);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!match.viewed)
                        PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              const Icon(Icons.visibility),
                              SizedBox(width: 8.w),
                              Text(l10n.markAsViewed),
                            ],
                          ),
                        ),
                      if (!match.dismissed)
                        PopupMenuItem(
                          value: 'dismiss',
                          child: Row(
                            children: [
                              const Icon(Icons.close, color: Colors.orange),
                              SizedBox(width: 8.w),
                              Text(
                                l10n.dismiss,
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.score,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${l10n.matchScore}: ${(match.matchScore * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    DateFormat('MMM d, yyyy HH:mm').format(match.matchedAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (match.dismissed) ...[
                SizedBox(height: 8.h),
                Chip(
                  label: Text(
                    l10n.dismissed,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMatchTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'posting':
        return Icons.post_add;
      case 'user':
        return Icons.person;
      case 'attribute':
        return Icons.label;
      default:
        return Icons.star;
    }
  }

  String _getMatchTypeLabel(AppLocalizations l10n, String type) {
    switch (type.toLowerCase()) {
      case 'posting':
        return l10n.postingMatch;
      case 'user':
        return l10n.userMatch;
      case 'attribute':
        return l10n.attributeMatch;
      default:
        return l10n.match;
    }
  }

  void _viewMatch(BuildContext context, MatchHistoryItem match) async {
    if (!match.viewed) {
      try {
        await context.read<NotificationsCubit>().markMatchViewed(match.id);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    
    // Navigate to match based on target type
    await _navigateToMatch(context, match);
  }
  
  Future<void> _navigateToMatch(BuildContext context, MatchHistoryItem match) async {
    final l10n = AppLocalizations.of(context)!;
    
    // Get the target user ID based on the match type
    final targetUserId = match.targetId;
    
    try {
      // Show loading indicator
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      
      // Load the user profile directly via API
      final apiClient = getIt<ApiClient>();
      final profile = await apiClient.getProfileInfo(targetUserId);
      
      // Dismiss loading dialog
      if (!context.mounted) return;
      Navigator.of(context).pop();
      
      // Create POI from profile
      final poi = PointOfInterest(profile: profile, distanceKm: 0.0);
      
      // Navigate to map screen with the POI
      if (context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MapScreenV2(initialPois: [poi]),
          ),
        );
      }
    } catch (e) {
      // Dismiss loading dialog if still showing
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _dismissMatch(BuildContext context, MatchHistoryItem match) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.dismissMatch),
        content: Text(l10n.dismissMatchConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text(l10n.dismiss),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final message =
            await context.read<NotificationsCubit>().dismissMatch(match.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message ?? l10n.matchDismissed),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
