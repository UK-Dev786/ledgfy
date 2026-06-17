import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_text.dart';
import '../../models/ledger_type.dart';

class LedgerTypePicker extends StatelessWidget {
  final LedgerType selected;
  final ValueChanged<LedgerType> onSelected;

  const LedgerTypePicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: LedgerType.all.map((type) {
        final isSelected = type.id == selected.id;
        return Bounce(
          duration: const Duration(milliseconds: 100),
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.icon,
                  size: AppSizes.iconSm,
                  color: isSelected ? AppColors.primary : AppColors.textHint,
                ),
                const SizedBox(width: AppSizes.sm),
                MyText(
                  type.label,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: isSelected ? AppColors.white : AppColors.textHint,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
