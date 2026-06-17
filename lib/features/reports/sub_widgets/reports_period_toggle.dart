import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../models/reports_chart_data.dart';

class ReportsPeriodToggle extends StatelessWidget {
  final ReportsPeriod selected;
  final ValueChanged<ReportsPeriod> onChanged;

  const ReportsPeriodToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _options = <ReportsPeriod, String>{
    ReportsPeriod.today: AppText.reportsPeriodToday,
    ReportsPeriod.thisWeek: AppText.reportsPeriodThisWeek,
    ReportsPeriod.thisMonth: AppText.reportsPeriodThisMonth,
    ReportsPeriod.thisYear: AppText.reportsPeriodThisYear,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _options.entries.map((entry) {
          final isSelected = selected == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: Bounce(
              duration: const Duration(milliseconds: 100),
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.16)
                      : AppColors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.55)
                        : AppColors.textHint.withValues(alpha: 0.2),
                  ),
                ),
                child: MyText(
                  entry.value,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: isSelected ? AppColors.white : AppColors.textHint,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
