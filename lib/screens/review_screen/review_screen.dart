import 'package:barter_app/models/reviews/review_eligibility.dart';
import 'package:barter_app/models/reviews/transaction_status.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../l10n/app_localizations.dart';
import 'cubit/review_cubit.dart';
import 'models/risk_analysis_model.dart';
import 'widgets/risk_warning_dialog.dart';

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
  final TextEditingController reviewTextController = TextEditingController();
  bool _guidelinesExpanded = false;
  late ReviewCubit _reviewCubit;

  @override
  void initState() {
    super.initState();
    _reviewCubit = ReviewCubit(
      otherUserId: widget.otherUserId,
      eligibility: widget.eligibility,
    );
  }

  @override
  void dispose() {
    reviewTextController.dispose();
    _reviewCubit.close();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_reviewCubit.isFormValid) return;

    final l10n = AppLocalizations.of(context)!;

    // Update cubit with current form data
    _reviewCubit.updateReviewText(reviewTextController.text);

    // Submit review through cubit
    await _reviewCubit.submitReview(
      defaultErrorMessage: l10n.failedToSubmitReview,
    );
  }

  Future<bool?> _showScamWarningDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    return showDialog<bool>(
      context: context,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.red),
              const SizedBox(width: 8),
              Text(l10n.reportScam),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.reportScamConfirmation),
              const SizedBox(height: 16),
              Text(
                l10n.reportScamConsequencesTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(l10n.reportScamConsequence1),
              Text(l10n.reportScamConsequence2),
              Text(l10n.reportScamConsequence3),
              const SizedBox(height: 16),
              Text(
                l10n.falseReportsWarning,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.report),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showRiskWarningDialog(RiskAnalysisReport riskReport) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !riskReport.isCritical, // Can't dismiss critical warnings
      builder: (context) => PointerInterceptor(
        child: RiskWarningDialog(riskReport: riskReport),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text(l10n.reviewSubmitted),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.thankYouForFeedback),
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
                      l10n.reviewVisibilityNotice(widget.otherUserName),
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
            child: Text(l10n.done),
          ),
        ],
        ),
      ),
    );
  }

  void _showErrorDialog(String error) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: Text(l10n.error),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSkipConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: Text(l10n.skipReviewTitle),
          content: Text(l10n.skipReviewMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.goBack),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.skip),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context, false); // Close review screen without submitting
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _reviewCubit,
      child: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) async {
          if (state is ReviewScamWarningRequired) {
            // Show scam warning dialog
            final confirmed = await _showScamWarningDialog();
            if (confirmed == true) {
              // Continue with submission after confirmation
              _reviewCubit.submitReviewAfterScamConfirmation(
                defaultErrorMessage: l10n.failedToSubmitReview,
              );
            }
          } else if (state is ReviewRiskAnalysisDetected) {
            // Show risk warning dialog
            final shouldProceed = await _showRiskWarningDialog(state.riskReport);
            if (shouldProceed == true || state.riskReport.isCritical) {
              // For critical risks, user can only acknowledge (no choice to continue)
              // For other risks, user chose to continue or just acknowledged
              _reviewCubit.acknowledgeRiskAndProceed();
            } else {
              // User cancelled after seeing risk
              _reviewCubit.cancelAfterRisk();
            }
          } else if (state is ReviewSubmitSuccess) {
            // Show success dialog
            await _showSuccessDialog();
          } else if (state is ReviewSubmitError) {
            // Show error dialog
            _showErrorDialog(state.errorMessage);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.reviewUser(widget.otherUserName)),
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
                SizedBox(height: 16),
                _buildStatusSection(),
                SizedBox(height: 16),
                _buildReviewTextSection(),
                SizedBox(height: 16),
                _buildGuidelinesSection(),
                SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ratingRequired,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _reviewCubit.updateRating(index + 1);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      index < _reviewCubit.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 48,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                _getRatingDescription(_reviewCubit.rating),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getRatingDescription(int rating) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (rating) {
      case 5:
        return l10n.ratingExcellent;
      case 4:
        return l10n.ratingGood;
      case 3:
        return l10n.ratingOkay;
      case 2:
        return l10n.ratingPoor;
      case 1:
        return l10n.ratingVeryBad;
      default:
        return l10n.tapToRate;
    }
  }

  Widget _buildStatusSection() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.howDidItGo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            //SizedBox(height: 4.h),
            ...TransactionStatus.values.map((status) {
              return RadioListTile<TransactionStatus>(
                value: status,
                groupValue: _reviewCubit.selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _reviewCubit.updateStatus(value);
                  });
                },
                title: Row(
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(_getStatusLabel(status)),
                  ],
                ),
              );
            }),
          ],
        );
      },
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
    final l10n = AppLocalizations.of(context)!;
    
    switch (status) {
      case TransactionStatus.done:
        return l10n.transactionStatusSuccessful;
      case TransactionStatus.cancelled:
        return l10n.transactionStatusCancelled;
      case TransactionStatus.noDeal:
        return l10n.transactionStatusNoDeal;
      case TransactionStatus.scam:
        return l10n.transactionStatusScam;
    }
  }

  Widget _buildReviewTextSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tellUsMore,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: reviewTextController,
          maxLength: 500,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: l10n.shareYourExperience,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            helperText: l10n.beSpecificAndConstructive,
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelinesSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.info_outline),
        title: Text(l10n.reviewGuidelines),
        initiallyExpanded: _guidelinesExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _guidelinesExpanded = expanded);
        },
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideline(l10n.guidelineHonest),
                _buildGuideline(l10n.guidelineFocusExperience),
                _buildGuideline(l10n.guidelineVisibility),
                _buildGuideline(l10n.guideline90Days),
                _buildGuideline(l10n.guidelineFalseReports),
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
          Icon(Icons.check, size: 16, color: Colors.green),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        final isSubmitting = state is ReviewSubmitting;
        
        return Column(
          children: [
            ElevatedButton(
              onPressed: _reviewCubit.isFormValid && !isSubmitting ? _submitReview : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 42),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(l10n.submitReview, style: const TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: isSubmitting ? null : _showSkipConfirmationDialog,
              child: Text(l10n.skipForNow),
            ),
          ],
        );
      },
    );
  }
}
