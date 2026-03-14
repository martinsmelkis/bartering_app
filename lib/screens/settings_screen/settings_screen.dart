import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../application.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/profile/user_profile_data.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../services/settings_service.dart';
import '../../services/secure_storage_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/debug_utils.dart';
import '../../utils/responsive_breakpoints.dart';
import '../pin_input_screen/setup_pin_from_settings_screen.dart';
import '../security_question_screen/setup_security_question_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool showAppBar; // Whether to show the app bar (false for panel mode)

  const SettingsScreen({super.key, this.showAppBar = true});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = getIt<SettingsService>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final ApiClient _apiClient = getIt<ApiClient>();
  bool _useMapCenterForSearch = false;
  double _nearbyUsersRadius = SettingsService.defaultNearbyUsersRadius;
  double _keywordSearchRadius = SettingsService.defaultKeywordSearchRadius;
  double _keywordSearchWeight = SettingsService.defaultKeywordSearchWeight.toDouble();
  bool _showSearchResultsAsList = false;
  bool _pinEnabled = false;
  bool _hasSecurityQuestion = false;
  bool _isLoading = true;
  String _selectedLanguage = 'en';
  bool _enableGpsLocation = false;

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
    final showResultsAsList = await _settingsService.getShowSearchResultsAsList();
    final pinEnabled = await _settingsService.isPinEnabled();
    final hasSecurityQuestion = await SecureStorageService().hasSecurityQuestion();
    final language = await _settingsService.getPreferredLanguage();
    final gpsLocationEnabled = await _settingsService.isGpsLocationEnabled();
    
    setState(() {
      _useMapCenterForSearch = useMapCenter;
      _nearbyUsersRadius = nearbyRadius;
      _keywordSearchRadius = keywordRadius;
      _keywordSearchWeight = keywordWeight.toDouble();
      _showSearchResultsAsList = showResultsAsList;
      _pinEnabled = pinEnabled;
      _hasSecurityQuestion = hasSecurityQuestion;
      _selectedLanguage = language ?? 'en';
      _enableGpsLocation = gpsLocationEnabled;
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

  Future<void> _saveShowSearchResultsAsList(bool value) async {
    setState(() {
      _showSearchResultsAsList = value;
    });
    await _settingsService.setShowSearchResultsAsList(value);
    _showSettingsSaved();
  }

  Future<void> _saveEnableGpsLocation(bool value) async {
    // Skip permission requests on web - geolocation is handled by browser
    if (!kIsWeb && value) {
      // Requesting to enable GPS - ask for location permission
      final status = await Permission.location.request();
      
      if (status.isDenied || status.isPermanentlyDenied) {
        // Permission denied - show dialog explaining why we need it
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final bool openSettings = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.settingsGpsLocationTitle),
              content: Text(l10n.locationPermissionRequiredDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.openSettings),
                ),
              ],
            ),
          ) ?? false;
          
          if (openSettings) {
            await openAppSettings();
          }
        }
        // Don't enable the setting if permission was denied
        return;
      }
    }
    
    setState(() {
      _enableGpsLocation = value;
    });
    await _settingsService.setEnableGpsLocation(value);
    _showSettingsSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Check if we're in web panel mode
    final bool isWebPanel = kIsWeb && !widget.showAppBar && context.canShowSideBySide;
    final double sidePadding = isWebPanel ? 12.0 : 16.0;
    final double verticalPadding = isWebPanel ? 8.0 : 16.0;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(l10n.settingsTitle),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :
        ListView(
          padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: verticalPadding),
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
            const SizedBox(height: 16),

            // Display Search Results As List
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
                                l10n.settingsShowResultsAsListTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _showSearchResultsAsList
                                    ? l10n.settingsShowResultsAsListViewDescription
                                    : l10n.settingsShowResultsOnMapDescription,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _showSearchResultsAsList,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            _saveShowSearchResultsAsList(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.settingsShowResultsAsListDescription,
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

            // GPS Location Setting
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
                                l10n.settingsGpsLocationTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                              _enableGpsLocation
                                  ? l10n.settingsGpsLocationEnabledDescription
                                  : l10n.settingsGpsLocationDisabledDescription,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _enableGpsLocation,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            _saveEnableGpsLocation(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.settingsGpsLocationDescription,
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

            // Language Settings Section
            _buildSectionHeader(l10n.settingsLanguageSection),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsLanguageTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsLanguageDescription,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(l10n.languageEnglish),
                        ),
                        DropdownMenuItem(
                          value: 'lv',
                          child: Text(l10n.languageLatvian),
                        ),
                        DropdownMenuItem(
                          value: 'fr',
                          child: Text(l10n.languageFrench),
                        ),
                        DropdownMenuItem(
                          value: 'de',
                          child: Text(l10n.languageGerman),
                        ),
                        DropdownMenuItem(
                          value: 'es',
                          child: Text(l10n.languageSpanish),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          // Save to local settings
                          await _settingsService.setPreferredLanguage(value);

                          // Update user profile via API
                          await _updateUserProfileLanguage(value);

                          // Update the app's locale immediately
                          localeNotifier.value = Locale(value);

                          _showSettingsSaved();

                          setState(() {
                            _selectedLanguage = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
    );
  }

  Future<void> _updateUserProfileLanguage(String languageCode) async {
    try {
      // Get current user data
      final userId = await _userRepository.getUserId();
      final userName = await _userRepository.getUserName();

      if (userId == null || userName == null) {
        logDebug('Cannot update profile: userId or userName is null');
        return;
      }
      
      // Create updated profile with new language
      final updatedProfile = UserProfileData(
        userId: userId,
        name: userName,
        latitude: _userRepository.latitude,
        longitude: _userRepository.longitude,
        attributes: List.empty(growable: false),
        profileKeywordDataMap: await _userRepository.getProfileKeywordDataMap(),
        activePostingIds: [],
        preferredLanguage: languageCode,
      );
      
      // Send to API
      await _apiClient.updateProfileInfo(updatedProfile);
      logDebug('Profile language updated successfully to: $languageCode');
    } catch (e) {
      logDebugError('Error updating profile language', e);
      // Don't show error to user since local setting is still saved
    }
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
