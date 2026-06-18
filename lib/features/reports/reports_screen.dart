import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/rounded_button.dart';
import '../../../core/widgets/shared_entrance_animation.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/ledger_providers.dart';
import '../../../di/profile_providers.dart';
import '../ledger/models/ledger_item.dart';
import '../ledger/shared/khata_report/khata_report_page.dart';
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
  bool _showFullAmounts = false;

  void _openReport({
    required List<LedgerItem> ledgers,
    required ReportsSnapshot snapshot,
  }) {
    if (!snapshot.hasPlData) {
      context.popMsg(
        AppText.reportsPrintNothingToPrint,
        color: AppColors.warning,
        icon: Icons.info_outline_rounded,
      );
      return;
    }

    KhataReportPage.openWithData(
      context,
      data: LedgerReportsAnalytics.buildKhataReport(
        ledgers: ledgers,
        snapshot: snapshot,
        period: _period,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ledgersAsync = ref.watch(ledgersStreamProvider);
    final ledgers = ref.watch(scopedLedgersProvider);
    final isStaff = ref.watch(isStaffUserProvider);
    final user = ref.watch(profileUserStreamProvider).valueOrNull;
    final snapshot = LedgerReportsAnalytics.build(
      ledgers: ledgers,
      period: _period,
      actorUserId: isStaff ? user?.id : null,
    );
    final hasLedgers = ledgers.isNotEmpty;
    final hasAnyEntries = ledgers.any((ledger) => ledger.entries.isNotEmpty);
    final canPrint = hasLedgers && hasAnyEntries && snapshot.hasPlData;

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ledgersAsync.when(
            skipLoadingOnReload: true,
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: MyText(
                  error.toString(),
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.error,
                  align: TextAlign.center,
                ),
              ),
            ),
            data: (_) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.lg,
                AppSizes.md,
                AppSizes.lg,
                AppSizes.xxl * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SharedEntranceAnimation(
                    child: _ReportsHeader(
                      canPrint: canPrint,
                      onReportTap: () => _openReport(
                        ledgers: ledgers,
                        snapshot: snapshot,
                      ),
                    ),
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
                        showFullAmounts: _showFullAmounts,
                        onToggleAmounts: () {
                          setState(() => _showFullAmounts = !_showFullAmounts);
                        },
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
                      child: ReportsNetPlLineChart(
                        points: snapshot.plPoints,
                        showFullAmounts: _showFullAmounts,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    SharedEntranceAnimation(
                      delay: const Duration(milliseconds: 220),
                      child: ReportsPartyRoleChart(
                        slices: snapshot.partyRoles,
                        showFullAmounts: _showFullAmounts,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportsHeader extends StatelessWidget {
  final bool canPrint;
  final VoidCallback onReportTap;

  const _ReportsHeader({
    required this.canPrint,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                AppText.reportsTitle,
                font: AppFont.inter,
                size: AppSizes.header2,
                color: AppColors.white,
                weight: FontWeight.w800,
              ),
              SizedBox(height: AppSizes.xs),
              MyText(
                '${AppText.appName} · ${AppText.reportsSubtitle}',
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                height: 1.4,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Tooltip(
          message: AppText.ledgerReportTitle,
          child: RoundedButton(
            onTap: onReportTap,
            icon: Icons.picture_as_pdf_outlined,
            iconColor: canPrint ? AppColors.primary : AppColors.textHint,
            size: 44,
          ),
        ),
      ],
    );
  }
}
