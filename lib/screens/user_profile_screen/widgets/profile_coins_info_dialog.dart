import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ProfileCoinsInfoDialog extends StatelessWidget {
  const ProfileCoinsInfoDialog({
    super.key,
    this.onPurchaseCoins,
  });

  final VoidCallback? onPurchaseCoins;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.barterCoinsTitle),
        content: Text(l10n.barterCoinsInfoMessage),
        actions: [
          TextButton(
            onPressed: () {
              if (kIsWeb) {
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: onPurchaseCoins ?? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.purchaseCoinsFlowComingSoon)),
              );
              if (kIsWeb) {
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.purchaseCoins),
          ),
        ],
      ),
    );
  }
}

