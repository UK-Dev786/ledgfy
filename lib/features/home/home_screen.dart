import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/ledger_providers.dart';
import '../../../di/profile_providers.dart';
import '../../../domain/entities/user.dart';
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

  const HomeScreen({super.key, this.onProfileTap, this.onLedgerTap});

  String _userName(User? user) {
    if (user?.displayName?.trim().isNotEmpty == true) {
      return user!.displayName!.trim();
    }
    return user?.email.split('@').first ?? AppText.homeGuestName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgersAsync = ref.watch(ledgersStreamProvider);
    final ledgers = ref.watch(scopedLedgersProvider);
    final isStaff = ref.watch(isStaffUserProvider);
    final user = ref.watch(profileUserStreamProvider).valueOrNull;
    final userName = _userName(user);

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ledgersAsync.when(
          skipLoadingOnReload: true,
          loading: () => SingleChildScrollView(
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
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.xxl * 2),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ],
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
          data: (_) {
            final dashboard = HomeDashboardAnalytics.build(
              ledgers: ledgers,
              actorUserId: isStaff ? user?.id : null,
            );

            return SingleChildScrollView(
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
                    HomeEmptyState(onAddTap: isStaff ? null : onLedgerTap),
                  if (dashboard.hasRecords) ...[
                    const SizedBox(height: AppSizes.xs),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: HomeTopLedgers(ledgerGroups: dashboard.topLedgers),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
