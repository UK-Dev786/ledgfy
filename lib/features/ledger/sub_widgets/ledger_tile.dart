import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../models/ledger_item.dart';
import 'ledger_flow_amount.dart';

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
          vertical: AppSizes.sm + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                ledger.type.icon,
                color: AppColors.primary,
                size: AppSizes.iconSm + 2,
              ),
            ),
            const SizedBox(width: AppSizes.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    ledger.title,
                    font: AppFont.inter,
                    size: AppSizes.subtitle,
                    color: AppColors.white,
                    weight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (ledger.hasDescription) ...[
                    const SizedBox(height: 2),
                    MyText(
                      ledger.description,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: AppSizes.sm + 2,
                    runSpacing: AppSizes.xs,
                    children: [
                      LedgerFlowAmount(
                        icon: Icons.arrow_upward_rounded,
                        color: AppColors.success,
                        amount: ledger.income,
                        compact: true,
                      ),
                      LedgerFlowAmount(
                        icon: Icons.arrow_downward_rounded,
                        color: AppColors.error,
                        amount: ledger.outgoing,
                        compact: true,
                      ),
                      LedgerFlowAmount(
                        icon: Icons.account_balance_wallet_outlined,
                        color: _subtotalColor(ledger.subtotal),
                        amount: ledger.subtotal,
                        compact: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: AppSizes.iconSm + 2,
            ),
          ],
        ),
      ),
    );
  }

  Color _subtotalColor(double subtotal) {
    if (subtotal > 0) return AppColors.success;
    if (subtotal < 0) return AppColors.error;
    return AppColors.textTertiary;
  }
}
