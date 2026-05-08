import 'package:barter_app/models/reviews/reputation_response.dart';
import 'package:barter_app/models/reviews/review_submission.dart';
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
import 'package:barter_app/screens/user_profile_screen/create_posting_screen.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/nested_panel_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/in_app_purchases_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/premium_profile_editor_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/user_profile_screen_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/premium_profile_editor_screen.dart';
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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../router/app_router.dart';
import '../../services/settings_service.dart';
import '../../theme/app_colors.dart';
import 'widgets/badges_info_dialog.dart';
import 'widgets/delete_profile_confirmation_dialog.dart';
import 'widgets/premium_lock_icon.dart';
import 'widgets/premium_user_benefits_dialog.dart';
import 'widgets/profile_action_button.dart';
import 'widgets/profile_coins_info_dialog.dart';
import 'widgets/purchase_coins_options_dialog.dart';
import 'widgets/rating_details_dialog.dart';
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

class _UserProfileScreenState extends State<UserProfileScreen>
    with WidgetsBindingObserver {
  String? _userLocation;
  Map<String, double>? _profileKeywordDataMap;
  
  // Reputation data with caching
  ReputationResponse? _reputationData;
  List<BadgeDetail>? _userBadges;
  WalletResponse? _walletData;
  List<PublicReviewItem> _publicReviews = const [];
  String? _currentUserId;
  bool _isPremiumActive = false;
  bool _isLoadingReputation = false;
  bool _isLoadingBadges = false;
  bool _isLoadingWallet = false;
  
  // Cache instance
  final ReputationCache _reputationCache = ReputationCache();

  late final InAppPurchasesCubit _inAppPurchasesCubit;
  late final UserProfileScreenCubit _userProfileScreenCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _inAppPurchasesCubit = InAppPurchasesCubit(
      appUserId: widget.userId,
      revenueCatApiKey: dotenv.env['REVENUECAT_API_KEY'] ?? '',
      apiClient: getIt<ApiClient>(),
      webPurchaseLinkBaseUrl:
          dotenv.env['REVENUECAT_WEB_PREMIUM_LINK_BASE_URL'] ?? '',
      webCoins20PurchaseLinkBaseUrl:
          dotenv.env['REVENUECAT_WEB_COINS_20_LINK_BASE_URL'] ?? '',
      webCoins50PurchaseLinkBaseUrl:
          dotenv.env['REVENUECAT_WEB_COINS_50_LINK_BASE_URL'] ?? '',
      webCoins200PurchaseLinkBaseUrl:
          dotenv.env['REVENUECAT_WEB_COINS_200_LINK_BASE_URL'] ?? '',
      texts: () {
        final l10n = AppLocalizations.of(context)!;
        return InAppPurchasesTexts(
          revenueCatApiKeyMissing: l10n.inAppRevenueCatApiKeyMissing,
          failedToInitializePurchases: l10n.inAppFailedToInitializePurchases,
          failedToLoadOfferings: l10n.inAppFailedToLoadOfferings,
          noPremiumPackagesAvailable: l10n.inAppNoPremiumPackagesAvailable,
          premiumActivatedSuccessfully: l10n.inAppPremiumActivatedSuccessfully,
          purchaseCompletedEntitlementNotActiveYet:
              l10n.inAppPurchaseCompletedEntitlementNotActiveYet,
          purchaseCancelled: l10n.inAppPurchaseCancelled,
          purchaseFailed: l10n.inAppPurchaseFailed,
          premiumRestoredSuccessfully: l10n.inAppPremiumRestoredSuccessfully,
          noActivePremiumPurchasesToRestore:
              l10n.inAppNoActivePremiumPurchasesToRestore,
          restoreFailed: l10n.inAppRestoreFailed,
        );
      },
      premiumEntitlementId: 'Bartering App Premium',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _inAppPurchasesCubit.initialize();
      _maybeSyncPendingPurchase();
    });

    _userProfileScreenCubit = UserProfileScreenCubit(getIt<ApiClient>());

    _loadUserLocation();
    _loadProfileKeywordData();
    _loadCurrentUserId();
    _loadPremiumStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notificationsCubit = context.read<NotificationsCubit>();
      if (notificationsCubit.state.matchHistory == null) {
        notificationsCubit.loadMatchHistory();
      }
    });

    // Delay reputation and badges loading by 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _loadReputationWithCache();
        _loadBadgesWithCache();
        _loadWalletData();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inAppPurchasesCubit.close();
    _userProfileScreenCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeSyncPendingPurchase();
    }
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
      final reputation = await _userProfileScreenCubit.fetchReputation(widget.userId);
      final reviewsResponse = await _userProfileScreenCubit.fetchUserReviews(widget.userId);
      // Cache the result
      _reputationCache.setReputation(widget.userId, reputation);
      setState(() {
        _reputationData = reputation;
        _publicReviews = reviewsResponse.reviews
            .where((review) {
              final hasText = review.reviewText?.trim().isNotEmpty ?? false;
              final hasRating = review.rating > 0;
              return review.isVisible && (hasText || hasRating);
            })
            .map(
              (review) => PublicReviewItem(
                reviewId: review.id,
                reviewerId: review.reviewerId,
                text: review.reviewText?.trim(),
                rating: review.rating > 0 ? review.rating.toDouble() : null,
                submittedAt: DateTime.fromMillisecondsSinceEpoch(review.submittedAt),
              ),
            )
            .toList();
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
      final badges = await _userProfileScreenCubit.fetchUserBadges(widget.userId);
      // Cache the result
      _reputationCache.setBadges(widget.userId, badges);
      setState(() {
        _userBadges = badges;
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
      final wallet = await _userProfileScreenCubit.fetchWallet();
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

  Future<void> _loadPremiumStatus() async {
    try {
      final premiumStatus = await getIt<ApiClient>().getPremiumStatus();
      if (!mounted) return;
      setState(() {
        _isPremiumActive = premiumStatus.isPremium;
      });
    } catch (e) {
      logDebug('Error loading premium status: $e');
      if (!mounted) return;
      setState(() {
        _isPremiumActive = false;
      });
    }
  }

  Future<void> _maybeSyncPendingPurchase() async {
    if (!kIsWeb || !mounted) return;

    final settingsService = getIt<SettingsService>();
    final hasPending = await settingsService.hasPendingPurchase();
    if (!hasPending || !mounted) return;

    try {
      await getIt<ApiClient>().syncPremiumNow();
      await _loadWalletData();
      await settingsService.clearPendingPurchase();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coins purchase sync completed.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      logDebug('Error syncing pending web coins purchase: $e');
    }
  }

  Future<void> _loadUserLocation() async {
    final location = await SecureStorageService().getOwnLocation();
    setState(() {
      _userLocation = _formatLocationForDisplay(location);
    });
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await getIt<UserRepository>().getUserId();
    if (!mounted) return;
    setState(() {
      _currentUserId = userId;
    });
  }

  String? _formatLocationForDisplay(String? rawLocation) {
    if (rawLocation == null || rawLocation.isEmpty) {
      return rawLocation;
    }

    final decimalNumberPattern = RegExp(r'-?\d+\.\d+');

    return rawLocation.replaceAllMapped(decimalNumberPattern, (match) {
      final value = double.tryParse(match.group(0)!);
      if (value == null) {
        return match.group(0)!;
      }
      return value.toStringAsFixed(4);
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
      onBackPressed: () async {
        if (!kIsWeb) {
          Navigator.pop(context);
        } else {
          AppRouter.navigateToHome();
        }
        return false;
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
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  widget.userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              PremiumLockIcon(
                                isPremiumActive: _isPremiumActive,
                                onTap: _handlePremiumLockTap,
                              ),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          _buildRatingDisplay(l10n),
                          SizedBox(height: 8),
                          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.25)),
                          SizedBox(height: 4),
                          Row(
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
                              PointerInterceptor(
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
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: AppDimensions.editIconSize,
                                    color: AppColors.primary,
                                  ),
                                  padding: EdgeInsets.fromLTRB(4, 4, (kIsWeb ? 8 : 0), 4),
                                  constraints: const BoxConstraints(),
                                  tooltip: l10n.editLocation,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 16,
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
                        horizontal: 12, vertical: 8.0),
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
                        horizontal: 12, vertical: 8.0),
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
                  ...?widget.interests,
                  ...?widget.offerings,
                ],
              ),
            SizedBox(height: 20.h),
            // Notification Preferences Button
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 250,
                child: ProfileActionButton(
                  icon: Icons.notifications_active,
                  label: l10n.notificationPreferences,
                  color: AppColors.primary,
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
                ),
              ),
            ),
            SizedBox(height: 8),
            // Match History Button
            // Use existing NotificationsCubit - don't reload match history here
            // Match history will be loaded when user actually opens the match history screen
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, notificationState) {
                final unreadCount = notificationState.matchHistory?.unviewedCount ?? 0;

                return Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: 250,
                        child: ProfileActionButton(
                          icon: Icons.history,
                          label: l10n.matchHistory,
                          color: AppColors.primary,
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
                  ),
                );
              },
            ),

            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 250,
                child: ProfileActionButton(
                  icon: Icons.manage_accounts,
                  label: l10n.managePostings,
                  color: AppColors.secondary,
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
                ),
              ),
            ),

            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: _requestDataExport,
                child: Text(l10n.requestCollectedDataExport),
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
          PointerInterceptor(
            child: InkWell(
              onTap: _showRatingDetailsDialog,
              borderRadius: BorderRadius.circular(12),
              child: Container(
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
        InkWell(
          onTap: _showCoinsInfoDialog,
          borderRadius: BorderRadius.circular(8),
          child: Container(
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
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: _showCoinsInfoDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.question_mark,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  void _showRatingDetailsDialog() {
    final reviewCount = _reputationData?.totalReviews ?? 0;
    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return RatingDetailsDialog(
          reviewCount: reviewCount,
          publicReviews: _publicReviews,
          currentUserId: _currentUserId,
          onAppealReview: _handleAppealReview,
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

  Future<void> _handleAppealReview(PublicReviewItem review) async {
    final l10n = AppLocalizations.of(context)!;
    final appealedBy = _currentUserId;

    if (appealedBy == null || appealedBy.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.unableToSubmitAppealNow),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reason = await showDialog<String>(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        String reasonText = '';

        return PointerInterceptor(
          child: AlertDialog(
            title: Text(l10n.appealReviewTitle),
            content: TextField(
              maxLines: 4,
              maxLength: 500,
              onChanged: (value) => reasonText = value,
              decoration: InputDecoration(
                hintText: l10n.appealReviewReasonHint,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(reasonText.trim()),
                child: Text(l10n.submitReview),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || reason == null) return;

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.appealReasonRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await getIt<ApiClient>().submitReviewAppeal(
        SubmitReviewAppealRequest(
          reviewId: review.reviewId,
          appealedBy: appealedBy,
          reason: reason,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      final message = _extractApiErrorMessage(e) ?? l10n.failedToSubmitAppeal;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSubmitAppeal),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _extractApiErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['error'] ?? data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    return null;
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

  void _showCoinsInfoDialog() {
    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return ProfileCoinsInfoDialog(
          onPurchaseCoins: () {
            if (kIsWeb) {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            } else {
              Navigator.of(dialogContext).pop();
            }
            _showPurchaseCoinsOptionsDialog();
          },
          onBrowseAvatarShop: () {
            if (kIsWeb) {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            } else {
              Navigator.of(dialogContext).pop();
            }
            context.push('/avatar-shop');
          },
        );
      },
    );
  }

  void _showPurchaseCoinsOptionsDialog() {
    showDialog<int>(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return const PurchaseCoinsOptionsDialog();
      },
    ).then((selectedAmount) async {
      if (!mounted || selectedAmount == null) return;

      switch (selectedAmount) {
        case 20:
          await _inAppPurchasesCubit.purchase20Coins();
          break;
        case 50:
          await _inAppPurchasesCubit.purchase50Coins();
          break;
        case 200:
          await _inAppPurchasesCubit.purchase200Coins();
          break;
        default:
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Coin pack $selectedAmount is not supported.'),
            ),
          );
          return;
      }

      final state = _inAppPurchasesCubit.state;

      if (!mounted) return;

      if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final message = state.statusMessage?.isNotEmpty == true
          ? state.statusMessage!
          : AppLocalizations.of(context)!
              .selectedCoinPackage(selectedAmount.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
      _loadWalletData();
    });
  }

  Future<void> _handlePremiumLockTap() async {
    bool isPremium = false;

    try {
      final premiumStatus = await getIt<ApiClient>().getPremiumStatus();
      isPremium = premiumStatus.isPremium;
      if (mounted) {
        setState(() {
          _isPremiumActive = isPremium;
        });
      }
    } catch (e) {
      logDebug('Error refreshing premium status: $e');
      isPremium = _isPremiumActive;
    }

    if (!isPremium) {
      _showPremiumBenefitsDialog();
      return;
    }

    await _openPremiumProfileEditor();
  }

  Future<void> _openPremiumProfileEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => PremiumProfileEditorCubit(
            apiClient: getIt<ApiClient>(),
            userRepository: getIt<UserRepository>(),
            appUserId: widget.userId,
          ),
          child: PremiumProfileEditorScreen(
            initialName: widget.userName,
            initialDescription: null,
          ),
        ),
      ),
    );
  }

  void _showPremiumBenefitsDialog() {
    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _inAppPurchasesCubit,
          child: BlocConsumer<InAppPurchasesCubit, InAppPurchasesState>(
            listener: (context, state) {
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state.statusMessage != null && state.statusMessage!.isNotEmpty) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(state.statusMessage!),
                    backgroundColor: Colors.green,
                  ),
                );
              }

              if (state.isPremium && mounted) {
                setState(() {
                  _isPremiumActive = true;
                });
              }
            },
            builder: (context, state) {
              return PremiumUserBenefitsDialog(
                isLoading: state.isPurchasing || state.isRestoring || state.isInitializing,
                onPurchasePremium: () async {
                  await context.read<InAppPurchasesCubit>().purchasePremium();
                },
                onRestorePurchases: () async {
                  await context.read<InAppPurchasesCubit>().restorePurchases();
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) {
        return DeleteProfileConfirmationDialog(
          onConfirmDelete: () async {
            await _deleteProfile();
          },
        );
      },
    );
  }

  Future<void> _requestDataExport() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _userProfileScreenCubit.requestGdprDataExport();
      final success = response.success;
      final message = response.message.trim();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isNotEmpty
                ? message
                : success
                    ? l10n.dataExportRequestAccepted
                    : l10n.dataExportRequestFailed,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } on DioException catch (e) {
      logDebugError('Error requesting GDPR data export', e);
      if (!mounted) return;

      final statusCode = e.response?.statusCode;
      final isEmailRequired = statusCode == 400;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEmailRequired
                ? l10n.dataExportEmailRequired
                : l10n.dataExportRequestFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      logDebugError('Error requesting GDPR data export', e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.dataExportRequestFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteProfile() async {
    final l10n = AppLocalizations.of(this.context)!;

    BuildContext? loadingDialogContext;
    try {
      showDialog(
        context: this.context,
        barrierDismissible: false,
        useRootNavigator: kIsWeb,
        builder: (dialogContext) {
          loadingDialogContext = dialogContext;
          return PointerInterceptor(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      await _userProfileScreenCubit.deleteProfile(widget.userId);

      if (!mounted) return;

      if (loadingDialogContext != null && loadingDialogContext!.mounted) {
        Navigator.of(loadingDialogContext!, rootNavigator: kIsWeb).pop();
      }

      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileDeleted),
          backgroundColor: Colors.green,
        ),
      );

      if (kIsWeb) {
        SystemNavigator.pop();
      } else {
        Navigator.of(this.context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const InitializeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      logDebugError('Error deleting profile', e);

      if (loadingDialogContext != null && loadingDialogContext!.mounted) {
        Navigator.of(loadingDialogContext!, rootNavigator: kIsWeb).pop();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorDeletingProfile),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
