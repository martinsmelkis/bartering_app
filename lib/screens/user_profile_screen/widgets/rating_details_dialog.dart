import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PublicReviewItem {
  const PublicReviewItem({
    this.text,
    this.rating,
    this.submittedAt,
  });

  final String? text;
  final double? rating;
  final DateTime? submittedAt;
}

class RatingDetailsDialog extends StatelessWidget {
  const RatingDetailsDialog({
    super.key,
    required this.reviewCount,
    required this.publicReviews,
    required this.onClose,
  });

  final int reviewCount;
  final List<PublicReviewItem> publicReviews;
  final VoidCallback onClose;

  String _formatReviewDate(BuildContext context, DateTime date) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(localeTag).format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.ratingAndReviews),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reviewsCount(reviewCount),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (publicReviews.isEmpty)
                Text(
                  l10n.reviewsCount(0),
                  style: TextStyle(color: Colors.grey[700]),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: publicReviews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final review = publicReviews[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (review.rating != null) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    review.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            if (review.submittedAt != null) ...[
                              Text(
                                _formatReviewDate(context, review.submittedAt!),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            if (review.text != null && review.text!.trim().isNotEmpty)
                              Text(
                                review.text!.trim(),
                                style: const TextStyle(fontSize: 13),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: onClose,
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
