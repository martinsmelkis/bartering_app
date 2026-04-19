import 'package:barter_app/utils/avatar_icon_utils.dart';
import 'package:barter_app/widgets/full_screen_image_viewer.dart';import 'package:barter_app/widgets/image_viewer_dialog.dart';
import 'package:barter_app/widgets/webp_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../configure_dependencies.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../models/postings/posting_data_response.dart';
import '../../../services/api_client.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/attribute_matching_utils.dart';
import '../../../utils/avatar_color_utils.dart';
import '../../../utils/category_stats_utils.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/attribute_bubble.dart';
import '../../../widgets/online_status_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/poi_panel_cubit.dart';
import '../../chat_screen/widgets/chat_panel_header.dart';
import '../../chat_screen/chat_screen.dart';

class SearchResultsListView extends StatefulWidget {
  final List<PointOfInterest> pois;
  final VoidCallback onClose;
  final Function(PointOfInterest) onPoiTap;
  final Function(PointOfInterest)? onChatTap;
  final bool isLargeScreen;
  final PointOfInterest? selectedPoi;
  final VoidCallback? onClosePoiPanel;
  final VoidCallback? onChatWithSelectedPoi;

  const SearchResultsListView({
    super.key,
    required this.pois,
    required this.onClose,
    required this.onPoiTap,
    this.onChatTap,
    this.isLargeScreen = false,
    this.selectedPoi,
    this.onClosePoiPanel,
    this.onChatWithSelectedPoi,
  });

  @override
  State<SearchResultsListView> createState() => _SearchResultsListViewState();
}

enum ViewMode { users, postings }

class _SearchResultsListViewState extends State<SearchResultsListView> {
  final Set<String> _expandedUserIds = {};

  // Current user's attributes for matching (normalized/translated)
  List<String> _currentUserInterestIds = [];
  List<String> _currentUserOfferIds = [];
  bool _isLoadingUserAttributes = true;

  // View mode toggle
  ViewMode _viewMode = ViewMode.users;

  // Postings data
  final Map<String, UserPostingData> _postingsCache = {};
  final Map<String, List<UserPostingData>> _userPostingsMap = {};
  bool _isLoadingPostings = false;

  // Flattened list of all postings with user info
  List<PostingWithUser> _allPostings = [];

  // Controllers for expandable postings (auto-expanded by default)
  final Map<String, ExpandableController> _postingControllers = {};

  // Controllers for expandable work references (collapsed by default)
  final Map<String, ExpandableController> _workReferenceControllers = {};

  // Chat panel state
  bool _showChatPanel = false;
  PointOfInterest? _chatWithPoi;

