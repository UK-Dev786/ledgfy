import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';

class HomeHeroCard extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;
  final String currencyCode;

  const HomeHeroCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.currencyCode,
  });

  @override
  State<HomeHeroCard> createState() => _HomeHeroCardState();
}

class _HomeHeroCardState extends State<HomeHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _income;
  late Animation<double> _expense;
  late Animation<double> _net;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _bindAnimations();
    unawaited(
      Future<void>.delayed(
        const Duration(milliseconds: 100),
        _controller.forward,
      ),
    );
  }

  void _bindAnimations({double incomeStart = 0, double expenseStart = 0}) {
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _income = Tween(begin: incomeStart, end: widget.totalIncome).animate(curve);
    _expense =
        Tween(begin: expenseStart, end: widget.totalExpense).animate(curve);
    _net = Tween(
      begin: incomeStart - expenseStart,
      end: widget.totalIncome - widget.totalExpense,
    ).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalIncome != widget.totalIncome ||
        oldWidget.totalExpense != widget.totalExpense) {
      _bindAnimations(
        incomeStart: _income.value,
        expenseStart: _expense.value,
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final netBalance = widget.totalIncome - widget.totalExpense;
    final statusColor = netBalance > 0
        ? AppColors.success
        : netBalance < 0
        ? AppColors.error
        : AppColors.textTertiary;
    final statusText = netBalance > 0
        ? AppText.homeStatusPositive
        : netBalance < 0
        ? AppText.homeStatusNegative
        : AppText.homeStatusNeutral;
    final hintText = netBalance > 0
        ? AppText.homeNetPositiveHint
        : netBalance < 0
        ? AppText.homeNetNegativeHint
        : AppText.homeNetNeutralHint;

    return MyCard(
      tint: MyCardTint.dark,
      blur: 0,
      border: false,
      padding: EdgeInsets.zero,
      borderRadius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MyCard(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyText(
                          AppText.homeMonthlyOverview.toUpperCase(),
                          font: AppFont.inter,
                          size: AppSizes.caption,
                          color: AppColors.white.withValues(alpha: 0.35),
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      _StatusChip(color: statusColor, label: statusText),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider.withValues(alpha: 0.06),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        AppText.homeNetBalance.toUpperCase(),
                        font: AppFont.inter,
                        size: AppSizes.caption,
                        color: AppColors.white.withValues(alpha: 0.3),
                        weight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: AppSizes.xs),
                            child: MyText(
                              widget.currencyCode,
                              font: AppFont.inter,
                              size: AppSizes.md,
                              color: AppColors.white.withValues(alpha: 0.35),
                              weight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: MyText(
                                CurrencyFormatter.formatSync(_net.value),
                                font: AppFont.inter,
                                size: 34,
                                color: AppColors.white,
                                weight: FontWeight.w700,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      MyText(
                        hintText,
                        font: AppFont.sourceSans,
                        size: AppSizes.caption,
                        color: AppColors.white.withValues(alpha: 0.25),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider.withValues(alpha: 0.06),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatColumn(
                          icon: Icons.arrow_upward,
                          color: AppColors.success,
                          label: AppText.homeIncome,
                          currencyCode: widget.currencyCode,
                          amount: CurrencyFormatter.formatSync(_income.value),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.divider.withValues(alpha: 0.06),
                      ),
                      Expanded(
                        child: _StatColumn(
                          icon: Icons.arrow_downward,
                          color: AppColors.error,
                          label: AppText.homeExpense,
                          currencyCode: widget.currencyCode,
                          amount: CurrencyFormatter.formatSync(_expense.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          MyText(
            label,
            font: AppFont.inter,
            size: AppSizes.caption,
            color: color,
            weight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String currencyCode;
  final String amount;

  const _StatColumn({
    required this.icon,
    required this.color,
    required this.label,
    required this.currencyCode,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, size: 11, color: color),
              ),
              const SizedBox(width: 6),
              MyText(
                label.toUpperCase(),
                font: AppFont.inter,
                size: AppSizes.caption,
                color: color.withValues(alpha: 0.8),
                weight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: MyText(
                  currencyCode,
                  font: AppFont.inter,
                  size: AppSizes.caption,
                  color: AppColors.white.withValues(alpha: 0.35),
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSizes.xs),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    amount,
                    font: AppFont.inter,
                    size: AppSizes.md,
                    color: AppColors.white,
                    weight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
