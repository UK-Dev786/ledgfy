import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../models/ledger_item.dart';
import 'ledger_tile.dart';

class LedgerListView extends StatelessWidget {
  final List<LedgerItem> ledgers;

  const LedgerListView({super.key, required this.ledgers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ledgers.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (context, index) {
        return LedgerTile(
          ledger: ledgers[index],
          index: index,
        );
      },
    );
  }
}
