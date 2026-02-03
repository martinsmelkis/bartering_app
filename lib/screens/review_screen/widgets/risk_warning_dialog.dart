import 'package:flutter/material.dart';

import '../models/risk_analysis_model.dart';
import '../../../l10n/app_localizations.dart';

class RiskWarningDialog extends StatelessWidget {
  final RiskAnalysisReport riskReport;

  const RiskWarningDialog({
    Key? key,
    required this.riskReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getIconForRiskLevel(riskReport.riskLevel),
            color: _getColorForRiskLevel(riskReport.riskLevel),
          ),
          const SizedBox(width: 8),
          Text(_getTitleForRiskLevel(context, riskReport.riskLevel)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getMessageForRiskLevel(context, riskReport.riskLevel),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (riskReport.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.recommendations,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...riskReport.recommendations.map(
                    (rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                ),
              ),
            ],
            if (riskReport.requiresManualReview) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.transactionWillBeReviewed,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!riskReport.isCritical)
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueAnyway),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(riskReport.isCritical ? l10n.ok : l10n.cancel),
        ),
      ],
    );
  }

  IconData _getIconForRiskLevel(String level) {
    switch (level) {
      case 'CRITICAL':
        return Icons.block;
      case 'HIGH':
        return Icons.warning;
      case 'MEDIUM':
        return Icons.info;
      default:
        return Icons.check_circle;
    }
  }

  Color _getColorForRiskLevel(String level) {
    switch (level) {
      case 'CRITICAL':
        return Colors.red;
      case 'HIGH':
        return Colors.orange;
      case 'MEDIUM':
        return Colors.yellow.shade700;
      default:
        return Colors.green;
    }
  }

  String _getTitleForRiskLevel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'CRITICAL':
        return l10n.transactionBlocked;
      case 'HIGH':
        return l10n.securityWarning;
      case 'MEDIUM':
        return l10n.securityNotice;
      default:
        return l10n.securityCheck;
    }
  }

  String _getMessageForRiskLevel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'CRITICAL':
        return l10n.transactionBlockedMessage;
      case 'HIGH':
        return l10n.securityWarningMessage;
      case 'MEDIUM':
        return l10n.securityNoticeMessage;
      default:
        return l10n.securityCheckMessage;
    }
  }
}