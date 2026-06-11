import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      delay: const Duration(milliseconds: 300),
      child: MyCard(
        borderRadius: AppSizes.radiusLg,
        child: Column(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.textHint,
              size: AppSizes.iconLg,
            ),
            const SizedBox(height: AppSizes.md),
            MyText(
              AppText.homeNoRecordsTitle,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            MyText(
              AppText.homeNoRecordsSubtitle,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            MyButton(
              text: AppText.homeAddFirstRecord,
              onTap: () {
                // TODO: navigate to Add Ledger Entry.
              },
            ),
          ],
        ),
      ),
    );
  }
}
