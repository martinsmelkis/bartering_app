// lib/utils/responsive_breakpoints.dart
import 'package:flutter/material.dart';

/// Responsive breakpoints and utilities for adaptive design
/// Following Material Design 3 and common best practices
class ResponsiveBreakpoints {
  // Private constructor to prevent instantiation
  ResponsiveBreakpoints._();

  // ============================================================================
  // BREAKPOINT CONSTANTS (Material Design 3 recommendations)
  // ============================================================================

  /// Compact: Phone in portrait (< 600dp)
  static const double compact = 600;

  /// Medium: Tablet in portrait, phone in landscape (600dp - 840dp)
  static const double medium = 840;

  /// Expanded: Tablet in landscape, desktop (840dp - 1200dp)
  static const double expanded = 1200;

  /// Large: Desktop, ultra-wide (1200dp - 1600dp)
  static const double large = 1600;

  /// Extra Large: Ultra-wide desktop (> 1600dp)
  static const double extraLarge = 1600;

  // ============================================================================
  // COMMON USE CASES
  // ============================================================================

  /// Breakpoint for showing side-by-side layouts (master-detail pattern)
  static const double masterDetail = 840;

  /// Breakpoint for showing 2 columns
  static const double twoColumns = 600;

  /// Breakpoint for showing 3 columns
  static const double threeColumns = 1200;

  // ============================================================================
  // DEVICE TYPE CHECKS
  // ============================================================================

  /// Check if device is a phone (compact)
  static bool isPhone(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width < compact;
  }

  /// Check if device is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return width >= compact && width < expanded;
  }

  /// Check if device is a desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width >= expanded;
  }

  /// Check if device has sufficient width for side-by-side layouts
  static bool canShowSideBySide(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width >= masterDetail;
  }

  /// Check if device can show 2 columns
  static bool canShowTwoColumns(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width >= twoColumns;
  }

  /// Check if device can show 3 columns
  static bool canShowThreeColumns(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width >= threeColumns;
  }

  // ============================================================================
  // DEVICE SIZE ENUM
  // ============================================================================

  /// Get the current device size category
  static DeviceSize getDeviceSize(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    if (width < compact) return DeviceSize.compact;
    if (width < medium) return DeviceSize.medium;
    if (width < expanded) return DeviceSize.expanded;
    if (width < large) return DeviceSize.large;
    return DeviceSize.extraLarge;
  }

  // ============================================================================
  // RESPONSIVE VALUES
  // ============================================================================

  /// Get a value based on device size
  static T getValue<T>({
    required BuildContext context,
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    final size = getDeviceSize(context);
    switch (size) {
      case DeviceSize.compact:
        return compact;
      case DeviceSize.medium:
        return medium ?? compact;
      case DeviceSize.expanded:
        return expanded ?? medium ?? compact;
      case DeviceSize.large:
        return large ?? expanded ?? medium ?? compact;
      case DeviceSize.extraLarge:
        return extraLarge ?? large ?? expanded ?? medium ?? compact;
    }
  }

  /// Get a value based on screen width comparison
  static T valueWhen<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // ============================================================================
  // LAYOUT HELPERS
  // ============================================================================

  /// Get number of columns based on screen width
  static int getColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Get padding based on screen width
  static double getPadding(BuildContext context) {
    return getValue(
      context: context,
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
      large: 48.0,
    );
  }

  /// Get grid spacing based on screen width
  static double getGridSpacing(BuildContext context) {
    return getValue(
      context: context,
      compact: 8.0,
      medium: 12.0,
      expanded: 16.0,
      large: 20.0,
    );
  }

  /// Get maximum content width for readable content
  static double getMaxContentWidth(BuildContext context) {
    return getValue(
      context: context,
      compact: double.infinity,
      medium: 840.0,
      expanded: 1200.0,
      large: 1400.0,
    );
  }

  /// Get panel width for side panels (e.g., chat, navigation)
  static double getPanelWidth(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    // 20% wider than before
    if (screenWidth >= extraLarge) return 540.0; // was 450
    if (screenWidth >= large) return 480.0; // was 400
    if (screenWidth >= expanded) return 420.0; // was 350
    return 360.0; // was 300
  }

  /// Get whether to show navigation rail vs bottom nav
  static bool shouldUseNavigationRail(BuildContext context) {
    return canShowSideBySide(context);
  }

  // ============================================================================
  // RESPONSIVE FONT SIZES
  // ============================================================================

  /// Get responsive font size with base size scaling
  /// The baseSize is for compact devices, larger devices get proportional increases
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    return getValue(
      context: context,
      compact: baseSize,
      medium: baseSize * 1.1,
      // 10% larger on tablets
      expanded: baseSize * 1.2,
      // 20% larger on small desktops
      large: baseSize * 1.3,
      // 30% larger on desktops
      extraLarge: baseSize * 1.4, // 40% larger on ultra-wide
    );
  }

  /// Get font size for display text (headlines, hero text)
  static double getDisplayFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 32.0,
      medium: 36.0,
      expanded: 40.0,
      large: 48.0,
      extraLarge: 56.0,
    );
  }

  /// Get font size for headings (page titles, card headers)
  static double getHeadingFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 24.0,
      medium: 26.0,
      expanded: 28.0,
      large: 32.0,
      extraLarge: 36.0,
    );
  }

  /// Get font size for subheadings (section titles, list headers)
  static double getSubheadingFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 18.0,
      medium: 20.0,
      expanded: 22.0,
      large: 24.0,
      extraLarge: 26.0,
    );
  }

  /// Get font size for body text (normal content)
  static double getBodyFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 14.0,
      medium: 15.0,
      expanded: 16.0,
      large: 17.0,
      extraLarge: 18.0,
    );
  }

  /// Get font size for small text (captions, helper text)
  static double getSmallFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 12.0,
      medium: 13.0,
      expanded: 14.0,
      large: 15.0,
      extraLarge: 16.0,
    );
  }

  /// Get font size for button text
  static double getButtonFontSize(BuildContext context) {
    return getValue(
      context: context,
      compact: 16.0,
      medium: 17.0,
      expanded: 18.0,
      large: 19.0,
      extraLarge: 21.0,
    );
  }
}

