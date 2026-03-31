import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Utility for handling Android back button on mobile web
/// 
/// Ensures back button behaves like the app bar back button by:
/// 1. Closing overlays (modals, dialogs, bottom sheets) first - automatic
/// 2. Closing custom panels/state before navigating
/// 3. Then allowing normal navigation
class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final Future<bool> Function()? onBackPressed;

  const BackButtonHandler({
    super.key,
    required this.child,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        // Check if custom handler prevents navigation
        if (onBackPressed != null) {
          final shouldPop = await onBackPressed!();
          if (!shouldPop) return;
        }

        // Check if drawer is open and close it
        final scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null && scaffoldState.isDrawerOpen) {
          context.pop();
          return;
        }

        // Allow normal back navigation
        if (context.canPop()) {
          context.pop();
          return;
        }

        // On native mobile, exit app when we're at the root route.
        if (!kIsWeb) {
          await SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
