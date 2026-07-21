import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Solid gold call-to-action button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
    this.radius = AppTheme.radiusCard,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional trailing icon (e.g. an arrow on onboarding).
  final IconData? icon;

  /// Whether the button stretches to the available width.
  final bool expanded;

  /// Swaps the label for a spinner and disables taps while an async
  /// action is in flight.
  final bool loading;

  final double radius;

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, size: 20, color: AppColors.onGold),
                ],
              ],
            ),
    );
    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}
