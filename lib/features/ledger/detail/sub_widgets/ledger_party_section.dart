import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../models/ledger_type_config.dart';
import '../../models/party_balance.dart';
import '../../shared/sub_widgets/ledger_simple_amount.dart';

class LedgerPartySection extends StatefulWidget {
  final List<PartyBalance> parties;
  final LedgerTypeConfig config;
  final bool showFullAmounts;
  final ValueChanged<String> onPartyTap;

  const LedgerPartySection({
    super.key,
    required this.parties,
    required this.config,
    required this.showFullAmounts,
    required this.onPartyTap,
  });

  @override
  State<LedgerPartySection> createState() => _LedgerPartySectionState();
}

class _LedgerPartySectionState extends State<LedgerPartySection> {
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PartyBalance> get _filteredParties {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return widget.parties;
    return widget.parties
        .where((party) => party.name.toLowerCase().contains(query))
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.supportsPartyLedger) return const SizedBox.shrink();

    final filtered = _filteredParties;

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
            IconButton(
              onPressed: _toggleSearch,
              icon: Icon(
                _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                color: _searchOpen ? AppColors.primary : AppColors.textHint,
                size: AppSizes.iconMd,
              ),
            ),
          ],
        ),
        if (_searchOpen) ...[
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.subtitle,
            ),
            decoration: InputDecoration(
              hintText: AppText.ledgerPartiesSearchHint,
              hintStyle: TextStyle(
                color: AppColors.textHint.withValues(alpha: 0.7),
                fontSize: AppSizes.subtitle,
              ),
              filled: true,
              fillColor: AppColors.white.withValues(alpha: 0.04),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.textHint.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.textHint.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
        MyText(
          AppText.ledgerPartiesSubtitle,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
          height: 1.4,
        ),
        const SizedBox(height: AppSizes.md),
        if (filtered.isEmpty)
          MyCard(
            borderRadius: AppSizes.radiusMd,
            child: MyText(
              _searchController.text.trim().isEmpty
                  ? AppText.ledgerPartiesEmpty
                  : AppText.ledgerPartiesSearchEmpty,
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
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              final party = filtered[index];
              return SharedEntranceAnimation(
                delay: Duration(milliseconds: 50 * index.clamp(0, 4)),
                child: _PartyTile(
                  party: party,
                  config: widget.config,
                  showFullAmounts: widget.showFullAmounts,
                  onTap: () => widget.onPartyTap(party.name),
                ),
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
  final bool showFullAmounts;
  final VoidCallback onTap;

  const _PartyTile({
    required this.party,
    required this.config,
    required this.showFullAmounts,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final balanceColor = party.balance > 0
        ? AppColors.success
        : party.balance < 0
        ? AppColors.error
        : AppColors.textTertiary;

    return Bounce(
      duration: const Duration(milliseconds: 100),
      onTap: onTap,
      child: MyCard(
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
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      LedgerSimpleAmount(
                        icon: config.creditIcon,
                        color: config.creditColor,
                        amount: party.given,
                        abbreviate: !showFullAmounts,
                        iconSize: 12,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      LedgerSimpleAmount(
                        icon: config.debitIcon,
                        color: config.debitColor,
                        amount: party.received,
                        abbreviate: !showFullAmounts,
                        iconSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            LedgerSimpleAmount(
              icon: Icons.account_balance_wallet_outlined,
              color: balanceColor,
              amount: party.balance,
              abbreviate: !showFullAmounts,
            ),
            const SizedBox(width: AppSizes.xs),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: AppSizes.iconSm + 2,
            ),
          ],
        ),
      ),
    );
  }
}
