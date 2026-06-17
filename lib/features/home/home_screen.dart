import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/auth_providers.dart';
import '../../../di/ledger_providers.dart';
import '../ledger/detail/ledger_detail_page.dart';
import 'services/home_dashboard_analytics.dart';
import 'sub_widgets/home_empty_state.dart';
import 'sub_widgets/home_greeting_header.dart';
import 'sub_widgets/home_hero_card.dart';
import 'sub_widgets/home_recent_records.dart';
import 'sub_widgets/home_top_ledgers.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onLedgerTap;

  const HomeScreen({
    super.key,
    this.onProfileTap,
    this.onLedgerTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgersAsync = ref.watch(ledgersStreamProvider);
    final ledgers = ref.watch(ledgersProvider);
    final dashboard = HomeDashboardAnalytics.build(ledgers: ledgers);
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    final userName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email.split('@').first ?? AppText.homeGuestName);

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ledgersAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              strokeWidth: 2,
            ),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Text(
                error.toString(),
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (_) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.md,
              AppSizes.lg,
              AppSizes.xxl,
            ),
            child: Column(
              children: [
                HomeGreetingHeader(
                  userName: userName,
                  onProfileTap: onProfileTap ?? () {},
                ),
                const SizedBox(height: AppSizes.lg),
                HomeHeroCard(
                  totalIncome: dashboard.totalIncome,
                  totalExpense: dashboard.totalExpense,
                  currencyCode: CurrencyFormatter.getActiveCurrencyCode(),
                ),
                const SizedBox(height: AppSizes.lg),
                if (dashboard.hasRecords)
                  HomeRecentRecords(
                    entries: dashboard.recentEntries,
                    onSeeAll: onLedgerTap,
                    onEntryTap: (entry) {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              LedgerDetailPage(ledgerId: entry.ledgerId),
                        ),
                      );
                    },
                  )
                else
                  HomeEmptyState(onAddTap: onLedgerTap),
                if (dashboard.hasRecords) ...[
                  const SizedBox(height: AppSizes.xs),
                  HomeTopLedgers(ledgerGroups: dashboard.topLedgers),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
