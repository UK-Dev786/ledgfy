import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../models/ledger_entry.dart';
import 'ledger_history_tile.dart';

class LedgerHistoryList extends StatelessWidget {
  final List<LedgerEntry> entries;

  const LedgerHistoryList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          AppText.ledgerDetailHistory,
          font: AppFont.inter,
          size: AppSizes.title,
          color: AppColors.white,
          weight: FontWeight.w700,
        ),
        const SizedBox(height: AppSizes.md),
        if (sorted.isEmpty)
          SharedEntranceAnimation(
            delay: const Duration(milliseconds: 80),
            child: MyCard(
              borderRadius: AppSizes.radiusMd,
              child: MyText(
                AppText.ledgerDetailEmptyHistory,
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
              return SharedEntranceAnimation(
                delay: Duration(milliseconds: 60 * index.clamp(0, 4)),
                child: LedgerHistoryTile(entry: sorted[index]),
              );
            },
          ),
      ],
    );
  }
}
