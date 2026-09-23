import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.industrialBlue,
        primary: AppColors.industrialBlue,
        secondary: AppColors.safetyAmber,
        error: AppColors.alertRed,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.grey900,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title.copyWith(color: AppColors.grey900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.grey200),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.display,
        headlineMedium: AppTypography.headline,
        titleLarge: AppTypography.title,
        bodyLarge: AppTypography.body,
        labelLarge: AppTypography.label,
        bodySmall: AppTypography.caption,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.industrialBlue.withValues(alpha: 0.1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.industrialBlue);
          }
          return const IconThemeData(color: AppColors.grey500);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.label.copyWith(color: AppColors.industrialBlue);
          }
          return AppTypography.label.copyWith(color: AppColors.grey500);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.industrialBlue,
        brightness: Brightness.dark,
        primary: AppColors.industrialBlue,
        secondary: AppColors.safetyAmber,
        error: AppColors.alertRed,
        surface: AppColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.grey100,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.grey100,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title.copyWith(color: AppColors.grey100),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.grey800),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: AppColors.grey100),
        headlineMedium: AppTypography.headline.copyWith(color: AppColors.grey100),
        titleLarge: AppTypography.title.copyWith(color: AppColors.grey100),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.grey300),
        labelLarge: AppTypography.label.copyWith(color: AppColors.grey300),
        bodySmall: AppTypography.caption.copyWith(color: AppColors.grey500),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.industrialBlue.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.industrialBlue);
          }
          return const IconThemeData(color: AppColors.grey400);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.label.copyWith(color: AppColors.industrialBlue);
          }
          return AppTypography.label.copyWith(color: AppColors.grey400);
        }),
      ),
    );
  }
}
