import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/home_dashboard_data.dart';

class HomeTopLedgers extends StatefulWidget {
  final List<HomeLedgerGroup> ledgerGroups;

  const HomeTopLedgers({super.key, required this.ledgerGroups});

  @override
  State<HomeTopLedgers> createState() => _HomeTopLedgersState();
}

class _HomeTopLedgersState extends State<HomeTopLedgers>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    unawaited(_startAnimations());
  }

  @override
  void didUpdateWidget(covariant HomeTopLedgers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ledgerGroups != widget.ledgerGroups) {
      _progressController
        ..reset()
        ..forward();
    }
  }

  Future<void> _startAnimations() async {
    await Future<void>.delayed(const Duration(milliseconds: 1030));
    if (!mounted) return;
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.ledgerGroups]
      ..sort((a, b) => b.totalIncome.compareTo(a.totalIncome));
    final visible = sorted.length <= 3 ? sorted : sorted.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          AppText.homeTopLedgers,
          font: AppFont.inter,
          size: AppSizes.title,
          color: AppColors.white,
          weight: FontWeight.w700,
        ),
        const SizedBox(height: AppSizes.md),
        if (visible.isEmpty)
          MyCard(
            borderRadius: AppSizes.radiusMd,
            child: Center(
              child: MyText(
                AppText.homeNoIncome,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
              ),
            ),
          )
        else
          ...visible.map((group) {
            final topValue = visible.first.totalIncome == 0
                ? 1.0
                : visible.first.totalIncome;
            final progress = group.totalIncome / topValue;
            final countLabel = group.transactionCount == 1
                ? '${group.transactionCount} ${AppText.homeTransaction}'
                : '${group.transactionCount} ${AppText.homeTransactions}';

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: MyCard(
                borderRadius: AppSizes.radiusMd,
                padding: EdgeInsets.all(AppSizes.radiusMd),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          group.icon,
                          color: AppColors.primary,
                          size: AppSizes.iconMd,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: MyText(
                            group.ledgerName,
                            font: AppFont.inter,
                            size: AppSizes.subtitle,
                            color: AppColors.white,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyText(
                              CurrencyFormatter.format(group.totalIncome),
                              font: AppFont.inter,
                              size: AppSizes.subtitle,
                              color: AppColors.success,
                              weight: FontWeight.w700,
                            ),
                            MyText(
                              countLabel,
                              font: AppFont.sourceSans,
                              size: AppSizes.caption,
                              color: AppColors.textHint,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, _) => LinearProgressIndicator(
                        value: progress * _progressController.value,
                        minHeight: AppSizes.xs,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primaryTint.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
