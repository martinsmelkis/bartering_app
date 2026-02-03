import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:share_plus/share_plus.dart';

/// Dialog that appears when user taps the "no users nearby" marker
/// Invites users to share the app with friends
class InviteFriendsDialog extends StatelessWidget {
  const InviteFriendsDialog({super.key});

  // Get app share link from environment variables
  static String get appShareLink => 
      dotenv.env['SERVICE_BASE_URL_WEB'] ?? 'https://barters.lv';

  void _shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shareMessage = l10n.inviteMessageShare(appShareLink);
    final subject = l10n.inviteMessageSubject;
    
    try {
      await SharePlus.instance.share(
        ShareParams(text: shareMessage, subject: subject)
      );
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.unableToShareAtThisTime),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyLink(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: appShareLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.linkCopiedToClipboard),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // On screens larger than mobile (>600px), limit width to 30% of screen
    // On mobile, use min 280px and max 90% of screen width
    final dialogWidth = context.isPhone
        ? min(screenWidth * 0.9, 500.0)  // Mobile: 90% max, cap at 500px
        : min(screenWidth * 0.3, 600.0);  // Large screens: 30% max, cap at 600px
    
    return PointerInterceptor(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: PointerInterceptor(
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              minWidth: 280,  // Minimum width for readability
              maxWidth: dialogWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              l10n.noUsersNearbyTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              l10n.noUsersNearbyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Share button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareApp(context),
                icon: const Icon(Icons.share),
                label: Text(l10n.shareApp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Copy link button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _copyLink(context),
                icon: const Icon(Icons.copy),
                label: Text(l10n.copyLink),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Close button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
