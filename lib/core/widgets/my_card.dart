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
  final bool cutTopRightCorner;
  final double cornerCutSize;
  final Widget? topRightCorner;

  const MyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.blur = 20,
    this.tint = MyCardTint.auto,
    this.border = true,
    this.height,
    this.cutTopRightCorner = false,
    this.cornerCutSize = 44,
    this.topRightCorner,
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

    final clipper = cutTopRightCorner
        ? _TopRightCornerCutClipper(
            radius: borderRadius,
            cutSize: cornerCutSize,
          )
        : null;

    final cardBody = Stack(
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
            borderRadius: cutTopRightCorner ? null : radius,
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
                painter: cutTopRightCorner
                    ? _CutCornerBorderPainter(
                        radius: borderRadius,
                        cutSize: cornerCutSize,
                        topLeft: borderTopLeft,
                        bottomRight: borderBottomRight,
                      )
                    : _GradientBorderPainter(
                        radius: radius,
                        topLeft: borderTopLeft,
                        bottomRight: borderBottomRight,
                      ),
              ),
            ),
          ),
      ],
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.55),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.18),
            blurRadius: 48,
            spreadRadius: -4,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.10),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: const Color(0xFF36CFE6).withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (clipper != null)
            ClipPath(clipper: clipper, child: cardBody)
          else
            ClipRRect(borderRadius: radius, child: cardBody),
          if (cutTopRightCorner && topRightCorner != null)
            Positioned(
              top: 0,
              right: 0,
              child: _TopRightCornerTab(
                size: cornerCutSize,
                cutSize: cornerCutSize,
                child: topRightCorner!,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopRightCornerTab extends StatelessWidget {
  final double size;
  final double cutSize;
  final Widget child;

  const _TopRightCornerTab({
    required this.size,
    required this.cutSize,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TopRightCornerTabClipper(cutSize: cutSize),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF12313A),
              const Color(0xFF0A1820).withValues(alpha: 0.98),
            ],
          ),
          border: Border(
            left: BorderSide(
              color: const Color(0xFF36CFE6).withValues(alpha: 0.22),
            ),
            bottom: BorderSide(
              color: const Color(0xFF36CFE6).withValues(alpha: 0.18),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF36CFE6).withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(-1, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: size * 0.20,
              right: size * 0.14,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRightCornerCutClipper extends CustomClipper<Path> {
  final double radius;
  final double cutSize;

  const _TopRightCornerCutClipper({
    required this.radius,
    required this.cutSize,
  });

  @override
  Path getClip(Size size) => _cutCornerPath(size, radius, cutSize);

  @override
  bool shouldReclip(_TopRightCornerCutClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.cutSize != cutSize;
  }
}

class _TopRightCornerTabClipper extends CustomClipper<Path> {
  final double cutSize;

  const _TopRightCornerTabClipper({required this.cutSize});

  @override
  Path getClip(Size size) => _roundedCornerTabPath(size, cutSize);

  @override
  bool shouldReclip(_TopRightCornerTabClipper oldClipper) {
    return oldClipper.cutSize != cutSize;
  }
}

double _cornerNotchRadius(double cut) => cut * 0.92;

Path _roundedCornerTabPath(Size size, double cut) {
  final notchRadius = _cornerNotchRadius(cut);
  return Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..arcToPoint(
      Offset.zero,
      radius: Radius.circular(notchRadius),
      clockwise: false,
    )
    ..close();
}

Path _cutCornerPath(Size size, double radius, double cutSize) {
  final width = size.width;
  final height = size.height;
  final cut = cutSize.clamp(0.0, width / 2);
  final notchRadius = _cornerNotchRadius(cut);

  final path = Path()
    ..moveTo(radius, 0)
    ..lineTo(width - cut, 0)
    ..arcToPoint(
      Offset(width, cut),
      radius: Radius.circular(notchRadius),
      clockwise: true,
    )
    ..lineTo(width, height - radius)
    ..arcToPoint(
      Offset(width - radius, height),
      radius: Radius.circular(radius),
    )
    ..lineTo(radius, height)
    ..arcToPoint(
      Offset(0, height - radius),
      radius: Radius.circular(radius),
    )
    ..lineTo(0, radius)
    ..arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    )
    ..close();

  return path;
}

class _CutCornerBorderPainter extends CustomPainter {
  final double radius;
  final double cutSize;
  final Color topLeft;
  final Color bottomRight;

  const _CutCornerBorderPainter({
    required this.radius,
    required this.cutSize,
    required this.topLeft,
    required this.bottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _cutCornerPath(size, radius, cutSize);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topLeft, bottomRight],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CutCornerBorderPainter old) {
    return old.radius != radius ||
        old.cutSize != cutSize ||
        old.topLeft != topLeft ||
        old.bottomRight != bottomRight;
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

/// Clip helper for swipe backgrounds that should match [MyCard] corner cuts.
class MyCardCornerCutClipper extends CustomClipper<Path> {
  final double radius;
  final double cutSize;

  const MyCardCornerCutClipper({
    required this.radius,
    required this.cutSize,
  });

  @override
  Path getClip(Size size) => _cutCornerPath(size, radius, cutSize);

  @override
  bool shouldReclip(MyCardCornerCutClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.cutSize != cutSize;
  }
}
