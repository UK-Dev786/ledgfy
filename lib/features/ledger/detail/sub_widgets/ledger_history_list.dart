import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_type_config.dart';
import 'ledger_history_tile.dart';

class LedgerHistoryList extends StatelessWidget {
  final List<LedgerEntry> entries;
  final LedgerTypeConfig config;
  final bool showFullAmounts;
  final bool preferDescriptionAsTitle;
  final bool showHeader;
  final bool animate;
  final ValueChanged<LedgerEntry>? onEntryEdit;
  final ValueChanged<LedgerEntry>? onEntryDelete;
  final bool Function(LedgerEntry entry)? entryCanMutate;

  const LedgerHistoryList({
    super.key,
    required this.entries,
    required this.config,
    required this.showFullAmounts,
    this.preferDescriptionAsTitle = false,
    this.showHeader = true,
    this.animate = false,
    this.onEntryEdit,
    this.onEntryDelete,
    this.entryCanMutate,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    final emptyMessage = preferDescriptionAsTitle
        ? config.subLedgerHistoryEmpty
        : config.emptyHistoryMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          const MyText(
            AppText.ledgerDetailHistory,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: AppSizes.md),
        ],
        if (sorted.isEmpty)
          _maybeAnimate(
            child: MyCard(
              borderRadius: AppSizes.radiusMd,
              child: MyText(
                emptyMessage,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                align: TextAlign.center,
                height: 1.45,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              final entry = sorted[index];
              final canEdit = onEntryEdit != null &&
                  (entryCanMutate?.call(entry) ?? true);
              final canDelete = onEntryDelete != null &&
                  (entryCanMutate?.call(entry) ?? true);
              return _maybeAnimate(
                delay: Duration(milliseconds: 60 * index.clamp(0, 4)),
                child: LedgerHistoryTile(
                  entry: entry,
                  config: config,
                  showFullAmounts: showFullAmounts,
                  preferDescriptionAsTitle: preferDescriptionAsTitle,
                  onEdit: canEdit ? () => onEntryEdit!(entry) : null,
                  onDelete: canDelete ? onEntryDelete : null,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _maybeAnimate({required Widget child, Duration delay = Duration.zero}) {
    if (!animate) return child;
    return SharedEntranceAnimation(delay: delay, child: child);
  }
}
