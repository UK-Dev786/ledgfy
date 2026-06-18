import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/profile_subscription_plans.dart';
import '../sub_widgets/profile_sub_page_scaffold.dart';

class ProfileSubscriptionPage extends StatefulWidget {
  final String accountType;

  const ProfileSubscriptionPage({
    super.key,
    required this.accountType,
  });

  static void open(
    BuildContext context, {
    required String accountType,
  }) {
    ProfileSubPageScaffold.open<void>(
      context,
      ProfileSubscriptionPage(accountType: accountType),
    );
  }

  @override
  State<ProfileSubscriptionPage> createState() => _ProfileSubscriptionPageState();
}

class _ProfileSubscriptionPageState extends State<ProfileSubscriptionPage> {
  SubscriptionBillingPeriod _billingPeriod =
      SubscriptionBillingPeriod.yearly;

  bool get _isOrganization =>
      ProfileSubscriptionPlans.isOrganization(widget.accountType);

  SubscriptionPriceOption get _selectedPrice {
    final options = ProfileSubscriptionPlans.pricesFor(
      accountType: widget.accountType,
    );
    return options.firstWhere((item) => item.period == _billingPeriod);
  }

  void _subscribe() {
    context.popMsg(
      AppText.profileComingSoon,
      icon: Icons.workspace_premium_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFeatures = ProfileSubscriptionPlans.currentPlanFeatures(
      accountType: widget.accountType,
    );
    final paidFeatures = ProfileSubscriptionPlans.paidUnlockFeaturesFor(
      accountType: widget.accountType,
    );
    final trialBadge = AppText.profileTrialBadge.replaceAll(
      '{months}',
      '${ProfileSubscriptionPlans.trialMonths}',
    );

    return ProfileSubPageScaffold(
      title: AppText.profileSubscriptionTitle,
      subtitle: AppText.profileSubscriptionSubtitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          0,
          AppSizes.lg,
          AppSizes.xxl * 2,
        ),
        children: [
          const _SectionHeading(title: AppText.profileCurrentPlanTitle),
          const SizedBox(height: AppSizes.sm),
          MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            blur: 28,
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _PlanBadge(
                      label: trialBadge,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    _PlanBadge(
                      label: widget.accountType,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                MyText(
                  _isOrganization
                      ? AppText.profilePlanOrganization
                      : AppText.profilePlanIndividual,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w800,
                ),
                const SizedBox(height: AppSizes.sm),
                const MyText(
                  AppText.profileTrialNote,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  height: 1.45,
                ),
                const SizedBox(height: AppSizes.lg),
                const MyText(
                  AppText.profileFreemiumFeaturesTitle,
                  font: AppFont.inter,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: AppSizes.sm),
                ...currentFeatures.map(
                  (item) => _BenefitRow(text: item, included: true),
                ),
                if (!_isOrganization) ...[
                  const SizedBox(height: AppSizes.md),
                  const MyText(
                    AppText.profileTeamOrgOnlyTitle,
                    font: AppFont.inter,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ...ProfileSubscriptionPlans.organizationPaidFeatures.map(
                    (item) => _BenefitRow(
                      text: item,
                      included: false,
                      locked: true,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  const MyText(
                    AppText.profileTeamOrgOnlyNote,
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                    height: 1.4,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const _SectionHeading(title: AppText.profilePaidUnlockTitle),
          const SizedBox(height: AppSizes.sm),
          MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            blur: 24,
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              children: paidFeatures
                  .map(
                    (item) => _BenefitRow(
                      text: item,
                      included: false,
                      isPro: true,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const _SectionHeading(title: AppText.profileChoosePlan),
          const SizedBox(height: AppSizes.sm),
          ...ProfileSubscriptionPlans.pricesFor(
            accountType: widget.accountType,
          ).map((option) {
            final selected = option.period == _billingPeriod;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _PricingPlanCard(
                option: option,
                selected: selected,
                accountType: widget.accountType,
                onTap: () => setState(() => _billingPeriod = option.period),
              ),
            );
          }),
          SizedBox(height: context.h * 1),
          MyButton(
            text:
                '${AppText.profileSubscribe} · ${_selectedPrice.priceLabel}${_selectedPrice.periodLabel}',
            onTap: _subscribe,
          ),
        ],
      ),
    );
  }
}

class _PricingPlanCard extends StatelessWidget {
  final SubscriptionPriceOption option;
  final bool selected;
  final String accountType;
  final VoidCallback onTap;

  const _PricingPlanCard({
    required this.option,
    required this.selected,
    required this.accountType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.7)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            blur: selected ? 28 : 20,
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? AppColors.primary : AppColors.textHint,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      option.label,
                      font: AppFont.inter,
                      size: AppSizes.body,
                      color: AppColors.white,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    MyText(
                      accountType,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    option.priceLabel,
                    font: AppFont.inter,
                    size: AppSizes.title,
                    color: AppColors.primary,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    option.periodLabel,
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                  ),
                  if (option.savingsLabel != null) ...[
                    const SizedBox(height: 2),
                    MyText(
                      option.savingsLabel!,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.secondary,
                      weight: FontWeight.w600,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PlanBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: MyText(
        label,
        font: AppFont.sourceSans,
        size: AppSizes.caption,
        color: color,
        weight: FontWeight.w600,
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.xs),
      child: MyText(
        title,
        font: AppFont.inter,
        size: AppSizes.caption,
        color: AppColors.textHint,
        weight: FontWeight.w600,
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;
  final bool included;
  final bool isPro;
  final bool locked;

  const _BenefitRow({
    required this.text,
    required this.included,
    this.isPro = false,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final icon = locked
        ? Icons.lock_outline_rounded
        : (included ? Icons.check_circle_rounded : Icons.star_rounded);
    final color = locked
        ? AppColors.textHint
        : (isPro ? AppColors.tertiaryLight : AppColors.primary);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: color),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: MyText(
              text,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: locked ? AppColors.textHint : AppColors.white,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
