import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF004AC6);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF434655);
  static const Color secondary = Color(0xFF565E74);
  static const Color outline = Color(0xFF737686);
  static const Color error = Color(0xFFBA1A1A);
  static const Color tertiaryContainer = Color(0xFF007D55);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x140B1C30);
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    color: AppColors.onSurface,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineSmall = TextStyle(
    color: AppColors.onSurface,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle title = TextStyle(
    color: AppColors.onSurface,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.onSurfaceVariant,
    fontSize: 14,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.onSurfaceVariant,
    fontSize: 12,
  );

  static const TextStyle secondaryBody = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle helper = TextStyle(
    color: AppColors.secondary,
    fontSize: 12,
  );

  static const TextStyle action = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}
