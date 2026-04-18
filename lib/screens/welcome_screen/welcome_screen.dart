import 'dart:math';

import 'package:barter_app/models/user/user_registration_data.dart';
import 'package:barter_app/services/crypto/crypto_service.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/profile/user_consent_update_request.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../services/settings_service.dart';
import '../../utils/debug_utils.dart';
import '../../widgets/dialogs/gdpr_consent_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  static const String _gdprConsentVersion = 'v1';

  late AnimationController _animationController;
  List<_FloatingIcon> _floatingIcons = [];

  // Avatar SVG assets (same as used in map screen)
  static const int _svgAssetCount = 29;

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/avatars/path$index.svg';

  // Same palette as onboarding category card colors
  static final List<Color> _onboardingCategoryColors = [
    Colors.green.shade400,
    Colors.red.shade400,
    Colors.blue.shade400,
    Colors.purple.shade400,
    Colors.yellow.shade700,
    Colors.orange.shade600,
    Colors.teal.shade400,
  ];

  // Onboarding category icons
  static const List<IconData> _onboardingIcons = [
    Icons.eco,
    Icons.park,
    Icons.pets,
    Icons.forest,
    Icons.sports_soccer,
    Icons.directions_run,
    Icons.party_mode,
    Icons.build,
    Icons.business,
    Icons.euro,
    Icons.work,
    Icons.handshake,
    Icons.palette,
    Icons.self_improvement,
    Icons.music_note,
    Icons.book,
    Icons.chat,
    Icons.forum,
    Icons.alternate_email,
    Icons.event,
    Icons.volunteer_activism,
    Icons.healing,
    Icons.support_agent,
    Icons.construction,
    Icons.computer,
    Icons.school,
    Icons.lightbulb,
    Icons.biotech,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_floatingIcons.isEmpty) {
      _floatingIcons = _generateFloatingIcons();
    }
  }

  List<_FloatingIcon> _generateFloatingIcons() {
    final random = Random();
    final screenSize = MediaQuery
        .of(context)
        .size;
    final deviceSize = ResponsiveBreakpoints.getDeviceSize(context);
    final isLargeNonWeb = !kIsWeb && context.canShowSideBySide;
    final iconSizeScale = isLargeNonWeb ? 1.5 : 1.0;

    // Calculate number of icons based on screen size
    int avatarIconCount;
    int onboardingIconCount;

    switch (deviceSize) {
      case DeviceSize.compact:
        avatarIconCount = 15;
        break;
      case DeviceSize.medium:
        avatarIconCount = 25;
        break;
      case DeviceSize.expanded:
        avatarIconCount = 35;
        break;
      case DeviceSize.large:
        avatarIconCount = 45;
        break;
      case DeviceSize.extraLarge:
        avatarIconCount = 60;
        break;
    }

    // Onboarding icons are 1/3 less
    onboardingIconCount = (avatarIconCount * 0.75).round();

    final List<_FloatingIcon> icons = [];

    // Generate avatar icons
    for (int i = 0; i < avatarIconCount; i++) {
      final size = (random.nextDouble() * 40 + 28) / iconSizeScale; // 30-70
      icons.add(_FloatingIcon(
        svgAsset: _getSvgAsset(random.nextInt(_svgAssetCount) + 1),
        // 1-based index
        left: random.nextDouble() * (screenSize.width - size),
        top: random.nextDouble() * screenSize.height,
        size: size,
        duration: Duration(seconds: random.nextInt(10) + 15),
        // 15-25 seconds
        delay: Duration(milliseconds: random.nextInt(3000)),
      ));
    }

    // Generate onboarding category icons
    for (int i = 0; i < onboardingIconCount; i++) {
      final size = (random.nextDouble() * 30 + 25) / iconSizeScale; // 25-55 (slightly smaller)
      icons.add(_FloatingIcon(
        iconData: _onboardingIcons[random.nextInt(_onboardingIcons.length)],
        iconColor:
            _onboardingCategoryColors[random.nextInt(_onboardingCategoryColors.length)]
                .withValues(alpha: 0.60),
        left: random.nextDouble() * (screenSize.width - size),
        top: random.nextDouble() * screenSize.height,
        size: size,
        duration: Duration(seconds: random.nextInt(10) + 15),
        delay: Duration(milliseconds: random.nextInt(3000)),
      ));
    }

    return icons;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onGetStartedPressed() async {
    final settingsService = getIt<SettingsService>();

    final alreadyConsented =
        await settingsService.hasAcceptedGdprConsentVersion(_gdprConsentVersion);

    if (!mounted) return;

    if (alreadyConsented) {
      context.pushReplacement('/onboarding?isInitialOnboarding=true');
      return;
    }

    final consent = await _showGdprConsentDialog(context);
    if (!mounted || consent == null) return;

    await settingsService.setGdprConsent(
      version: _gdprConsentVersion,
      locationConsent: consent.locationConsent,
      aiProcessingConsent: consent.aiProcessingConsent,
      analyticsCookiesConsent: consent.analyticsCookiesConsent,
    );

    try {
      final userRepository = getIt<UserRepository>();
      final apiClient = getIt<ApiClient>();

      // Deferred first-launch account bootstrap:
      // only do expensive crypto/profile creation after explicit consent.
      await userRepository.init();
      final hasOnboardingData = await userRepository.getProfileKeywordDataMap();
      if (hasOnboardingData == null) {
        String? userId = await userRepository.getUserId();

        if (userId != null && userId.isNotEmpty) {
          try {
            CryptoService.disposeSingletonStatic();
            final cryptoService = await CryptoService.create();
            final publicKey = cryptoService.ecPublicKeyToString(
              cryptoService.getPublicKey(),
            );

            await apiClient.createProfile(
              UserRegistrationData(
                id: userId,
                name: 'User_${userId.substring(0, 8)}',
                publicKey: publicKey,
                email: '',
                password: 'User_${Random.secure().nextInt(100000)}',
              ),
            );
          } on PlatformException catch (cryptoError) {
            final cryptoErrorString = cryptoError.toString().toLowerCase();
            if (cryptoErrorString.contains('key_not_found') ||
                cryptoErrorString.contains('badpaddingexception') ||
                cryptoErrorString.contains('bad_decrypt') ||
                cryptoErrorString.contains('cipher functions') ||
                (cryptoError.code.toLowerCase().contains('read') && cryptoError.message == null) ||
                (cryptoError.message?.toLowerCase().contains('read') == true) ||
                cryptoErrorString.contains('keystore') ||
                cryptoErrorString.contains('fluttersecurestorage')) {
              logDebug('🔄 Keystore error during deferred crypto init. Resetting secure storage and retrying bootstrap.');

              await userRepository.clearStorage();
              await userRepository.resetUserId();
              userId = await userRepository.getUserId();

              if (userId != null && userId.isNotEmpty) {
                CryptoService.disposeSingletonStatic();
                final recoveredCryptoService = await CryptoService.create();
                final recoveredPublicKey = recoveredCryptoService.ecPublicKeyToString(
                  recoveredCryptoService.getPublicKey(),
                );

                await apiClient.createProfile(
                  UserRegistrationData(
                    id: userId,
                    name: 'User_${userId.substring(0, 8)}',
                    publicKey: recoveredPublicKey,
                    email: '',
                    password: 'User_${Random.secure().nextInt(100000)}',
                  ),
                );
              }
            } else {
              rethrow;
            }
          }
        }
      }

      final userId = await userRepository.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await apiClient.updateUserConsent(
          UserConsentUpdateRequest(
            userId: userId,
            locationConsent: consent.locationConsent,
            aiProcessingConsent: consent.aiProcessingConsent,
            analyticsCookiesConsent: consent.analyticsCookiesConsent,
            privacyPolicyVersion: _gdprConsentVersion,
            termsConditionsVersion: _gdprConsentVersion,
          ),
        );
      } else {
        logDebug('⚠️ GDPR consent not submitted: userId missing');
      }
    } catch (e) {
      logDebug('⚠️ Failed to complete deferred registration/consent sync: $e');
    }

    if (!mounted) return;
    context.pushReplacement('/onboarding?isInitialOnboarding=true');
  }

  Future<GdprConsentChoice?> _showGdprConsentDialog(BuildContext context) async {
    final settingsService = getIt<SettingsService>();
    final initialLocationConsent = await settingsService.getStoredLocationConsent();
    final initialAiConsent = await settingsService.getStoredAiProcessingConsent();
    final initialAnalyticsConsent = await settingsService.getStoredAnalyticsCookiesConsent();

    if (!context.mounted) return null;

    return showDialog<GdprConsentChoice>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GdprConsentDialog(
        initialLocationConsent: initialLocationConsent,
        initialAiProcessingConsent: initialAiConsent,
        initialAnalyticsCookiesConsent: initialAnalyticsConsent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // On large non-web screens (tablets/desktop-like), make welcome text/icons 2x smaller.
    final bool isLargeNonWeb = !kIsWeb && context.canShowSideBySide;
    // Keep existing web behavior, but enforce stronger downscale for large non-web.
    final double fontScale = isLargeNonWeb ? 2.0 : (kIsWeb ? 1.5 : 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating icons background
            ..._floatingIcons.map((icon) =>
                _AnimatedFloatingIcon(
                  floatingIcon: icon,
                  controller: _animationController,
                )),
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveBreakpoints.getPadding(context),
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Title
                      Text(
                        l10n.appTitle,
                        style: TextStyle(
                          fontSize: context.displayFontSize / fontScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      // Tagline
                      Text(
                        l10n.welcomeTagline,
                        style: TextStyle(
                          fontSize: context.headingFontSize / fontScale,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      // Get Started Button
                      ElevatedButton(
                        onPressed: _onGetStartedPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withValues(alpha: 0.5),
                        ),
                        child: Text(
                          l10n.getStarted,
                          style: TextStyle(
                            fontSize: context.buttonFontSize / fontScale,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.black87
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      // How it works section
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveBreakpoints.getMaxContentWidth(
                              context),
                        ),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.howItWorks,
                              style: TextStyle(
                                fontSize: context.headingFontSize / fontScale,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildHowItWorksStep(
                              context,
                              Icons.person_add,
                              l10n.welcomeStep1Title,
                              l10n.welcomeStep1Description,
                            ),
                            SizedBox(height: 12.h),
                            _buildHowItWorksStep(
                              context,
                              Icons.explore,
                              l10n.welcomeStep2Title,
                              l10n.welcomeStep2Description,
                            ),
                            SizedBox(height: 12.h),
                            _buildHowItWorksStep(
                              context,
                              Icons.chat_bubble_outline,
                              l10n.welcomeStep3Title,
                              l10n.welcomeStep3Description,
                            ),
                            SizedBox(height: 12.h),
                            _buildHowItWorksStep(
                              context,
                              Icons.handshake,
                              l10n.welcomeStep4Title,
                              l10n.welcomeStep4Description,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      GestureDetector(
                        onTap: () => context.push('/device-migration'),
                        child: Text(
                          l10n.importExistingAccount,
                          style: TextStyle(
                            fontSize: context.bodyFontSize / fontScale,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksStep(BuildContext context,
      IconData icon,
      String title,
      String description,) {
    final bool isLargeNonWeb = !kIsWeb && context.canShowSideBySide;
    // Keep existing web tuning, but apply 2x downscale on large non-web screens.
    final double fontScale = isLargeNonWeb ? 1.5 : (kIsWeb ? 1.2 : 1.0);
    final double iconScale = isLargeNonWeb ? 2.0 : (kIsWeb ? 2.0 : 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w / iconScale),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12.r / iconScale),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp / iconScale,
          ),
        ),
        SizedBox(width: 12.w / iconScale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: context.subheadingFontSize / fontScale,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h / iconScale),
              Text(
                description,
                style: TextStyle(
                  fontSize: context.bodyFontSize / fontScale,
                  color: Colors.black87.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper class to store floating icon data
class _FloatingIcon {
  final String? svgAsset;
  final IconData? iconData;
  final Color? iconColor;
  final double left;
  final double top;
  final double size;
  final Duration duration;
  final Duration delay;

  _FloatingIcon({
    this.svgAsset,
    this.iconData,
    this.iconColor,
    required this.left,
    required this.top,
    required this.size,
    required this.duration,
    required this.delay,
  }) : assert(svgAsset != null || iconData != null,
  'Either svgAsset or iconData must be provided');
}

// Animated floating icon widget
class _AnimatedFloatingIcon extends StatefulWidget {
  final _FloatingIcon floatingIcon;
  final AnimationController controller;

  const _AnimatedFloatingIcon({
    required this.floatingIcon,
    required this.controller,
  });

  @override
  State<_AnimatedFloatingIcon> createState() => _AnimatedFloatingIconState();
}

class _AnimatedFloatingIconState extends State<_AnimatedFloatingIcon> {
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;
  final Random _random = Random();
  late double _startOffset;
  late double _endOffset;

  @override
  void initState() {
    super.initState();
    _startOffset = _random.nextDouble() * 100 - 50; // -50 to 50
    _endOffset = _random.nextDouble() * 100 - 50; // -50 to 50

    _animation = Tween<double>(
      begin: _startOffset,
      end: _endOffset,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.5), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0), weight: 1),
    ]).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Positioned(
          left: widget.floatingIcon.left + _animation.value,
          top: widget.floatingIcon.top,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child!,
          ),
        );
      },
      child: widget.floatingIcon.svgAsset != null
          ? FutureBuilder<String>(
              future: _loadAndModifySvg(widget.floatingIcon.svgAsset!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: widget.floatingIcon.size,
                    height: widget.floatingIcon.size,
                  );
                }
                return SvgPicture.string(
                  snapshot.data!,
                  width: widget.floatingIcon.size,
                  height: widget.floatingIcon.size,
                );
              },
            )
          : Icon(
              widget.floatingIcon.iconData!,
              size: widget.floatingIcon.size,
              color: widget.floatingIcon.iconColor ?? Colors.white.withValues(alpha: 0.5),
            ),
    );
  }

  Future<String> _loadAndModifySvg(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final random = Random();

    // Generate a random color
    final colors = [
      Colors.red.shade200,
      Colors.deepOrange.shade100,
      Colors.brown.shade200,
      Colors.purple.shade100,
      Colors.orange.shade100,
      Colors.yellow.shade100,
      Colors.orangeAccent.shade100,
    ];

    final color = colors[random.nextInt(colors.length)];
    final colorHex =
        '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    // Replace the default color with the random color
    return svgString;//.replaceAll('#ffd4a3', colorHex);
  }
}
