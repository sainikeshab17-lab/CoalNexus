import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const TextStyle display = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
}
