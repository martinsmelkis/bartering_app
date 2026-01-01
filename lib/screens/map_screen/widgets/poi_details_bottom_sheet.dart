import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/postings/posting_data_response.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attribute_entry_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/avatar_color_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:barter_app/widgets/full_screen_image_viewer.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/text_utils.dart';

class PoiDetailsBottomSheet extends StatefulWidget {
  final PointOfInterest poi;
  final VoidCallback onChatButtonPressed;

  const PoiDetailsBottomSheet({
    super.key,
    required this.poi,
    required this.onChatButtonPressed,
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

  // Cache for attribute spans to avoid recalculating on every rebuild
  Map<String, List<TextSpan>>? _cachedSpans;
  Future<Map<String, List<TextSpan>>>? _spansFuture;
  Future<bool>? _favoriteStatusFuture;

  // Avatar/POI icon state
  Widget? _avatarIcon;
  bool _isLoadingAvatar = true;

  @override
  void initState() {
    super.initState();
    // Initialize spans immediately but render simple placeholder first
    _spansFuture = _prepareSpans(context);

    // Schedule postings and favorite status loading after the first frame is rendered
    // This prevents blocking the UI, especially on web platform
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadPostings();
        _favoriteStatusFuture = _loadFavoriteStatus();
        _loadAvatarIcon();
      }
    });
  }

  Future<bool> _loadFavoriteStatus() async {
    try {
      final apiClient = getIt<ApiClient>();
      final userRepository = getIt<UserRepository>();
      final currentUserId = userRepository.userId;

      if (currentUserId == null) {
        return false;
      }

      // Get relationships for the current user
      final relationships = await apiClient.getRelationships(currentUserId);

      // Check if the POI user is in the current user's favorites list
      final isFavorite = relationships.favorites.contains(
          widget.poi.profile.userId);

      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
          _isLoadingFavorite = false;
        });
      }

      return isFavorite;
    } catch (e) {
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
      } else {
        // Add favorite
        await apiClient.createRelationship(relationshipRequest);
      }

      setState(() {
        _isFavorite = !_isFavorite;
        _isTogglingFavorite = false;
      });
    } catch (e) {
      setState(() {
        _isTogglingFavorite = false;
      });

      if (mounted) {
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

  Future<void> _loadAvatarIcon() async {
    try {
      // Use the same logic as map_screen to select the icon
      const int svgAssetCount = 25;
      final userIdHashCode = widget.poi.profile.userId.hashCode;
      final index = userIdHashCode.abs() % svgAssetCount;
      final selectedIconPath = 'assets/icons/path${index + 1}.svg';

      // Load and modify the SVG
      final svgString = await _loadAndModifySvg(selectedIconPath);

      if (mounted) {
        setState(() {
          _avatarIcon = SvgPicture.string(
            svgString,
            width: 56,
            height: 56,
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

  Future<String> _loadAndModifySvg(String assetPath) async {
    final attributes = widget.poi.profile.attributes?.map((e) => e.uiStyleHint).whereType<String>().toList();
    
    return AvatarColorUtils.loadAndColorSvgFromAttributes(
      assetPath: assetPath,
      attributes: attributes,
      relevancyScore: widget.poi.matchRelevancyScore,
    );
  }

  Future<void> _loadPostings() async {
    if (widget.poi.profile.activePostingIds == null ||
        widget.poi.profile.activePostingIds!.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingPostings = false;
        });
      }
      return;
    }

    try {
      final apiClient = getIt<ApiClient>();
      final postingIds = widget.poi.profile.activePostingIds!;

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

  // Helper to parse color from a string like "underscore:0xAARRGGBB"
  Color? _parseColorFromHint(String? hint) {
    if (hint != null) {
      final hexString =
      hint == 'GREEN' ? '0xFF00FF00' :
      hint == 'RED' ? '0xFFFF0000' :
      hint == 'BLUE' ? '0xFF0044FF' :
      hint == 'YELLOW' ? '0xFFFFFF40' :
      hint == 'ORANGE' ? '0xFFFFA500' :
      hint == 'PURPLE' ? '0xFF800080' :
      hint == 'TEAL' ? '0xFF00A0A0' :
      '0xFF1A1A1A';
      try {
        return Color(int.parse(hexString));
      } catch (e) {
        return null; // Return null if parsing fails
      }
    }
    return null;
  }

  // New async method to prepare all spans for the FutureBuilder
  Future<Map<String, List<TextSpan>>> _prepareSpans(
      BuildContext context) async {
    // 1. Get the current user's attributes for comparison
    final userRepository = getIt<UserRepository>();
    final currentUserInterests = await userRepository.getInterests();
    final currentUserOffers = await userRepository.getOfferings();

    final currentUserAttributeInterestIds = (currentUserInterests as List<
        ParsedAttributeData>).map((attr) => attr.attribute).toList();
    final currentUserAttributeOfferIds = (currentUserOffers as List<
        ParsedAttributeData>).map((attr) => attr.attribute).toList();

    // 2. Filter the POI's attributes into interests and offerings
    final poiInterests = widget.poi.profile.attributes
        ?.where((attr) => attr.type != 1)
        .toList() ?? [];
    final poiOfferings = widget.poi.profile.attributes
        ?.where((attr) => attr.type == 1)
        .toList() ?? [];

    // 3. Build the styled text spans with two types of matching:
    // - POI's interests vs user's OFFERINGS (complementary match - can trade)
    // - POI's interests vs user's INTERESTS (similar interests - blue color)
    final interestSpans = _buildAttributeSpans(
      context,
      poiInterests,
      currentUserAttributeOfferIds, // Complementary match
      currentUserAttributeInterestIds, // Similar match (blue)
    );

    // - POI's offerings vs user's INTERESTS (complementary match - can trade)
    // - POI's offerings vs user's OFFERINGS (similar offerings - blue color)
    final offeringSpans = _buildAttributeSpans(
      context,
      poiOfferings,
      currentUserAttributeInterestIds, // Complementary match
      currentUserAttributeOfferIds, // Similar match (blue)
    );

    return {
      'interests': interestSpans,
      'offerings': offeringSpans,
    };
  }

  // Corrected synchronous helper method to build spans for a given list of attributes
  List<TextSpan> _buildAttributeSpans(BuildContext context,
      List<UserAttributeEntryData> attributes,
      List<String> complementaryMatchIds,
      // For trade matches (offering meets interest)
      List<String> similarMatchIds,
      // For similar interests/offerings (blue color)
      ) {
    if (attributes.isEmpty) return [];

    List<TextSpan> spans = [];
    for (var i = 0; i < attributes.length; i++) {
      final attribute = attributes[i];
      final normalizedAttr = TextUtils.getTranslatedOrNormalizedAttribute(
          attribute.attributeId, context);

      // Check both types of matches
      final isComplementaryMatch = complementaryMatchIds.contains(
          normalizedAttr);
      final isSimilarMatch = similarMatchIds.contains(normalizedAttr);
      final underscoreColor = _parseColorFromHint(attribute.uiStyleHint);

      Color? textColor;
      FontWeight fontWeight = FontWeight.normal;

      if (isComplementaryMatch) {
        // Complementary match (can trade) - use secondary color
        textColor = AppColors.secondary;
        fontWeight = FontWeight.bold;
      } else if (isSimilarMatch) {
        // Similar match (same type) - use blue color
        textColor = Colors.blue;
        fontWeight = FontWeight.bold;
      }

      spans.add(
        TextSpan(
          text: normalizedAttr,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: ResponsiveBreakpoints.getSubheadingFontSize(context),
            decoration: (isComplementaryMatch || isSimilarMatch)
                ? null
                : underscoreColor != null ? TextDecoration.underline : null,
            decorationColor: (isComplementaryMatch || isSimilarMatch)
                ? null
                : underscoreColor,
            decorationThickness: 3,
          ),
        ),
      );

      // Add a comma separator if it's not the last item
      if (i < attributes.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }

  Widget _buildPostingImage(UserPostingData posting, int index) {
    // Get the base URL from the service
    final baseUrl = getIt<String>(instanceName: 'serviceBaseUrl');

    // Extract the filename from the imageUrl (assuming it's stored as just the filename)
    final filename = posting.imageUrls![index];

    // Construct the full URL: {baseUrl}/{userId}/{fileName}
    final imageUrl = '$baseUrl$filename';

    return GestureDetector(
      onTap: () {
        // Create list of all image URLs for this posting
        final allImageUrls = posting.imageUrls!
            .map((file) => '$baseUrl$file')
            .toList();

        // Open full-screen image viewer
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageViewer(
              imageUrls: allImageUrls,
              initialIndex: index,
              heroTag: 'posting_${posting.id}_image',
            ),
          ),
        );
      },
      child: Hero(
        tag: 'posting_${posting.id}_image_$index',
        child: Image.network(
          imageUrl,
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

  Widget _buildPostingCard(UserPostingData posting, AppLocalizations l10n) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                posting.isOffer ? Icons.add_circle : Icons.add_circle_outline,
                color: posting.isOffer ? Colors.blue : Colors.blue,
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
                        Icons.monetization_on, size: 16, color: Colors.green),
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
                        Icons.calendar_today, size: 16, color: Colors.orange),
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
        child: Center(
          child: CircularProgressIndicator(),
        ),
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
        const Divider(height: 24),
        Text(
          l10n.activePostings,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: PointerInterceptor(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar/POI icon on the left
                      Container(
                        width: 42,
                        height: 42,
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
                            : _avatarIcon ?? const Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(width: 8),
                      // Name in the center
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              widget.poi.profile.name +
                                  (((widget.poi.matchRelevancyScore ?? 0) > 0
                                  && (widget.poi.matchRelevancyScore ?? 1) < 1)
                                  ? " (" + (((widget.poi.matchRelevancyScore ?? 0) * 100))
                                  .toStringAsFixed(1) + "% ${l10n.match})" : ""),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: context.subheadingFontSize,
                                color: Colors.grey[900],
                                fontFamily: 'Courier',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Favorite icon button on the right
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: _isLoadingFavorite
                            ? const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  _isFavorite ? Icons.star : Icons.star_border,
                                  color: _isFavorite ? AppColors.primary : Colors.grey,
                                ),
                                onPressed: _isTogglingFavorite ? null : _toggleFavorite,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  // Use a FutureBuilder with cached future to avoid recalculating on every rebuild
                  FutureBuilder<Map<String, List<TextSpan>>>(
                    future: _spansFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        // Show simple text while loading for faster initial render
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${l10n.userInterestedIn} ${widget.poi.profile
                                  .attributes?.where((a) => a.type != 1).map((
                                  a) => a.attributeId).join(", ") ?? ""}',
                              style: TextStyle(color: Colors.grey,
                                fontSize: ResponsiveBreakpoints.getSubheadingFontSize(context),),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${l10n.userOffers} ${widget.poi.profile
                                  .attributes?.where((a) => a.type == 1).map((
                                  a) => a.attributeId).join(", ") ?? ""}',
                              style: TextStyle(color: Colors.grey,
                                fontSize: ResponsiveBreakpoints.getSubheadingFontSize(context),),
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                            '${l10n.errorLoadingAttributes}: ${snapshot
                                .error}');
                      }

                      // Cache the result for potential future use
                      _cachedSpans ??= snapshot.data;

                      final interestSpans = snapshot.data!['interests']!;
                      final offeringSpans = snapshot.data!['offerings']!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle
                                  .of(context)
                                  .style
                                  .copyWith(fontSize: context.bodyFontSize),
                              // Responsive font size
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${l10n.userInterestedIn} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveBreakpoints.getSubheadingFontSize(context)),
                                ),
                                ...interestSpans,
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle
                                  .of(context)
                                  .style
                                  .copyWith(fontSize: context.bodyFontSize),
                              // Responsive font size
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${l10n.userOffers} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveBreakpoints.getSubheadingFontSize(context)),
                                ),
                                ...offeringSpans,
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Postings section
                  _buildPostingsSection(l10n),
                ],
              ),
            ),
          ),
          // Chat button always at the bottom
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(l10n.chat),
                onPressed: widget.onChatButtonPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
