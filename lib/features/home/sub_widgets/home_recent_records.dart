import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../home_mock_data.dart';
import 'home_record_tile.dart';

class HomeRecentRecords extends StatelessWidget {
  final List<MockLedgerEntry> entries;

  const HomeRecentRecords({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SharedEntranceAnimation(
          delay: const Duration(milliseconds: 300),
          child: Row(
            children: [
              Expanded(
                child: MyText(
                  AppText.homeRecentRecords,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
              ),
              MyText(
                AppText.homeSeeAll,
                font: AppFont.inter,
                size: AppSizes.subtitle,
                color: AppColors.primary,
                weight: FontWeight.w600,
                isOnTap: true,
                onTap: () {
                  // TODO: navigate to Ledger tab.
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        ...List.generate(entries.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.md),
            child: SharedEntranceAnimation(
              delay: Duration(milliseconds: 360 + (index * 60)),
              distance: 16,
              child: HomeRecordTile(entry: entries[index]),
            ),
          );
        }),
      ],
    );
  }
}
