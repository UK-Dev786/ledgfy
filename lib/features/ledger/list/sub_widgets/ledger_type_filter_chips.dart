import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../models/ledger_type.dart';

class LedgerTypeFilterChips extends StatelessWidget {
  final String? selectedTypeId;
  final ValueChanged<String?> onSelected;

  const LedgerTypeFilterChips({
    super.key,
    required this.selectedTypeId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: AppText.ledgersFilterAll,
            selected: selectedTypeId == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSizes.sm),
          ...LedgerType.all.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: _FilterChip(
                label: type.label,
                icon: type.icon,
                selected: selectedTypeId == type.id,
                onTap: () => onSelected(type.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
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
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppSizes.iconSm,
                color: selected ? AppColors.primary : AppColors.textHint,
              ),
              const SizedBox(width: AppSizes.sm),
            ],
            MyText(
              label,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: selected ? AppColors.white : AppColors.textHint,
              weight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
