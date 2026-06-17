import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';

class LedgerAmountExpandButton extends StatelessWidget {
  final bool showFullAmounts;
  final VoidCallback onTap;
  final double iconSize;

  const LedgerAmountExpandButton({
    super.key,
    required this.showFullAmounts,
    required this.onTap,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: showFullAmounts
          ? AppText.ledgerShowShortAmounts
          : AppText.ledgerShowFullAmounts,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xs),
          child: Icon(
            showFullAmounts
                ? Icons.unfold_less_rounded
                : Icons.unfold_more_rounded,
            size: iconSize,
            color: showFullAmounts ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
