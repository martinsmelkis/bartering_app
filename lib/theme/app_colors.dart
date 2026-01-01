// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Define your primary colors
  static const Color primary = Color(0xFFf77649);
  static const Color primaryVariant = Color(0xFFf89c35); // A darker variant

  // Define your secondary colors
  static const Color secondary = Color(0xFFff7651);
  static const Color secondaryVariant = Color(0xFFf76c8b); // A darker variant

  // Define other common colors
  static const Color background = Color(0xFFffefd3);
  static const Color surface = Color(0xFFFFFFFF); // Cards, sheets, menus
  static const Color error = Color(0xFFB00020); // Standard error color

  // Define colors for text and icons
  static const Color onPrimary = Color(
      0xFFFFFFFF); // Text/icons on primary color
  static const Color onSecondary = Color(
      0xFF000000); // Text/icons on secondary color
  static const Color onBackground = Color(
      0xFF000000); // Text/icons on background
  static const Color onSurface = Color(0xFF000000); // Text/icons on surface
  static const Color onError = Color(0xFFFFFFFF); // Text/icons on error color

  // You can add more specific colors as needed
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF333333);
  static const Color chatBubbleMe = primary; // Example for user's chat bubble
  static const Color chatBubbleOther = Color(0xFFff9c35);

}