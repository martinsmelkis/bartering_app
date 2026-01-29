import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/map_screen/cubit/profile_panel_cubit.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/user_profile_screen.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A floating action button that displays the current user's avatar
/// with an edit badge and optional notification count
class UserAvatarFab extends StatelessWidget {
  final String? userId;
  final String? userName;
  final List<ParsedAttributeData>? userInterests;
  final List<ParsedAttributeData>? userOfferings;

  const UserAvatarFab({
    super.key,
    required this.userId,
    required this.userName,
    this.userInterests,
    this.userOfferings,
  });

  // Avatar SVG assets (dynamically generated)
  static const int _svgAssetCount = 29;

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/path$index.svg';

  Future<Widget> _createUserAvatar(BuildContext context) async {
    final userRepository = getIt<UserRepository>();
    final interests = userInterests?.isEmpty == true 
        ? userRepository.userInterests 
        : userInterests;
    final offerings = userOfferings?.isEmpty == true 
        ? userRepository.userOfferings 
        : userOfferings;

    print('@@@@@@@@@ UserAvatarFab creating avatar for $userId');

    final List<UserAttributeEntryData> attrList = List.of(
      offerings?.map((e) => UserAttributeEntryData(
        attributeId: e.attribute,
        type: 0,
        relevancy: e.relevancyScore,
        description: "",
        uiStyleHint: e.uiStyleHint,
      )) ?? [],
    );
    attrList.addAll(
      interests?.map((e) => UserAttributeEntryData(
        attributeId: e.attribute,
        type: 1,
        relevancy: e.relevancyScore,
        description: "",
        uiStyleHint: e.uiStyleHint,
      )) ?? [],
    );

    // Create a dummy POI for the user
    final userPoi = PointOfInterest(
      profile: UserProfileData(
        userId: userId ?? "",
        name: userName ?? "",
        latitude: 0,
        longitude: 0,
        attributes: attrList,
        profileKeywordDataMap: await userRepository.getProfileKeywordDataMap(),
        activePostingIds: List.empty(growable: false),
      ),
      distanceKm: 0,
    );

    // Use the userId to get a consistent random icon
    final userIdHashCode = userPoi.profile.userId.hashCode;
    final index = userIdHashCode.abs() % _svgAssetCount;
    final selectedIconPath = _getSvgAsset(index + 1); // 1-based index

    // Load SVG without color modification
    final svgString = await rootBundle.loadString(selectedIconPath);
    final localSvgCopy = String.fromCharCodes(svgString.runes);

    return RepaintBoundary(
      child: CategoryStatsUtils.buildCategoryStatsCircle(
        keywordMap: userPoi.profile.profileKeywordDataMap,
        size: AppDimensions.poiMarkerSize,
        strokeWidth: kIsWeb ? 3.0 : 6.0,
        gapWidth: kIsWeb ? 1.0 : 2.0,
        child: ClipOval(
          child: SvgPicture.string(
            localSvgCopy,
            width: AppDimensions.poiMarkerSize,
            height: AppDimensions.poiMarkerSize,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: false,
            placeholderBuilder: (context) => Container(
              width: AppDimensions.poiMarkerSize,
              height: AppDimensions.poiMarkerSize,
              color: Colors.grey.shade200,
            ),
            key: ValueKey('poi_marker_${userPoi.profile.userId}'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const SizedBox.shrink();
    }

    final userRepository = getIt<UserRepository>();
    final interests = userInterests?.isEmpty == true 
        ? userRepository.userInterests 
        : userInterests;
    final offerings = userOfferings?.isEmpty == true 
        ? userRepository.userOfferings 
        : userOfferings;

    return FutureBuilder<Widget>(
      future: _createUserAvatar(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final avatarWidget = snapshot.data!;

        return GestureDetector(
          onTap: () async {
            // Use adaptive behavior: panel on web/desktop, full-screen on mobile
            if (kIsWeb && context.canShowSideBySide) {
              // Open as left panel on web
              context.read<ProfilePanelCubit>().openProfile(
                userId: userId!,
                userName: userName!,
                interests: interests,
                offerings: offerings,
              );
            } else {
              // Navigate to full-screen on mobile
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(
                    userId: userId!,
                    userName: userName!,
                    interests: interests,
                    offerings: offerings,
                  ),
                ),
              );
              // Reload match history when user returns
              if (context.mounted) {
                context.read<NotificationsCubit>().loadMatchHistory();
              }
            }
          },
          child: Stack(
            children: [
              Container(
                width: AppDimensions.userAvatarSize,
                height: AppDimensions.userAvatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: kIsWeb ? 1.3 : 1,
                      offset: Offset(kIsWeb ? 1.3 : 1, kIsWeb ? 1.3 : 1),
                    ),
                  ],
                ),
                child: avatarWidget,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, notificationState) {
                    final unreadCount =
                        notificationState.matchHistory?.unviewedCount ?? 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: AppDimensions.avatarEditIconSize,
                          height: AppDimensions.avatarEditIconSize,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: kIsWeb ? 5.2 : 4,
                                offset: Offset(0, kIsWeb ? 2.6 : 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: AppDimensions.avatarEditIconInnerSize,
                            color: AppColors.primary,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: kIsWeb ? -5.2 : -4,
                            right: kIsWeb ? -5.2 : -4,
                            child: Container(
                              padding: EdgeInsets.all(kIsWeb ? 5.2 : 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: kIsWeb ? 2.0 : 1.5,
                                ),
                              ),
                              constraints: BoxConstraints(
                                minWidth: kIsWeb ? 42.9 : 33,
                                minHeight: kIsWeb ? 42.9 : 33,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: kIsWeb ? 14.3 : 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
