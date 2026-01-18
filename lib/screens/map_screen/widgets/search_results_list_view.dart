import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/map/point_of_interest.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/avatar_color_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/online_status_badge.dart';

class SearchResultsListView extends StatefulWidget {
  final List<PointOfInterest> pois;
  final VoidCallback onClose;
  final Function(PointOfInterest) onPoiTap;
  final Function(PointOfInterest)? onChatTap;

  const SearchResultsListView({
    super.key,
    required this.pois,
    required this.onClose,
    required this.onPoiTap,
    this.onChatTap,
  });

  @override
  State<SearchResultsListView> createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  final Set<String> _expandedUserIds = {};

  void _toggleExpanded(String userId) {
    setState(() {
      if (_expandedUserIds.contains(userId)) {
        _expandedUserIds.remove(userId);
      } else {
        _expandedUserIds.add(userId);
      }
    });
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
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${sortedPois.length} ${sortedPois.length == 1 ? 'result' : 'results'} found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                  tooltip: l10n.close,
                ),
              ],
            ),
          ),
          // List of results
          Expanded(
            child: sortedPois.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedPois.length,
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final poi = sortedPois[index];
                      return _buildPoiListItem(context, poi);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoiListItem(BuildContext context, PointOfInterest poi) {
    final isExpanded = _expandedUserIds.contains(poi.profile.userId);
    
    return InkWell(
      onTap: () => widget.onPoiTap(poi),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name with avatar
            Row(
              children: [
                Expanded(
                  child: Text(
                    poi.profile.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Smaller Avatar with online badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FutureBuilder<String>(
                      future: _loadAndModifySvg(poi),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SvgPicture.string(
                            snapshot.data!,
                            width: 32,
                            height: 32,
                          );
                        }
                        return Container(
                          width: 32,
                          height: 32,
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
                      size: 10.0,
                      right: -5,
                      top: -5,
                      borderWidth: 2.0,
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Interests and Offerings separated
            if (poi.profile.attributes != null && poi.profile.attributes!.isNotEmpty) ...[
              _buildAttributesSection(context, poi, isExpanded),
            ],
            const SizedBox(height: 8),
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
          Icon(
            Icons.location_on,
            size: 16,
            color: Colors.blue[700],
          ),
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
          Icon(
            Icons.star,
            size: 16,
            color: Colors.amber[700],
          ),
          const SizedBox(width: 4),
          Text(
            'Match: ${(poi.matchRelevancyScore! * 100).toStringAsFixed(0)}%',
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
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => widget.onChatTap!(poi),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      ],
    );
  }

  Widget _buildAttributesSection(BuildContext context, PointOfInterest poi, bool isExpanded) {
    final l10n = AppLocalizations.of(context)!;
    
    // Separate interests (type != 1) and offerings (type == 1)
    final interests = poi.profile.attributes?.where((a) => a.type != 1).toList() ?? [];
    final offerings = poi.profile.attributes?.where((a) => a.type == 1).toList() ?? [];
    final postings = poi.profile.activePostingIds ?? [];
    
    // Check if there are more items to show
    final hasMoreItems = interests.length > 3 || offerings.length > 3 || postings.isNotEmpty;
    
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
            children: (isExpanded ? interests : interests.take(3)).map((attr) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getColorForAttribute(attr.uiStyleHint).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  TextUtils.getTranslatedOrNormalizedAttribute(
                      attr.attributeId, context),
                  style: TextStyle(
                    fontSize: 11,
                    color: _getColorForAttribute(attr.uiStyleHint),
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
            children: (isExpanded ? offerings : offerings.take(3)).map((attr) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getColorForAttribute(attr.uiStyleHint).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                    TextUtils.getTranslatedOrNormalizedAttribute(
                        attr.attributeId, context),
                  style: TextStyle(
                    fontSize: 11,
                    color: _getColorForAttribute(attr.uiStyleHint),
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                  '${postings.length} ${postings.length == 1 ? l10n.posting : l10n.postings}',
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
                    isExpanded ? 'Show less' : 'Show more',
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

  Future<String> _loadAndModifySvg(PointOfInterest poi) async {
    final userIdHashCode = poi.profile.userId.hashCode;
    final index = userIdHashCode.abs() % 25; // Assuming 25 avatars
    final selectedIconPath = 'assets/icons/path${index + 1}.svg';
    
    final attributes = poi.profile.attributes?.map((e) => e.uiStyleHint).whereType<String>().toList();
    
    return AvatarColorUtils.loadAndColorSvgFromAttributes(
      assetPath: selectedIconPath,
      attributes: attributes,
      relevancyScore: poi.matchRelevancyScore,
    );
  }

  Color _getColorForAttribute(String? uiStyleHint) {
    switch (uiStyleHint?.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.amber;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }
}
