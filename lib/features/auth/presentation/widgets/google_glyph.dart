import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The four-color Google "G", painted locally so no network asset is needed.
class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const _GoogleGPainter(),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  const _GoogleGPainter();

  static const _blue = Color(0xFF4285F4);
  static const _green = Color(0xFF34A853);
  static const _yellow = Color(0xFFFBBC05);
  static const _red = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    double rad(double deg) => deg * math.pi / 180;

    canvas.drawArc(rect, rad(0), rad(45), false, paint..color = _blue);
    canvas.drawArc(rect, rad(45), rad(90), false, paint..color = _green);
    canvas.drawArc(rect, rad(135), rad(90), false, paint..color = _yellow);
    canvas.drawArc(rect, rad(225), rad(90), false, paint..color = _red);

    // Horizontal bar of the G.
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2,
        (size.height - stroke) / 2,
        size.width / 2,
        stroke,
      ),
      Paint()..color = _blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
