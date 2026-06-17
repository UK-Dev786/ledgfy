import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../models/ledger_type_config.dart';
import '../../models/party_balance.dart';

class LedgerPartySection extends StatelessWidget {
  final List<PartyBalance> parties;
  final LedgerTypeConfig config;

  const LedgerPartySection({
    super.key,
    required this.parties,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (!config.supportsPartyLedger) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: MyText(
                AppText.ledgerPartiesTitle,
                font: AppFont.inter,
                size: AppSizes.title,
                color: AppColors.white,
                weight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
              child: MyText(
                AppText.ledgerProBadge,
                font: AppFont.inter,
                size: AppSizes.caption,
                color: AppColors.primary,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        MyText(
          AppText.ledgerPartiesSubtitle,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
          height: 1.4,
        ),
        const SizedBox(height: AppSizes.md),
        if (parties.isEmpty)
          MyCard(
            borderRadius: AppSizes.radiusMd,
            child: MyText(
              AppText.ledgerPartiesEmpty,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              align: TextAlign.center,
              height: 1.45,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: parties.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              final party = parties[index];
              return SharedEntranceAnimation(
                delay: Duration(milliseconds: 50 * index.clamp(0, 4)),
                child: _PartyTile(party: party, config: config),
              );
            },
          ),
      ],
    );
  }
}

class _PartyTile extends StatelessWidget {
  final PartyBalance party;
  final LedgerTypeConfig config;

  const _PartyTile({required this.party, required this.config});

  @override
  Widget build(BuildContext context) {
    final balanceColor = party.balance > 0
        ? AppColors.success
        : party.balance < 0
        ? AppColors.error
        : AppColors.textTertiary;

    return MyCard(
      borderRadius: AppSizes.radiusMd,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: AppSizes.iconSm,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  party.name,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                MyText(
                  '${config.creditLabel} ${CurrencyFormatter.format(party.given, abbreviate: true)} · '
                  '${config.debitLabel} ${CurrencyFormatter.format(party.received, abbreviate: true)}',
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          MyText(
            CurrencyFormatter.format(party.balance, abbreviate: true),
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: balanceColor,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
