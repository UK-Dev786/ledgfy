import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // ── Screen dimensions ──────────────────────────────────────────────────────
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // ── Responsive fractions ───────────────────────────────────────────────────
  double get w => screenWidth / 100;   // 1% of screen width
  double get h => screenHeight / 100;  // 1% of screen height

  // ── Safe area ──────────────────────────────────────────────────────────────
  double get paddingTop => MediaQuery.paddingOf(this).top;
  double get paddingBottom => MediaQuery.paddingOf(this).bottom;

  // ── Breakpoints ────────────────────────────────────────────────────────────
  bool get isSmall => screenWidth < 360;
  bool get isMedium => screenWidth >= 360 && screenWidth < 600;
  bool get isLarge => screenWidth >= 600;
}
