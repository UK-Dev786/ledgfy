import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../models/ledger_item.dart';

class LedgerTile extends StatelessWidget {
  final LedgerItem ledger;
  final int index;

  const LedgerTile({
    super.key,
    required this.ledger,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      delay: Duration(milliseconds: 80 * index.clamp(0, 4)),
      child: MyCard(
        borderRadius: AppSizes.radiusLg,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                ledger.type.icon,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    ledger.title,
                    font: AppFont.inter,
                    size: AppSizes.title,
                    color: AppColors.white,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  MyText(
                    ledger.type.label,
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
