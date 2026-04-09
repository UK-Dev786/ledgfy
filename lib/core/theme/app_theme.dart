import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ── Shared shape ──────────────────────────────────────────────────────────
  static const _radiusCard = Radius.circular(16);
  static const _radiusInput = Radius.circular(12);
  static const _radiusButton = Radius.circular(12);

  // ── Light theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const cs = ColorScheme(
      brightness: Brightness.light,
      // Primary — emerald green
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: AppColors.primaryDark,
      // Secondary — cyan
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryTint,
      onSecondaryContainer: AppColors.secondaryDark,
      // Tertiary — purple
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.tertiaryTint,
      onTertiaryContainer: AppColors.tertiary,
      // Surfaces
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,
      // Utility
      outline: AppColors.divider,
      outlineVariant: AppColors.divider,
      shadow: AppColors.shadow,
      // Semantic
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: Color(0xFFFFEDEF),
      onErrorContainer: AppColors.errorDim,
      // Background (deprecated but still consumed by some widgets)
      // ignore: deprecated_member_use
      background: AppColors.background,
      // ignore: deprecated_member_use
      onBackground: AppColors.textPrimary,
      inversePrimary: AppColors.primaryLight,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.white,
      scrim: Color(0x52000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,

      // ── Scaffold ────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Typography ──────────────────────────────────────────────────────
      textTheme: _buildTextTheme(AppColors.textPrimary),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_radiusCard),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
        margin: EdgeInsets.zero,
        shadowColor: AppColors.shadowMedium,
      ),

      // ── ElevatedButton ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 56),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_radiusButton),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_radiusButton),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_radiusButton),
          ),
        ),
      ),

      // ── FloatingActionButton ─────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── InputDecoration ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(_radiusInput),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(_radiusInput),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(_radiusInput),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(_radiusInput),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(_radiusInput),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── BottomNavigationBar ──────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),

      // ── NavigationBar (M3) ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryTint,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.textTertiary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextStyles.labelSmall;
        }),
        elevation: 8,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primaryTint,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
        side: const BorderSide(color: AppColors.divider, width: 1),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Switch ───────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.divider;
        }),
      ),

      // ── Checkbox ─────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.divider, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),

      // ── Radio ─────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textTertiary;
        }),
      ),

      // ── ListTile ─────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AppColors.textSecondary,
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_radiusCard),
        ),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_radiusCard),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        actionTextColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),

      // ── Progress indicator ───────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryTint,
        circularTrackColor: AppColors.primaryTint,
      ),

      // ── Tab bar ──────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        unselectedLabelStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textTertiary,
        ),
      ),

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 24),
    );
  }

  // ── Dark theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFF003D28),
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.black,
      secondaryContainer: Color(0xFF003D3D),
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: AppColors.black,
      tertiaryContainer: Color(0xFF3A1060),
      onTertiaryContainer: AppColors.tertiaryLight,
      surface: Color(0xFF0D1F35),
      onSurface: Color(0xFFE8EDF2),
      surfaceContainerHighest: Color(0xFF1B3A52),
      onSurfaceVariant: Color(0xFFABB8C3),
      outline: Color(0xFF2A4A63),
      outlineVariant: Color(0xFF1E3A52),
      shadow: Color(0xFF000000),
      error: AppColors.errorLight,
      onError: AppColors.black,
      errorContainer: Color(0xFF5C0A16),
      onErrorContainer: AppColors.errorLight,
      // ignore: deprecated_member_use
      background: Color(0xFF0A1628),
      // ignore: deprecated_member_use
      onBackground: Color(0xFFE8EDF2),
      inversePrimary: AppColors.primaryDark,
      inverseSurface: Color(0xFFE8EDF2),
      onInverseSurface: Color(0xFF0A1628),
      scrim: Color(0x73000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFF0A1628),
      textTheme: _buildTextTheme(const Color(0xFFE8EDF2)),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFE8EDF2),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: const Color(0xFFE8EDF2),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE8EDF2)),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF0D1F35),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_radiusCard),
          side: BorderSide(color: Color(0xFF2A4A63), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_radiusButton),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A4A63),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFABB8C3), size: 24),
    );
  }

  // ── Shared text theme builder ─────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: baseColor),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: baseColor),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: baseColor),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: baseColor),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: baseColor),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: baseColor),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: baseColor),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: baseColor),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: baseColor),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: baseColor),
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge.copyWith(color: baseColor),
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );
  }
}
