import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Row of gold stars for a 0–5 rating. Supports halves and tap-to-rate.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.onRate,
  });

  final double rating;
  final double size;

  /// When provided, stars become tappable (used to rate past bookings).
  final ValueChanged<int>? onRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final IconData icon = rating >= i + 1
            ? Icons.star_rounded
            : rating > i
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        final star = Icon(
          icon,
          size: size,
          color: rating > i ? AppColors.gold : AppColors.textMuted,
        );
        if (onRate == null) return star;
        return GestureDetector(
          onTap: () => onRate!(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: star,
          ),
        );
      }),
    );
  }
}
