import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../ledger/shared/sub_widgets/ledger_amount_expand_button.dart';

class ReportsSummaryStrip extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netPl;
  final bool showFullAmounts;
  final VoidCallback onToggleAmounts;

  const ReportsSummaryStrip({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netPl,
    required this.showFullAmounts,
    required this.onToggleAmounts,
  });

  String _format(double amount) {
    if (showFullAmounts) return CurrencyFormatter.format(amount);
    return CurrencyFormatter.formatCompact(amount);
  }

  @override
  Widget build(BuildContext context) {
    final netColor = netPl > 0
        ? AppColors.success
        : netPl < 0
            ? AppColors.error
            : AppColors.textTertiary;

    return MyCard(
      borderRadius: AppSizes.radiusLg,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.sm,
        AppSizes.md,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: AppText.reportsIncome,
                    amount: _format(totalIncome),
                    color: AppColors.success,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider.withValues(alpha: 0.12),
                ),
                Expanded(
                  child: _Metric(
                    label: AppText.reportsExpense,
                    amount: _format(totalExpense),
                    color: AppColors.error,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider.withValues(alpha: 0.12),
                ),
                Expanded(
                  child: _Metric(
                    label: AppText.reportsNetPl,
                    amount: _format(netPl),
                    color: netColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: LedgerAmountExpandButton(
              showFullAmounts: showFullAmounts,
              onTap: onToggleAmounts,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _Metric({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(
          label,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
          align: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.xs),
        MyText(
          amount,
          font: AppFont.inter,
          size: AppSizes.subtitle,
          color: color,
          weight: FontWeight.w700,
          align: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
