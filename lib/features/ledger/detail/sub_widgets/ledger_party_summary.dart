import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../models/ledger_type_config.dart';
import '../../models/party_balance.dart';
import '../../shared/sub_widgets/ledger_simple_amount.dart';

class LedgerPartySummary extends StatelessWidget {
  final PartyBalance party;
  final LedgerTypeConfig config;
  final bool showFullAmounts;

  const LedgerPartySummary({
    super.key,
    required this.party,
    required this.config,
    this.showFullAmounts = false,
  });

  @override
  Widget build(BuildContext context) {
    final abbreviate = !showFullAmounts;

    return SharedEntranceAnimation(
      child: MyCard(
        borderRadius: AppSizes.radiusLg,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: LedgerSimpleAmount(
                  icon: config.creditIcon,
                  color: config.creditColor,
                  amount: party.given,
                  abbreviate: abbreviate,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 28,
              color: AppColors.divider.withValues(alpha: 0.12),
            ),
            Expanded(
              child: Center(
                child: LedgerSimpleAmount(
                  icon: config.debitIcon,
                  color: config.debitColor,
                  amount: party.received,
                  abbreviate: abbreviate,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 28,
              color: AppColors.divider.withValues(alpha: 0.12),
            ),
            Expanded(
              child: Center(
                child: LedgerSimpleAmount(
                  icon: Icons.account_balance_wallet_outlined,
                  color: _balanceColor(party.balance),
                  amount: party.balance,
                  abbreviate: abbreviate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _balanceColor(double balance) {
    if (balance > 0) return AppColors.success;
    if (balance < 0) return AppColors.error;
    return AppColors.textTertiary;
  }
}
