import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Monogram avatar: initials on a tonal circle, optional gold ring.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.ringColor,
    this.ringWidth = 2,
  });

  final String initials;
  final double size;

  /// Gold for selected/active states, border grey otherwise.
  final Color? ringColor;

  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceHighest,
        border: Border.all(
          color: ringColor ?? AppColors.border,
          width: ringWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.manrope(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w700,
          color: AppColors.gold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
