import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/rounded_button.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_type_config.dart';

class LedgerDetailFabs extends StatelessWidget {
  final LedgerTypeConfig config;
  final void Function(LedgerEntryType type)? onAddTap;
  final VoidCallback? onAddSubLedger;

  const LedgerDetailFabs({
    super.key,
    required this.config,
    this.onAddTap,
    this.onAddSubLedger,
  });

  @override
  Widget build(BuildContext context) {
    if (config.supportsSubLedgers && onAddSubLedger != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.md),
        child: RoundedButton(
          onTap: onAddSubLedger!,
          icon: config.addSubLedgerFabIcon,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.isExpenseOnly)
            RoundedButton(
              onTap: () => onAddTap!(config.singleEntryType),
              icon: config.debitIcon,
              iconColor: config.debitColor,
            )
          else ...[
            RoundedButton(
              onTap: () => onAddTap!(config.outflowEntryType),
              icon: config.outflowIcon,
              iconColor: config.outflowColor,
            ),
            const SizedBox(height: AppSizes.md),
            RoundedButton(
              onTap: () => onAddTap!(config.inflowEntryType),
              icon: config.inflowIcon,
              iconColor: config.inflowColor,
            ),
          ],
        ],
      ),
    );
  }
}
