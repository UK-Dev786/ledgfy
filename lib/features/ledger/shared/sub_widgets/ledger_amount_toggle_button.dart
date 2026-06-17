import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';

class LedgerAmountToggleButton extends StatelessWidget {
  final bool showFullAmounts;
  final VoidCallback onToggle;

  const LedgerAmountToggleButton({
    super.key,
    required this.showFullAmounts,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: showFullAmounts
          ? AppText.ledgerShowShortAmounts
          : AppText.ledgerShowFullAmounts,
      child: IconButton(
        onPressed: onToggle,
        icon: Icon(
          showFullAmounts
              ? Icons.monetization_on_rounded
              : Icons.monetization_on_outlined,
          color: showFullAmounts ? AppColors.primary : AppColors.textHint,
          size: AppSizes.iconMd,
        ),
      ),
    );
  }
}
