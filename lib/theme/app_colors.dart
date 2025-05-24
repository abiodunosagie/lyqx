import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors from Figma
  static const Color primaryGold = Color(0xFFF4D374);
  static const Color darkGray = Color(0xFF1E1E1E);
  static const Color accentGold = Color(0xFFD49F07);
  static const Color lightCream = Color(0xFFFFE8B2);
  static const Color lightGray = Color(0xFFF6F6F6);

  // Light Theme Colors
  static const Color lightBackground = Color(0x0fffffff);
  static const Color lightSurface = lightGray;
  static const Color lightOnPrimary = darkGray;
  static const Color lightOnSurface = darkGray;
  static const Color lightOnBackground = darkGray;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnPrimary = darkGray;
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkOnBackground = Color(0xFFE1E1E1);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Text Colors
  static const Color textPrimary = darkGray;
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextDisabled = Color(0xFF616161);
}