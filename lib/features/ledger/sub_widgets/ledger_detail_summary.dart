import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../models/ledger_item.dart';
import 'ledger_flow_amount.dart';

class LedgerDetailSummary extends StatelessWidget {
  final LedgerItem ledger;

  const LedgerDetailSummary({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      child: MyCard(
        borderRadius: AppSizes.radiusLg,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: AppText.ledgerDetailIncome,
                child: LedgerFlowAmount(
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.success,
                  amount: ledger.income,
                  compact: true,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: AppColors.divider.withValues(alpha: 0.12),
            ),
            Expanded(
              child: _SummaryItem(
                label: AppText.ledgerDetailOutgoing,
                child: LedgerFlowAmount(
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.error,
                  amount: ledger.outgoing,
                  compact: true,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: AppColors.divider.withValues(alpha: 0.12),
            ),
            Expanded(
              child: _SummaryItem(
                label: AppText.ledgerDetailSubtotal,
                child: LedgerFlowAmount(
                  icon: Icons.account_balance_wallet_outlined,
                  color: _subtotalColor(ledger.subtotal),
                  amount: ledger.subtotal,
                  compact: true,
                ),
              ),
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

class _SummaryItem extends StatelessWidget {
  final String label;
  final Widget child;

  const _SummaryItem({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            label,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            align: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.sm),
          child,
        ],
      ),
    );
  }
}
