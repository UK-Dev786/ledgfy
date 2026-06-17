import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../detail/sub_widgets/ledger_delete_dialog.dart';
import '../../models/ledger_item.dart';
import '../../models/ledger_type_config.dart';
import '../../shared/sub_widgets/ledger_amount_expand_button.dart';
import '../../shared/sub_widgets/ledger_simple_amount.dart';

class LedgerTile extends StatefulWidget {
  final LedgerItem ledger;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final ValueChanged<LedgerItem>? onDelete;

  const LedgerTile({
    super.key,
    required this.ledger,
    required this.index,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<LedgerTile> createState() => _LedgerTileState();
}

class _LedgerTileState extends State<LedgerTile> {
  late bool _showFullAmounts = widget.ledger.config.showsFullAmountsByDefault;

  String _format(double amount) {
    if (_showFullAmounts) return CurrencyFormatter.format(amount);
    return CurrencyFormatter.formatCompact(amount);
  }

  Future<bool> _confirmDelete() {
    return LedgerDeleteDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.ledger.config;

    return SharedEntranceAnimation(
      delay: Duration(milliseconds: 80 * widget.index.clamp(0, 4)),
      child: Dismissible(
        key: ValueKey(widget.ledger.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => _confirmDelete(),
        onDismissed: (_) => widget.onDelete?.call(widget.ledger),
        background: ClipPath(
          clipper: MyCardCornerCutClipper(
            radius: AppSizes.radiusLg,
            cutSize: 44,
          ),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSizes.lg),
            color: AppColors.error.withValues(alpha: 0.92),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.white,
              size: AppSizes.iconMd,
            ),
          ),
        ),
        child: MyCard(
          cutTopRightCorner: true,
          cornerCutSize: 44,
          topRightCorner: widget.onEdit == null
              ? null
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onEdit,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                      size: 15,
                    ),
                  ),
                ),
          borderRadius: AppSizes.radiusLg,
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.sm + 2,
            AppSizes.md,
            AppSizes.sm + 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm + 2,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Icon(
                          widget.ledger.type.icon,
                          color: AppColors.primary,
                          size: AppSizes.iconSm + 2,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm + 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText(
                              widget.ledger.title,
                              font: AppFont.inter,
                              size: AppSizes.subtitle,
                              color: AppColors.white,
                              weight: FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.ledger.hasDescription) ...[
                              const SizedBox(height: 2),
                              MyText(
                                widget.ledger.description,
                                font: AppFont.sourceSans,
                                size: AppSizes.caption,
                                color: AppColors.textHint,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: AppSizes.sm),
                            _AmountsRow(
                              ledger: widget.ledger,
                              config: config,
                              formatter: _format,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (config.showAmountExpandButton)
                LedgerAmountExpandButton(
                  showFullAmounts: _showFullAmounts,
                  onTap: () =>
                      setState(() => _showFullAmounts = !_showFullAmounts),
                ),
              InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: const Padding(
                  padding: EdgeInsets.all(AppSizes.xs),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                    size: AppSizes.iconSm + 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountsRow extends StatelessWidget {
  final LedgerItem ledger;
  final LedgerTypeConfig config;
  final String Function(double) formatter;

  const _AmountsRow({
    required this.ledger,
    required this.config,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    if (config.isExpenseOnly) {
      return LedgerSimpleAmount(
        icon: config.debitIcon,
        color: config.debitColor,
        amount: ledger.balance,
        formatter: formatter,
        iconSize: 12,
      );
    }

    return Row(
      children: [
        LedgerSimpleAmount(
          icon: config.outflowIcon,
          color: config.outflowColor,
          amount: config.outflowAmount(
            creditTotal: ledger.creditTotal,
            debitTotal: ledger.debitTotal,
          ),
          formatter: formatter,
          iconSize: 12,
        ),
        const SizedBox(width: AppSizes.sm),
        LedgerSimpleAmount(
          icon: config.inflowIcon,
          color: config.inflowColor,
          amount: config.inflowAmount(
            creditTotal: ledger.creditTotal,
            debitTotal: ledger.debitTotal,
          ),
          formatter: formatter,
          iconSize: 12,
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: LedgerSimpleAmount(
            icon: Icons.account_balance_wallet_outlined,
            color: _balanceColor(ledger.balance),
            amount: ledger.balance,
            formatter: formatter,
            // iconSize: 12,
          ),
        ),
      ],
    );
  }

  Color _balanceColor(double balance) {
    if (balance > 0) return AppColors.success;
    if (balance < 0) return AppColors.error;
    return AppColors.textTertiary;
  }
}
