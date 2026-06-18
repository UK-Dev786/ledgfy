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
import 'ledger_delete_dialog.dart';

class LedgerHistoryTile extends StatelessWidget {
  final LedgerEntry entry;
  final LedgerTypeConfig config;
  final bool showFullAmounts;
  final bool preferDescriptionAsTitle;
  final VoidCallback? onEdit;
  final ValueChanged<LedgerEntry>? onDelete;

  const LedgerHistoryTile({
    super.key,
    required this.entry,
    required this.config,
    required this.showFullAmounts,
    this.preferDescriptionAsTitle = false,
    this.onEdit,
    this.onDelete,
  });

  Future<bool> _confirmDelete(BuildContext context) {
    return LedgerDeleteDialog.show(
      context,
      title: AppText.ledgerDeleteEntryTitle,
      message: AppText.ledgerDeleteEntryMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = config.colorForEntry(entry.type);
    final icon = config.iconForEntry(entry.type);
    final timeLabel = DateFormat('MMM d, h:mm a').format(entry.occurredAt);
    final displayName = _displayName();

    final card = MyCard(
      cutTopRightCorner: onEdit != null,
      cornerCutSize: 44,
      topRightCorner: onEdit == null
          ? null
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 15,
                ),
              ),
            ),
      borderRadius: AppSizes.radiusMd,
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm + 2,
        onEdit != null ? AppSizes.lg : AppSizes.md,
        AppSizes.sm + 2,
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

    if (onDelete == null) return card;

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete!(entry),
      background: ClipPath(
        clipper: MyCardCornerCutClipper(
          radius: AppSizes.radiusMd,
          cutSize: 44,
        ),
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSizes.lg),
          color: AppColors.error.withValues(alpha: 0.92),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.white,
            size: AppSizes.iconMd,
          ),
        ),
      ),
      child: card,
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
