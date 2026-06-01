import 'dart:convert';
import 'dart:math';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:share_plus/share_plus.dart';

/// Dialog that appears when user taps the "no users nearby" marker.
/// Invites users to share the app with friends and opt into nearby-user alerts.
class InviteFriendsDialog extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double radiusMeters;

  const InviteFriendsDialog({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  // Get app share link from environment variables
  static String get appShareLink =>
      dotenv.env['SERVICE_BASE_URL_WEB'] ?? 'https://bartering.app';

  @override
  State<InviteFriendsDialog> createState() => _InviteFriendsDialogState();
}

class _InviteFriendsDialogState extends State<InviteFriendsDialog> {
  static const int _nearbyUsersAlertThreshold = 5;

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  bool _notifyWhenUsersNearby = false;
  bool _isLoadingAlertState = true;
  bool _isLoadingContacts = true;
  bool _isSavingAlertState = false;
  bool _isSavingEmail = false;
  String? _notificationEmail;
  String? _dialogMessage;
  Color _dialogMessageColor = AppColors.primary;

  bool get _hasNotificationEmail =>
      _notificationEmail?.trim().isNotEmpty == true;

  bool get _shouldShowOptionalEmailTitlePrefix =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    _loadNearbyUsersAlertState();
    _loadNotificationContacts();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadNearbyUsersAlertState() async {
    try {
      final response = await getIt<ApiClient>().getNearbyUsersAlert();
      final data = response.data;
      final enabled = _extractEnabledState(
        data is Map<String, dynamic> ? data : const <String, dynamic>{},
      );

      if (!mounted) return;
      setState(() {
        _notifyWhenUsersNearby = enabled;
        _isLoadingAlertState = false;
      });
    } catch (e) {
      debugPrint('Unable to load nearby users alert state: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingAlertState = false;
      });
    }
  }

  Future<void> _loadNotificationContacts() async {
    try {
      final response = await getIt<ApiClient>().getNotificationContacts();
      final email = response.contacts.email?.trim();

      if (!mounted) return;
      setState(() {
        _notificationEmail = email?.isNotEmpty == true ? email : null;
        _emailController.text = _notificationEmail ?? '';
        _isLoadingContacts = false;
      });
    } catch (e) {
      debugPrint('Unable to load notification contacts: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingContacts = false;
      });
    }
  }

  bool _extractEnabledState(Map<String, dynamic> response) {
    final alert = response['alert'];
    final preference = response['preference'];

    final candidates = [
      response['enabled'],
      response['active'],
      if (alert is Map<String, dynamic>) alert['enabled'],
      if (alert is Map<String, dynamic>) alert['active'],
      if (preference is Map<String, dynamic>) preference['enabled'],
      if (preference is Map<String, dynamic>) preference['active'],
    ];

    for (final candidate in candidates) {
      if (candidate is bool) return candidate;
    }

    return false;
  }

  Future<void> _saveNotificationEmail() async {
    if (_isSavingEmail) return;
    if (_emailFormKey.currentState?.validate() != true) return;

    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    setState(() {
      _isSavingEmail = true;
    });

    try {
      final response = await getIt<ApiClient>().updateNotificationContacts(
        UpdateUserNotificationContactsRequest(email: email),
      );
      final savedEmail = response.contacts.email?.trim();

      if (!mounted) return;
      setState(() {
        _notificationEmail = savedEmail?.isNotEmpty == true
            ? savedEmail
            : email;
      });
      _showMessage(l10n.notificationEmailSaved);
    } catch (e) {
      debugPrint('Unable to save notification email: $e');
      if (!mounted) return;
      _showMessage(
        l10n.notificationEmailSaveError,
        backgroundColor: Colors.red,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSavingEmail = false;
      });
    }
  }

  void _openNotificationPreferences() {
    final router = GoRouter.of(context);
    router.push('/notifications/contacts');
  }

  void _showMessage(String message, {Color? backgroundColor}) {
    if (!mounted) return;

    final color = backgroundColor ?? AppColors.primary;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null && messenger.mounted) {
      try {
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      } catch (e) {
        debugPrint('Unable to show snackbar from invite dialog: $e');
      }
    }

    if (!mounted) return;
    setState(() {
      _dialogMessage = message;
      _dialogMessageColor = color;
    });
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final l10n = AppLocalizations.of(context)!;

    if (email.isEmpty) {
      return l10n.notificationEmailRequired;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return l10n.notificationEmailInvalid;
    }

    return null;
  }

  Future<void> _setNearbyUsersAlert(bool enabled) async {
    if (_isSavingAlertState) return;

    final l10n = AppLocalizations.of(context)!;

    if (enabled && !await _requestNotificationPermission()) {
      if (!mounted) return;
      _showMessage(l10n.nearbyUsersAlertSaveError, backgroundColor: Colors.red);
      return;
    }

    final previousValue = _notifyWhenUsersNearby;
    setState(() {
      _notifyWhenUsersNearby = enabled;
      _isSavingAlertState = true;
    });

    final apiClient = getIt<ApiClient>();

    try {
      await apiClient.createOrUpdateNearbyUsersAlert({
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'radiusMeters': widget.radiusMeters,
        'minUserCount': _nearbyUsersAlertThreshold,
        'enabled': enabled,
      });

      if (!mounted) return;
      _showMessage(
        enabled ? l10n.nearbyUsersAlertEnabled : l10n.nearbyUsersAlertDisabled,
      );
    } catch (e) {
      debugPrint('Unable to update nearby users alert: $e');
      if (!mounted) return;
      setState(() {
        _notifyWhenUsersNearby = previousValue;
      });
      _showMessage(l10n.nearbyUsersAlertSaveError, backgroundColor: Colors.red);
    } finally {
      if (!mounted) return;
      setState(() {
        _isSavingAlertState = false;
      });
    }
  }

  Future<bool> _requestNotificationPermission() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return true;
    }

    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!isAuthorized) return false;

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        final platform = defaultTargetPlatform == TargetPlatform.android
            ? 'ANDROID'
            : 'IOS';
        final userId = await getIt<UserRepository>().userId ?? '';
        await getIt<ApiClient>().addPushToken(
          AddPushTokenRequest(
            token: token,
            platform: platform,
            deviceId: '${userId}_$platform',
          ),
        );
      }

      return true;
    } catch (e) {
      debugPrint('Unable to request notification permission: $e');
      return false;
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shareMessage = l10n.inviteMessageShare(
      InviteFriendsDialog.appShareLink,
    );
    final subject = l10n.inviteMessageSubject;

    try {
      await SharePlus.instance.share(
        ShareParams(text: shareMessage, subject: subject),
      );

      final inviterUserId = await getIt<UserRepository>().getUserId();
      if (inviterUserId == null || inviterUserId.isEmpty) {
        return;
      }

      const campaign = 'INIT_PROMO';
      final inviterShortId = inviterUserId.length >= 6
          ? inviterUserId.substring(0, 6)
          : inviterUserId;

      final request = ClaimAwardRequest(
        userId: inviterUserId,
        awardType: 'referral_signup',
        externalRef: 'inviteCode:$campaign:inviter:$inviterShortId',
        metadataJson: jsonEncode({
          'campaign': campaign,
          'inviterUserId': inviterUserId,
          'source': 'mobile_referral',
        }),
      );

      await getIt<ApiClient>().claimWalletAward(request);
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        _showMessage(l10n.unableToShareAtThisTime, backgroundColor: Colors.red);
      }
    }
  }

  void _copyLink(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: InviteFriendsDialog.appShareLink));
    _showMessage(l10n.linkCopiedToClipboard);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    // On screens larger than mobile (>600px), limit width to 30% of screen.
    // On mobile, use min 280px and max 90% of screen width.
    final dialogWidth = context.isPhone
        ? min(screenWidth * 0.9, 500.0)
        : min(screenWidth * 0.3, 600.0);

    return PointerInterceptor(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: PointerInterceptor(
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              minWidth: 280,
              maxWidth: dialogWidth,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.people_outline,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.noUsersNearbyTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noUsersNearbyMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_dialogMessage != null) ...[
                      _buildDialogMessage(),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 16),
                    _buildNearbyUsersAlertCheckbox(l10n),
                    const SizedBox(height: 12),
                    _buildNotificationContactSection(l10n),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _shareApp(context),
                        icon: const Icon(Icons.share),
                        label: Text(l10n.shareApp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _copyLink(context),
                        icon: const Icon(Icons.copy),
                        label: Text(l10n.copyLink),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.close),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _dialogMessageColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dialogMessageColor.withValues(alpha: 0.35)),
      ),
      child: Text(
        _dialogMessage!,
        style: TextStyle(
          color: _dialogMessageColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNearbyUsersAlertCheckbox(AppLocalizations l10n) {
    final isDisabled = _isLoadingAlertState || _isSavingAlertState;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: CheckboxListTile(
        value: _notifyWhenUsersNearby,
        onChanged: isDisabled
            ? null
            : (value) => _setNearbyUsersAlert(value ?? false),
        activeColor: AppColors.primary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        title: Text(
          l10n.nearbyUsersAlertCheckboxTitle(_nearbyUsersAlertThreshold),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _isLoadingAlertState
              ? l10n.nearbyUsersAlertLoading
              : l10n.nearbyUsersAlertCheckboxSubtitle,
        ),
        secondary: _isSavingAlertState
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
    );
  }

  Widget _buildNotificationContactSection(AppLocalizations l10n) {
    if (_isLoadingContacts) {
      return const SizedBox(
        height: 28,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_hasNotificationEmail) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          leading: Icon(Icons.email_outlined, color: AppColors.primary),
          title: Text(l10n.notificationEmailConfigured(_notificationEmail!)),
          subtitle: Text(l10n.nearbyUsersAlertManageDelivery),
          trailing: TextButton(
            onPressed: _openNotificationPreferences,
            child: Text(l10n.notificationPreferences),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _emailFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _shouldShowOptionalEmailTitlePrefix
                    ? '(Optional) ${l10n.notificationEmailTitle}'
                    : l10n.notificationEmailTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              /*const SizedBox(height: 4),
              Text(
                l10n.notificationEmailSubtitle,
                style: TextStyle(color: Colors.grey.shade700),
              ),*/
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                enabled: !_isSavingEmail,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.done,
                validator: _validateEmail,
                onFieldSubmitted: (_) => _saveNotificationEmail(),
                decoration: InputDecoration(
                  labelText: l10n.notificationEmailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSavingEmail
                          ? null
                          : _openNotificationPreferences,
                      child: Text(
                        l10n.notificationPreferences,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSavingEmail ? null : _saveNotificationEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSavingEmail
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.notificationEmailSave,
                              style: TextStyle(fontSize: 11),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