  @override
  void initState() {
    super.initState();
    // Load after first frame to get context for translation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCurrentUserAttributes();
        _loadAllPostings();
      }
    });
  }

  @override
  void didUpdateWidget(SearchResultsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload user attributes when widget is updated (e.g., when shown again after profile changes)
    if (widget.pois != oldWidget.pois) {
      // Clear stale postings data when search results change
      _userPostingsMap.clear();
      _allPostings.clear();

      // Reset to users view when search results change
      setState(() {
        _viewMode = ViewMode.users;
      });
      _loadCurrentUserAttributes();
      _loadAllPostings();
    }
  }

  Future<void> _loadAllPostings() async {
    if (widget.pois.isEmpty) return;

    setState(() {
      _isLoadingPostings = true;
    });

    try {
      final apiClient = getIt<ApiClient>();
      final List<PostingWithUser> allPostings = [];

      for (final poi in widget.pois) {
        if (poi.profile.activePostingIds.isEmpty) {
          continue;
        }

        final postingIds = poi.profile.activePostingIds;
        final userPostings = <UserPostingData>[];

        for (final postingId in postingIds) {
          // Check cache first
          if (_postingsCache.containsKey(postingId)) {
            userPostings.add(_postingsCache[postingId]!);
          } else {
            try {
              final posting = await apiClient.getPostingById(postingId);
              if (posting != null) {
                _postingsCache[postingId] = posting;
                userPostings.add(posting);
              }
            } catch (e) {
              debugPrint('Error fetching posting $postingId: $e');
            }
          }
        }

        _userPostingsMap[poi.profile.userId] = userPostings;

        // Add to flattened list with user info
        for (final posting in userPostings) {
          allPostings.add(PostingWithUser(posting: posting, poi: poi));
        }
      }

      if (mounted) {
        setState(() {
          _allPostings = allPostings;
          _isLoadingPostings = false;
          // Switch to Postings tab by default if there are more than 2 postings
          if (_allPostings.length > 2 && _viewMode == ViewMode.users) {
            _viewMode = ViewMode.postings;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading postings: $e');
      if (mounted) {
        setState(() {
          _isLoadingPostings = false;
        });
      }
    }
  }

  Future<void> _loadCurrentUserAttributes() async {
    try {
      final userMatch = await AttributeMatchingUtils.loadUserAttributes(
        context,
      );

      if (mounted) {
        setState(() {
          _currentUserInterestIds = userMatch.interestIds;
          _currentUserOfferIds = userMatch.offerIds;
          _isLoadingUserAttributes = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading current user attributes: $e');
      if (mounted) {
        setState(() {
          _isLoadingUserAttributes = false;
        });
      }
    }
  }

  void _toggleExpanded(String userId) {
    setState(() {
      if (_expandedUserIds.contains(userId)) {
        _expandedUserIds.remove(userId);
      } else {
        _expandedUserIds.add(userId);
      }
    });
  }

  ExpandableController _getPostingController(String postingId) {
    if (!_postingControllers.containsKey(postingId)) {
      _postingControllers[postingId] = ExpandableController(
        initialExpanded: true,
      );
    }
    return _postingControllers[postingId]!;
  }

  ExpandableController _getWorkReferenceController(String userId) {
    if (!_workReferenceControllers.containsKey(userId)) {
      _workReferenceControllers[userId] = ExpandableController(
        initialExpanded: false,
      );
    }
    return _workReferenceControllers[userId]!;
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _postingControllers.values) {
      controller.dispose();
    }
    for (var controller in _workReferenceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Open chat panel below search results (for large screens)
  void _openChatPanel(PointOfInterest poi) {
    if (widget.isLargeScreen) {
      // On large screens, show chat panel below the list
      setState(() {
        _showChatPanel = true;
        _chatWithPoi = poi;
      });
    } else {
      // On small screens, use the default behavior (callback)
      widget.onChatTap?.call(poi);
    }
  }

  /// Close the inline chat panel
  void _closeChatPanel() {
    setState(() {
      _showChatPanel = false;
      _chatWithPoi = null;
    });
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: widget.isLargeScreen
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.isLargeScreen ? 12 : 10,
          height: widget.isLargeScreen ? 12 : 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 1),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: widget.isLargeScreen ? 10 : 9,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersListView(List<PointOfInterest> sortedPois) {
    final l10n = AppLocalizations.of(context)!;
    if (sortedPois.isEmpty) {
      return Center(
        child: Text(
          l10n.noUsersFound,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
        // Ensure pointer scrolling works on web
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: sortedPois.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final poi = sortedPois[index];
          return _buildPoiListItem(context, poi);
        },
      ),
    );
  }

  Widget _buildPostingsListView() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoadingPostings) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allPostings.isEmpty) {
      return Center(
        child: Text(
          l10n.noPostingsFound,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
        // Ensure pointer scrolling works on web
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _allPostings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final postingWithUser = _allPostings[index];
          return _buildPostingCard(context, postingWithUser);
        },
      ),
    );
  }

  Widget _buildPostingCard(
    BuildContext context,
    PostingWithUser postingWithUser,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final posting = postingWithUser.posting;
    final poi = postingWithUser.poi;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: Colors.white,
      //shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.circular(12),
      //),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info header (clickable to view user)
          InkWell(
            onTap: () => widget.onPoiTap(poi),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
              /*decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),*/
              child: Row(
                children: [
                  // Small avatar with category color circle
                  FutureBuilder<String>(
                    future: _loadSvg(poi),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CategoryStatsUtils.buildCategoryStatsCircle(
                          keywordMap: poi.profile.profileKeywordDataMap,
                          attributes: poi.profile.attributes,
                          size: 40,
                          strokeWidth: 2.0,
                          gapWidth: 0.5,
                          child: ClipOval(
                            child: SvgPicture.string(
                              snapshot.data!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poi.profile.name.startsWith('User_')
                              ? poi.profile.name.replaceFirst(
                                  'User_',
                                  l10n.userPrefix + ' ',
                                )
                              : poi.profile.name,
                          style: const TextStyle(
                            fontSize: 12.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (poi.distanceKm != null)
                          Text(
                            '${poi.distanceKm!.toStringAsFixed(1)} km away',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // User rating display
                  _buildCompactRatingDisplay(poi),
                  // Chat button
                  if (widget.onChatTap != null)
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      color: AppColors.primary,
                      onPressed: () => _openChatPanel(poi),
                      tooltip: l10n.chat,
                    ),
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
          // Posting content
          ExpandablePanel(
            controller: _getPostingController(
              posting.id ?? '${poi.profile.userId}_${posting.title}',
            ),
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
            header: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 4),
              child: Row(
                children: [
                  Icon(
                    posting.isOffer ? Icons.arrow_upward : Icons.arrow_downward,
                    color: posting.isOffer ? AppColors.secondary : Colors.blue,
                    size: 20,
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
                          Icons.monetization_on,
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
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
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
        ],
      ),
    );
  }

  Widget _buildPostingImage(UserPostingData posting, int index) {
    final baseUrl = ApiClient.serviceBaseUrl;
    final filename = posting.imageUrls![index];

    // Use thumbnail for list view (300x300, ~5-20KB)
    final thumbnailUrl = ImageUtils.buildThumbnailUrl(
      baseUrl: baseUrl,
      imagePath: filename,
    );

    return GestureDetector(
      onTap: () {
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
          ImageViewerDialog.show(
            context: context,
            imageUrls: allFullImageUrls,
            initialIndex: index,
            heroTag: 'posting_${posting.id}_image',
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageViewer(
                imageUrls: allFullImageUrls,
                initialIndex: index,
                heroTag: 'posting_${posting.id}_image',
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: 'posting_${posting.id}_image_$index',
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

  Widget _buildWorkReferenceImage(
    List<String> workReferenceImageUrls,
    int index,
    String userId,
  ) {
    final baseUrl = ApiClient.serviceBaseUrl;
    final filename = workReferenceImageUrls[index];

    final thumbnailUrl = ImageUtils.buildThumbnailUrl(
      baseUrl: baseUrl,
      imagePath: filename,
    );

    return GestureDetector(
      onTap: () {
        final allFullImageUrls = workReferenceImageUrls
            .map(
              (file) => ImageUtils.buildFullImageUrl(
                baseUrl: baseUrl,
                imagePath: file,
              ),
            )
            .toList();

        if (kIsWeb) {
          ImageViewerDialog.show(
            context: context,
            imageUrls: allFullImageUrls,
            initialIndex: index,
            heroTag: 'work_ref_${userId}_image',
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageViewer(
                imageUrls: allFullImageUrls,
                initialIndex: index,
                heroTag: 'work_ref_${userId}_image',
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: 'work_ref_${userId}_image_$index',
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

  Widget _buildWorkReferencesPanel(PointOfInterest poi) {
    final l10n = AppLocalizations.of(context)!;
    final workReferences = poi.profile.workReferenceImageUrls;

    if (workReferences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: ExpandablePanel(
        controller: _getWorkReferenceController(poi.profile.userId),
        theme: const ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          hasIcon: true,
        ),
        header: Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '${l10n.premiumProfileEditorWorkReferenceImages} (${workReferences.length})',
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
                    child: _buildWorkReferenceImage(
                      workReferences,
                      index,
                      poi.profile.userId,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Sort POIs with online users getting a 10% boost to their relevancy score
    final sortedPois = List<PointOfInterest>.from(widget.pois);
    sortedPois.sort((a, b) {
      // Calculate effective scores with online boost
      final aScore = (a.matchRelevancyScore ?? 0.0) * (a.isOnline ? 1.1 : 1.0);
      final bScore = (b.matchRelevancyScore ?? 0.0) * (b.isOnline ? 1.1 : 1.0);

      // Sort in descending order (highest score first)
      return bScore.compareTo(aScore);
    });

    // Build the main search results container
    final searchResultsContainer = Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: widget.isLargeScreen
            ? null
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
        boxShadow: widget.isLargeScreen
            ? null // Shadow handled by parent container in Row layout
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2), // Shadow on top for bottom panel
                ),
              ],
      ),
      child: Column(
        children: [
          // Header
          const SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isLargeScreen ? 16 : 12,
              vertical: widget.isLargeScreen ? 4 : 2,
            ),
            child: widget.isLargeScreen
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _viewMode == ViewMode.users
                                  ? l10n.matchingUsersFound(sortedPois.length)
                                  : l10n.matchingPostingsFound(
                                      _allPostings.length,
                                    ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Toggle buttons with legend for large screens
                            Row(
                              children: [
                                // Toggle buttons
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildToggleButton(
                                        icon: Icons.people,
                                        label: l10n.users,
                                        isSelected: _viewMode == ViewMode.users,
                                        onTap: () {
                                          setState(() {
                                            _viewMode = ViewMode.users;
                                          });
                                        },
                                      ),
                                      _buildToggleButton(
                                        icon: Icons.article,
                                        label: l10n.postings,
                                        isSelected:
                                            _viewMode == ViewMode.postings,
                                        onTap: () {
                                          setState(() {
                                            _viewMode = ViewMode.postings;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Legend - aligned to right of toggle buttons on large screens
                                if (!_isLoadingUserAttributes)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      _buildLegendItem(
                                        color: AppColors.secondary,
                                        label: l10n.tradeMatch,
                                      ),
                                      const SizedBox(width: 12),
                                      _buildLegendItem(
                                        color: Colors.blue,
                                        label: l10n.similar,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onClose,
                          borderRadius: BorderRadius.circular(20),
                          canRequestFocus: false,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.close, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _viewMode == ViewMode.users
                                  ? l10n.matchingUsersFound(sortedPois.length)
                                  : l10n.matchingPostingsFound(
                                      _allPostings.length,
                                    ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.onClose,
                              borderRadius: BorderRadius.circular(20),
                              canRequestFocus: false,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Toggle buttons and legend in flexible layout for small screens
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Toggle buttons
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildToggleButton(
                                  icon: Icons.people,
                                  label: l10n.users,
                                  isSelected: _viewMode == ViewMode.users,
                                  onTap: () {
                                    setState(() {
                                      _viewMode = ViewMode.users;
                                    });
                                  },
                                ),
                                _buildToggleButton(
                                  icon: Icons.article,
                                  label: l10n.postings,
                                  isSelected: _viewMode == ViewMode.postings,
                                  onTap: () {
                                    setState(() {
                                      _viewMode = ViewMode.postings;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Legend - will wrap to next line if needed
                          if (!_isLoadingUserAttributes)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                _buildLegendItem(
                                  color: AppColors.secondary,
                                  label: l10n.tradeMatch,
                                ),
                                const SizedBox(width: 8),
                                _buildLegendItem(
                                  color: Colors.blue,
                                  label: l10n.similar,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 4),
          // List of results
          Expanded(
            child: _viewMode == ViewMode.users
                ? _buildUsersListView(sortedPois)
                : _buildPostingsListView(),
          ),
        ],
      ),
    );

    // For large screens, use BlocBuilder to show POI details or chat below the search results
    if (widget.isLargeScreen) {
      // If chat panel is open, show chat below search results
      if (_showChatPanel && _chatWithPoi != null) {
        return Column(
          children: [
            // Search results list - takes 60% of height
            Expanded(flex: 6, child: searchResultsContainer),
            // Chat panel - takes 40% of height
            Expanded(flex: 4, child: _buildInlineChatPanel()),
          ],
        );
      }

      return BlocBuilder<PoiPanelCubit, PoiPanelState>(
        builder: (context, poiPanelState) {
          if (poiPanelState.isOpen && poiPanelState.selectedPoi != null) {
            // Show search results and POI details in a vertical split
            return Column(
              children: [
                Expanded(flex: 1, child: searchResultsContainer)
              ],
            );
          }
          // POI panel closed - show only search results
          return searchResultsContainer;
        },
      );
    }

    // For small screens, return the search results container directly
    return searchResultsContainer;
  }

  Widget _buildPoiListItem(BuildContext context, PointOfInterest poi) {
    final l10n = AppLocalizations.of(context)!;
    final isExpanded = _expandedUserIds.contains(poi.profile.userId);

    return InkWell(
      onTap: () => widget.onPoiTap(poi),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name with avatar
            Row(
              children: [
                // Avatar with online badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FutureBuilder<String>(
                      future: _loadSvg(poi),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CategoryStatsUtils.buildCategoryStatsCircle(
                            keywordMap: poi.profile.profileKeywordDataMap,
                            attributes: poi.profile.attributes,
                            size: 68,
                            strokeWidth: 3.0,
                            gapWidth: 1.0,
                            child: ClipOval(
                              child: SvgPicture.string(
                                snapshot.data!,
                                width: 68,
                                height: 68,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    // Online status badge - positioned closer to the edge
                    PositionedOnlineStatusBadge(
                      isOnline: poi.isOnline,
                      isAway: poi.isAway,
                      size: 10.0,
                      right: 10,
                      top: 10,
                      borderWidth: 2.0,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // User rating display
                _buildRatingDisplay(poi),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey),
                const SizedBox(width: 8),
                // Username
                Expanded(
                  child: Text(
                    poi.profile.name.startsWith('User_')
                        ? poi.profile.name.replaceFirst(
                            'User_',
                            l10n.userPrefix + ' ',
                          )
                        : poi.profile.name,
                    style: const TextStyle(
                      fontSize: 14.4,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            if ((poi.profile.selfDescription ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                poi.profile.selfDescription!.trim(),
                maxLines: isExpanded ? 6 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 6),
            ],
            _buildWorkReferencesPanel(poi),
            // Interests and Offerings separated
            if (poi.profile.attributes.isNotEmpty) ...[
              _buildAttributesSection(context, poi, isExpanded),
            ],
            // Distance, relevancy score, and chat button
            _buildBottomRow(context, poi),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context, PointOfInterest poi) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Distance
        if (poi.distanceKm != null) ...[
          Icon(Icons.location_on, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Text(
            '${poi.distanceKm!.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        // Relevancy score
        if (poi.matchRelevancyScore != null) ...[
          if (poi.distanceKm != null) const SizedBox(width: 16),
          Icon(Icons.star, size: 16, color: Colors.amber[700]),
          const SizedBox(width: 4),
          Text(
            '${l10n.matchLabel} ${(poi.matchRelevancyScore! * 100).toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const Spacer(),
        // Chat button
        if (widget.onChatTap != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => _openChatPanel(poi),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.chat,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAttributesSection(
    BuildContext context,
    PointOfInterest poi,
    bool isExpanded,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // Separate interests (type != 1) and offerings (type == 1)
    final interests = poi.profile.attributes.where((a) => a.type != 1).toList();
    final offerings = poi.profile.attributes.where((a) => a.type == 1).toList();
    final postings = poi.profile.activePostingIds;

    // Check if there are more items to show
    final hasMoreItems =
        interests.length > 4 || offerings.length > 4 || postings.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interests
        if (interests.isNotEmpty) ...[
          Text(
            l10n.userInterestedIn,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (isExpanded ? interests : interests.take(4)).map((attr) {
              final normalizedAttr =
                  TextUtils.getTranslatedOrNormalizedAttribute(
                    attr.attributeId,
                    context,
                  );

              // Use utility to determine match type
              final matchType = AttributeMatchingUtils.getMatchType(
                normalizedAttribute: normalizedAttr,
                currentUserInterestIds: _currentUserInterestIds,
                currentUserOfferIds: _currentUserOfferIds,
                isPoiInterest: true, // This is POI's interest
              );

              return AttributeBubble(
                attribute: attr,
                matchType: matchType,
                scaleFactor: 1.0,
                currentUserInterestIds: _currentUserInterestIds,
                currentUserOfferIds: _currentUserOfferIds,
                isPoiInterest: true,
              );
            }).toList(),
          ),
        ],
        // Offerings
        if (offerings.isNotEmpty) ...[
          if (interests.isNotEmpty) const SizedBox(height: 8),
          Text(
            l10n.userOffers,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (isExpanded ? offerings : offerings.take(4)).map((attr) {
              final normalizedAttr =
                  TextUtils.getTranslatedOrNormalizedAttribute(
                    attr.attributeId,
                    context,
                  );

              // Use utility to determine match type
              final matchType = AttributeMatchingUtils.getMatchType(
                normalizedAttribute: normalizedAttr,
                currentUserInterestIds: _currentUserInterestIds,
                currentUserOfferIds: _currentUserOfferIds,
                isPoiInterest: false, // This is POI's offering
              );

              return AttributeBubble(
                attribute: attr,
                matchType: matchType,
                scaleFactor: 1.0,
                currentUserInterestIds: _currentUserInterestIds,
                currentUserOfferIds: _currentUserOfferIds,
                isPoiInterest: false,
              );
            }).toList(),
          ),
        ],
        // Active Postings (only show when expanded)
        if (isExpanded && postings.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.activePostings,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${postings.length} ${postings.length == 1 ? l10n.posting.toLowerCase() : l10n.postings.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        // Expand/Collapse button
        if (hasMoreItems) ...[
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _toggleExpanded(poi.profile.userId),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isExpanded ? l10n.showLess : l10n.showMore,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build rating display widget
  Widget _buildRatingDisplay(PointOfInterest poi) {
    // Use rating data from POI fields, default to 0.0 and 0 if not available
    final rating = poi.averageRating ?? 0.0;
    final reviewCount = poi.totalReviews ?? 0;
    final ratingColor = AvatarColorUtils.getRatingColor(rating);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: ratingColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.white),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          '($reviewCount)',
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// Build compact rating display widget for posting cards (horizontal layout)
  Widget _buildCompactRatingDisplay(PointOfInterest poi) {
    // Use rating data from POI fields, default to 0.0 and 0 if not available
    final rating = poi.averageRating ?? 0.0;
    final reviewCount = poi.totalReviews ?? 0;
    final ratingColor = AvatarColorUtils.getRatingColor(rating);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          decoration: BoxDecoration(
            color: ratingColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 10, color: Colors.white),
              const SizedBox(width: 1),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '($reviewCount)',
          style: TextStyle(fontSize: 9, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// Build inline chat panel that appears below search results
  Widget _buildInlineChatPanel() {
    if (_chatWithPoi == null) return const SizedBox.shrink();

    final poi = _chatWithPoi!;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Chat header with 3-point menu
          ChatPanelHeader(
            chatPoiName: poi.profile.name,
            chatPoiId: poi.profile.userId,
            onClose: _closeChatPanel,
          ),
          // Chat content
          Expanded(
            child: ChatScreen(
              poiId: poi.profile.userId,
              poiName: poi.profile.name,
              poi: poi,
              showAppBar: false,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _loadSvg(PointOfInterest poi) async {
    return AvatarIconUtils.resolveSvgForProfile(poi.profile);
  }
}

/// Helper class to associate a posting with its user
class PostingWithUser {
  final UserPostingData posting;
  final PointOfInterest poi;

  PostingWithUser({required this.posting, required this.poi});
}
