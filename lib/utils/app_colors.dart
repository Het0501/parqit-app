import 'package:flutter/material.dart';

/// PARQIT brand color constants.
/// All colors for the app are defined here — never hardcode colors in widgets.
class AppColors {
  AppColors._();

  // Primary brand gradient
  static const Color primaryDark = Color(0xFF0A0F1E);   // deep navy
  static const Color primaryMid = Color(0xFF0D1B3E);    // midnight blue
  static const Color accentCyan = Color(0xFF00E5FF);    // electric cyan
  static const Color accentBlue = Color(0xFF2979FF);    // vivid blue

  // Gradient used on the splash & key backgrounds
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryMid],
  );

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textMuted = Color(0xFF546E7A);

  // Status
  static const Color slotAvailable = Color(0xFF00C853); // green
  static const Color slotOccupied = Color(0xFFD50000);  // red

  // Surface / card
  static const Color surface = Color(0xFF131C35);
  static const Color surfaceLight = Color(0xFF1E2A4A);
}
