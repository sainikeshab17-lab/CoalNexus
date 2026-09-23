import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Industrial Palette
  static const Color coalBlack = Color(0xFF121212);
  static const Color industrialBlue = Color(0xFF1E3A8A);
  static const Color safetyAmber = Color(0xFFD97706);
  static const Color alertRed = Color(0xFFDC2626);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color infoBlue = Color(0xFF2563EB);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // Risk Semantic Colors
  static const Color riskHigh = alertRed;
  static const Color riskMedium = safetyAmber;
  static const Color riskLow = successGreen;
  static const Color riskCritical = Color(0xFF7F1D1D);

  // Neutral
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);
}
