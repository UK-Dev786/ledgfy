import 'package:flutter/material.dart';

/// Official multicolor Google "G" — UI only, no external assets.
class GoogleLogoIcon extends StatelessWidget {
  final double size;

  const GoogleLogoIcon({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48;
    canvas.scale(scale);

    _draw(canvas, const Color(0xFFEA4335), () {
      final p = Path()..moveTo(24, 9.5);
      p.cubicTo(27.54, 9.5, 30.71, 10.72, 33.21, 13.1);
      p.lineTo(40.06, 6.25);
      p.cubicTo(35.9, 2.38, 30.47, 0, 24, 0);
      p.cubicTo(14.62, 0, 6.51, 5.38, 2.56, 13.22);
      p.lineTo(10.54, 19.41);
      p.cubicTo(12.43, 13.72, 17.74, 9.5, 24, 9.5);
      p.close();
      return p;
    });

    _draw(canvas, const Color(0xFF4285F4), () {
      final p = Path()
        ..moveTo(46.98, 24.55)
        ..cubicTo(46.98, 22.98, 46.83, 21.46, 46.6, 20)
        ..lineTo(24, 20)
        ..lineTo(24, 29.02)
        ..lineTo(36.94, 29.02)
        ..cubicTo(36.36, 31.98, 34.68, 34.5, 31.9, 36.18)
        ..lineTo(39.63, 42.18)
        ..cubicTo(44.14, 38, 46.98, 31.81, 46.98, 24.55)
        ..close();
      return p;
    });

    _draw(canvas, const Color(0xFFFBBC05), () {
      final p = Path()
        ..moveTo(10.53, 28.59)
        ..cubicTo(10.05, 27.14, 9.79, 25.59, 9.79, 24)
        ..cubicTo(9.79, 22.41, 10.06, 20.86, 10.53, 19.41)
        ..lineTo(2.55, 13.22)
        ..cubicTo(0.92, 16.46, 0, 20.12, 0, 24)
        ..cubicTo(0, 27.88, 0.92, 31.54, 2.56, 34.78)
        ..lineTo(10.53, 28.59)
        ..close();
      return p;
    });

    _draw(canvas, const Color(0xFF34A853), () {
      final p = Path()
        ..moveTo(24, 48)
        ..cubicTo(30.48, 48, 36.93, 45.87, 40.89, 42.19)
        ..lineTo(33.16, 36.19)
        ..cubicTo(30.31, 37.64, 27.08, 38.44, 23.84, 38.44)
        ..cubicTo(17.58, 38.44, 12.27, 34.22, 10.37, 28.53)
        ..lineTo(2.39, 34.72)
        ..cubicTo(6.51, 42.62, 14.62, 48, 24, 48)
        ..close();
      return p;
    });
  }

  void _draw(Canvas canvas, Color color, Path Function() builder) {
    canvas.drawPath(
      builder(),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
