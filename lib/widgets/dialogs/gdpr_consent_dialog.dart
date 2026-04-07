import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../services/settings_service.dart';

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
  const GdprConsentDialog({
    super.key,
    this.initialLocationConsent,
    this.initialAiProcessingConsent,
    this.initialAnalyticsCookiesConsent,
  });

  final bool? initialLocationConsent;
  final bool? initialAiProcessingConsent;
  final bool? initialAnalyticsCookiesConsent;

  @override
  State<GdprConsentDialog> createState() => _GdprConsentDialogState();
}

class _GdprConsentDialogState extends State<GdprConsentDialog> {
  final SettingsService _settingsService = getIt<SettingsService>();

  bool _locationConsent = true;
  bool _aiConsent = true;
  bool _analyticsCookiesConsent = true;
  bool _isLoadingPersistedConsents = true;

  @override
  void initState() {
    super.initState();
    _loadInitialConsentValues();
  }

  Future<void> _loadInitialConsentValues() async {
    final locationConsent =
        widget.initialLocationConsent ?? await _settingsService.getStoredLocationConsent();
    final aiConsent = widget.initialAiProcessingConsent
        ?? await _settingsService.getStoredAiProcessingConsent();
    final analyticsConsent = widget.initialAnalyticsCookiesConsent
        ?? await _settingsService.getStoredAnalyticsCookiesConsent();

    if (!mounted) return;

    setState(() {
      _locationConsent = locationConsent ?? true;
      _aiConsent = aiConsent ?? true;
      _analyticsCookiesConsent = analyticsConsent ?? true;
      _isLoadingPersistedConsents = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoadingPersistedConsents) {
      return const AlertDialog(
        content: SizedBox(
          width: 120,
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

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
            Navigator.of(context).pop();
          },
          child: Text(l10n.gdprConsentDecline),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(GdprConsentChoice(
              locationConsent: _locationConsent,
              aiProcessingConsent: _aiConsent,
              analyticsCookiesConsent: kIsWeb ? _analyticsCookiesConsent : true,
            ));
          },
          child: Text(l10n.gdprConsentAccept),
        ),
      ],
    );
  }
}
