import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/postings/posting_data_response.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/attribute_matching_utils.dart';
import 'package:barter_app/utils/category_stats_utils.dart';
import 'package:barter_app/utils/avatar_icon_utils.dart';
import 'package:barter_app/utils/image_utils.dart';import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/utils/text_utils.dart';
import 'package:barter_app/widgets/attribute_bubble.dart';
import 'package:barter_app/widgets/full_screen_image_viewer.dart';
import 'package:barter_app/widgets/image_viewer_dialog.dart';
import 'package:barter_app/widgets/online_status_badge.dart';
import 'package:barter_app/widgets/webp_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../models/reviews/reputation_response.dart';
import '../../../theme/app_colors.dart';
import '../../user_profile_screen/widgets/badges_info_dialog.dart';
import '../../../utils/avatar_color_utils.dart';

class PoiDetailsBottomSheet extends StatefulWidget {
  final PointOfInterest poi;
  final VoidCallback? onChatButtonPressed;
  final bool isLargeScreen;
  final VoidCallback? onClose;
  final bool showChatButton;

  const PoiDetailsBottomSheet({
    super.key,
    required this.poi,
    this.onChatButtonPressed,
    this.isLargeScreen = false,
    this.onClose,
    this.showChatButton = true,
  });

  @override
  State<PoiDetailsBottomSheet> createState() => _PoiDetailsBottomSheetState();
}

class _PoiDetailsBottomSheetState extends State<PoiDetailsBottomSheet> {
  // Static cache for postings to avoid re-fetching
  static final Map<String, UserPostingData> _postingsCache = {};

  // Static cache for favorite status to avoid re-fetching
  static final Map<String, Set<String>> _favoritesCache = {};
  static DateTime? _favoritesCacheTime;
  static const _cacheValidityDuration = Duration(minutes: 5);

  List<UserPostingData> _postings = [];
  bool _isLoadingPostings = true;
  String? _postingsError;

  // Favorite state
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;
  bool _isTogglingFavorite = false;

  Widget? _avatarIcon;
  bool _isLoadingAvatar = true;

  // Current user's attributes for matching (normalized/translated)
  List<String> _currentUserInterestIds = [];
  List<String> _currentUserOfferIds = [];

  late ExpandableController _workReferenceController;

  @override
  void initState() {
    super.initState();
    _workReferenceController = ExpandableController(initialExpanded: false);
    _initializeData();
  }

  @override
  void didUpdateWidget(PoiDetailsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the POI has changed (different user)
    if (oldWidget.poi.profile.userId != widget.poi.profile.userId) {
      _workReferenceController.dispose();
      _workReferenceController = ExpandableController(initialExpanded: false);
      // Reset all state and reload data for the new POI
      _resetState();
      _initializeData();
    }
  }

  void _resetState() {
    setState(() {
      _postings = [];
      _isLoadingPostings = true;
      _postingsError = null;
      _isFavorite = false;
      _isLoadingFavorite = true;
      _isTogglingFavorite = false;
      _avatarIcon = null;
      _isLoadingAvatar = true;
    });
  }

  @override
  void dispose() {
    _workReferenceController.dispose();
    super.dispose();
  }

