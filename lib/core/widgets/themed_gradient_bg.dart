import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_background.dart';

class ThemedGradientBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const ThemedGradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient ?? AppBackgroundGradients.splashGradient,
        ),
        child: child,
      ),
    );
  }
}
