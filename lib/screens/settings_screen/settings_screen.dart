import 'package:flutter/material.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../services/settings_service.dart';
import '../../services/secure_storage_service.dart';
import '../../theme/app_colors.dart';
import '../pin_input_screen/setup_pin_from_settings_screen.dart';
import '../security_question_screen/setup_security_question_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = getIt<SettingsService>();
  bool _useMapCenterForSearch = false;
  double _nearbyUsersRadius = SettingsService.defaultNearbyUsersRadius;
  double _keywordSearchRadius = SettingsService.defaultKeywordSearchRadius;
  double _keywordSearchWeight = SettingsService.defaultKeywordSearchWeight.toDouble();
  bool _pinEnabled = false;
  bool _hasSecurityQuestion = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final useMapCenter = await _settingsService.getUseMapCenterForSearch();
    final nearbyRadius = await _settingsService.getNearbyUsersRadius();
    final keywordRadius = await _settingsService.getKeywordSearchRadius();
    final keywordWeight = await _settingsService.getKeywordSearchWeight();
    final pinEnabled = await _settingsService.isPinEnabled();
    final hasSecurityQuestion = await SecureStorageService().hasSecurityQuestion();
    
    setState(() {
      _useMapCenterForSearch = useMapCenter;
      _nearbyUsersRadius = nearbyRadius;
      _keywordSearchRadius = keywordRadius;
      _keywordSearchWeight = keywordWeight.toDouble();
      _pinEnabled = pinEnabled;
      _hasSecurityQuestion = hasSecurityQuestion;
      _isLoading = false;
    });
  }

  Future<void> _saveSearchCenterPoint(bool value) async {
    setState(() {
      _useMapCenterForSearch = value;
    });
    await _settingsService.setUseMapCenterForSearch(value);
    _showSettingsSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Search Settings Section
                _buildSectionHeader(l10n.settingsSearchSection),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.settingsSearchCenterPointTitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _useMapCenterForSearch
                                        ? l10n.settingsSearchCenterMapCenterDescription
                                        : l10n.settingsSearchCenterUserLocationDescription,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _useMapCenterForSearch,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                _saveSearchCenterPoint(value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.settingsSearchCenterPointDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Nearby Users Radius
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsNearbyUsersRadiusTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.settingsNearbyUsersRadiusDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _nearbyUsersRadius,
                                min: 5.0,
                                max: 200.0,
                                divisions: 39,
                                activeColor: AppColors.primary,
                                label: '${_nearbyUsersRadius.round()} km',
                                onChanged: (value) {
                                  setState(() {
                                    _nearbyUsersRadius = value;
                                  });
                                },
                                onChangeEnd: (value) async {
                                  await _settingsService.setNearbyUsersRadius(value);
                                  _showSettingsSaved();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 65,
                              child: Text(
                                '${_nearbyUsersRadius.round()} km',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Keyword Search Radius
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsKeywordSearchRadiusTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.settingsKeywordSearchRadiusDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _keywordSearchRadius,
                                min: 10.0,
                                max: 500.0,
                                divisions: 49,
                                activeColor: AppColors.primary,
                                label: '${_keywordSearchRadius.round()} km',
                                onChanged: (value) {
                                  setState(() {
                                    _keywordSearchRadius = value;
                                  });
                                },
                                onChangeEnd: (value) async {
                                  await _settingsService.setKeywordSearchRadius(value);
                                  _showSettingsSaved();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 65,
                              child: Text(
                                '${_keywordSearchRadius.round()} km',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Keyword Search Weight
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsKeywordSearchWeightTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.settingsKeywordSearchWeightDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _keywordSearchWeight,
                                min: 10.0,
                                max: 100.0,
                                divisions: 90,
                                activeColor: AppColors.primary,
                                label: '${_keywordSearchWeight.round()}',
                                onChanged: (value) {
                                  setState(() {
                                    _keywordSearchWeight = value;
                                  });
                                },
                                onChangeEnd: (value) async {
                                  await _settingsService.setKeywordSearchWeight(value.round());
                                  _showSettingsSaved();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 45,
                              child: Text(
                                '${_keywordSearchWeight.round()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Security Settings Section
                _buildSectionHeader(l10n.settingsSecuritySection),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      // PIN Enable/Disable Switch
                      SwitchListTile(
                        title: Text(l10n.settingsPinTitle),
                        subtitle: Text(
                          _pinEnabled 
                              ? l10n.settingsPinEnabledDescription 
                              : l10n.settingsPinDisabledDescription,
                        ),
                        value: _pinEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (value) async {
                          if (value) {
                            // Enable PIN - show setup screen
                            final result = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => SetupPinFromSettingsScreen(
                                  onPinSet: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ),
                            );
                            
                            if (result == true) {
                              setState(() {
                                _pinEnabled = true;
                              });
                            }
                          } else {
                            // Disable PIN
                            setState(() {
                              _pinEnabled = false;
                            });
                            await _settingsService.setPinEnabled(false);
                            _showSettingsSaved();
                          }
                        },
                      ),
                      
                      // Change PIN Button (only visible if PIN is enabled)
                      if (_pinEnabled) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: Text(l10n.settingsChangePinButton),
                          subtitle: Text(l10n.settingsChangePinDescription),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SetupPinFromSettingsScreen(
                                  onPinSet: () {
                                    Navigator.of(context).pop();
                                    _showSettingsSaved();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      
                      // Security Question Management
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: Text(l10n.manageSecurityQuestion),
                        subtitle: Text(
                          _hasSecurityQuestion 
                              ? l10n.securityQuestionSet
                              : l10n.noSecurityQuestion,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SetupSecurityQuestionScreen(
                                onSetupComplete: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _hasSecurityQuestion = true;
                                  });
                                  _showSettingsSaved();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  void _showSettingsSaved() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.settingsSaved),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
