import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';

import 'initialize_cubit.dart';

class InitializeScreen extends StatelessWidget {
  const InitializeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InitializeCubit(getIt<UserRepository>(),
              ApiClient.create())..startInitialization(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<InitializeCubit, InitializeState>(
      listener: (context, state) async {
        if (state is InitializeStateRegistered) {
          // Check if PIN is enabled in settings
          final settingsService = getIt<SettingsService>();
          final pinEnabled = await settingsService.isPinEnabled();

          if (pinEnabled) {
            // PIN is enabled - navigate to PIN verification screen
            print('@@@@@@@@@ PIN is enabled - navigating to PIN verification');
            if (context.mounted) {
              context.go('/verify-pin');
            }
          } else {
            // PIN not enabled - go directly to map
            print('@@@@@@@@@ PIN is disabled - navigating directly to map');
            if (context.mounted) {
              context.go('/map');
            }
          }
        } else if (state is InitializeStateUnregistered) {
          // Navigate to welcome screen first
          if (context.mounted) {
            context.go('/welcome');
          }
        } else if (state is InitializeError) {
          // Optionally show an error dialog or navigate to an error screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorWithMessage(state.errorMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<InitializeCubit, InitializeState>(
          builder: (context, state) {
            String message = l10n.loading;
            if (state is InitializeLoading) {
              message = state.message;
            } else if (state is InitializeError) {
              message = l10n.errorDuringInitialization;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // You can add your app logo here
                  Padding(
                   padding: const EdgeInsets.only(top: 50.0),
                   child: SvgPicture.asset('assets/icons/ic_launcher.svg', width: 50),
                 ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
