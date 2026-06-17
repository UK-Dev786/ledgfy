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
    final gap = compact ? AppSizes.xs : AppSizes.sm;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedWidth = constraints.maxWidth.isFinite;
        final amountText = FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MyText(
            CurrencyFormatter.format(
              amount,
              compact: compact,
            ),
            font: AppFont.inter,
            size: textSize,
            color: color,
            weight: FontWeight.w700,
            maxLines: 1,
          ),
        );

        return Row(
          mainAxisSize:
              hasBoundedWidth ? MainAxisSize.max : MainAxisSize.min,
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
            SizedBox(width: gap),
            if (hasBoundedWidth)
              Expanded(child: amountText)
            else
              amountText,
          ],
        );
      },
    );
  }
}
