import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: l10n.privacyPolicyIntroTitle,
              content: l10n.privacyPolicyIntroContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataCollectionTitle,
              content: l10n.privacyPolicyDataCollectionContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataUsageTitle,
              content: l10n.privacyPolicyDataUsageContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataSharingTitle,
              content: l10n.privacyPolicyDataSharingContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyDataSecurityTitle,
              content: l10n.privacyPolicyDataSecurityContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyUserRightsTitle,
              content: l10n.privacyPolicyUserRightsContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyThirdPartyTitle,
              content: l10n.privacyPolicyThirdPartyContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.termsConditionsSectionMinimumAgeTitle,
              content: l10n.termsConditionsSectionMinimumAgeContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyChangesTitle,
              content: l10n.privacyPolicyChangesContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: l10n.privacyPolicyContactTitle,
              content: l10n.privacyPolicyContactContent,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                l10n.privacyPolicyLastUpdated,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
