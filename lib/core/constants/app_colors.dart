import 'package:flutter/material.dart';

/// PREMIUM LIGHT THEME with Vibrant Green/Teal - Professional Fintech Design
/// Clean, bright, and perfect for all-day use
class AppColors {
  // ============ BASE LIGHT PALETTE ============
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Light professional grey-blue
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards
  static const Color surfaceVariant = Color(0xFFFAFBFC); // Very light grey-blue
  static const Color divider = Color(0xFFE8EAEF); // Subtle dividers

  // ============ PRIMARY - VIBRANT EMERALD GREEN ============
  static const Color primary = Color(
    0xFF00D084,
  ); // Bright, vibrant green (Hero color)
  static const Color primaryDark = Color(0xFF00AA6F); // Darker green
  static const Color primaryLight = Color(0xFF26E5A8); // Lighter green
  static const Color primaryTint = Color(0xFFE8F9F3); // Very light green

  // ============ SECONDARY - CYAN/TEAL ACCENT ============
  static const Color secondary = Color(
    0xFF00E5E5,
  ); // Bright cyan (Secondary hero)
  static const Color secondaryDark = Color(0xFF00B8B8); // Darker cyan
  static const Color secondaryLight = Color(0xFF33F3F3); // Lighter cyan
  static const Color secondaryTint = Color(0xFFE0F9F6); // Very light cyan

  // ============ TERTIARY - PURPLE ACCENT ============
  static const Color tertiary = Color(0xFF9D4EDD); // Modern purple
  static const Color tertiaryLight = Color(0xFFBB86FC); // Light purple
  static const Color tertiaryTint = Color(0xFFF3E5FF); // Very light purple

  // ============ TEXT COLORS - Dark on light ============
  static const Color textPrimary = Color(0xFF0F1219); // Deep black
  static const Color textSecondary = Color(0xFF5A6575); // Medium grey
  static const Color textTertiary = Color(0xFF8A94A6); // Light grey
  static const Color textHint = Color(0xFFC5CED5); // Very light grey

  // ============ NEUTRAL COLORS ============
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============ ACCENT COLORS (Vibrant) ============
  // Success States
  static const Color success = Color(0xFF00D084);
  static const Color successLight = Color(0xFF26E5A8);
  static const Color successDim = Color(0xFF00A86F);

  // Warning States
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDim = Color(0xFFFF8C00);

  // Error States
  static const Color error = Color(0xFFFF4757);
  static const Color errorLight = Color(0xFFFF6B7A);
  static const Color errorDim = Color(0xFFFF3838);

  // Info States
  static const Color info = Color(0xFF00E5E5);
  static const Color infoLight = Color(0xFF33F3F3);
  static const Color infoDim = Color(0xFF00B8B8);

  // ============ PREMIUM ACCENTS ============
  static const Color accentGreen = Color(0xFF00D084);
  static const Color accentCyan = Color(0xFF00E5E5);
  static const Color accentPurple = Color(0xFF9D4EDD);
  static const Color accentPink = Color(0xFFFF1493);
  static const Color accentYellow = Color(0xFFFFD700);

  // ============ SHADOWS (For light theme) ============
  static const Color shadow = Color(0x0D000000); // 5% black
  static const Color shadowMedium = Color(0x14000000); // 8% black
  static const Color shadowLarge = Color(0x1F000000); // 12% black

  // ============ PREMIUM GRADIENTS ============
  static const List<Color> gradientPrimary = [
    Color(0xFFF5F7FA), // Light grey-blue
    Color(0xFFFFFFFF), // White
    Color(0xFFFAFBFC), // Very light grey-blue
  ];

  static const List<Color> gradientSuccess = [
    Color(0xFF00D084),
    Color(0xFF00A86F),
  ];

  static const List<Color> gradientCyan = [
    Color(0xFF00E5E5),
    Color(0xFF00B8B8),
  ];

  static const List<Color> gradientWarning = [
    Color(0xFFFFA726),
    Color(0xFFFF8C00),
  ];

  static const List<Color> gradientError = [
    Color(0xFFFF4757),
    Color(0xFFFF3838),
  ];

  static const List<Color> gradientPremium = [
    Color(0xFF00D084),
    Color(0xFF00E5E5),
  ];

  static const List<Color> gradientNeon = [
    Color(0xFF0A1F2E),
    Color(0xFF1B3A52),
    Color(0xFF0A1F2E),
  ];
}