  _initializeData() async {
    // Schedule postings and favorite status loading after the first frame is rendered
    // This prevents blocking the UI, especially on web platform
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _loadPostings();
        _loadFavoriteStatus();
        _loadAvatarIcon();
        _loadCurrentUserAttributes();
      }
    });
  }

  _loadCurrentUserAttributes() async {
    try {
      final userMatch = await AttributeMatchingUtils.loadUserAttributes(
        context,
      );

      if (mounted) {
        setState(() {
          _currentUserInterestIds = userMatch.interestIds
              .map((e) => e.toLowerCase().replaceAll(" ", "_"))
              .toList();
          _currentUserOfferIds = userMatch.offerIds
              .map((e) => e.toLowerCase().replaceAll(" ", "_"))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading current user attributes: $e');
    }
  }

  _loadFavoriteStatus() async {
    try {
      final apiClient = getIt<ApiClient>();
      final userRepository = getIt<UserRepository>();
      final currentUserId = userRepository.userId;

      if (currentUserId == null) {
        if (mounted) {
          setState(() {
            _isLoadingFavorite = false;
          });
        }
        return false;
      }

      // Check if cache is valid
      final now = DateTime.now();
      final cacheIsValid =
          _favoritesCacheTime != null &&
          now.difference(_favoritesCacheTime!) < _cacheValidityDuration &&
          _favoritesCache.containsKey(currentUserId);

      Set<String> favorites;

      if (cacheIsValid) {
        // Use cached data
        favorites = _favoritesCache[currentUserId]!;
      } else {
        // Fetch fresh data and update cache
        final relationships = await apiClient.getRelationships(currentUserId);
        favorites = relationships.favorites.toSet();

        // Update cache
        _favoritesCache[currentUserId] = favorites;
        _favoritesCacheTime = now;
      }

      // Check if the POI user is in the favorites list
      final isFavorite = favorites.contains(widget.poi.profile.userId);

      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
          _isLoadingFavorite = false;
        });
      }

      return isFavorite;
    } catch (e) {
      debugPrint('Error loading favorite status: $e');
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
      return false;
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isTogglingFavorite) return;

    setState(() {
      _isTogglingFavorite = true;
    });

    try {
      final apiClient = getIt<ApiClient>();
      final userRepository = getIt<UserRepository>();
      final currentUserId = userRepository.userId;

      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      final relationshipRequest = {
        'fromUserId': currentUserId,
        'toUserId': widget.poi.profile.userId,
        'relationshipType': 'favorite',
      };

      if (_isFavorite) {
        // Remove favorite
        await apiClient.removeRelationship(relationshipRequest);
        // Update cache
        _favoritesCache[currentUserId]?.remove(widget.poi.profile.userId);
      } else {
        // Add favorite
        await apiClient.createRelationship(relationshipRequest);
        // Update cache
        if (_favoritesCache.containsKey(currentUserId)) {
          _favoritesCache[currentUserId]!.add(widget.poi.profile.userId);
        }
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isTogglingFavorite = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTogglingFavorite = false;
        });

        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorUpdatingFavorite}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  _loadAvatarIcon() async {
    try {
      final svgString = await AvatarIconUtils.resolveSvgForProfile(widget.poi.profile);

      if (mounted) {
        setState(() {
          _avatarIcon = ClipOval(
            child: SvgPicture.string(
              svgString,
              width: 56,
              height: 56,
              fit: BoxFit.contain,
            ),
          );
          _isLoadingAvatar = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading avatar icon: $e');
      if (mounted) {
        setState(() {
          _isLoadingAvatar = false;
        });
      }
    }
  }

  _loadPostings() async {
    if (widget.poi.profile.activePostingIds.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingPostings = false;
        });
      }
      return;
    }

    try {
      final apiClient = getIt<ApiClient>();
      final postingIds = widget.poi.profile.activePostingIds;

      // Separate cached and non-cached postings
      final cachedPostings = <UserPostingData>[];
      final idsToFetch = <String>[];

      for (final postingId in postingIds) {
        if (_postingsCache.containsKey(postingId)) {
          cachedPostings.add(_postingsCache[postingId]!);
        } else {
          idsToFetch.add(postingId);
        }
      }

      // Fetch all non-cached postings in parallel
      final fetchFutures = idsToFetch.map((postingId) async {
        try {
          final posting = await apiClient.getPostingById(postingId);
          if (posting != null) {
            _postingsCache[postingId] = posting; // Cache it
            return posting;
          }
        } catch (e) {
          // Log error but don't fail entire operation
          debugPrint('Error fetching posting $postingId: $e');
        }
        return null;
      });

      // Wait for all fetches to complete in parallel
      final fetchedPostings = await Future.wait(fetchFutures);

      // Combine cached and newly fetched postings, filtering out nulls
      final allPostings = [
        ...cachedPostings,
        ...fetchedPostings.whereType<UserPostingData>(),
      ];

      if (mounted) {
        setState(() {
          _postings = allPostings;
          _isLoadingPostings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _postingsError = e.toString();
          _isLoadingPostings = false;
        });
      }
    }
  }

  Widget _buildAttributeBubbles({
    required BuildContext context,
    required List<dynamic> attributes,
    required bool isPoiInterest,
  }) {
    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 7.2, // 6 * 1.2
      runSpacing: 7.2, // 6 * 1.2
      children: attributes.map((attr) {
        final normalizedAttr = TextUtils.getTranslatedOrNormalizedAttribute(
          attr.attributeId,
          context,
        );

        // Use utility to determine match type
        final matchType = AttributeMatchingUtils.getMatchType(
          normalizedAttribute: normalizedAttr.toLowerCase().replaceAll(
            " ",
            "_",
          ),
          currentUserInterestIds: _currentUserInterestIds,
          currentUserOfferIds: _currentUserOfferIds,
          isPoiInterest: isPoiInterest,
        );

        return AttributeBubble(
          attribute: attr,
          matchType: matchType,
          scaleFactor: 1.1,
          currentUserInterestIds: _currentUserInterestIds,
          currentUserOfferIds: _currentUserOfferIds,
          isPoiInterest: isPoiInterest,
        );
      }).toList(),
    );
  }

  Widget _buildPostingImage(UserPostingData posting, int index) {
    // Get the base URL from ApiClient static getter
    final baseUrl = ApiClient.serviceBaseUrl;

    // Extract the filename from the imageUrl (assuming it's stored as just the filename)
    final filename = posting.imageUrls![index];

    // Use thumbnail for list view (300x300, ~5-20KB)
    final thumbnailUrl = ImageUtils.buildThumbnailUrl(
      baseUrl: baseUrl,
      imagePath: filename,
    );

    return GestureDetector(
      onTap: () async {
        // Create list of all FULL RESOLUTION image URLs for the viewer
        final allFullImageUrls = posting.imageUrls!
            .map(
              (file) => ImageUtils.buildFullImageUrl(
                baseUrl: baseUrl,
                imagePath: file,
              ),
            )
            .toList();

        // Open full-screen image viewer with full resolution images
        // Use dialog on web to prevent map iframe destruction, navigation on native
        if (kIsWeb) {
          await ImageViewerDialog.show(
            context: context,
            imageUrls: allFullImageUrls,
            initialIndex: index,
            heroTag: null,
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageViewer(
                imageUrls: allFullImageUrls,
                initialIndex: index,
                heroTag: null,
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: 'posting_${posting.id}_image_$index',
        // Disable hero animation to prevent thumbnail being used in full-screen view
        transitionOnUserGestures: false,
        child: WebPImage(
          imageUrl: thumbnailUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkReferenceImage(int index) {
    final baseUrl = ApiClient.serviceBaseUrl;
    final filename = widget.poi.profile.workReferenceImageUrls[index];

    final thumbnailUrl = ImageUtils.buildThumbnailUrl(
      baseUrl: baseUrl,
      imagePath: filename,
    );

    return GestureDetector(
      onTap: () async {
        final allFullImageUrls = widget.poi.profile.workReferenceImageUrls
            .map(
              (file) => ImageUtils.buildFullImageUrl(
                baseUrl: baseUrl,
                imagePath: file,
              ),
            )
            .toList();

        if (kIsWeb) {
          await ImageViewerDialog.show(
            context: context,
            imageUrls: allFullImageUrls,
            initialIndex: index,
            heroTag: null,
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageViewer(
                imageUrls: allFullImageUrls,
                initialIndex: index,
                heroTag: null,
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: 'work_ref_${widget.poi.profile.userId}_image_$index',
        transitionOnUserGestures: false,
        child: WebPImage(
          imageUrl: thumbnailUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkReferencesPanel(AppLocalizations l10n) {
    final workReferences = widget.poi.profile.workReferenceImageUrls;

    if (workReferences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpandablePanel(
        controller: _workReferenceController,
        theme: const ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          hasIcon: true,
        ),
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '${l10n.premiumProfileEditorWorkReferenceImages} (${workReferences.length})',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        collapsed: const SizedBox.shrink(),
        expanded: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: workReferences.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildWorkReferenceImage(index),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostingCard(UserPostingData posting, AppLocalizations l10n) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          tapHeaderToExpand: true,
          hasIcon: true,
        ),
        header: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                posting.isOffer ? Icons.arrow_upward : Icons.arrow_downward,
                color: posting.isOffer ? AppColors.secondary : Colors.blue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  posting.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        collapsed: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            posting.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        expanded: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                posting.description,
                style: TextStyle(color: Colors.grey[800]),
              ),
              const SizedBox(height: 12),
              if (posting.value != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.euro_outlined,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.valuePrefix}: \$${posting.value!.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (posting.expiresAt != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.expiresPrefix}: ${dateFormat.format(posting.expiresAt!)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.postedPrefix}: ${dateFormat.format(posting.createdAt)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (posting.imageUrls != null &&
                  posting.imageUrls!.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posting.imageUrls!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildPostingImage(posting, index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostingsSection(AppLocalizations l10n) {
    if (_isLoadingPostings) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_postingsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '${l10n.errorLoadingPostings}: $_postingsError',
          style: TextStyle(color: Colors.red[700], fontSize: 12),
        ),
      );
    }

    if (_postings.isEmpty) {
      return const SizedBox.shrink();
    }

    final offers = _postings.where((p) => p.isOffer).toList();
    final interests = _postings.where((p) => !p.isOffer).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24, color: AppColors.primary),
        Text(
          l10n.activePostings,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (offers.isNotEmpty) ...[
          Text(
            '${l10n.offers} (${offers.length})',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...offers.map((posting) => _buildPostingCard(posting, l10n)),
        ],
        if (interests.isNotEmpty) ...[
          if (offers.isNotEmpty) const SizedBox(height: 8),
          Text(
            '${l10n.lookingFor} (${interests.length})',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...interests.map((posting) => _buildPostingCard(posting, l10n)),
        ],
      ],
    );
  }

  void _showPoiBadgesInfoDialog() {
    final earnedBadgeTypes = (widget.poi.badges ?? const <ReputationBadge>[])
        .map((b) => b.value.toLowerCase())
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.grey[900],
        decoration: TextDecoration.none,
        fontFamily: null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: widget.isLargeScreen
              ? null
              : const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
        ),
        child: PointerInterceptor(
          child: Column(
            mainAxisSize: widget.isLargeScreen
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: [
              // Close button for large screen panel
              if (widget.isLargeScreen && widget.onClose != null)
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          l10n.userDetails,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: widget.onClose,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        tooltip: l10n.close,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category stats bar at the very top - extends to edges and clips under rounded corners
                      ClipRRect(
                        borderRadius: widget.isLargeScreen
                            ? BorderRadius.zero
                            : const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                        child: CategoryStatsUtils.buildCategoryStatsBar(
                          keywordMap: widget.poi.profile.profileKeywordDataMap,
                          attributes: widget.poi.profile.attributes,
                          height: 8,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card containing avatar, name, favorite, and rating
                            Card(
                              elevation: 1,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    // Favorite icon button on the left
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isLoadingFavorite
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : IconButton(
                                              padding: EdgeInsets.only(
                                                left: 4,
                                                top: 0,
                                              ),
                                              icon: Icon(
                                                _isFavorite
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: _isFavorite
                                                    ? AppColors.primary
                                                    : Colors.grey,
                                              ),
                                              onPressed: _isTogglingFavorite
                                                  ? null
                                                  : _toggleFavorite,
                                            ),
                                    ),
                                    const SizedBox(width: 6),
                                    // Name in the center
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  (widget.poi.profile.name.startsWith(
                                                            'User_',
                                                          )
                                                          ? widget.poi.profile.name
                                                                .replaceFirst(
                                                                  'User_',
                                                                  l10n.userPrefix +
                                                                      ' ',
                                                                )
                                                          : widget.poi.profile.name) +
                                                      (((widget.poi.matchRelevancyScore ??
                                                                      0) >
                                                                  0 &&
                                                              (widget.poi.matchRelevancyScore ??
                                                                      1) <
                                                                  1)
                                                          ? " (" +
                                                                (((widget.poi.matchRelevancyScore ??
                                                                            0) *
                                                                        100))
                                                                    .toStringAsFixed(
                                                                      1,
                                                                    ) +
                                                                "% ${l10n.match})"
                                                          : ""),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[900],
                                                    fontSize:
                                                        ResponsiveBreakpoints.getBodyFontSize(
                                                          context,
                                                        ) *
                                                        (widget.isLargeScreen
                                                            ? 0.85
                                                            : 1.0),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!widget.isLargeScreen && widget.poi.distanceKm != null) ...[
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 14,
                                                  color: Colors.blue[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${widget.poi.distanceKm!.toStringAsFixed(1)} km',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if ((widget.poi.profile.selfDescription ?? '').trim().isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              widget.poi.profile.selfDescription!.trim(),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                          _buildWorkReferencesPanel(l10n),
                                        ],
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final poiRating = widget.poi.averageRating;
                                        final hasRating = poiRating != null && poiRating > 0;

                                        final badgesIndicator = PointerInterceptor(
                                          child: InkWell(
                                            onTap: _showPoiBadgesInfoDialog,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 2,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 16,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color: (widget.poi.badges != null &&
                                                              widget.poi.badges!.isNotEmpty)
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
                                                    '${widget.poi.badges?.length ?? 0}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: (widget.poi.badges != null &&
                                                              widget.poi.badges!.isNotEmpty)
                                                          ? Colors.grey[700]
                                                          : Colors.grey[500],
                                                      fontWeight: (widget.poi.badges != null &&
                                                              widget.poi.badges!.isNotEmpty)
                                                          ? FontWeight.w600
                                                          : FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                        final ratingWidget = hasRating
                                            ? Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AvatarColorUtils.getRatingColor(poiRating),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 10,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      poiRating.toStringAsFixed(1),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox.shrink();

                                        final avatarWidget = Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            SizedBox(
                                              width: 56,
                                              height: 56,
                                              child: _isLoadingAvatar
                                                  ? const Center(
                                                      child: SizedBox(
                                                        width: 26,
                                                        height: 26,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                                    )
                                                  : _avatarIcon ??
                                                        const Icon(
                                                          Icons.person,
                                                          size: 35,
                                                        ),
                                            ),
                                            // Online status badge - positioned at bottom-right
                                            PositionedOnlineStatusBadge(
                                              isOnline: widget.poi.isOnline,
                                              isAway: widget.poi.isAway,
                                              size: 16.0,
                                              right: 5,
                                              bottom: 5,
                                              borderWidth: 2.5,
                                            ),
                                          ],
                                        );

                                        return hasRating
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ratingWidget,
                                                      const SizedBox(width: 8),
                                                      avatarWidget,
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: badgesIndicator,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                height: 56,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    badgesIndicator,
                                                    const SizedBox(width: 8),
                                                    avatarWidget,
                                                  ],
                                                ),
                                              );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Attribute cards
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_downward,
                                                  size: 20,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${l10n.userInterestedIn}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[900],
                                                  fontSize:
                                                      ResponsiveBreakpoints.getBodyFontSize(
                                                        context,
                                                      ) *
                                                      (widget.isLargeScreen
                                                          ? 0.85
                                                          : 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                              top: 6,
                                            ),
                                            child: _buildAttributeBubbles(
                                              context: context,
                                              attributes:
                                                  widget.poi.profile.attributes
                                                      .where(
                                                        (a) => a.type != 1,
                                                      )
                                                      .toList(),
                                              isPoiInterest: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  size: 20,
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${l10n.userOffers}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[900],
                                                  fontSize:
                                                      ResponsiveBreakpoints.getBodyFontSize(
                                                        context,
                                                      ) *
                                                      (widget.isLargeScreen
                                                          ? 0.85
                                                          : 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                              top: 6,
                                            ),
                                            child: _buildAttributeBubbles(
                                              context: context,
                                              attributes:
                                                  widget.poi.profile.attributes
                                                      .where(
                                                        (a) => a.type == 1,
                                                      )
                                                      .toList(),
                                              isPoiInterest: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Postings section
                            _buildPostingsSection(l10n),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Chat button always at the bottom (unless hidden)
              if (widget.showChatButton && widget.onChatButtonPressed != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    16 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(l10n.chat, style: TextStyle(fontSize: 14)),
                      onPressed: widget.onChatButtonPressed!,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
