import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/notifications_screen/tabs/match_history_tab.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';

class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()..loadMatchHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.matches),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const MatchHistoryTab(),
      ),
    );
  }
}
