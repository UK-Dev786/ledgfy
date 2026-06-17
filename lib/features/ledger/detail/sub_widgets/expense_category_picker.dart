import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';

class ExpenseCategoryPicker extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const ExpenseCategoryPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const categories = [
    AppText.ledgerExpenseCategoryRent,
    AppText.ledgerExpenseCategoryStock,
    AppText.ledgerExpenseCategorySalary,
    AppText.ledgerExpenseCategoryUtilities,
    AppText.ledgerExpenseCategoryOther,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: categories.map((category) {
        final isSelected = category == selected;
        return Bounce(
          duration: const Duration(milliseconds: 100),
          onTap: () => onSelected(category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.error.withValues(alpha: 0.16)
                  : AppColors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: isSelected
                    ? AppColors.error.withValues(alpha: 0.55)
                    : AppColors.textHint.withValues(alpha: 0.2),
              ),
            ),
            child: MyText(
              category,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: isSelected ? AppColors.white : AppColors.textHint,
              weight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
