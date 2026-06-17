import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import 'ledger_simple_amount.dart';
import 'ledger_amount_expand_button.dart';

class LedgerSummaryAmount {
  final IconData icon;
  final Color color;
  final double amount;
  final String? label;

  const LedgerSummaryAmount({
    required this.icon,
    required this.color,
    required this.amount,
    this.label,
  });
}

class LedgerSummaryCard extends StatefulWidget {
  final List<LedgerSummaryAmount> amounts;
  final bool initialShowFullAmounts;
  final bool showExpandButton;

  const LedgerSummaryCard({
    super.key,
    required this.amounts,
    this.initialShowFullAmounts = false,
    this.showExpandButton = true,
  });

  @override
  State<LedgerSummaryCard> createState() => _LedgerSummaryCardState();
}

class _LedgerSummaryCardState extends State<LedgerSummaryCard> {
  late bool _showFullAmounts = widget.initialShowFullAmounts;

  String _format(double amount) {
    if (_showFullAmounts) return CurrencyFormatter.format(amount);
    return CurrencyFormatter.formatCompact(amount);
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
        borderRadius: AppSizes.radiusLg,
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.sm,
          AppSizes.sm,
          AppSizes.md,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Row(
                children: [
                  for (var i = 0; i < widget.amounts.length; i++) ...[
                    if (i > 0)
                      Container(
                        width: 1,
                        height: 36,
                        color: AppColors.divider.withValues(alpha: 0.12),
                      ),
                    Expanded(child: _amountColumn(widget.amounts[i])),
                  ],
                ],
              ),
            ),
            if (widget.showExpandButton)
              Positioned(
                top: 0,
                right: 0,
                child: LedgerAmountExpandButton(
                  showFullAmounts: _showFullAmounts,
                  onTap: () =>
                      setState(() => _showFullAmounts = !_showFullAmounts),
                ),
              ),
          ],
        ),
    );
  }

  Widget _amountColumn(LedgerSummaryAmount item) {
    final hasLabel = item.label != null && item.label!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasLabel) ...[
            MyText(
              item.label!,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
              align: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          LedgerSimpleAmount(
            icon: item.icon,
            color: item.color,
            amount: item.amount,
            formatter: _format,
          ),
        ],
      ),
    );
  }
}
