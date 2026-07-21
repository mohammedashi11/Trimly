import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Standard Trimly container: 1px border, 16px radius, tonal fill.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surfaceLow,
    this.borderColor = AppColors.border,
    this.radius = AppTheme.radiusCard,
    this.onTap,
    this.clipContent = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  /// Gold when the card is focused/selected, per the design system.
  final Color borderColor;

  final double radius;
  final VoidCallback? onTap;

  /// Clips the child to the rounded shape (for edge-to-edge imagery).
  final bool clipContent;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor),
    );

    Widget content = Padding(padding: padding, child: child);
    if (clipContent) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: content,
      );
    }

    return Material(
      color: color,
      shape: shape,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              customBorder: shape,
              child: content,
            ),
    );
  }
}
