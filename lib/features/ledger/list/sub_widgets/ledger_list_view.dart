import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../models/ledger_item.dart';
import 'ledger_tile.dart';

class LedgerListView extends StatelessWidget {
  final List<LedgerItem> ledgers;
  final ValueChanged<LedgerItem>? onLedgerTap;
  final ValueChanged<LedgerItem>? onLedgerEdit;
  final ValueChanged<LedgerItem>? onLedgerDelete;

  const LedgerListView({
    super.key,
    required this.ledgers,
    this.onLedgerTap,
    this.onLedgerEdit,
    this.onLedgerDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ledgers.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (context, index) {
        final ledger = ledgers[index];
        return LedgerTile(
          ledger: ledger,
          index: index,
          onTap: onLedgerTap == null ? null : () => onLedgerTap!(ledger),
          onEdit: onLedgerEdit == null ? null : () => onLedgerEdit!(ledger),
          onDelete: onLedgerDelete,
        );
      },
    );
  }
}
