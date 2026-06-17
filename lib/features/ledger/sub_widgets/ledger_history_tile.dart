import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/ledger_entry.dart';

class LedgerHistoryTile extends StatelessWidget {
  final LedgerEntry entry;

  const LedgerHistoryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.type == LedgerEntryType.income;
    final color = isIncome ? AppColors.success : AppColors.error;
    final icon = isIncome
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final label = isIncome
        ? AppText.ledgerDetailIncome
        : AppText.ledgerDetailOutgoing;
    final timeLabel = DateFormat('MMM d, h:mm a').format(entry.createdAt);

    return MyCard(
      borderRadius: AppSizes.radiusMd,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: color.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconSm),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  label,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                MyText(
                  timeLabel,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: MyText(
                CurrencyFormatter.format(entry.amount, compact: true),
                font: AppFont.inter,
                size: AppSizes.subtitle,
                color: color,
                weight: FontWeight.w700,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
