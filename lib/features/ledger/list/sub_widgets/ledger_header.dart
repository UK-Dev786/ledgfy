import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../product/khata_pro.dart';

class LedgerHeader extends StatelessWidget {
  const LedgerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: MyText(
                  AppText.ledgersTitle,
                  font: AppFont.inter,
                  size: AppSizes.header2,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm + 2,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: MyText(
                  KhataPro.edition,
                  font: AppFont.inter,
                  size: AppSizes.caption,
                  color: AppColors.white,
                  weight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          const MyText(
            AppText.ledgersSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.subtitle,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}
