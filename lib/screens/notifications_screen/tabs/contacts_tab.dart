import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final contacts = state.contacts;

        // Show email input form if no contacts found (404 or empty response)
        if (contacts == null) {
          return _buildEmailInputForm(context, l10n);
        }

        return RefreshIndicator(
          onRefresh: () => context.read<NotificationsCubit>().loadContacts(),
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Global Notification Settings Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_active,
                              color: AppColors.primary),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.notificationSettings,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Notifications Enabled Toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.enableNotifications,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          l10n.enableNotificationsDescription,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        value: contacts.notificationsEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          context
                              .read<NotificationsCubit>()
                              .updateContacts(notificationsEnabled: value);
                        },
                      ),
                      SizedBox(height: 12.h),
                      Divider(),
                      SizedBox(height: 12.h),
                      // Quiet Hours Section
                      Text(
                        l10n.quietHours,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.quietHoursDescription,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.startTime,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                InkWell(
                                  onTap: () => _showQuietHoursStartPicker(context, contacts),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          contacts.quietHoursStart != null
                                              ? _formatHour(
                                                  contacts.quietHoursStart!)
                                              : l10n.notSet,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        Icon(Icons.access_time, size: 20.sp),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.endTime,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                InkWell(
                                  onTap: () => _showQuietHoursEndPicker(context, contacts),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          contacts.quietHoursEnd != null
                                              ? _formatHour(contacts.quietHoursEnd!)
                                              : l10n.notSet,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        Icon(Icons.access_time, size: 20.sp),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (contacts.quietHoursStart != null ||
                          contacts.quietHoursEnd != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: TextButton.icon(
                            onPressed: () {
                              context.read<NotificationsCubit>().updateContacts(
                                    quietHoursStart: -1, // -1 means clear
                                    quietHoursEnd: -1,
                                  );
                            },
                            icon: Icon(Icons.clear, size: 16.sp),
                            label: Text(l10n.clearQuietHours),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Email Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, color: AppColors.primary),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.emailAddress,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (contacts.email != null && contacts.email!.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contacts.email!,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            if (contacts.emailVerified)
                              Chip(
                                label: Text(
                                  l10n.verified,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              )
                            else
                              Chip(
                                label: Text(
                                  l10n.notVerified,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.orange,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                          ],
                        )
                      else
                        Text(
                          l10n.notSet,
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      SizedBox(height: 12.h),
                      ElevatedButton.icon(
                        onPressed: () => _showUpdateEmailDialog(context),
                        icon: const Icon(Icons.edit),
                        label: Text(l10n.updateEmail),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Push Tokens Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_active,
                              color: AppColors.primary),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.pushNotifications,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (contacts.pushTokens.isEmpty)
                        Text(
                          l10n.noPushTokens,
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.grey),
                        )
                      else
                        ...contacts.pushTokens.map((token) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              _getPlatformIcon(token.platform),
                              color: AppColors.primary,
                            ),
                            title: Text(
                              token.platform.toUpperCase(),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            subtitle: token.deviceId != null
                                ? Text(
                                    token.deviceId!,
                                    style: TextStyle(fontSize: 12.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _removePushToken(context, token.token),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatHour(int hour) {
    if (hour < 0 || hour > 23) return '00:00';
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:00 $period';
  }

  void _showQuietHoursStartPicker(
      BuildContext context, UserNotificationContacts contacts) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: contacts.quietHoursStart ?? 22,
        minute: 0,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<NotificationsCubit>().updateContacts(
            quietHoursStart: picked.hour,
          );
    }
  }

  void _showQuietHoursEndPicker(
      BuildContext context, UserNotificationContacts contacts) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: contacts.quietHoursEnd ?? 8,
        minute: 0,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<NotificationsCubit>().updateContacts(
            quietHoursEnd: picked.hour,
          );
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      case 'web':
        return Icons.web;
      default:
        return Icons.devices;
    }
  }

  void _showUpdateEmailDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.updateEmail),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.emailAddress,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              final email = controller.text.trim();
              if (email.isNotEmpty) {
                try {
                  final message = await context
                      .read<NotificationsCubit>()
                      .updateContacts(email: email);
                  if (context.mounted) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message ?? l10n.emailUpdated),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _removePushToken(BuildContext context, String token) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.removePushToken),
        content: Text(l10n.removePushTokenConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final message =
            await context.read<NotificationsCubit>().removePushToken(token);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message ?? l10n.pushTokenRemoved),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildEmailInputForm(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.email_outlined,
                size: 80.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 24.h),
              Text(
                l10n.setupEmailTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                l10n.setupEmailDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32.h),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailAddress,
                  hintText: l10n.emailHint,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.emailRequired;
                  }
                  
                  // Basic email validation
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  
                  if (!emailRegex.hasMatch(value.trim())) {
                    return l10n.emailInvalid;
                  }
                  
                  return null;
                },
                enabled: !_isSubmitting,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.saveEmail,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitEmail(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final email = _emailController.text.trim();
      final message = await context
          .read<NotificationsCubit>()
          .updateContacts(email: email);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? l10n.emailSaved),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Clear the form
        _emailController.clear();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
