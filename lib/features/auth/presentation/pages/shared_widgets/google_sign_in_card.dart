import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/my_card.dart';
import 'google_logo_icon.dart';

/// Rounded card with the Google logo only — UI placeholder (no auth wired yet).
class GoogleSignInCard extends StatelessWidget {
  final VoidCallback? onTap;

  const GoogleSignInCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.buttonHeight,
        height: AppSizes.buttonHeight,
        child: MyCard(
          borderRadius: AppSizes.radiusFull,
          blur: 16,
          padding: const EdgeInsets.all(AppSizes.md),
          child: const Center(child: GoogleLogoIcon(size: AppSizes.iconMd)),
        ),
      ),
    );
  }
}
