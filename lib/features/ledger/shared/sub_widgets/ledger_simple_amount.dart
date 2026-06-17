import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/my_text.dart';

class LedgerSimpleAmount extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double amount;
  final bool abbreviate;
  final double iconSize;
  final double textSize;

  const LedgerSimpleAmount({
    super.key,
    required this.icon,
    required this.color,
    required this.amount,
    this.abbreviate = false,
    this.iconSize = AppSizes.iconSm,
    this.textSize = AppSizes.caption,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: AppSizes.xs),
          MyText(
            CurrencyFormatter.format(amount, abbreviate: abbreviate),
            font: AppFont.inter,
            size: textSize,
            color: color,
            weight: FontWeight.w700,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
