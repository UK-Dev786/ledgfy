// TODO: replace CustomPainter with fl_chart BarChart once added to pubspec.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../home_mock_data.dart';

class HomeSpendingChart extends StatefulWidget {
  final List<MockDailyTotal> dailyTotals;

  const HomeSpendingChart({super.key, required this.dailyTotals});

  @override
  State<HomeSpendingChart> createState() => _HomeSpendingChartState();
}

class _HomeSpendingChartState extends State<HomeSpendingChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    unawaited(_startAnimation());
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(const Duration(milliseconds: 680));
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasChartData = widget.dailyTotals.any(
      (item) => item.income > 0 || item.expense > 0,
    );
    if (!hasChartData) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: AnimatedBuilder(
            animation: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            builder: (context, _) => CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _HomeChartPainter(
                dailyTotals: widget.dailyTotals,
                progress: _controller.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.dailyTotals.map((item) {
            final label = AppText.homeChartDayLabels[item.date.weekday - 1];
            return Expanded(
              child: MyText(
                label,
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.textHint,
                align: TextAlign.center,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _ChartLegend(color: AppColors.success, label: AppText.homeChartIncomeLegend),
            SizedBox(width: AppSizes.md),
            _ChartLegend(color: AppColors.error, label: AppText.homeChartExpenseLegend),
          ],
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.sm + AppSizes.xs / 2,
          height: AppSizes.sm + AppSizes.xs / 2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSizes.xs),
        MyText(
          label,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
        ),
      ],
    );
  }
}

class _HomeChartPainter extends CustomPainter {
  final List<MockDailyTotal> dailyTotals;
  final double progress;

  const _HomeChartPainter({required this.dailyTotals, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = dailyTotals
        .expand((item) => [item.income, item.expense])
        .fold<double>(0, math.max);
    if (maxValue == 0) return;

    final incomePaint = Paint()..color = AppColors.success;
    final expensePaint = Paint()..color = AppColors.error;
    final groupWidth = size.width / dailyTotals.length;
    final barWidth = (groupWidth - AppSizes.sm) / 2;

    for (var i = 0; i < dailyTotals.length; i++) {
      final item = dailyTotals[i];
      final incomeHeight = (item.income / maxValue) * size.height * progress;
      final expenseHeight = (item.expense / maxValue) * size.height * progress;
      final left = (groupWidth * i) + (AppSizes.xs / 2);

      final incomeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - incomeHeight, barWidth, incomeHeight),
        const Radius.circular(AppSizes.xs),
      );
      final expenseRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          left + barWidth + AppSizes.xs,
          size.height - expenseHeight,
          barWidth,
          expenseHeight,
        ),
        const Radius.circular(AppSizes.xs),
      );
      canvas.drawRRect(incomeRect, incomePaint);
      canvas.drawRRect(expenseRect, expensePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HomeChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.dailyTotals != dailyTotals;
  }
}
