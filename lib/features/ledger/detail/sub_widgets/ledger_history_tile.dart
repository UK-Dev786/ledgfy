import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_type_config.dart';

class LedgerHistoryTile extends StatelessWidget {
  final LedgerEntry entry;
  final LedgerTypeConfig config;
  final bool showFullAmounts;
  final bool preferDescriptionAsTitle;

  const LedgerHistoryTile({
    super.key,
    required this.entry,
    required this.config,
    required this.showFullAmounts,
    this.preferDescriptionAsTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = config.colorForEntry(entry.type);
    final icon = config.iconForEntry(entry.type);
    final timeLabel = DateFormat('MMM d, h:mm a').format(entry.createdAt);
    final displayName = _displayName();

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
                  displayName,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                MyText(
                  timeLabel,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: MyText(
              CurrencyFormatter.format(
                entry.amount,
                abbreviate: !showFullAmounts,
              ),
              font: AppFont.inter,
              size: AppSizes.subtitle,
              color: color,
              weight: FontWeight.w700,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _displayName() {
    if (preferDescriptionAsTitle) {
      if (entry.note != null && entry.note!.trim().isNotEmpty) {
        return entry.note!.trim();
      }
      return AppText.ledgerDefaultEntryName;
    }

    if (entry.partyName != null && entry.partyName!.trim().isNotEmpty) {
      return entry.partyName!.trim();
    }
    if (entry.note != null && entry.note!.trim().isNotEmpty) {
      return entry.note!.trim();
    }
    if (entry.category != null && entry.category!.trim().isNotEmpty) {
      return entry.category!.trim();
    }
    return AppText.ledgerDefaultEntryName;
  }
}
