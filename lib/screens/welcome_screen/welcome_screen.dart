import 'dart:math';

import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<_FloatingIcon> _floatingIcons = [];

  // Avatar SVG assets (same as used in map screen)
  static const int _svgAssetCount = 25;

  // Generate SVG asset path by index (1-based)
  static String _getSvgAsset(int index) => 'assets/icons/path$index.svg';

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
    Icons.attach_money,
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
    onboardingIconCount = (avatarIconCount * 0.67).round();

    final List<_FloatingIcon> icons = [];

    // Generate avatar icons
    for (int i = 0; i < avatarIconCount; i++) {
      final size = random.nextDouble() * 40 + 30; // 30-70
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
      final size = random.nextDouble() * 30 + 25; // 25-55 (slightly smaller)
      icons.add(_FloatingIcon(
        iconData: _onboardingIcons[random.nextInt(_onboardingIcons.length)],
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use smaller sizes on web, original sizes on mobile
    final double fontScale = kIsWeb ? 1.5 : 1.0;

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
                    vertical: 40.h,
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
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 24.h),
                      // Get Started Button
                      ElevatedButton(
                        onPressed: () {
                          if (context.mounted) {
                            context.go('/onboarding?isInitialOnboarding=true');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 48.w,
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
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
                      SizedBox(height: 24.h),
                      // How it works section
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveBreakpoints.getMaxContentWidth(
                              context),
                        ),
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
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
    // Use smaller sizes on web, original sizes on mobile
    final double fontScale = kIsWeb ? 1.2 : 1.0;
    final double iconScale = kIsWeb ? 2.0 : 1.0;

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
            size: 24.sp / iconScale,
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
  final double left;
  final double top;
  final double size;
  final Duration duration;
  final Duration delay;

  _FloatingIcon({
    this.svgAsset,
    this.iconData,
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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.7), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 1),
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
        color: Colors.white.withValues(alpha: 0.5),
      ),
    );
  }

  Future<String> _loadAndModifySvg(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final random = Random();

    // Generate a random color
    final colors = [
      Colors.red.shade200,
      Colors.blue.shade200,
      Colors.green.shade200,
      Colors.purple.shade200,
      Colors.orange.shade200,
      Colors.yellow.shade200,
      Colors.teal.shade200,
    ];

    final color = colors[random.nextInt(colors.length)];
    final colorHex =
        '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    // Replace the default color with the random color
    return svgString.replaceAll('#ffd4a3', colorHex);
  }
}
