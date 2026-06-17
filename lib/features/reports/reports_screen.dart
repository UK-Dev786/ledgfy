import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/ledger_providers.dart';
import 'models/reports_chart_data.dart';
import 'services/ledger_reports_analytics.dart';
import 'sub_widgets/reports_net_pl_line_chart.dart';
import 'sub_widgets/reports_party_role_chart.dart';
import 'sub_widgets/reports_period_toggle.dart';
import 'sub_widgets/reports_pl_column_chart.dart';
import 'sub_widgets/reports_summary_strip.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportsPeriod _period = ReportsPeriod.thisWeek;

  @override
  Widget build(BuildContext context) {
    final ledgers = ref.watch(ledgersProvider);
    final snapshot = LedgerReportsAnalytics.build(
      ledgers: ledgers,
      period: _period,
    );
    final hasLedgers = ledgers.isNotEmpty;
    final hasAnyEntries = ledgers.any((ledger) => ledger.entries.isNotEmpty);

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.md,
              AppSizes.lg,
              AppSizes.xxl * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SharedEntranceAnimation(
                  child: _ReportsHeader(),
                ),
                const SizedBox(height: AppSizes.lg),
                if (!hasLedgers || !hasAnyEntries) ...[
                  MyCard(
                    borderRadius: AppSizes.radiusLg,
                    child: const MyText(
                      AppText.reportsEmpty,
                      font: AppFont.sourceSans,
                      size: AppSizes.subtitle,
                      color: AppColors.textHint,
                      align: TextAlign.center,
                      height: 1.45,
                    ),
                  ),
                ] else ...[
                  SharedEntranceAnimation(
                    delay: const Duration(milliseconds: 60),
                    child: ReportsSummaryStrip(
                      totalIncome: snapshot.totalIncome,
                      totalExpense: snapshot.totalExpense,
                      netPl: snapshot.netPl,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  SharedEntranceAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: ReportsPeriodToggle(
                      selected: _period,
                      onChanged: (period) => setState(() => _period = period),
                    ),
                  ),
                  if (!snapshot.hasPlData) ...[
                    const SizedBox(height: AppSizes.sm),
                    const MyText(
                      AppText.reportsPeriodEmpty,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                      align: TextAlign.center,
                      height: 1.4,
                    ),
                  ],
                  const SizedBox(height: AppSizes.lg),
                  SharedEntranceAnimation(
                    delay: const Duration(milliseconds: 140),
                    child: ReportsPlColumnChart(points: snapshot.plPoints),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  SharedEntranceAnimation(
                    delay: const Duration(milliseconds: 180),
                    child: ReportsNetPlLineChart(points: snapshot.plPoints),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  SharedEntranceAnimation(
                    delay: const Duration(milliseconds: 220),
                    child: ReportsPartyRoleChart(slices: snapshot.partyRoles),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          AppText.reportsTitle,
          font: AppFont.inter,
          size: AppSizes.header2,
          color: AppColors.white,
          weight: FontWeight.w800,
        ),
        const SizedBox(height: AppSizes.xs),
        MyText(
          '${AppText.appName} · ${AppText.reportsSubtitle}',
          font: AppFont.sourceSans,
          size: AppSizes.subtitle,
          color: AppColors.textHint,
          height: 1.4,
        ),
      ],
    );
  }
}
