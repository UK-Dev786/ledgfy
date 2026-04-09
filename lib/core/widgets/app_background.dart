import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Variants:
///   light — default for all data/ledger/POS screens (clean, near-white, dot-grid)
///   dark  — POS night mode / checkout (deep navy, faint green glow)
///   brand — splash & onboarding (emerald gradient, crisp rule lines)
enum AppBackgroundVariant { light, dark, brand }

class AppBackground extends StatelessWidget {
  final Widget child;
  final AppBackgroundVariant variant;

  const AppBackground({
    Key? key,
    required this.child,
    this.variant = AppBackgroundVariant.light,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _Base(variant: variant),
        _Texture(variant: variant),
        child,
      ],
    );
  }
}

// ─── Base gradient ────────────────────────────────────────────────────────────

class _Base extends StatelessWidget {
  final AppBackgroundVariant variant;
  const _Base({required this.variant});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      // Crisp emerald → teal for splash / onboarding
      case AppBackgroundVariant.brand:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00B871), // deep emerald
                Color(0xFF00A368), // mid green
                Color(0xFF008F60), // dark green
              ],
              stops: [0.0, 0.52, 1.0],
            ),
          ),
        );

      // Deep navy for POS / dark mode
      case AppBackgroundVariant.dark:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1829), // near-black navy
                Color(0xFF0F2035), // dark navy
                Color(0xFF0B1829), // near-black navy
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        );

      // Clean off-white for ledger / data screens
      case AppBackgroundVariant.light:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FB), // top: very slightly cool white
                Color(0xFFF3F5F8), // bottom: soft blue-grey
              ],
            ),
          ),
        );
    }
  }
}

// ─── Texture layer (CustomPaint) ──────────────────────────────────────────────

class _Texture extends StatelessWidget {
  final AppBackgroundVariant variant;
  const _Texture({required this.variant});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _TexturePainter(variant: variant));
  }
}

class _TexturePainter extends CustomPainter {
  final AppBackgroundVariant variant;
  const _TexturePainter({required this.variant});

  @override
  void paint(Canvas canvas, Size size) {
    switch (variant) {
      case AppBackgroundVariant.light:
        _paintDotGrid(canvas, size);
      case AppBackgroundVariant.dark:
        _paintDarkGlow(canvas, size);
      case AppBackgroundVariant.brand:
        _paintBrandLines(canvas, size);
    }
  }

  // ── Light: very faint dot-grid (accounting-paper feel) ───────────────────
  void _paintDotGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D084).withValues(alpha: 0.10)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (int c = 0; c <= cols; c++) {
      for (int r = 0; r <= rows; r++) {
        canvas.drawCircle(Offset(c * spacing, r * spacing), 1.1, paint);
      }
    }

    // Faint horizontal rule lines — evokes a ledger / notebook
    final linePaint = Paint()
      ..color = const Color(0xFF8AA0B4).withValues(alpha: 0.07)
      ..strokeWidth = 0.6;

    const lineSpacing = 56.0;
    final lineCount = (size.height / lineSpacing).ceil() + 1;
    for (int i = 0; i <= lineCount; i++) {
      final y = i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Subtle top-right corner arc — brand accent
    final arcPaint = Paint()
      ..color = const Color(0xFF00D084).withValues(alpha: 0.07)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (final r in [size.width * 0.35, size.width * 0.55, size.width * 0.75]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width, 0), radius: r),
        math.pi * 0.5,
        math.pi * 0.5,
        false,
        arcPaint,
      );
    }
  }

  // ── Dark: single soft green glow in the top area ──────────────────────────
  void _paintDarkGlow(Canvas canvas, Size size) {
    // One large, very soft green radial glow — like a terminal backlight
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF00D084).withValues(alpha: 0.10),
              const Color(0xFF00D084).withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.0),
              radius: size.width * 0.9,
            ),
          );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    // Fine horizontal scan lines — very dark, subtle
    final scanPaint = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.06)
      ..strokeWidth = 0.8;

    const scanSpacing = 4.0;
    final scanCount = (size.height / scanSpacing).ceil();
    for (int i = 0; i < scanCount; i++) {
      final y = i * scanSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }
  }

  // ── Brand: crisp diagonal rule lines on the gradient ─────────────────────
  void _paintBrandLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.06)
      ..strokeWidth = 0.8;

    const spacing = 36.0;
    final count = ((size.width + size.height) / spacing).ceil() + 2;

    for (int i = -2; i < count; i++) {
      final x = i * spacing;
      // 45° lines top-left → bottom-right
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        linePaint,
      );
    }

    // Bottom-left decorative arcs
    final arcPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (final r in [size.width * 0.45, size.width * 0.65, size.width * 0.85]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(0, size.height), radius: r),
        -math.pi * 0.5,
        math.pi * 0.5,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TexturePainter old) => old.variant != variant;
}
