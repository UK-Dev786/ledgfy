import 'dart:ui';

import 'package:flutter/material.dart';

enum MirrorCardTint { auto, light, dark }

class MirrorCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final MirrorCardTint tint;
  final bool border;

  const MirrorCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.blur = 20,
    this.tint = MirrorCardTint.auto,
    this.border = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    final Color sheen = const Color(0xFF0A1820).withValues(alpha: 1.0);
    final Color glassBase = const Color(0xFF0A1820).withValues(alpha: 1.0);
    final Color dim = const Color(0xFF0A1820).withValues(alpha: 0.06);

    final Color borderTopLeft = const Color(0xFF112A37).withValues(alpha: 0.90);
    final Color borderBottomRight = const Color(
      0xFF0D1F29,
    ).withValues(alpha: 0.80);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.50),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),

          BoxShadow(
            color: const Color(0xFF00132B).withValues(alpha: 0.12),
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: const SizedBox.expand(),
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
                child: CustomPaint(
                  painter: _GradientBorderPainter(
                    radius: radius,
                    topLeft: borderTopLeft,
                    bottomRight: borderBottomRight,
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
      ..strokeWidth = 2
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
