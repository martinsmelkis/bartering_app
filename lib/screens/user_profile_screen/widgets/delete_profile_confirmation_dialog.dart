import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class DeleteProfileConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteProfileConfirmationDialog({
    super.key,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PointerInterceptor(
      child: AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Text(l10n.deleteProfileConfirmation),
        actions: [
          PointerInterceptor(
            child: TextButton(
              onPressed: () {
                if (kIsWeb) {
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          PointerInterceptor(
            child: TextButton(
              onPressed: () {
                if (kIsWeb) {
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  Navigator.of(context).pop();
                }
                onConfirmDelete();
              },
              child: Text(
                l10n.deleteProfile,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
