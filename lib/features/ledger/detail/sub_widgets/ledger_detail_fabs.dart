import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/rounded_button.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_type_config.dart';

class LedgerDetailFabs extends StatelessWidget {
  final LedgerTypeConfig config;
  final void Function(LedgerEntryType type) onAddTap;

  const LedgerDetailFabs({
    super.key,
    required this.config,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.isExpenseOnly)
            RoundedButton(
              onTap: () => onAddTap(config.singleEntryType),
              icon: config.debitIcon,
              iconColor: config.debitColor,
            )
          else ...[
            RoundedButton(
              onTap: () => onAddTap(config.creditEntryType),
              icon: config.creditIcon,
              iconColor: config.creditColor,
            ),
            const SizedBox(height: AppSizes.md),
            RoundedButton(
              onTap: () => onAddTap(config.debitEntryType!),
              icon: config.debitIcon,
              iconColor: config.debitColor,
            ),
          ],
        ],
      ),
    );
  }
}
