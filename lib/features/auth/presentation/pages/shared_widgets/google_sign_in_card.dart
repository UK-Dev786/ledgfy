import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/my_card.dart';
import 'google_logo_icon.dart';

class GoogleSignInCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool loading;

  const GoogleSignInCard({
    super.key,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onTap: loading ? null : onTap,
      child: SizedBox(
        width: AppSizes.buttonHeight,
        height: AppSizes.buttonHeight,
        child: MyCard(
          borderRadius: AppSizes.radiusFull,
          blur: 16,
          padding: const EdgeInsets.all(AppSizes.md),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  )
                : const GoogleLogoIcon(size: AppSizes.iconMd),
          ),
        ),
      ),
    );
  }
}
