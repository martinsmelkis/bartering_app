import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class GdprConsentChoice {
  final bool locationConsent;
  final bool aiProcessingConsent;
  final bool? analyticsCookiesConsent;

  const GdprConsentChoice({
    required this.locationConsent,
    required this.aiProcessingConsent,
    this.analyticsCookiesConsent,
  });
}

class GdprConsentDialog extends StatefulWidget {
  const GdprConsentDialog({super.key});

  @override
  State<GdprConsentDialog> createState() => _GdprConsentDialogState();
}

class _GdprConsentDialogState extends State<GdprConsentDialog> {
  bool _locationConsent = false;
  bool _aiConsent = true;
  bool _analyticsCookiesConsent = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.gdprConsentTitle),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.gdprConsentIntro),
              const SizedBox(height: 12),
              Text(
                l10n.gdprConsentRequiredLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.gdprConsentRequiredDescription,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const Divider(height: 24),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _locationConsent,
                onChanged: (value) => setState(() => _locationConsent = value),
                title: Text(l10n.gdprConsentLocationLabel),
                subtitle: Text(l10n.gdprConsentLocationDescription),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _aiConsent,
                onChanged: (value) => setState(() => _aiConsent = value),
                title: Text(l10n.gdprConsentAiLabel),
                subtitle: Text(l10n.gdprConsentAiDescription),
              ),
              if (kIsWeb) ...[
                const Divider(height: 24),
                Text(
                  l10n.gdprCookiesSectionTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.gdprCookiesRequiredLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.gdprCookiesRequiredDescription,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _analyticsCookiesConsent,
                  onChanged: (value) =>
                      setState(() => _analyticsCookiesConsent = value),
                  title: Text(l10n.gdprCookiesAnalyticsLabel),
                  subtitle: Text(l10n.gdprCookiesAnalyticsDescription),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.gdprConsentManageLater,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(const GdprConsentChoice(
              locationConsent: false,
              aiProcessingConsent: false,
              analyticsCookiesConsent: false,
            ));
          },
          child: Text(l10n.gdprConsentDecline),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(GdprConsentChoice(
              locationConsent: _locationConsent,
              aiProcessingConsent: _aiConsent,
              analyticsCookiesConsent: kIsWeb ? _analyticsCookiesConsent : null,
            ));
          },
          child: Text(l10n.gdprConsentAccept),
        ),
      ],
    );
  }
}
