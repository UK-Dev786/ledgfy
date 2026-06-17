import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';

class LedgerEmptyState extends StatelessWidget {
  const LedgerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      delay: const Duration(milliseconds: 120),
      child: MyCard(
        borderRadius: AppSizes.radiusLg,
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              color: AppColors.textHint.withValues(alpha: 0.9),
              size: AppSizes.iconLg,
            ),
            const SizedBox(height: AppSizes.md),
            MyText(
              AppText.ledgersEmptyTitle,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            MyText(
              AppText.ledgersEmptySubtitle,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              align: TextAlign.center,
              height: 1.45,
            ),
          ],
        ),
      ),
    );
  }
}
