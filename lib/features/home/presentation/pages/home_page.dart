import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 5,
              vertical: context.h * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TopBar(),
                SizedBox(height: context.h * 2.5),
                const _BalanceCard(),
                SizedBox(height: context.h * 3),
                MyText(
                  'Recent Transactions',
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
                SizedBox(height: context.h * 1.5),
                ..._dummyTransactions.map((t) => _TransactionTile(t)),
                SizedBox(height: context.h * 3),
                MyText(
                  'Summary',
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
                SizedBox(height: context.h * 1.5),
                const _SummaryRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              'Good morning,',
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
            ),
            MyText(
              'Hassan',
              font: AppFont.inter,
              size: AppSizes.header3,
              color: AppColors.white,
              weight: FontWeight.bold,
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: AppSizes.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Balance card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w * 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.gradientPremium,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            'Total Balance',
            font: AppFont.sourceSans,
            size: AppSizes.subtitle,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
          SizedBox(height: context.h * 0.8),
          MyText(
            '\$24,850.00',
            font: AppFont.inter,
            size: AppSizes.header1,
            color: AppColors.white,
            weight: FontWeight.bold,
          ),
          SizedBox(height: context.h * 2),
          Row(
            children: [
              _BalanceStat(
                icon: Icons.arrow_downward_rounded,
                label: 'Income',
                value: '\$8,420',
              ),
              SizedBox(width: context.w * 8),
              _BalanceStat(
                icon: Icons.arrow_upward_rounded,
                label: 'Expense',
                value: '\$3,210',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BalanceStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(icon, color: AppColors.white, size: AppSizes.iconSm),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              label,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            MyText(
              value,
              font: AppFont.inter,
              size: AppSizes.subtitle,
              color: AppColors.white,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}

// ── Transactions ─────────────────────────────────────────────────────────────

class _Transaction {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final IconData icon;
  final Color iconColor;

  const _Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.icon,
    required this.iconColor,
  });
}

const _dummyTransactions = [
  _Transaction(
    title: 'Client Payment',
    subtitle: 'Ahmed & Co. • Today',
    amount: '+\$1,200.00',
    isCredit: true,
    icon: Icons.payments_outlined,
    iconColor: AppColors.primary,
  ),
  _Transaction(
    title: 'Office Supplies',
    subtitle: 'Stationery • Yesterday',
    amount: '-\$85.50',
    isCredit: false,
    icon: Icons.shopping_bag_outlined,
    iconColor: AppColors.warning,
  ),
  _Transaction(
    title: 'Invoice #1042',
    subtitle: 'Sara Textiles • 2 days ago',
    amount: '+\$3,500.00',
    isCredit: true,
    icon: Icons.receipt_long_outlined,
    iconColor: AppColors.secondary,
  ),
  _Transaction(
    title: 'Utility Bill',
    subtitle: 'KESC • 3 days ago',
    amount: '-\$220.00',
    isCredit: false,
    icon: Icons.bolt_outlined,
    iconColor: AppColors.tertiary,
  ),
  _Transaction(
    title: 'Product Sale',
    subtitle: 'Walk-in customer • 4 days ago',
    amount: '+\$640.00',
    isCredit: true,
    icon: Icons.storefront_outlined,
    iconColor: AppColors.primary,
  ),
];

class _TransactionTile extends StatelessWidget {
  final _Transaction tx;
  const _TransactionTile(this.tx);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h * 1.2),
      padding: EdgeInsets.symmetric(
        horizontal: context.w * 4,
        vertical: context.h * 1.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tx.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(tx.icon, color: tx.iconColor, size: AppSizes.iconMd),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  tx.title,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: AppColors.white,
                  weight: FontWeight.w500,
                ),
                SizedBox(height: context.h * 0.3),
                MyText(
                  tx.subtitle,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
          MyText(
            tx.amount,
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: tx.isCredit ? AppColors.primary : AppColors.error,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Invoices',
            value: '12',
            icon: Icons.receipt_outlined,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: context.w * 3),
        Expanded(
          child: _SummaryCard(
            label: 'Pending',
            value: '4',
            icon: Icons.hourglass_top_outlined,
            color: AppColors.warning,
          ),
        ),
        SizedBox(width: context.w * 3),
        Expanded(
          child: _SummaryCard(
            label: 'Clients',
            value: '27',
            icon: Icons.people_outline,
            color: AppColors.tertiary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.h * 2,
        horizontal: context.w * 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconMd),
          SizedBox(height: context.h * 0.8),
          MyText(
            value,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.bold,
            align: TextAlign.center,
          ),
          SizedBox(height: context.h * 0.3),
          MyText(
            label,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
