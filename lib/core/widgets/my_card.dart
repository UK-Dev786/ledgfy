import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

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
    this.blur = 0,
    this.tint = MyCardTint.auto,
    this.border = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final isDark = switch (tint) {
      MyCardTint.dark => true,
      MyCardTint.light => false,
      MyCardTint.auto => true,
    };

    final surfaceColor = isDark
        ? const Color(0xFF0D1A22)
        : AppColors.surface;
    final borderColor = isDark
        ? AppColors.primary.withValues(alpha: 0.10)
        : AppColors.black.withValues(alpha: 0.06);
    final topStroke = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.white.withValues(alpha: 0.55);
    final bottomShade = isDark
        ? AppColors.black.withValues(alpha: 0.16)
        : AppColors.black.withValues(alpha: 0.04);
    final deepShadow = AppColors.black.withValues(alpha: isDark ? 0.42 : 0.14);
    final softShadow = AppColors.black.withValues(alpha: isDark ? 0.18 : 0.08);

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: deepShadow,
            blurRadius: 32,
            spreadRadius: -10,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: softShadow,
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: radius,
          border: border ? Border.all(color: borderColor) : null,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: borderRadius * 0.5,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [topStroke, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: borderRadius * 0.8,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, bottomShade],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
