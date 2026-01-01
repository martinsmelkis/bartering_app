import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../../../configure_dependencies.dart';

class AttributePreferencesTab extends StatelessWidget {
  const AttributePreferencesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        //if (state.attributePreferences.isEmpty) {
          return _AttributeSetupView();
        //}

        /*return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationsCubit>().loadAttributePreferences(),
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  bottom: 80.h, // Extra padding for FAB
                ),
                itemCount: state.attributePreferences.length,
                itemBuilder: (context, index) {
                  final pref = state.attributePreferences[index];
                  return _AttributePreferenceCard(preference: pref);
                },
              ),
            ),
            // Floating Action Button to add more attributes
            Positioned(
              right: 16.w,
              bottom: 16.h,
              child: FloatingActionButton.extended(
                onPressed: () => _showAddAttributesDialog(context, state),
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.add),
                label: Text(l10n.addAttributes),
              ),
            ),
          ],
        );*/
      },
    );
  }

  void _showAddAttributesDialog(BuildContext context, NotificationsState state) {

  }
}

class _AttributePreferenceCard extends StatelessWidget {
  final AttributeNotificationPreference preference;

  const _AttributePreferenceCard({required this.preference});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    preference.attributeId,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: preference.notificationsEnabled,
                  onChanged: (value) =>
                      _toggleNotifications(context, preference, value),
                  activeColor: AppColors.primary,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deletePreference(context, preference);
                    } else if (value == 'edit') {
                      _showEditDialog(context, preference);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          SizedBox(width: 8.w),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildInfoRow(
              Icons.schedule,
              l10n.frequency,
              _getFrequencyLabel(l10n, preference.notificationFrequency),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              Icons.score,
              l10n.minMatchScore,
              '${(preference.minMatchScore * 100).toStringAsFixed(0)}%',
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: [
                if (preference.notifyOnNewPostings)
                  Chip(
                    label: Text(
                      l10n.newPostings,
                      style: TextStyle(fontSize: 11.sp),
                    ),
                    backgroundColor: Colors.blue.shade100,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (preference.notifyOnNewUsers)
                  Chip(
                    label: Text(
                      l10n.newUsers,
                      style: TextStyle(fontSize: 11.sp),
                    ),
                    backgroundColor: Colors.green.shade100,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey.shade600),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getFrequencyLabel(AppLocalizations l10n, NotificationFrequency freq) {
    switch (freq) {
      case NotificationFrequency.instant:
        return l10n.instant;
      case NotificationFrequency.daily:
        return l10n.daily;
      case NotificationFrequency.weekly:
        return l10n.weekly;
      case NotificationFrequency.manual:
        return l10n.manual;
    }
  }

  void _toggleNotifications(BuildContext context,
      AttributeNotificationPreference pref, bool enabled) async {
    try {
      await context.read<NotificationsCubit>().updateAttributePreference(
        pref.attributeId,
        UpdateAttributeNotificationPreferenceRequest(
          notificationsEnabled: enabled,
        ),
      );
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

  void _deletePreference(
      BuildContext context, AttributeNotificationPreference pref) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePreference),
        content: Text(l10n.deletePreferenceConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final message = await context
            .read<NotificationsCubit>()
            .deleteAttributePreference(pref.attributeId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message ?? l10n.preferenceDeleted),
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

  void _showEditDialog(
      BuildContext context, AttributeNotificationPreference pref) {
    final l10n = AppLocalizations.of(context)!;

    NotificationFrequency selectedFrequency = pref.notificationFrequency;
    double minMatchScore = pref.minMatchScore;
    bool notifyOnPostings = pref.notifyOnNewPostings;
    bool notifyOnUsers = pref.notifyOnNewUsers;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editPreference),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<NotificationFrequency>(
                  value: selectedFrequency,
                  decoration: InputDecoration(
                    labelText: l10n.frequency,
                    border: const OutlineInputBorder(),
                  ),
                  items: NotificationFrequency.values.map((freq) {
                    return DropdownMenuItem(
                      value: freq,
                      child: Text(_getFrequencyLabel(l10n, freq)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedFrequency = value);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                Text('${l10n.minMatchScore}: ${(minMatchScore * 100).toStringAsFixed(0)}%'),
                Slider(
                  value: minMatchScore,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(minMatchScore * 100).toStringAsFixed(0)}%',
                  onChanged: (value) {
                    setState(() => minMatchScore = value);
                  },
                ),
                CheckboxListTile(
                  title: Text(l10n.notifyOnNewPostings),
                  value: notifyOnPostings,
                  onChanged: (value) {
                    setState(() => notifyOnPostings = value ?? true);
                  },
                ),
                CheckboxListTile(
                  title: Text(l10n.notifyOnNewUsers),
                  value: notifyOnUsers,
                  onChanged: (value) {
                    setState(() => notifyOnUsers = value ?? false);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await context
                      .read<NotificationsCubit>()
                      .updateAttributePreference(
                    pref.attributeId,
                    UpdateAttributeNotificationPreferenceRequest(
                      notificationFrequency: selectedFrequency,
                      minMatchScore: minMatchScore,
                      notifyOnNewPostings: notifyOnPostings,
                      notifyOnNewUsers: notifyOnUsers,
                    ),
                  );
                  if (context.mounted) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.preferenceUpdated),
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
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget shown when no attribute preferences exist
class _AttributeSetupView extends StatefulWidget {
  @override
  State<_AttributeSetupView> createState() => _AttributeSetupViewState();
}

class _AttributeSetupViewState extends State<_AttributeSetupView> {
  List<ParsedAttributeData> _interests = [];
  List<ParsedAttributeData> _offerings = [];
  bool _loading = true;
  String? _error;
  final Set<String> _selectedAttributes = {};
  NotificationFrequency _frequency = NotificationFrequency.instant;
  double _minMatchScore = 0.5;
  bool _notifyOnPostings = true;
  bool _notifyOnUsers = false;

  @override
  void initState() {
    super.initState();
    _loadUserAttributes();
  }

  Future<void> _loadUserAttributes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userRepository = getIt<UserRepository>();

      // Load both interests and offerings
      final interests = await userRepository.getInterests(loadFromStorage: true);
      final offerings = await userRepository.getOfferings(loadFromStorage: true);

      setState(() {
        _interests = interests ?? [];
        _offerings = offerings ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Error: $_error'),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadUserAttributes,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    // Combine interests and offerings into a single list
    final allAttributes = [..._interests, ..._offerings];

    if (allAttributes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.noAttributePreferences,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                l10n.noAttributesInProfile,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header with instructions
              Container(
                padding: EdgeInsets.all(16.w),
                color: AppColors.primary.withValues(alpha: 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.primary),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            l10n.setupAttributeNotifications,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.setupAttributeNotificationsHint,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              // Global settings
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.defaultSettings,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<NotificationFrequency>(
                          value: _frequency,
                          decoration: InputDecoration(
                            labelText: l10n.frequency,
                            border: const OutlineInputBorder(),
                          ),
                          items: NotificationFrequency.values.map((freq) {
                            return DropdownMenuItem(
                              value: freq,
                              child: Text(_getFrequencyLabel(l10n, freq)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _frequency = value);
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          '${l10n.minMatchScore}: ${(_minMatchScore * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Slider(
                          value: _minMatchScore,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_minMatchScore * 100).toStringAsFixed(0)}%',
                          onChanged: (value) {
                            setState(() => _minMatchScore = value);
                          },
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.notifyOnNewPostings),
                          value: _notifyOnPostings,
                          onChanged: (value) {
                            setState(() => _notifyOnPostings = value ?? true);
                          },
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.notifyOnNewUsers),
                          value: _notifyOnUsers,
                          onChanged: (value) {
                            setState(() => _notifyOnUsers = value ?? false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Attribute selection section header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  l10n.selectAttributes,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Attribute selection list
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: allAttributes.map((attr) {
                    final isSelected = _selectedAttributes.contains(attr.attribute);
                    final isOffering = _offerings.contains(attr);

                    return Card(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: CheckboxListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                attr.attribute,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            // Badge to indicate type
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: isOffering
                                    ? Colors.green.shade100
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                isOffering ? l10n.offering : l10n.interest,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: isOffering
                                      ? Colors.green.shade800
                                      : Colors.blue.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${l10n.category}: ${attr.uiStyleHint} • ${l10n.relevancy}: ${(attr.relevancyScore * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedAttributes.add(attr.attribute);
                            } else {
                              _selectedAttributes.remove(attr.attribute);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Add bottom padding for the fixed action bar
              SizedBox(height: 80.h),
            ],
          ),
        ),

        // Bottom action bar (fixed at bottom)
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_selectedAttributes.length} ${l10n.attributesSelected}',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _selectedAttributes.isEmpty
                    ? null
                    : () => _createBatchPreferences(context),
                icon: const Icon(Icons.check),
                label: Text(l10n.createPreferences),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFrequencyLabel(AppLocalizations l10n, NotificationFrequency freq) {
    switch (freq) {
      case NotificationFrequency.instant:
        return l10n.instant;
      case NotificationFrequency.daily:
        return l10n.daily;
      case NotificationFrequency.weekly:
        return l10n.weekly;
      case NotificationFrequency.manual:
        return l10n.manual;
    }
  }

  Future<void> _createBatchPreferences(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final preferences = AttributeBatchPreferences(
        notificationsEnabled: true,
        notificationFrequency: _frequency,
        minMatchScore: _minMatchScore,
        notifyOnNewPostings: _notifyOnPostings,
        notifyOnNewUsers: _notifyOnUsers,
      );

      final request = AttributeBatchRequest(
        attributeIds: _selectedAttributes.toList(),
        preferences: preferences,
      );

      final message = await context
          .read<NotificationsCubit>()
          .batchCreateAttributePreferences(request);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? l10n.preferencesCreated),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
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
