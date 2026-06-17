import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/home_dashboard_data.dart';

class HomeRecordTile extends StatelessWidget {
  final HomeRecordItem entry;
  final VoidCallback? onTap;

  const HomeRecordTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountPrefix = entry.isIncome ? '+ ' : '− ';
    final amountColor = entry.isIncome ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: onTap,
      child: MyCard(
        borderRadius: AppSizes.radiusMd,
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              width: AppSizes.xxl,
              height: AppSizes.xxl,
              decoration: BoxDecoration(
                color: AppColors.primaryTint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                entry.icon,
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
                    entry.title,
                    font: AppFont.inter,
                    size: AppSizes.subtitle,
                    color: AppColors.white,
                    weight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  MyText(
                    '${entry.ledgerName} · ${DateFormat('dd MMM').format(entry.date)}',
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            MyText(
              '$amountPrefix${CurrencyFormatter.format(entry.amount)}',
              font: AppFont.inter,
              size: AppSizes.subtitle,
              color: amountColor,
              weight: FontWeight.w700,
              align: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
