import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsConditionsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              title: l10n.termsConditionsSectionScopeTitle,
              content: l10n.termsConditionsSectionScopeContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionMinimumAgeTitle,
              content: l10n.termsConditionsSectionMinimumAgeContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionAccountUseTitle,
              content: l10n.termsConditionsSectionAccountUseContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionProhibitedConductTitle,
              content: l10n.termsConditionsSectionProhibitedConductContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionAccountRestrictionTitle,
              content: l10n.termsConditionsSectionAccountRestrictionContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionLiabilityDisputesTitle,
              content: l10n.termsConditionsSectionLiabilityDisputesContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionKidsSafetyTitle,
              content: l10n.termsConditionsSectionKidsSafetyContent,
            ),
            const SizedBox(height: 20),
            _section(
              title: l10n.termsConditionsSectionChangesTitle,
              content: l10n.termsConditionsSectionChangesContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
