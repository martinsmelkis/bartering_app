import 'dart:io';

import 'package:barter_app/models/reviews/reputation_response.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/initialize_screen/initialize_screen.dart';
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart';
import 'package:barter_app/screens/interests_screen/interests_screen.dart';
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
import 'package:barter_app/services/reputation_cache.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/attribute_matching_utils.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
import 'package:barter_app/utils/back_button_handler.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/widgets/attribute_bubble.dart';
import 'package:barter_app/widgets/count_badge.dart';
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
import '../../widgets/dialogs/badges_info_dialog.dart';
import '../onboarding_screen/cubit/onboarding_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;
  final bool showAppBar; // Whether to show the app bar (false for panel mode)
  final Function(bool)? onNestedPanelChanged; // Callback when nested panel opens/closes
  final bool skipNestedPanelLayout; // When true, external layout handles nested panel (prevents double rendering)

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.interests,
    this.offerings,
    this.showAppBar = true,
    this.onNestedPanelChanged,
    this.skipNestedPanelLayout = false,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _userLocation;
  Map<String, double>? _profileKeywordDataMap;
  
  // Reputation data with caching
  ReputationResponse? _reputationData;
  List<BadgeDetail>? _userBadges;
  WalletResponse? _walletData;
  bool _isLoadingReputation = false;
  bool _isLoadingBadges = false;
  bool _isLoadingWallet = false;
  
  // Cache instance
  final ReputationCache _reputationCache = ReputationCache();

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadProfileKeywordData();
    // Delay reputation and badges loading by 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _loadReputationWithCache();
        _loadBadgesWithCache();
        _loadWalletData();
      }
    });
  }

  /// Load reputation data with 10-minute caching
  Future<void> _loadReputationWithCache() async {
    // Check cache first
    final cached = _reputationCache.getReputation(widget.userId);
    if (cached != null) {
      setState(() {
        _reputationData = cached;
      });
      logDebug('✅ Using cached reputation data for ${widget.userId}');
      return;
    }

    setState(() {
      _isLoadingReputation = true;
    });
    try {
      final apiClient = getIt<ApiClient>();
      final reputation = await apiClient.getReputation(widget.userId);
      // Cache the result
      _reputationCache.setReputation(widget.userId, reputation);
      setState(() {
        _reputationData = reputation;
        _isLoadingReputation = false;
      });
      logDebug('✅ Fetched and cached reputation for ${widget.userId}');
    } catch (e) {
      logDebug('Error loading reputation: $e');
      setState(() {
        _isLoadingReputation = false;
      });
    }
  }

  /// Load badges with 10-minute caching
  Future<void> _loadBadgesWithCache() async {
    // Check cache first
    final cached = _reputationCache.getBadges(widget.userId);
    if (cached != null) {
      setState(() {
        _userBadges = cached;
      });
      logDebug('✅ Using cached badges for ${widget.userId}');
      return;
    }

    setState(() {
      _isLoadingBadges = true;
    });
    try {
      final apiClient = getIt<ApiClient>();
      final badgesResponse = await apiClient.getUserBadges(widget.userId);
      // Cache the result
      _reputationCache.setBadges(widget.userId, badgesResponse.badges);
      setState(() {
        _userBadges = badgesResponse.badges;
        _isLoadingBadges = false;
      });
      logDebug('✅ Fetched and cached badges for ${widget.userId}');
    } catch (e) {
      logDebug('Error loading user badges: $e');
      setState(() {
        _isLoadingBadges = false;
      });
    }
  }

  Future<void> _loadWalletData() async {
    setState(() {
      _isLoadingWallet = true;
    });

    try {
      final apiClient = getIt<ApiClient>();
      final wallet = await apiClient.getWallet();
      if (!mounted) return;
      setState(() {
        _walletData = wallet;
        _isLoadingWallet = false;
      });
      logDebug('✅ Fetched wallet data for ${widget.userId}');
    } catch (e) {
      logDebug('Error loading wallet data: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingWallet = false;
      });
    }
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

    return BackButtonHandler(
      onBackPressed: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: BlocListener<NestedPanelCubit, NestedPanelState>(
          listener: (context, nestedPanelState) {
            // Notify parent when nested panel state changes (for panel expansion)
            widget.onNestedPanelChanged?.call(nestedPanelState.isOpen);
          },
          child: BlocBuilder<NestedPanelCubit, NestedPanelState>(
            builder: (context, nestedPanelState) {
              // When skipNestedPanelLayout is true, render just the profile content
              // When false, wrap with AdaptiveNestedPanelLayout for side-by-side nested panels
              if (widget.skipNestedPanelLayout) {
                return _buildProfileContent(context, l10n, isWebPanel);
              }
              
              return AdaptiveNestedPanelLayout(
                panelType: nestedPanelState.panelType,
                userId: nestedPanelState.userId,
                onClose: () => context.read<NestedPanelCubit>().closePanel(),
                mainContent: _buildProfileContent(context, l10n, isWebPanel),
              );
            },
          ),
        ),
      );
  }

  /// Builds the main profile content widget
  Widget _buildProfileContent(BuildContext context, AppLocalizations l10n, bool isWebPanel) {
    return Scaffold(
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

                          _buildRatingDisplay(l10n),
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
                            context.pushReplacement('/location-picker');
                            //if (mounted) {
                            //  await _loadProfileKeywordData();
                            //}
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
                    if (!context.mounted) return;
                    try {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                          const CreatePostingScreen(isOffer: false),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Navigation error: $e');
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
                    if (!context.mounted) return;
                    try {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                          const CreatePostingScreen(isOffer: true),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Navigation error: $e');
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

                      // Navigate back to map after editing (only in full-screen mode)
                      // In panel mode, just stay on the current screen
                      if (mounted && widget.showAppBar) {
                        // Include pinVerified flag for web to prevent router double-creation
                        context.pushReplacement('/map', extra: {'pinVerified': true});
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
                // Use existing NotificationsCubit - don't reload match history here
                // Match history will be loaded when user actually opens the match history screen
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  bloc: getIt<NotificationsCubit>(),
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
                          PositionedCountBadge(
                            count: unreadCount,
                            top: -6,
                            right: -6,
                            padding: const EdgeInsets.all(4),
                            borderColor: Colors.white,
                            borderWidth: 1.5,
                            constraints: const BoxConstraints(
                              minWidth: 28,
                              minHeight: 28,
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
            SizedBox(height: 12,),
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
                  color: AppColors.secondary,
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
                      l10n.migrateToNewDevice,
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
    );
  }

  /// Build rating display widget for profile header with badges and balance
  Widget _buildRatingDisplay(AppLocalizations l10n) {
    // Use reputation data if available, otherwise default to 0.0 and 0
    final rating = _reputationData?.averageRating ?? 0.0;
    final reviewCount = _reputationData?.totalReviews ?? 0;
    final ratingColor = AvatarColorUtils.getRatingColor(rating);
    final balanceText = _isLoadingWallet
        ? '...'
        : (_walletData?.availableBalance.toDouble() ?? 0.0).toStringAsFixed(2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rating badge
        if (_isLoadingReputation)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: ratingColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(width: 8),
        // Reviews count - only show when not loading
        if (!_isLoadingReputation)
          Text(
            l10n.reviewsCount(reviewCount),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(width: 12),
        // Badges display
        if (_isLoadingBadges)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        else
          PointerInterceptor(
            child: InkWell(
              onTap: _showBadgesInfoDialog,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _userBadges != null && _userBadges!.isNotEmpty
                            ? Colors.amber
                            : Colors.orange[300],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'B',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_userBadges?.length ?? 0}',
                      style: TextStyle(
                        fontSize: 12,
                        color: (_userBadges != null && _userBadges!.isNotEmpty)
                            ? Colors.grey[700]
                            : Colors.grey[500],
                        fontWeight: (_userBadges != null && _userBadges!.isNotEmpty)
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(width: 16),
        // Account Balance placeholder
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 21,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '₿',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                balanceText,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBadgesInfoDialog() {
    final earnedBadgeTypes = (_userBadges ?? const <BadgeDetail>[])
        .map((b) => b.type.toLowerCase())
        .toSet();

    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return BadgesInfoDialog(
          earnedBadgeTypes: earnedBadgeTypes,
          onClose: () {
            if (kIsWeb) {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            } else {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
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

                    // Delete profile
                    await _deleteProfile(dialogContext);
                  },
                  child: Text(
                    l10n.deleteProfile,
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
    final l10n = AppLocalizations.of(this.context)!;
    
    try {
      // Show loading dialog
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
      if (kIsWeb) {
        // On web, use SystemNavigator to exit and let the app restart
        SystemNavigator.pop();
      } else {
        // On mobile, navigate to InitializeScreen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const InitializeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      logDebugError('Error deleting profile', e);
      if (mounted) {
        // Dismiss loading dialog if showing
        Navigator.of(context, rootNavigator: true).pop();
        
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorDeletingProfile),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
