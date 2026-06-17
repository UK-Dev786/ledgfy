import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/reports_chart_data.dart';

class ReportsNetPlLineChart extends StatelessWidget {
  final List<PeriodPlPoint> points;

  const ReportsNetPlLineChart({super.key, required this.points});

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
            AppText.reportsNetPlChartTitle,
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: AppColors.white,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: AppSizes.xs),
          const MyText(
            AppText.reportsNetPlChartSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                interval: points.length > 12 ? 3 : 1,
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
              ),
              series: <CartesianSeries<PeriodPlPoint, String>>[
                LineSeries<PeriodPlPoint, String>(
                  dataSource: points,
                  xValueMapper: (point, _) => point.label,
                  yValueMapper: (point, _) => point.net,
                  color: AppColors.primary,
                  width: 2.5,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                    color: AppColors.primary,
                    borderColor: AppColors.white,
                    borderWidth: 1.2,
                  ),
                ),
                AreaSeries<PeriodPlPoint, String>(
                  dataSource: points,
                  xValueMapper: (point, _) => point.label,
                  yValueMapper: (point, _) => point.net,
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderWidth: 0,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x : point.y',
                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                  final item = data as PeriodPlPoint;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: MyText(
                      '${item.label}: ${CurrencyFormatter.format(item.net)}',
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
