import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'my_card.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final double size;

  const RoundedButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.size = AppSizes.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: MyCard(
          tint: MyCardTint.dark,
          borderRadius: AppSizes.radiusFull,
          blur: 24,
          padding: EdgeInsets.zero,
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.42,
            ),
          ),
        ),
      ),
    );
  }
}
