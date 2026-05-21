import 'package:barter_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PurchaseCoinsOptionsDialog extends StatefulWidget {
  const PurchaseCoinsOptionsDialog({
    super.key,
    this.options = const [20, 50, 200],
  });

  final List<int> options;

  @override
  State<PurchaseCoinsOptionsDialog> createState() => _PurchaseCoinsOptionsDialogState();
}

class _PurchaseCoinsOptionsDialogState extends State<PurchaseCoinsOptionsDialog> {
  int? _selectedAmount;

  @override
  void initState() {
    super.initState();
    if (widget.options.isNotEmpty) {
      _selectedAmount = widget.options.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.purchaseCoins),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.selectCoinPackage),
            const SizedBox(height: 12),
            ...widget.options.map(
              (amount) => RadioListTile<int>(
                value: amount,
                groupValue: _selectedAmount,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('$amount'),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedAmount = value;
                  });
                },
              ),
            ),
          ],
        ),
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
            onPressed: _selectedAmount == null
                ? null
                : () => Navigator.of(context).pop(_selectedAmount),
            child: Text(l10n.purchaseCoins),
          ),
        ],
      ),
    );
  }
}
