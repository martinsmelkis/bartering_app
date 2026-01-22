import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/notifications_screen/tabs/attribute_preferences_tab.dart';
import 'package:barter_app/screens/notifications_screen/tabs/contacts_tab.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/responsive_breakpoints.dart';

class NotificationsScreen extends StatelessWidget {
  final bool showAppBar; // Whether to show the app bar (false for panel mode)

  const NotificationsScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()
        ..loadContacts()
        ..loadAttributePreferences(),
      child: _NotificationsScreenView(showAppBar: showAppBar),
    );
  }
}

class _NotificationsScreenView extends StatelessWidget {
  final bool showAppBar;

  const _NotificationsScreenView({this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Check if we're in web panel mode
    final bool isWebPanel = kIsWeb && !showAppBar && context.canShowSideBySide;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: Text(l10n.notificationPreferences),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.label),
                      text: l10n.attributes,
                    ),
                    Tab(
                      icon: const Icon(Icons.contact_mail),
                      text: l10n.contacts,
                    ),
                  ],
                ),
              )
            : null,
        body: Column(
          children: [
            if (!showAppBar)
              Material(
                color: AppColors.primary,
                child: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.label),
                      text: l10n.attributes,
                    ),
                    Tab(
                      icon: const Icon(Icons.contact_mail),
                      text: l10n.contacts,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
            if (state.status == NotificationsStatus.loading &&
                state.contacts == null &&
                state.attributePreferences.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NotificationsStatus.error &&
                state.contacts == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text('${l10n.error}: ${state.errorMessage}'),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationsCubit>().loadContacts();
                        context
                            .read<NotificationsCubit>()
                            .loadAttributePreferences();
                      },
                      child: Text(l10n.continueButton),
                    ),
                  ],
                ),
              );
            }

                  return const TabBarView(
                    children: [
                      AttributePreferencesTab(),
                      ContactsTab(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
