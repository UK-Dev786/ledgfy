import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/reports_chart_data.dart';

class ReportsPlColumnChart extends StatelessWidget {
  final List<PeriodPlPoint> points;

  const ReportsPlColumnChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
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
            AppText.reportsPlChartTitle,
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: AppColors.white,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: AppSizes.xs),
          const MyText(
            AppText.reportsPlChartSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 220,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.zero,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: AxisLine(
                  color: AppColors.textHint.withValues(alpha: 0.2),
                ),
                labelStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: AppSizes.caption,
                ),
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: MajorGridLines(
                  color: AppColors.textHint.withValues(alpha: 0.12),
                ),
                labelStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: AppSizes.caption,
                ),
                numberFormat: NumberFormat.compact(locale: 'en'),
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: AppSizes.caption,
                ),
              ),
              series: <CartesianSeries<PeriodPlPoint, String>>[
                ColumnSeries<PeriodPlPoint, String>(
                  name: AppText.reportsIncome,
                  dataSource: points,
                  xValueMapper: (point, _) => point.label,
                  yValueMapper: (point, _) => point.income,
                  color: AppColors.success,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  width: 0.35,
                ),
                ColumnSeries<PeriodPlPoint, String>(
                  name: AppText.reportsExpense,
                  dataSource: points,
                  xValueMapper: (point, _) => point.label,
                  yValueMapper: (point, _) => point.expense,
                  color: AppColors.error,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  width: 0.35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
