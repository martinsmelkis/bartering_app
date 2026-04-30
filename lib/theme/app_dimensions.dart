// lib/theme/app_dimensions.dart
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized dimensions that adapt based on platform (web vs mobile)
/// This eliminates the need for kIsWeb checks throughout the codebase
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // ============================================================================
  // AVATAR & MARKER SIZES
  // ============================================================================

  /// Size for POI markers on the map
  ///
  /// Keeps physical size visually closer across Android density buckets.
  /// Devices with higher pixel density (same physical screen size) get a
  /// slight boost to reduce the "icons look smaller" effect.
  static double get mapPoiMarkerSize {
    if (kIsWeb) return 90;

    final logicalSize = (105.w).clamp(98.0, 108.0).toDouble();

    // Use the current view DPR to apply a mild compensation for high-density
    // Android displays where icons can appear physically smaller.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return logicalSize;
    }

    final dpr = ui.PlatformDispatcher.instance.views.isNotEmpty
        ? ui.PlatformDispatcher.instance.views.first.devicePixelRatio
        : 1.0;

    final minAvatarSize = dpr >= 3.25 ? 115 : dpr >= 2.85 ? 110 : dpr >= 2.55 ? 100 : dpr >= 2.25 ? 95 : 90;

    final compensation = dpr >= 3.25 ? 1.45 : dpr >= 2.85 ? 1.25 : dpr >= 2.55 ? 1.05 : dpr >= 2.25 ? 1.02 : 1.0;

    return (logicalSize * compensation).clamp(minAvatarSize, 145.0).toDouble();
  }

  /// Size for user avatar FAB
  static double get userAvatarSize => kIsWeb ? 88.4 : 90.0;

  /// Size for edit icon overlay on avatar
  static double get avatarEditIconSize => kIsWeb ? 26.0 : 28.0;

  /// Size for icon inside the edit icon overlay
  static double get avatarEditIconInnerSize => kIsWeb ? 15.6 : 13.0;

  // ============================================================================
  // CLUSTER MARKER SIZES
  // ============================================================================

  /// Container size for main cluster markers
  ///
  /// NOTE: Keep native tablet sizing close to phone proportions.
  static double get mainClusterSize =>
      kIsWeb ? 80.0 : (72.w).clamp(65.0, 78.0).toDouble();

  /// Font size for main cluster marker text
  static double get mainClusterFontSize => kIsWeb ? 25.0 : 20;

  /// Border width for main cluster markers
  static double get mainClusterBorderWidth => kIsWeb ? 2.0 : 4.0;

  /// Container size for sub-cluster markers
  static double get subClusterSize =>
      kIsWeb ? 60.0 : (65.w).clamp(58.0, 70.0).toDouble();

  /// Font size for sub-cluster marker text
  static double get subClusterFontSize => kIsWeb ? 22 : 17;

  /// Border width for sub-cluster markers
  static double get subClusterBorderWidth => kIsWeb ? 2.0 : 4.0;

  // ============================================================================
  // TEXT SIZES
  // ============================================================================

  /// Heading text size
  static double get headingTextSize => kIsWeb ? 16.0 : 19;

  /// Medium heading text size
  static double get mediumHeadingTextSize => kIsWeb ? 16.0 : 17;

  /// Body text size
  static double get bodyTextSize => kIsWeb ? 14.0 : 16.sp;

  /// Small text size
  static double get smallTextSize => kIsWeb ? 12.0 : 14.sp;

  /// Caption text size
  static double get captionTextSize => kIsWeb ? 10.0 : 12.sp;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  /// Standard icon size
  static double get iconSize => kIsWeb ? 20.0 : 24.sp;

  /// Small icon size (for buttons, etc.)
  static double get smallIconSize => kIsWeb ? 18.0 : 20.sp;

  /// Large icon size
  static double get largeIconSize => kIsWeb ? 28.0 : 32.sp;

  /// Edit icon size (for inline editing)
  static double get editIconSize => kIsWeb ? 18.0 : 20;

  // ============================================================================
  // SPACING & PADDING
  // ============================================================================

  /// Small spacing
  static double get spacingSmall => kIsWeb ? 4.0 : 8.w;

  /// Medium spacing
  static double get spacingMedium => kIsWeb ? 8.0 : 12.w;

  /// Large spacing
  static double get spacingLarge => kIsWeb ? 12.0 : 16.w;

  /// Extra large spacing
  static double get spacingXLarge => kIsWeb ? 16.0 : 20.w;

  // ============================================================================
  // BUTTON SIZES
  // ============================================================================

  /// Button height
  static double get buttonHeight => kIsWeb ? 40.0 : 48.h;

  /// Small button height
  static double get smallButtonHeight => kIsWeb ? 32.0 : 40.h;

  /// Button padding (horizontal)
  static double get buttonPaddingHorizontal => kIsWeb ? 16.0 : 20.w;

  /// Button padding (vertical)
  static double get buttonPaddingVertical => kIsWeb ? 8.0 : 12.h;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  /// Small border radius
  static double get borderRadiusSmall => kIsWeb ? 4.0 : 8.r;

  /// Medium border radius
  static double get borderRadiusMedium => kIsWeb ? 8.0 : 12.r;

  /// Large border radius
  static double get borderRadiusLarge => kIsWeb ? 12.0 : 20.r;

  // ============================================================================
  // CARD & CONTAINER SIZES
  // ============================================================================

  /// Card padding
  static double get cardPadding => kIsWeb ? 12.0 : 16.w;

  /// Card elevation
  static double get cardElevation => kIsWeb ? 1.0 : 2.0;

  // ============================================================================
  // INPUT FIELD SIZES
  // ============================================================================

  /// Input field height
  static double get inputFieldHeight => kIsWeb ? 40.0 : 48.h;

  /// Input field font size
  static double get inputFieldFontSize => kIsWeb ? 14.0 : 16.sp;

  // ============================================================================
  // APP BAR SIZES
  // ============================================================================

  /// App bar height
  static double get appBarHeight => kIsWeb ? 56.0 : 56.0;

  /// App bar title font size
  static double get appBarTitleSize => kIsWeb ? 18.0 : 20.sp;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get platform-specific value
  static T platformValue<T>({required T web, required T mobile}) {
    return kIsWeb ? web : mobile;
  }

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile
  static bool get isMobile => !kIsWeb;
}
