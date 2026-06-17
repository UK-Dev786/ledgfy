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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Chip(
            label: AppText.reportsPeriodDaily,
            selected: selected == ReportsPeriod.daily,
            onTap: () => onChanged(ReportsPeriod.daily),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: _Chip(
            label: AppText.reportsPeriodMonthly,
            selected: selected == ReportsPeriod.monthly,
            onTap: () => onChanged(ReportsPeriod.monthly),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 100),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.16)
              : AppColors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.55)
                : AppColors.textHint.withValues(alpha: 0.2),
          ),
        ),
        child: MyText(
          label,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: selected ? AppColors.white : AppColors.textHint,
          weight: selected ? FontWeight.w600 : FontWeight.w500,
          align: TextAlign.center,
        ),
      ),
    );
  }
}
