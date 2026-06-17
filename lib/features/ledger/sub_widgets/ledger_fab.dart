import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/my_card.dart';

class LedgerFab extends StatelessWidget {
  final VoidCallback onTap;

  const LedgerFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.buttonHeight,
        height: AppSizes.buttonHeight,
        child: MyCard(
          tint: MyCardTint.dark,
          borderRadius: AppSizes.radiusFull,
          blur: 24,
          padding: EdgeInsets.zero,
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: AppColors.primary,
              size: AppSizes.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
