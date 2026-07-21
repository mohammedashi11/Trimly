import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Pill chip — dark stroke when idle, solid gold when selected.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  /// Disabled chips (e.g. unavailable time slots) render at 30% opacity.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? AppColors.gold : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          color: selected ? AppColors.onGold : AppColors.textSecondary,
        ),
      ),
    );

    if (!enabled) return Opacity(opacity: 0.3, child: chip);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}