/// Device size categories
enum DeviceSize {
  /// Phone in portrait (< 600dp)
  compact,

  /// Tablet in portrait, phone in landscape (600dp - 840dp)
  medium,

  /// Tablet in landscape, small desktop (840dp - 1200dp)
  expanded,

  /// Desktop (1200dp - 1600dp)
  large,

  /// Ultra-wide desktop (> 1600dp)
  extraLarge,
}

/// Extension methods on BuildContext for convenience
extension ResponsiveExtensions on BuildContext {
  /// Check if device is a phone
  bool get isPhone => ResponsiveBreakpoints.isPhone(this);

  /// Check if device is a tablet
  bool get isTablet => ResponsiveBreakpoints.isTablet(this);

  /// Check if device is a desktop
  bool get isDesktop => ResponsiveBreakpoints.isDesktop(this);

  /// Check if device can show side-by-side layouts
  bool get canShowSideBySide => ResponsiveBreakpoints.canShowSideBySide(this);

  /// Get the current device size category
  DeviceSize get deviceSize => ResponsiveBreakpoints.getDeviceSize(this);

  /// Get responsive padding
  double get responsivePadding => ResponsiveBreakpoints.getPadding(this);

  /// Get panel width
  double get panelWidth => ResponsiveBreakpoints.getPanelWidth(this);

  // Font size getters
  /// Get responsive font size with custom base size
  double responsiveFontSize(double baseSize) =>
      ResponsiveBreakpoints.getResponsiveFontSize(this, baseSize);

  /// Get display font size (headlines, hero text)
  double get displayFontSize => ResponsiveBreakpoints.getDisplayFontSize(this);

  /// Get heading font size (page titles, card headers)
  double get headingFontSize => ResponsiveBreakpoints.getHeadingFontSize(this);

  /// Get subheading font size (section titles, list headers)
  double get subheadingFontSize =>
      ResponsiveBreakpoints.getSubheadingFontSize(this);

  /// Get body font size (normal content)
  double get bodyFontSize => ResponsiveBreakpoints.getBodyFontSize(this);

  /// Get small font size (captions, helper text)
  double get smallFontSize => ResponsiveBreakpoints.getSmallFontSize(this);

  /// Get button font size
  double get buttonFontSize => ResponsiveBreakpoints.getButtonFontSize(this);
}
