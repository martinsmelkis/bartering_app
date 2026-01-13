import 'package:flutter/material.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/models/relationships/report_models.dart';

/// Dialog for reporting a user with reason selection
class ReportUserDialog extends StatefulWidget {
  final String targetUserName;

  const ReportUserDialog({
    super.key,
    required this.targetUserName,
  });

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  ReportReason? _selectedReason;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use maximum recommended dialog width (560dp) or 90% of screen width, whichever is smaller
    final dialogWidth = (screenWidth * 0.9).clamp(280.0, 560.0);

    return AlertDialog(
      title: Text(l10n.reportUserTitle(widget.targetUserName)),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.whyReportingUser),
              const SizedBox(height: 16),
              ...ReportReason.values.map((reason) => RadioListTile<ReportReason>(
                    title: Text(_getReasonDisplayName(reason, l10n)),
                    value: reason,
                    groupValue: _selectedReason,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() => _selectedReason = value);
                    },
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.additionalDetails,
                  border: const OutlineInputBorder(),
                  hintText: l10n.provideMoreContext,
                ),
                maxLines: 3,
                maxLength: 500,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _selectedReason == null ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.submitReport),
        ),
      ],
    );
  }

  String _getReasonDisplayName(ReportReason reason, AppLocalizations l10n) {
    switch (reason) {
      case ReportReason.spam:
        return l10n.reportReasonSpam;
      case ReportReason.harassment:
        return l10n.reportReasonHarassment;
      case ReportReason.inappropriateContent:
        return l10n.reportReasonInappropriateContent;
      case ReportReason.scam:
        return l10n.reportReasonScam;
      case ReportReason.fakeProfile:
        return l10n.reportReasonFakeProfile;
      case ReportReason.impersonation:
        return l10n.reportReasonImpersonation;
      case ReportReason.threateningBehavior:
        return l10n.reportReasonThreateningBehavior;
      case ReportReason.other:
        return l10n.reportReasonOther;
    }
  }

  void _submitReport() {
    Navigator.pop(context, {
      'reason': _selectedReason,
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    });
  }
}
