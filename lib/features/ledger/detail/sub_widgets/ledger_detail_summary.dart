import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../models/ledger_item.dart';
import '../../shared/sub_widgets/ledger_flow_amount.dart';

class LedgerDetailSummary extends StatelessWidget {
  final LedgerItem ledger;

  const LedgerDetailSummary({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    final config = ledger.config;

    if (config.isExpenseOnly) {
      return SharedEntranceAnimation(
        child: MyCard(
          borderRadius: AppSizes.radiusLg,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          child: Column(
            children: [
              MyText(
                config.balanceLabel,
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.textHint,
              ),
              const SizedBox(height: AppSizes.sm),
              LedgerFlowAmount(
                icon: config.debitIcon,
                color: config.debitColor,
                amount: ledger.balance,
                compact: true,
              ),
            ],
          ),
        ),
      );
    }

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
                label: config.creditLabel,
                child: LedgerFlowAmount(
                  icon: config.creditIcon,
                  color: config.creditColor,
                  amount: ledger.creditTotal,
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
                label: config.debitLabel,
                child: LedgerFlowAmount(
                  icon: config.debitIcon,
                  color: config.debitColor,
                  amount: ledger.debitTotal,
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
                label: config.balanceLabel,
                child: LedgerFlowAmount(
                  icon: Icons.account_balance_wallet_outlined,
                  color: _balanceColor(ledger.balance),
                  amount: ledger.balance,
                  compact: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _balanceColor(double balance) {
    if (balance > 0) return AppColors.success;
    if (balance < 0) return AppColors.error;
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
