import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../home_mock_data.dart';
import 'home_spending_chart.dart';
import 'home_top_ledgers.dart';

class TopLedgers extends StatefulWidget {
  final List<MockLedgerGroup> ledgerGroups;
  final List<MockDailyTotal> dailyTotals;

  const TopLedgers({
    super.key,
    required this.ledgerGroups,
    required this.dailyTotals,
  });

  @override
  State<TopLedgers> createState() => _TopLedgersState();
}

class _TopLedgersState extends State<TopLedgers>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fade = Tween(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curved);
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
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MyText(
            //   AppText.homeMonthlySummary,
            //   font: AppFont.inter,
            //   size: AppSizes.title,
            //   color: AppColors.white,
            //   weight: FontWeight.w700,
            // ),
            // const SizedBox(height: AppSizes.md),
            HomeTopLedgers(ledgerGroups: widget.ledgerGroups),
            const SizedBox(height: AppSizes.sm),
            HomeSpendingChart(dailyTotals: widget.dailyTotals),
          ],
        ),
      ),
    );
  }
}
