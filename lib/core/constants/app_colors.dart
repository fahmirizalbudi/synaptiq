import 'package:flutter/material.dart';

/// App color constants extracted from design
/// Dark theme with coral accent
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFE79471);
  static const Color primaryLight = Color(0x33E79471);

  // Background Colors
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF171717);
  static const Color surfaceVariant = Color(0xFF212121);
  static const Color surfaceDim = Color(0xFF131313);

  // Border Colors
  static const Color border = Color(0xFF2E2E2E);
  static const Color borderLight = Color(0x1AFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFD9D9D9);
  static const Color textSecondary = Color(0xFF7E7E7E);
  static const Color textTertiary = Color(0xFFAEAEAE);

  // Semantic Colors
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);

  // Icon Colors
  static const Color iconPrimary = Colors.white;
  static const Color iconSecondary = Color(0xFF7E7E7E);
  static const Color iconAccent = Color(0xFFE79471);
}
