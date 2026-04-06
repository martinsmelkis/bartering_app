import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PremiumUserBenefitsDialog extends StatelessWidget {
  final VoidCallback? onPurchasePremium;
  final VoidCallback? onRestorePurchases;
  final bool isLoading;

  const PremiumUserBenefitsDialog({
    super.key,
    this.onPurchasePremium,
    this.onRestorePurchases,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.premiumUserBenefitsTitle),
        content: Text(l10n.premiumUserBenefitsMessage),
        actions: [
          if (onRestorePurchases != null)
            TextButton(
              onPressed: isLoading ? null : onRestorePurchases,
              child: Text(l10n.restorePurchases),
            ),
          if (onPurchasePremium != null)
            FilledButton(
              onPressed: isLoading ? null : onPurchasePremium,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.buyPremium),
            ),
          TextButton(
            onPressed: () {
              if (kIsWeb) {
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
