import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Outlined ghost button — 1px border, transparent fill.
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.leading,
    this.expanded = true,
    this.radius = AppTheme.radiusCard,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional custom leading widget (e.g. a brand mark).
  final Widget? leading;

  final bool expanded;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        // The theme's full-width minimum only applies when expanded;
        // inline buttons size to their content.
        minimumSize: expanded
            ? null
            : const Size(120, AppTheme.buttonHeight),
        padding: expanded
            ? null
            : const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ] else if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}
