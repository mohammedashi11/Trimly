import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Manrope type scale from the Trimly design system.
abstract final class AppTextStyles {
  static TextStyle get displayLg => GoogleFonts.manrope(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -0.96,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineLg => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        letterSpacing: -0.32,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMd => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMd => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLg => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMd => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySm => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.textSecondary,
      );

  /// Uppercase metadata label, 14px / 600 / 0.05em tracking.
  static TextStyle get labelMd => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.7,
        color: AppColors.textPrimary,
      );

  /// Uppercase metadata label, 12px / 500 / 0.05em tracking.
  static TextStyle get labelSm => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.6,
        color: AppColors.textMuted,
      );
}
