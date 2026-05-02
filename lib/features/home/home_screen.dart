import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/themed_gradient_bg.dart';
import 'home_mock_data.dart';
import 'sub_widgets/home_empty_state.dart';
import 'sub_widgets/home_greeting_header.dart';
import 'sub_widgets/home_hero_card.dart';
import 'sub_widgets/home_monthly_summary.dart';
import 'sub_widgets/home_recent_records.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const HomeScreen({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final hasRecords = mockRecentEntries.isNotEmpty;

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.md,
            AppSizes.lg,
            AppSizes.xxl,
          ),
          child: Column(
            children: [
              HomeGreetingHeader(
                userName: mockUserName,
                onProfileTap: () {
                  onProfileTap?.call();
                },
              ),

              const SizedBox(height: AppSizes.lg),

              HomeHeroCard(
                totalIncome: mockTotalIncome,
                totalExpense: mockTotalExpense,
                currencyCode: CurrencyFormatter.getActiveCurrencyCode(),
              ),
              const SizedBox(height: AppSizes.lg),
              hasRecords
                  ? HomeRecentRecords(entries: mockRecentEntries)
                  : const HomeEmptyState(),
              if (hasRecords) ...[
                const SizedBox(height: AppSizes.xs),
                TopLedgers(
                  ledgerGroups: mockLedgerGroups,
                  dailyTotals: mockDailyTotals,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
