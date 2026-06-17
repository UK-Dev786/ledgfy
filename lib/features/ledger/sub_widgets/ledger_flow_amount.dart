import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_text.dart';

class LedgerFlowAmount extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double amount;
  final bool compact;

  const LedgerFlowAmount({
    super.key,
    required this.icon,
    required this.color,
    required this.amount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconBoxSize = compact ? 18.0 : 22.0;
    final iconSize = compact ? 11.0 : 13.0;
    final textSize = compact ? AppSizes.caption : AppSizes.subtitle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconBoxSize,
          height: iconBoxSize,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: color.withValues(alpha: 0.28)),
          ),
          child: Icon(icon, size: iconSize, color: color),
        ),
        SizedBox(width: compact ? AppSizes.xs : AppSizes.sm),
        MyText(
          CurrencyFormatter.format(amount),
          font: AppFont.inter,
          size: textSize,
          color: color,
          weight: FontWeight.w700,
        ),
      ],
    );
  }
}
