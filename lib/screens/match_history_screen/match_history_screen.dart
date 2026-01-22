import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/notifications_screen/tabs/match_history_tab.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/responsive_breakpoints.dart';

class MatchHistoryScreen extends StatelessWidget {
  final bool showAppBar; // Whether to show the app bar (false for panel mode)

  const MatchHistoryScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Check if we're in web panel mode
    final bool isWebPanel = kIsWeb && !showAppBar && context.canShowSideBySide;

    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()..loadMatchHistory(),
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: Text(l10n.matches),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              )
            : null,
        body: const MatchHistoryTab(),
      ),
    );
  }
}
