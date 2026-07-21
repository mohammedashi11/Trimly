import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Trimly scissors-monogram: a letter "T" whose stem opens into
/// scissor finger-rings. Drawn as a vector so it stays crisp at any size.
class TrimlyLogo extends StatelessWidget {
  const TrimlyLogo({
    super.key,
    this.size = 96,
    this.color = AppColors.gold,
    this.glow = false,
  });

  final double size;
  final Color color;

  /// Adds the soft ambient halo used on the splash screen.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: Size(size, size),
      painter: _ScissorsMonogramPainter(color: color),
    );

    if (!glow) return mark;

    return Container(
      padding: EdgeInsets.all(size * 0.35),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [AppColors.goldGlow, Colors.transparent],
        ),
      ),
      child: mark,
    );
  }
}

class _ScissorsMonogramPainter extends CustomPainter {
  const _ScissorsMonogramPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 100;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * unit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Offset p(double x, double y) => Offset(x * unit, y * unit);

    // Crossbar of the "T".
    canvas.drawLine(p(18, 16), p(82, 16), paint);
    // Stem descending to the pivot.
    canvas.drawLine(p(50, 16), p(50, 52), paint);
    // Blades opening outwards from the pivot.
    canvas.drawLine(p(50, 52), p(37, 65), paint);
    canvas.drawLine(p(50, 52), p(63, 65), paint);
    // Short center tail between the rings.
    canvas.drawLine(p(50, 52), p(50, 68), paint);
    // Finger rings.
    canvas.drawCircle(p(31, 75), 12 * unit, paint);
    canvas.drawCircle(p(69, 75), 12 * unit, paint);
  }

  @override
  bool shouldRepaint(_ScissorsMonogramPainter oldDelegate) =>
      oldDelegate.color != color;
}
