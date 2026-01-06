import 'package:flutter/material.dart';

import '../models/risk_analysis_model.dart';

class RiskWarningDialog extends StatelessWidget {
  final RiskAnalysisReport riskReport;

  const RiskWarningDialog({
    Key? key,
    required this.riskReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getIconForRiskLevel(riskReport.riskLevel),
            color: _getColorForRiskLevel(riskReport.riskLevel),
          ),
          const SizedBox(width: 8),
          Text(_getTitleForRiskLevel(riskReport.riskLevel)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getMessageForRiskLevel(riskReport.riskLevel),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (riskReport.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Recommendations:',
                style: TextStyle(fontWeight: FontWeight.bold),
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
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This transaction will be reviewed by our security team.',
                        style: TextStyle(fontSize: 12),
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
            child: const Text('Continue Anyway'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(riskReport.isCritical ? 'OK' : 'Cancel'),
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

  String _getTitleForRiskLevel(String level) {
    switch (level) {
      case 'CRITICAL':
        return 'Transaction Blocked';
      case 'HIGH':
        return 'Security Warning';
      case 'MEDIUM':
        return 'Security Notice';
      default:
        return 'Security Check';
    }
  }

  String _getMessageForRiskLevel(String level) {
    switch (level) {
      case 'CRITICAL':
        return 'This transaction has been blocked due to suspicious activity patterns. '
            'Please contact support if you believe this is an error.';
      case 'HIGH':
        return 'Unusual activity has been detected. Additional verification may be required.';
      case 'MEDIUM':
        return 'We\'ve detected some unusual patterns. Your review may be subject to additional verification.';
      default:
        return 'Everything looks good!';
    }
  }
}