import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text.dart';
import '../../models/ledger_item.dart';
import '../../shared/sub_widgets/ledger_summary_card.dart';

class LedgerDetailSummary extends StatelessWidget {
  final LedgerItem ledger;

  const LedgerDetailSummary({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    final config = ledger.config;

    if (config.isExpenseOnly) {
      return LedgerSummaryCard(
        initialShowFullAmounts: config.showsFullAmountsByDefault,
        showExpandButton: config.showAmountExpandButton,
        amounts: [
          LedgerSummaryAmount(
            icon: config.debitIcon,
            color: config.debitColor,
            amount: ledger.balance,
            label: config.balanceLabel,
          ),
        ],
      );
    }

    return LedgerSummaryCard(
      showExpandButton: config.showAmountExpandButton,
      amounts: [
        if (ledger.openingBalance != 0) ...[
          LedgerSummaryAmount(
            icon: Icons.savings_outlined,
            color: AppColors.textTertiary,
            amount: ledger.openingBalance,
            label: AppText.ledgerOpeningBalance,
          ),
        ],
        LedgerSummaryAmount(
          icon: config.outflowIcon,
          color: config.outflowColor,
          amount: config.outflowAmount(
            creditTotal: ledger.creditTotal,
            debitTotal: ledger.debitTotal,
          ),
          label: config.outflowLabel,
        ),
        LedgerSummaryAmount(
          icon: config.inflowIcon,
          color: config.inflowColor,
          amount: config.inflowAmount(
            creditTotal: ledger.creditTotal,
            debitTotal: ledger.debitTotal,
          ),
          label: config.inflowLabel,
        ),
        LedgerSummaryAmount(
          icon: Icons.account_balance_wallet_outlined,
          color: _balanceColor(ledger.balance),
          amount: ledger.balance,
          label: config.balanceLabel,
        ),
      ],
    );
  }

  Color _balanceColor(double balance) {
    if (balance > 0) return AppColors.success;
    if (balance < 0) return AppColors.error;
    return AppColors.textTertiary;
  }
}
