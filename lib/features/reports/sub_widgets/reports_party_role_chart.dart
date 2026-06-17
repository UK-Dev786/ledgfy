import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/reports_chart_data.dart';

class ReportsPartyRoleChart extends StatelessWidget {
  final List<PartyRoleSlice> slices;

  const ReportsPartyRoleChart({super.key, required this.slices});

  @override
  Widget build(BuildContext context) {
    final activeSlices = slices.where((slice) => slice.amount > 0).toList();
    final hasData = activeSlices.isNotEmpty;

    return MyCard(
      borderRadius: AppSizes.radiusLg,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyText(
            AppText.reportsPartyRoleChartTitle,
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: AppColors.white,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: AppSizes.xs),
          const MyText(
            AppText.reportsPartyRoleChartSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            height: 1.4,
          ),
          const SizedBox(height: AppSizes.md),
          if (!hasData)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
              child: MyText(
                AppText.reportsPartyRoleEmpty,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                align: TextAlign.center,
                height: 1.45,
              ),
            )
          else ...[
            SizedBox(
              height: 220,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: AppSizes.caption,
                  ),
                ),
                series: <CircularSeries<PartyRoleSlice, String>>[
                  DoughnutSeries<PartyRoleSlice, String>(
                    dataSource: activeSlices,
                    xValueMapper: (slice, _) => slice.role,
                    yValueMapper: (slice, _) => slice.amount,
                    pointColorMapper: (slice, _) => _colorForRole(slice.role),
                    innerRadius: '58%',
                    radius: '88%',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      textStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: AppSizes.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            for (final slice in activeSlices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.xs),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _colorForRole(slice.role),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: MyText(
                        slice.role,
                        font: AppFont.sourceSans,
                        size: AppSizes.caption,
                        color: AppColors.textHint,
                      ),
                    ),
                    MyText(
                      CurrencyFormatter.format(slice.amount),
                      font: AppFont.inter,
                      size: AppSizes.caption,
                      color: AppColors.white,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Color _colorForRole(String role) {
    if (role == AppText.reportsCustomerRole) {
      return AppColors.success;
    }
    return AppColors.secondary;
  }
}
