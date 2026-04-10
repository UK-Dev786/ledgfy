import 'dart:math' as math;

import 'package:flutter/material.dart';

enum AppBackgroundVariant { light, dark, brand }

class AppBackgroundGradients {
  AppBackgroundGradients._();

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A181C), Color(0xFF0B1017)],
  );
  static const LinearGradient normal = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF091317), Color(0xFF060C1B)],
  );
}
