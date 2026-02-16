import 'dart:io';

import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/initialize_screen/initialize_screen.dart';
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart';
import 'package:barter_app/screens/interests_screen/interests_screen.dart';
import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:barter_app/screens/match_history_screen/match_history_screen.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/notifications_screen/notifications_screen.dart';
import 'package:barter_app/screens/offers_screen/offers_screen.dart';
import 'package:barter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:barter_app/screens/manage_postings_screen/manage_postings_screen.dart';
import 'package:barter_app/screens/device_migration_screen/source_migration_screen.dart';
import 'package:barter_app/screens/user_profile_screen/create_posting_screen.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/nested_panel_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/adaptive_nested_panel_layout.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/attribute_matching_utils.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/widgets/attribute_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../configure_dependencies.dart';
import '../../data/local/platform/platform.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/chat_repository.dart';
import '../../services/messaging/firebase_auth_service.dart';
import '../../services/settings_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/text_utils.dart';
import '../onboarding_screen/cubit/onboarding_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;
  final bool showAppBar; // Whether to show the app bar (false for panel mode)
  final Function(bool)? onNestedPanelChanged; // Callback when nested panel opens/closes

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.interests,
    this.offerings,
    this.showAppBar = true,
    this.onNestedPanelChanged,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _userLocation;
  Map<String, double>? _profileKeywordDataMap;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadProfileKeywordData();
  }

  Future<void> _loadUserLocation() async {
    final location = await SecureStorageService().getOwnLocation();
    setState(() {
      _userLocation = location;
    });
  }

  Future<void> _loadProfileKeywordData() async {
    final userRepository = getIt<UserRepository>();
    final keywordData = await userRepository.getProfileKeywordDataMap();
    setState(() {
      _profileKeywordDataMap = keywordData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Check if we're in web panel mode
    final bool isWebPanel = kIsWeb && !widget.showAppBar && context.canShowSideBySide;

    return BlocProvider(
      create: (context) => NestedPanelCubit(),
      child: BlocListener<NestedPanelCubit, NestedPanelState>(
        listener: (context, nestedPanelState) {
          // Notify parent when nested panel state changes (for panel expansion)
          widget.onNestedPanelChanged?.call(nestedPanelState.isOpen);
        },
        child: BlocBuilder<NestedPanelCubit, NestedPanelState>(
          builder: (context, nestedPanelState) {
            return AdaptiveNestedPanelLayout(
              panelType: nestedPanelState.panelType,
              userId: nestedPanelState.userId,
              onClose: () => context.read<NestedPanelCubit>().closePanel(),
              mainContent: Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(l10n.accountSetupSuccess),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            l10n.userId,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.userId,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PointerInterceptor(
                        child: IconButton(
                          onPressed: () => _showDeleteProfileDialog(context),
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 24,
                          ),
                          padding: EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          tooltip: l10n.deleteProfile,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Location Section
            Card(
              elevation: 1,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _userLocation ?? l10n.notSet,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Courier',
                              color: _userLocation != null
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: 40), // Space for the edit icon
                      ],
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 6 : -2,
                    right: kIsWeb ? 6 : -2,
                    child: PointerInterceptor(
                      child: IconButton(
                        onPressed: () async {
                          // Navigate to location picker
                          // If in full-screen mode, the location picker will handle navigation back
                          // If in panel mode, just reload data when done
                          if (widget.showAppBar) {
                            // Full-screen mode: use go navigation
                            context.push('/location-picker');
                          } else {
                            // Panel mode: use push and reload on return
                            await context.push('/location-picker');
                            if (mounted) {
                              await _loadProfileKeywordData();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          size: AppDimensions.editIconSize,
                          color: AppColors.primary,
                        ),
                        padding: EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        tooltip: l10n.editLocation,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Interests Section
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  l10n.userInterestedIn,
                  style: TextStyle(
                    fontSize: isWebPanel 
                        ? AppDimensions.headingTextSize * 1.1 
                        : AppDimensions.headingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    final locale = Localizations.localeOf(context);
                    await getIt<OnboardingCubit>().completeOnboarding(
                        locale.languageCode);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            InterestsScreen(isInitialOnboarding: false),
                      ),
                    );
                    
                    // Reload data after returning from interests screen
                    // The InterestsScreen will pop back when done, so we just reload
                    if (mounted) {
                      await _loadProfileKeywordData();
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    size: AppDimensions.editIconSize,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                        const CreatePostingScreen(isOffer: false),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.addNewPosting,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.interests == null || widget.interests!.isEmpty
                          ? const SizedBox()
                          : Wrap(
                        spacing: 7.2,
                        runSpacing: 7.2,
                        children: widget.interests!
                            .where((interest) => interest != null)
                            .map((interest) {
                          try {
                            return AttributeBubble(
                              attribute: interest,
                              matchType: AttributeMatchType.none,
                              scaleFactor: 1.2,
                            );
                          } catch (e) {
                            logDebug('Error rendering interest bubble: $e');
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: isWebPanel ? 24.h : 12.h),

            // Offerings Section
            Row(
              children: [
                Text(
                  l10n.userOffers,
                  style: TextStyle(
                    fontSize: isWebPanel 
                        ? AppDimensions.headingTextSize * 1.1 
                        : AppDimensions.headingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    final locale = Localizations.localeOf(context);
                    (await getIt<InterestsCubit>().submitInterests(
                        locale.languageCode, false));
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            OffersScreen(isInitialOnboarding: false),
                      ),
                    );
                    
                    // Reload data after returning from offers screen
                    // The OffersScreen will pop back when done, so we just reload
                    if (mounted) {
                      await _loadProfileKeywordData();
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    size: AppDimensions.editIconSize,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                        const CreatePostingScreen(isOffer: true),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.addNewPosting,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.offerings == null || widget.offerings!.isEmpty
                          ? const SizedBox()
                          : Wrap(
                        spacing: 7.2,
                        runSpacing: 7.2,
                        children: widget.offerings!
                            .where((offering) => offering != null)
                            .map((offering) {
                          try {
                            return AttributeBubble(
                              attribute: offering,
                              matchType: AttributeMatchType.none,
                              scaleFactor: 1.2,
                            );
                          } catch (e) {
                            logDebug('Error rendering offering bubble: $e');
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Keywords Section
            Row(
              children: [
                Text(
                  l10n.editKeywords,
                  style: TextStyle(
                    fontSize: AppDimensions.mediumHeadingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            OnboardingScreen(isInitialOnboarding: false),
                      ),
                    );
                    
                    // Reload data after returning from onboarding screen
                    if (mounted) {
                      await _loadProfileKeywordData();
                      
                      // Navigate back to MapScreenV2 after editing (only in full-screen mode)
                      // In panel mode, just stay on the current screen
                      if (mounted && widget.showAppBar) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const MapScreenV2(),
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    size: AppDimensions.editIconSize,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Category Stats Bar
            if (_profileKeywordDataMap != null)
              CategoryStatsUtils.buildCategoryStatsBar(
                keywordMap: _profileKeywordDataMap,
                attributes: [
                  ...?(widget.interests?.where((i) => i != null)),
                  ...?(widget.offerings?.where((o) => o != null)),
                ],
              ),
            SizedBox(height: 20.h),

            // Notification Preferences and Match History Buttons
            Row(
              children: [
                // Notification Preferences Button
                InkWell(
                  onTap: () async {
                    // Use adaptive behavior: panel within profile on web, full-screen on mobile
                    if (isWebPanel) {
                      // Open as nested panel within profile on web
                      context.read<NestedPanelCubit>().openNotifications();
                    } else {
                      // Navigate to full-screen on mobile
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          l10n.notificationPreferences,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Match History Button
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  bloc: getIt<NotificationsCubit>()..loadMatchHistory(),
                  builder: (context, notificationState) {
                    final unreadCount = notificationState.matchHistory?.unviewedCount ?? 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () async {
                            // Use adaptive behavior: panel within profile on web, full-screen on mobile
                            if (isWebPanel) {
                              // Open as nested panel within profile on web
                              context.read<NestedPanelCubit>().openMatchHistory();
                            } else {
                              // Navigate to full-screen on mobile
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MatchHistoryScreen(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  l10n.matchHistory,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              child: Text(
                                unreadCount > 99 ? '99+' : '$unreadCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: () async {
                // Use adaptive behavior: panel within profile on web, full-screen on mobile
                if (isWebPanel) {
                  // Open as nested panel within profile on web
                  context.read<NestedPanelCubit>().openManagePostings(widget.userId);
                } else {
                  // Navigate to full-screen on mobile
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ManagePostingsScreen(userId: widget.userId),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.manage_accounts,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      l10n.managePostings,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4,),
            InkWell(
              onTap: () async {
                // Navigate to source device migration screen
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SourceMigrationScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phonelink_setup,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Migrate to New Device',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
            ),
          );
        },
        ),
      ),
    );
  }

  void _showDeleteProfileDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (BuildContext dialogContext) {
        return PointerInterceptor(
          child: AlertDialog(
            title: Text(l10n.deleteProfile),
            content: Text(l10n.deleteProfileConfirmation),
            actions: [
              PointerInterceptor(
                child: TextButton(
                  onPressed: () {
                    if (kIsWeb) {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                    } else {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              PointerInterceptor(
                child: TextButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                    } else {
                      Navigator.of(dialogContext).pop();
                    }
                    await _deleteProfile(context);
                  },
                  child: Text(
                    l10n.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteProfile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: kIsWeb,
        builder: (BuildContext context) {
          return PointerInterceptor(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      // End the session (unregister push token and unsubscribe from topics)
      final authService = FCMTokenService();
      await authService.onSessionEnded(widget.userId);

      // Call the API to delete the user
      await getIt<ApiClient>().deleteUser(widget.userId);
      
      // Delete the database file to prevent encryption key mismatch on next registration
      try {
        final path = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(path.path, 'app.db.enc'));
        if (await dbFile.exists()) {
          await dbFile.delete();
          logDebug('✅ Database file deleted');
        }
      } catch (dbError) {
        logDebug('⚠️ Failed to delete database file: $dbError');
        // Continue anyway - the error handling in platform_app.dart will handle this
      }
      
      // Clear all secure storage data
      await SecureStorageService().clearStorage();
      
      // Clear all SharedPreferences settings
      await getIt<SettingsService>().clearAll();
      
      // Clear all local chat data
      await getIt<ChatRepository>().clearAllChats();
      
      // Clear browser storage (IndexedDB, localStorage) on web
      if (kIsWeb) {
        await Platform.clearAllBrowserStorage();
      }
      
      // Dismiss loading dialog
      if (!mounted) return;
      if (kIsWeb) {
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        Navigator.of(context).pop();
      }
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileDeleted),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to welcome screen and clear navigation stack
      if (!mounted) return;
      
      // Use addPostFrameCallback to avoid navigator lock issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (kIsWeb) {
            // On web with page-based navigation, use SystemNavigator to exit
            // and let the app restart, which will show InitializeScreen
            SystemNavigator.pop();
          } else {
            // On mobile, use standard navigation
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const InitializeScreen(),
              ),
              (route) => false,
            );
          }
        }
      });
    } catch (e) {
      // Dismiss loading dialog
      if (!mounted) return;
      if (kIsWeb) {
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorDeletingProfile}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
