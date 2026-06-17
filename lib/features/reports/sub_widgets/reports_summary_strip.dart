import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';

class ReportsSummaryStrip extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netPl;

  const ReportsSummaryStrip({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netPl,
  });

  @override
  Widget build(BuildContext context) {
    final netColor = netPl > 0
        ? AppColors.success
        : netPl < 0
            ? AppColors.error
            : AppColors.textTertiary;

    return MyCard(
      borderRadius: AppSizes.radiusLg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: _Metric(
              label: AppText.reportsIncome,
              amount: totalIncome,
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
              amount: totalExpense,
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
              amount: netPl,
              color: netColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final double amount;
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
          CurrencyFormatter.format(amount, abbreviate: true),
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
