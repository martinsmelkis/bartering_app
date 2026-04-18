import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/reviews/reputation_response.dart';

class BadgesInfoDialog extends StatelessWidget {
  final Set<String> earnedBadgeTypes;
  final VoidCallback onClose;

  const BadgesInfoDialog({
    super.key,
    required this.earnedBadgeTypes,
    required this.onClose,
  });

  String _localizedBadgeTitle(
    AppLocalizations l10n,
    ReputationBadge badge,
  ) {
    switch (badge) {
      case ReputationBadge.IDENTITY_VERIFIED:
        return l10n.badgeIdentityVerifiedTitle;
      case ReputationBadge.VETERAN_TRADER:
        return l10n.badgeVeteranTraderTitle;
      case ReputationBadge.TOP_RATED:
        return l10n.badgeTopRatedTitle;
      case ReputationBadge.PREMIUM_USER:
        return l10n.badgePremiumUserTitle;
      case ReputationBadge.TOP_1000:
        return l10n.badgeTop1000Title;
      case ReputationBadge.QUICK_RESPONDER:
        return l10n.badgeQuickResponderTitle;
      case ReputationBadge.COMMUNITY_CONNECTOR:
        return l10n.badgeCommunityConnectorTitle;
      case ReputationBadge.LOCAL_LEGEND:
        return l10n.badgeVerifiedBusinessTitle;
      case ReputationBadge.DISPUTE_FREE:
        return l10n.badgeDisputeFreeTitle;
      case ReputationBadge.FAST_TRADER:
        return l10n.badgeFastTraderTitle;
    }
  }

  String _localizedBadgeDescription(
    AppLocalizations l10n,
    ReputationBadge badge,
  ) {
    switch (badge) {
      case ReputationBadge.IDENTITY_VERIFIED:
        return l10n.badgeIdentityVerifiedDescription;
      case ReputationBadge.VETERAN_TRADER:
        return l10n.badgeVeteranTraderDescription;
      case ReputationBadge.TOP_RATED:
        return l10n.badgeTopRatedDescription;
      case ReputationBadge.PREMIUM_USER:
        return l10n.badgePremiumUserDescription;
      case ReputationBadge.TOP_1000:
        return l10n.badgeTop1000Description;
      case ReputationBadge.QUICK_RESPONDER:
        return l10n.badgeQuickResponderDescription;
      case ReputationBadge.COMMUNITY_CONNECTOR:
        return l10n.badgeCommunityConnectorDescription;
      case ReputationBadge.LOCAL_LEGEND:
        return l10n.badgeVerifiedBusinessDescription;
      case ReputationBadge.DISPUTE_FREE:
        return l10n.badgeDisputeFreeDescription;
      case ReputationBadge.FAST_TRADER:
        return l10n.badgeFastTraderDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allBadges = ReputationBadge.values;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.badgesTitle),
        content: SizedBox(
          width: 380,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: allBadges.length,
            separatorBuilder: (_, __) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final badge = allBadges[index];
              print('@@@@@@@@@ $badge ${badge.value} ${earnedBadgeTypes}');
              final isEarned = earnedBadgeTypes.contains(badge.value.toLowerCase());
              return Opacity(
                opacity: isEarned ? 1 : 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: isEarned ? Colors.amber : Colors.grey,
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
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _localizedBadgeTitle(l10n, badge),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _localizedBadgeDescription(l10n, badge),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          PointerInterceptor(
            child: TextButton(
              onPressed: onClose,
              child: Text(l10n.close),
            ),
          ),
        ],
      ),
    );
  }
}
