import 'package:flutter/material.dart';

/// Trimly "Noir Luxe" palette.
///
/// Single source of truth for every color in the app — widgets must never
/// hardcode color values.
abstract final class AppColors {
  // Foundation
  static const Color background = Color(0xFF141414);
  static const Color surfaceLowest = Color(0xFF0E0E0E);
  static const Color surfaceLow = Color(0xFF1C1B1B);
  static const Color surface = Color(0xFF201F1F);
  static const Color surfaceHigh = Color(0xFF2A2A2A);
  static const Color surfaceHighest = Color(0xFF353534);

  // Structure
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderMuted = Color(0xFF4D4635);

  // Brand
  static const Color gold = Color(0xFFF2CA50);
  static const Color goldDim = Color(0xFFE9C349);
  static const Color onGold = Color(0xFF3C2F00);

  // Typography
  static const Color textPrimary = Color(0xFFE5E2E1);
  static const Color textSecondary = Color(0xFFC8C6C5);
  static const Color textMuted = Color(0xFF99907C);

  // Feedback
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);

  // Overlays
  static const Color scrim = Color(0xB3000000);
  static const Color goldGlow = Color(0x33F2CA50);
}
