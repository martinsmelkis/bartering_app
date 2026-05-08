import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/map_screen/cubit/profile_panel_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/avatar_icon_utils.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/widgets/count_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// A floating action button that displays the current user's avatar
/// with an edit badge and optional notification count
class UserAvatarFab extends StatefulWidget {
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

  @override
  State<UserAvatarFab> createState() => _UserAvatarFabState();
}

class _UserAvatarFabState extends State<UserAvatarFab> {
  Future<String?> _getOwnProfileAvatarIcon() async {
    try {
      final userRepository = getIt<UserRepository>();
      final uid = await userRepository.getUserId();
      if (uid == null || uid.isEmpty) return null;

      final apiClient = getIt<ApiClient>();
      final profile = await apiClient.getProfileInfo(uid);
      return AvatarIconUtils.resolveSvgForProfile(profile);
    } catch (_) {
      return null;
    }
  }

  Future<Widget> _createUserAvatar(BuildContext context) async {
    final userRepository = getIt<UserRepository>();
    final interests = widget.userInterests?.isEmpty == true
        ? userRepository.userInterests
        : widget.userInterests;
    final offerings = widget.userOfferings?.isEmpty == true
        ? userRepository.userOfferings
        : widget.userOfferings;

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
        userId: widget.userId ?? "",
        name: widget.userName ?? "",
        latitude: 0,
        longitude: 0,
        attributes: attrList,
        profileKeywordDataMap: await userRepository.getProfileKeywordDataMap(),
        activePostingIds: List.empty(growable: false),
      ),
      distanceKm: 0,
    );

    final ownProfileAvatarSvg = await _getOwnProfileAvatarIcon();

    final localSvgCopy = (ownProfileAvatarSvg != null && ownProfileAvatarSvg.isNotEmpty)
        ? ownProfileAvatarSvg
        : await AvatarIconUtils.resolveSvgForProfile(userPoi.profile);

    return RepaintBoundary(
      child: CategoryStatsUtils.buildCategoryStatsCircle(
        keywordMap: userPoi.profile.profileKeywordDataMap,
        attributes: userPoi.profile.attributes,
        size: AppDimensions.userAvatarSize * 3,
        strokeWidth: kIsWeb ? 7.2 : 6.0,
        gapWidth: kIsWeb ? 3.6 : 6.0,
        child: ClipOval(
          child: SvgPicture.string(
            localSvgCopy,
            width: AppDimensions.userAvatarSize,
            height: AppDimensions.userAvatarSize,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: false,
            placeholderBuilder: (context) => Container(
              width: AppDimensions.userAvatarSize,
              height: AppDimensions.userAvatarSize,
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
    if (widget.userId == null) {
      return const SizedBox.shrink();
    }

    final userRepository = getIt<UserRepository>();
    final interests = widget.userInterests?.isEmpty == true
        ? userRepository.userInterests
        : widget.userInterests;
    final offerings = widget.userOfferings?.isEmpty == true
        ? userRepository.userOfferings
        : widget.userOfferings;

    return ValueListenableBuilder<int>(
      valueListenable: userRepository.avatarRefreshNotifier,
      builder: (context, refreshTick, _) {
        return FutureBuilder<Widget>(
          key: ValueKey('avatar_fab_${widget.userId}_$refreshTick'),
          future: _createUserAvatar(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final avatarWidget = snapshot.data!;

            return GestureDetector(
              onTap: () async {
                if (kIsWeb && context.canShowSideBySide) {
                  context.read<ProfilePanelCubit>().openProfile(
                        userId: widget.userId!,
                        userName: widget.userName!,
                        interests: interests,
                        offerings: offerings,
                      );
                } else {
                  await context.push(
                    '/profile',
                    extra: {
                      'userId': widget.userId!,
                      'userName': widget.userName ?? 'Not registered',
                      'interests': interests,
                      'offerings': offerings,
                    },
                  );
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
                                color: AppColors.fabColor,
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
                                color: AppColors.darkGrey,
                              ),
                            ),
                            if (unreadCount > 0)
                              PositionedCountBadge(
                                count: unreadCount,
                                top: kIsWeb ? -5.2 : -4,
                                right: kIsWeb ? -5.2 : -4,
                                padding: EdgeInsets.all(kIsWeb ? 5.2 : 4),
                                borderColor: AppColors.background,
                                borderWidth: kIsWeb ? 2.0 : 1.5,
                                fontSize: kIsWeb ? 14.3 : 11,
                                constraints: BoxConstraints(
                                  minWidth: kIsWeb ? 42.9 : 33,
                                  minHeight: kIsWeb ? 42.9 : 33,
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
      },
    );
  }
}
