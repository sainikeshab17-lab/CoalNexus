import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E3A8A), // Deep Industrial Blue
        brightness: Brightness.light,
        primary: const Color(0xFF1E3A8A),
        secondary: const Color(0xFFD97706), // Amber Safety Amber
        error: const Color(0xFFDC2626), // Industrial Red
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E3A8A),
        brightness: Brightness.dark,
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFFF59E0B),
        error: const Color(0xFFEF4444),
      ),
    );
  }
}
