import 'dart:ui';

import 'package:flutter/material.dart';

/// A frosted-glass "mirror" card sized exactly to its child.
///
/// Usage:
///   MirrorCard(child: YourWidget())
///   MirrorCard(tint: MirrorCardTint.dark, child: YourWidget())
///
/// [tint]   — auto (follows theme) | light | dark
/// [blur]   — backdrop blur sigma (default 20)
/// [border] — gradient glass-highlight border (default true)
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

    // Mirror glass — bright, reflective, with a green shimmer.
    // Looks like frosted glass over an emerald surface.

    // Fill gradient: pure white sheen → translucent white → mint tint
    final Color sheen = const Color(0xFFFFFFFF).withValues(alpha: 0.92);
    final Color glassBase = const Color(0xFFFFFFFF).withValues(alpha: 0.88);
    final Color dim = const Color(0xFFBFF3E0).withValues(alpha: 0.12);

    // Border: crisp white highlight top-left, green accent bottom-right
    const Color borderTopLeft = Color(0xFFD6F6EB);
    final Color borderBottomRight = const Color(0xFFD6F6EB);

    // The card is sized by its child. BackdropFilter sits inside a ClipRRect
    // that is constrained to the card's own size via IntrinsicHeight/Width,
    // so it never expands beyond the content.
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          // Outer glow — green brand colour
          BoxShadow(
            color: const Color(0xFF818080).withValues(alpha: 0.15),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(5, 0),
          ),
          // Mid shadow
          BoxShadow(
            color: const Color(0xFF818080).withValues(alpha: 0.15),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
          // Top white lift — simulates light source above
          BoxShadow(
            color: const Color(0xFFC2F8E9).withValues(alpha: 0.30),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      // ClipRRect constrains the blur to the card shape & size
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit:
              StackFit.passthrough, // ← sizes Stack to its non-positioned child
          children: [
            // ── Blur layer (must be first so it blurs what's behind) ──────
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: const SizedBox.expand(),
              ),
            ),

            // ── Glass fill + content (drives the card's size) ─────────────
            Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [sheen, glassBase, dim],
                  stops: const [0.0, 0.35, 1.5],
                ),
              ),
              padding: padding,
              child: child,
            ),

            // ── Gradient border on top ─────────────────────────────────────
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

// ─── Gradient border painter ──────────────────────────────────────────────────

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
