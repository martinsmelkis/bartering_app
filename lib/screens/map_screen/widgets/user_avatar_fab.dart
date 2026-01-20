import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/map/point_of_interest.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/user_profile_screen/user_profile_screen.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/theme/app_dimensions.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
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

  Future<MarkerIcon> _createUserAvatar(BuildContext context) async {
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
        profileKeywordDataMap: null,
        activePostingIds: List.empty(growable: false),
      ),
      distanceKm: 0,
    );

    // Use the userId to get a consistent random icon
    final userIdHashCode = userPoi.profile.userId.hashCode;
    final index = userIdHashCode.abs() % _svgAssetCount;
    final selectedIconPath = _getSvgAsset(index + 1); // 1-based index

    final attributes = userPoi.profile.attributes
        ?.map((e) => e.uiStyleHint)
        .whereType<String>()
        .toList();

    final svgString = await AvatarColorUtils.loadAndColorSvgFromAttributes(
      assetPath: selectedIconPath,
      attributes: attributes,
      relevancyScore: userPoi.matchRelevancyScore,
    );

    // Create a local copy of the string to avoid reference issues
    final localSvgCopy = String.fromCharCodes(svgString.runes);

    return MarkerIcon(
      iconWidget: SvgPicture.string(
        localSvgCopy,
        width: AppDimensions.poiMarkerSize,
        height: AppDimensions.poiMarkerSize,
        key: ValueKey('poi_marker_${userPoi.profile.userId}'),
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

    return FutureBuilder<MarkerIcon>(
      future: _createUserAvatar(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final markerWidget = snapshot.data!.iconWidget!;

        return GestureDetector(
          onTap: () async {
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
                      blurRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: markerWidget,
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
                                blurRadius: 4,
                                offset: const Offset(0, 2),
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
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 33,
                                minHeight: 33,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
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
