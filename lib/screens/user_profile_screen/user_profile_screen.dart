import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/screens/initialize_screen/initialize_screen.dart';
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart';
import 'package:barter_app/screens/interests_screen/interests_screen.dart';
import 'package:barter_app/screens/location_picker_screen/location_picker_osm_screen.dart';
import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:barter_app/screens/match_history_screen/match_history_screen.dart';
import 'package:barter_app/screens/notifications_screen/notifications_screen.dart';
import 'package:barter_app/screens/offers_screen/offers_screen.dart';
import 'package:barter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:barter_app/screens/manage_postings_screen/manage_postings_screen.dart';
import 'package:barter_app/screens/user_profile_screen/create_posting_screen.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/firebase_auth_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../utils/text_utils.dart';
import '../onboarding_screen/cubit/onboarding_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final List<ParsedAttributeData>? interests;
  final List<ParsedAttributeData>? offerings;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.interests,
    this.offerings,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final location = await SecureStorageService().getOwnLocation();
    setState(() {
      _userLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountSetupSuccess),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
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
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            l10n.userId,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.userId,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: IconButton(
                        onPressed: () => _showDeleteProfileDialog(context),
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 24.sp,
                        ),
                        padding: EdgeInsets.all(8.w),
                        constraints: const BoxConstraints(),
                        tooltip: l10n.deleteProfile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Location Section
            Row(
              children: [
                Text(
                  l10n.userLocation,
                  style: TextStyle(
                    fontSize: AppDimensions.headingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LocationPickerScreenOsm(),
                      ),
                    );
                    // Navigate back to MapScreenV2 after editing
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MapScreenV2(),
                        ),
                      );
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
            Card(
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _userLocation ?? l10n.notSet,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Courier',
                          color: _userLocation != null
                              ? Colors.black87
                              : Colors.grey,
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
                    fontSize: AppDimensions.headingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    final locale = Localizations.localeOf(context);
                    await getIt<OnboardingCubit>().completeOnboarding(
                        locale.languageCode);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            InterestsScreen(isInitialOnboarding: false),
                      ),
                    );
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
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.addNewPosting,
                          style: TextStyle(
                            fontSize: 12.sp,
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
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.interests == null
                          ? const SizedBox()
                          : Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: widget.interests!.map((interest) {
                          return Chip(
                            label: Text(
                                TextUtils.getTranslatedOrNormalizedAttribute(
                                    interest.attribute, context)),
                            backgroundColor: _getColorForStyleHint(
                                interest.uiStyleHint),
                            labelStyle: const TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            //SizedBox(height: 20.h),

            // Offerings Section
            Row(
              children: [
                Text(
                  l10n.userOffers,
                  style: TextStyle(
                    fontSize: AppDimensions.headingTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    final locale = Localizations.localeOf(context);
                    (await getIt<InterestsCubit>().submitInterests(
                        locale.languageCode));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            OffersScreen(isInitialOnboarding: false),
                      ),
                    );
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
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.addNewPosting,
                          style: TextStyle(
                            fontSize: 12.sp,
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
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.offerings == null
                          ? const SizedBox()
                          : Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: widget.offerings!.map((offering) {
                          return Chip(
                            label:
                            Text(TextUtils.getTranslatedOrNormalizedAttribute(
                                offering.attribute, context)),
                            backgroundColor: _getColorForStyleHint(
                                offering.uiStyleHint),
                            labelStyle: const TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            //SizedBox(height: 20.h),
            //SizedBox(height: 20.h),

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
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            OnboardingScreen(isInitialOnboarding: false),
                      ),
                    );
                    // Navigate back to MapScreenV2 after editing
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MapScreenV2(),
                        ),
                      );
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
            SizedBox(height: 20.h),
            // Notification Preferences and Match History Buttons
            Row(
              children: [
                // Notification Preferences Button
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.notificationPreferences,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Match History Button
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MatchHistoryScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          l10n.matchHistory,
                          style: TextStyle(
                            fontSize: 12.sp,
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
            SizedBox(height: 12.w),
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ManagePostingsScreen(userId: widget.userId),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.manage_accounts,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      l10n.managePostings,
                      style: TextStyle(
                        fontSize: 12.sp,
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

  Color _getColorForStyleHint(String? hint) {
    if (hint == null) return Colors.grey;

    if (hint.contains('GREEN')) return Colors.green;
    if (hint.contains('RED')) return Colors.red;
    if (hint.contains('YELLOW')) return Colors.yellow[700]!;
    if (hint.contains('ORANGE')) return Colors.orange;
    if (hint.contains('TEAL')) return Colors.teal;
    if (hint.contains('PURPLE')) return Colors.purple;
    if (hint.contains('BLUE')) return Colors.blue;

    return Colors.grey;
  }

  void _showDeleteProfileDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteProfile),
          content: Text(l10n.deleteProfileConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteProfile(context);
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
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
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // End the session (unregister push token and unsubscribe from topics)
      final authService = FCMTokenService();
      await authService.onSessionEnded(widget.userId);

      // Call the API to delete the user
      await getIt<ApiClient>().deleteUser(widget.userId);
      
      // Clear all secure storage data
      await SecureStorageService().clearStorage();
      
      // Dismiss loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();
      
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const InitializeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      // Dismiss loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();
      
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
