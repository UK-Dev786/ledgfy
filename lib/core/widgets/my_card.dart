import 'dart:ui';

import 'package:flutter/material.dart';

enum MyCardTint { auto, light, dark }

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final MyCardTint tint;
  final bool border;
  final double? height;

  const MyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.blur = 20,
    this.tint = MyCardTint.auto,
    this.border = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    final Color sheen = const Color(0xFF0A1820).withValues(alpha: 1.0);
    final Color glassBase = const Color(0xFF0A1820).withValues(alpha: 1.0);
    final Color dim = const Color(0xFF0A1820).withValues(alpha: 0.06);

    final Color borderTopLeft = const Color(0xFF36CFE6).withValues(alpha: 0.30);
    final Color borderBottomRight = const Color(
      0xFF36CFE6,
    ).withValues(alpha: 0.15);

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          // Deep drop shadow — lifts card off background
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.55),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          // Wide ambient teal glow
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.18),
            blurRadius: 48,
            spreadRadius: -4,
            offset: const Offset(0, 0),
          ),
          // Tight border glow — top
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.10),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, -2),
          ),
          // Tight border glow — bottom
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [sheen, glassBase, dim],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              padding: padding,
              child: child,
            ),

            if (border)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GradientBorderPainter(
                      radius: radius,
                      topLeft: borderTopLeft,
                      bottomRight: borderBottomRight,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final BorderRadius radius;
  final Color topLeft;
  final Color bottomRight;

  const _GradientBorderPainter({
    required this.radius,
    required this.topLeft,
    required this.bottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topLeft, bottomRight],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter old) =>
      old.topLeft != topLeft ||
      old.bottomRight != bottomRight ||
      old.radius != radius;
}
