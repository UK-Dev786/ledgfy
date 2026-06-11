import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../home_mock_data.dart';
import 'home_spending_chart.dart';
import 'home_top_ledgers.dart';

class TopLedgers extends StatelessWidget {
  final List<MockLedgerGroup> ledgerGroups;
  final List<MockDailyTotal> dailyTotals;

  const TopLedgers({
    super.key,
    required this.ledgerGroups,
    required this.dailyTotals,
  });

  @override
  Widget build(BuildContext context) {
    return SharedEntranceAnimation(
      delay: const Duration(milliseconds: 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTopLedgers(ledgerGroups: ledgerGroups),
          const SizedBox(height: AppSizes.sm),
          HomeSpendingChart(dailyTotals: dailyTotals),
        ],
      ),
    );
  }
}
