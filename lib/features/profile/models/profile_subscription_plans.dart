import '../../../core/constants/app_text.dart';

enum SubscriptionBillingPeriod {
  monthly,
  sixMonths,
  yearly,
}

enum SubscriptionPlanTier {
  individual,
  organization,
}

class SubscriptionPriceOption {
  final SubscriptionBillingPeriod period;
  final String label;
  final String priceLabel;
  final String periodLabel;
  final String? savingsLabel;

  const SubscriptionPriceOption({
    required this.period,
    required this.label,
    required this.priceLabel,
    required this.periodLabel,
    this.savingsLabel,
  });
}

/// Subscription copy and pricing for the profile subscription screen (UI only).
abstract final class ProfileSubscriptionPlans {
  static const trialMonths = 2;

  static const freemiumFeatures = [
    'All ledger types — Udhar, Cash, Expense & Project',
    'Add parties (customers & suppliers)',
    'Cash in / out, expenses & opening balance',
    'PDF khata reports & P&L charts',
    'Cloud sync on one device',
  ];

  static const organizationPaidFeatures = [
    'Invite team members with roles',
    'Staff activity & audit history',
    'Multiple shops under one account',
  ];

  static const paidUnlockFeatures = [
    'Unlimited entries after trial',
    'SMS / WhatsApp payment reminders',
    'Multi-device backup & sync',
    'Priority support',
  ];

  static bool isOrganization(String accountType) =>
      accountType == AppText.accountTypeOrganization;

  static List<String> currentPlanFeatures({
    required String accountType,
  }) =>
      [...freemiumFeatures];

  static List<String> paidUnlockFeaturesFor({
    required String accountType,
  }) {
    final features = [...paidUnlockFeatures];
    if (isOrganization(accountType)) {
      features.insertAll(0, organizationPaidFeatures);
    }
    return features;
  }

  static List<SubscriptionPriceOption> pricesFor({
    required String accountType,
  }) {
    final isOrg = isOrganization(accountType);
    if (isOrg) {
      return const [
        SubscriptionPriceOption(
          period: SubscriptionBillingPeriod.monthly,
          label: AppText.profileBillingMonthly,
          priceLabel: 'PKR 999',
          periodLabel: AppText.profileBillingPerMonth,
        ),
        SubscriptionPriceOption(
          period: SubscriptionBillingPeriod.sixMonths,
          label: AppText.profileBillingSixMonths,
          priceLabel: 'PKR 4,999',
          periodLabel: AppText.profileBillingPerSixMonths,
          savingsLabel: AppText.profileBillingSaveSixMonths,
        ),
        SubscriptionPriceOption(
          period: SubscriptionBillingPeriod.yearly,
          label: AppText.profileBillingYearly,
          priceLabel: 'PKR 8,999',
          periodLabel: AppText.profileBillingPerYear,
          savingsLabel: AppText.profileBillingSaveYearly,
        ),
      ];
    }

    return const [
      SubscriptionPriceOption(
        period: SubscriptionBillingPeriod.monthly,
        label: AppText.profileBillingMonthly,
        priceLabel: 'PKR 499',
        periodLabel: AppText.profileBillingPerMonth,
      ),
      SubscriptionPriceOption(
        period: SubscriptionBillingPeriod.sixMonths,
        label: AppText.profileBillingSixMonths,
        priceLabel: 'PKR 2,499',
        periodLabel: AppText.profileBillingPerSixMonths,
        savingsLabel: AppText.profileBillingSaveSixMonths,
      ),
      SubscriptionPriceOption(
        period: SubscriptionBillingPeriod.yearly,
        label: AppText.profileBillingYearly,
        priceLabel: 'PKR 4,499',
        periodLabel: AppText.profileBillingPerYear,
        savingsLabel: AppText.profileBillingSaveYearly,
      ),
    ];
  }
}
