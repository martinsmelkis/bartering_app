import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/reviews/review_eligibility.dart';
import 'package:barter_app/models/reviews/review_submission.dart';
import 'package:barter_app/models/reviews/transaction_status.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final ReviewEligibilityResponse eligibility;

  const ReviewScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    required this.eligibility,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 0;
  TransactionStatus? selectedStatus;
  final TextEditingController reviewTextController = TextEditingController();
  bool isSubmitting = false;
  bool _guidelinesExpanded = false;

  bool get isFormValid => rating > 0 && selectedStatus != null;

  @override
  void dispose() {
    reviewTextController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!isFormValid) return;

    // Show scam warning if reporting scam
    if (selectedStatus == TransactionStatus.scam) {
      final confirmed = await _showScamWarningDialog();
      if (confirmed != true) return;
    }

    setState(() => isSubmitting = true);

    try {
      final userRepository = getIt<UserRepository>();
      final currentUserId = await userRepository.getUserId();

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final submission = SubmitReviewRequest(
        transactionId: widget.eligibility.transactionId!,
        reviewerId: currentUserId,
        targetUserId: widget.otherUserId,
        rating: rating,
        reviewText: reviewTextController.text.isEmpty ? null : reviewTextController.text,
        transactionStatus: selectedStatus!.value,
      );

      final apiClient = getIt<ApiClient>();
      final response = await apiClient.submitReview(submission);

      if (mounted) {
        if (response.success) {
          await _showSuccessDialog();
        } else {
          _showErrorDialog('Failed to submit review');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  Future<bool?> _showScamWarningDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Report Scam'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to report this user for scam?'),
            const SizedBox(height: 16),
            const Text(
              'This will:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Flag this transaction for moderator review'),
            const Text('• Potentially suspend the other user'),
            const Text('• Require evidence from you'),
            const SizedBox(height: 16),
            Text(
              'False reports may result in penalties to your account.',
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Review Submitted!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thank you for your feedback!'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility_off, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your review will be visible after ${widget.otherUserName} '
                      'submits their review, or in 14 days.',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Close review screen with success
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSkipConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Review?'),
        content: const Text(
          'You can review this user later from your transaction history. '
          'Reviews help build trust in the community.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Go Back'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Skip'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context, false); // Close review screen without submitting
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${widget.otherUserName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRatingSection(),
            SizedBox(height: 16.h),
            _buildStatusSection(),
            SizedBox(height: 16.h),
            _buildReviewTextSection(),
            SizedBox(height: 16.h),
            _buildGuidelinesSection(),
            SizedBox(height: 24.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating *',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => setState(() => rating = index + 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 48.sp,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            _getRatingDescription(rating),
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 5:
        return "Excellent";
      case 4:
        return "Good";
      case 3:
        return "Okay";
      case 2:
        return "Poor";
      case 1:
        return "Very Bad";
      default:
        return "Tap to rate";
    }
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How did it go? *',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        //SizedBox(height: 4.h),
        ...TransactionStatus.values.map((status) {
          return RadioListTile<TransactionStatus>(
            value: status,
            groupValue: selectedStatus,
            onChanged: (value) => setState(() => selectedStatus = value),
            title: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(_getStatusLabel(status)),
              ],
            ),
          );
        }),
      ],
    );
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.done:
        return Icons.check_circle;
      case TransactionStatus.cancelled:
        return Icons.cancel;
      case TransactionStatus.noDeal:
        return Icons.handshake_outlined;
      case TransactionStatus.scam:
        return Icons.report;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.done:
        return Colors.green;
      case TransactionStatus.scam:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.done:
        return "Successful Trade";
      case TransactionStatus.cancelled:
        return "Cancelled";
      case TransactionStatus.noDeal:
        return "Talked but no deal";
      case TransactionStatus.scam:
        return "🚩 Report Scam";
    }
  }

  Widget _buildReviewTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us more (optional)',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: reviewTextController,
          maxLength: 500,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Share your experience...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            helperText: 'Be specific and constructive',
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelinesSection() {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('Review Guidelines'),
        initiallyExpanded: _guidelinesExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _guidelinesExpanded = expanded);
        },
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideline('Be honest and fair'),
                _buildGuideline('Focus on your actual experience'),
                _buildGuideline('Reviews become visible after both parties submit'),
                _buildGuideline('You have 90 days to submit a review'),
                _buildGuideline('False reports may result in account suspension'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 16.sp, color: Colors.green),
          SizedBox(width: 8.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isFormValid && !isSubmitting ? _submitReview : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 42.h),
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: Colors.grey,
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Submit Review', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 8.h),
        TextButton(
          onPressed: isSubmitting ? null : _showSkipConfirmationDialog,
          child: const Text('Skip for Now'),
        ),
      ],
    );
  }
}
