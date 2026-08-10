import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _buildDark();
  static ThemeData get light => _buildLight();

  static ThemeData _buildDark() {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primary500,
      primaryContainer: AppColors.primary800,
      onPrimary: Colors.white,
      secondary: AppColors.secondary400,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary400,
      surface: AppColors.surfaceDark,
      surfaceContainerHighest: AppColors.surfaceCardDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.evidenceMissing,
      outline: AppColors.borderDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      cardColor: AppColors.surfaceCardDark,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.brandWordmark.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),

      // Text
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textSecondaryDark),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.evidenceMissing, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.evidenceMissing, width: 2),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary500,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        selectedColor: AppColors.primary500.withOpacity(0.2),
        side: const BorderSide(color: AppColors.borderDark),
        labelStyle: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // BottomNav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardDark,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      // NavigationBar (Material3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardDark,
        indicatorColor: AppColors.primary500.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary500);
          }
          return const IconThemeData(color: AppColors.textTertiaryDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: AppColors.primary500);
          }
          return AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark);
        }),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceCardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        titleTextStyle: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.borderDark,
      ),
    );
  }

  static ThemeData _buildLight() {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary500,
      primaryContainer: AppColors.primary100,
      onPrimary: Colors.white,
      secondary: AppColors.secondary400,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary500,
      surface: AppColors.surfaceLight,
      surfaceContainerHighest: AppColors.surfaceCardLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.evidenceMissing,
      outline: AppColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceLight,
      cardColor: AppColors.surfaceCardLight,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.brandWordmark.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryLight),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryLight),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryLight),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryLight),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryLight),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryLight),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryLight),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryLight),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryLight),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryLight),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryLight),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryLight),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textSecondaryLight),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryLight),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedLight,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary500, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary500,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.borderLight,
      ),
    );
  }
}
