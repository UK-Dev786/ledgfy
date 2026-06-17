import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';

class LedgerHeader extends StatelessWidget {
  const LedgerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedEntranceAnimation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            AppText.ledgersTitle,
            font: AppFont.inter,
            size: AppSizes.header2,
            color: AppColors.white,
            weight: FontWeight.w700,
          ),
          SizedBox(height: AppSizes.xs),
          MyText(
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
