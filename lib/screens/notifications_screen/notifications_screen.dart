import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/screens/notifications_screen/tabs/attribute_preferences_tab.dart';
import 'package:barter_app/screens/notifications_screen/tabs/contacts_tab.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  final bool showAppBar; // Whether to show the app bar (false for panel mode)
  final bool contactsOnly; // Whether to show only contacts content for direct flows
  final String? unsubscribeToken; // Optional deep-link token for public unsubscribe flow

  const NotificationsScreen({
    super.key,
    this.showAppBar = true,
    this.contactsOnly = false,
    this.unsubscribeToken,
  });

  @override
  Widget build(BuildContext context) {
    // Public deep-link flow: no auth/session required, no cubit needed
    if (unsubscribeToken != null && unsubscribeToken!.isNotEmpty) {
      return _EmailUnsubscribeScreen(
        token: unsubscribeToken!,
        showAppBar: showAppBar,
      );
    }

    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()
        ..loadContacts()
        ..loadAttributePreferences(),
      child: _NotificationsScreenView(
        showAppBar: showAppBar,
        contactsOnly: contactsOnly,
      ),
    );
  }
}

class _EmailUnsubscribeScreen extends StatefulWidget {
  final String token;
  final bool showAppBar;

  const _EmailUnsubscribeScreen({
    required this.token,
    this.showAppBar = true,
  });

  @override
  State<_EmailUnsubscribeScreen> createState() => _EmailUnsubscribeScreenState();
}

class _EmailUnsubscribeScreenState extends State<_EmailUnsubscribeScreen> {
  bool _isSubmitting = false;
  bool _isCompleted = false;
  String? _errorMessage;

  Future<void> _unsubscribe() async {
    if (_isSubmitting || _isCompleted) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await getIt<ApiClient>().unsubscribeFromEmails(widget.token);
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isCompleted = true;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      final backendMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString())
          : null;
      setState(() {
        _isSubmitting = false;
        _errorMessage = backendMessage ?? e.message ?? e.toString();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(l10n.emailNotificationPreferences),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.email_outlined, size: 56, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.emailNotificationPreferences,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.marketingConsentDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null) ...[
                  Text(
                    '${l10n.error}: $_errorMessage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: (_isSubmitting || _isCompleted) ? null : _unsubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isCompleted ? l10n.close : l10n.emailUnsubscribe),
                ),
                if (_isCompleted) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.emailUnsubscribed,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsScreenView extends StatelessWidget {
  final bool showAppBar;
  final bool contactsOnly;

  const _NotificationsScreenView({
    this.showAppBar = true,
    this.contactsOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (contactsOnly) {
      return Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: Text(l10n.contacts),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              )
            : null,
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading &&
                state.contacts == null) {
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
                      },
                      child: Text(l10n.continueButton),
                    ),
                  ],
                ),
              );
            }
            return const ContactsTab();
          },
        ),
      );
    }

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
