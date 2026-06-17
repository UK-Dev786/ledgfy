import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../models/ledger_type_config.dart';
import '../../models/party_balance.dart';
import '../../shared/sub_widgets/ledger_summary_card.dart';

class LedgerPartySummary extends StatelessWidget {
  final PartyBalance party;
  final LedgerTypeConfig config;

  const LedgerPartySummary({
    super.key,
    required this.party,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return LedgerSummaryCard(
      amounts: [
        LedgerSummaryAmount(
          icon: config.creditIcon,
          color: config.creditColor,
          amount: party.given,
        ),
        LedgerSummaryAmount(
          icon: config.debitIcon,
          color: config.debitColor,
          amount: party.received,
        ),
        LedgerSummaryAmount(
          icon: Icons.account_balance_wallet_outlined,
          color: _balanceColor(party.balance),
          amount: party.balance,
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
