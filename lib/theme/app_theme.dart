// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart'; // Import your custom colors

class AppTheme {
  /// Creates a responsive text theme based on the device size
  /// This is a base theme that will be scaled by textScaleFactor if needed
  static TextTheme getResponsiveTextTheme() {
    return const TextTheme(
      // Display styles (large hero text)
      displayLarge: TextStyle(
          fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),

      // Headline styles (page titles)
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),

      // Title styles (card titles, list headers)
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),

      // Body styles (main content)
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),

      // Label styles (buttons, tabs)
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // Recommended for new apps
      brightness: Brightness.light,

      // --- Core Colors ---
      primaryColor: AppColors.primary,
      // scaffoldBackgroundColor also uses this if not set explicitly
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryVariant,
        // Or another suitable color
        onPrimaryContainer: AppColors.onPrimary,

        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryVariant,
        // Or another suitable color
        onSecondaryContainer: AppColors.onSecondary,

        tertiary: Colors.orange,
        // Example, define in AppColors if used often
        onTertiary: AppColors.background,

        error: AppColors.error,
        onError: AppColors.onError,

        surface: AppColors.surface,
        onSurface: AppColors.onSurface,

        // You can also define variants: surfaceVariant, onSurfaceVariant, etc.
      ),

      // --- Specific Widget Theming (Examples) ---
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        // For title text and icons
        elevation: 4.0,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.onPrimary,
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary, // Text color
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        hintStyle: TextStyle(color: AppColors.darkGrey.withValues(alpha: 0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
      ),

      // --- Responsive Text Theme ---
      textTheme: getResponsiveTextTheme(),

      // --- Add custom theme extensions if needed for very specific colors ---
      // extensions: <ThemeExtension<dynamic>>[
      //   const CustomChatTheme(
      //     meBubbleColor: AppColors.chatBubbleMe,
      //     otherBubbleColor: AppColors.chatBubbleOther,
      //   ),
      // ],

      // If you are NOT using Material 3, you might set these directly:
      // accentColor: AppColors.secondary, // Deprecated in favor of colorScheme.secondary
      // buttonColor: AppColors.primary, // For older button types
    );
  }

// You can also define a darkTheme in a similar way
// static ThemeData get darkTheme { ... }
}

// --- Optional: Custom Theme Extension for highly specific colors ---
// @immutable
// class CustomChatTheme extends ThemeExtension<CustomChatTheme> {
//   const CustomChatTheme({
//     required this.meBubbleColor,
//     required this.otherBubbleColor,
//   });

//   final Color? meBubbleColor;
//   final Color? otherBubbleColor;

//   @override
//   CustomChatTheme copyWith({Color? meBubbleColor, Color? otherBubbleColor}) {
//     return CustomChatTheme(
//       meBubbleColor: meBubbleColor ?? this.meBubbleColor,
//       otherBubbleColor: otherBubbleColor ?? this.otherBubbleColor,
//     );
//   }

//   @override
//   CustomChatTheme lerp(ThemeExtension<CustomChatTheme>? other, double t) {
//     if (other is! CustomChatTheme) {
//       return this;
//     }
//     return CustomChatTheme(
//       meBubbleColor: Color.lerp(meBubbleColor, other.meBubbleColor, t),
//       otherBubbleColor: Color.lerp(otherBubbleColor, other.otherBubbleColor, t),
//     );
//   }
// }