import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/ledger_entry.dart';
import '../../../core/widgets/rounded_button.dart';

class LedgerDetailFabs extends StatelessWidget {
  final void Function(LedgerEntryType type) onAddTap;

  const LedgerDetailFabs({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundedButton(
            onTap: () => onAddTap(LedgerEntryType.income),
            icon: Icons.arrow_upward_rounded,
            iconColor: AppColors.success,
          ),
          const SizedBox(height: AppSizes.md),
          RoundedButton(
            onTap: () => onAddTap(LedgerEntryType.outgoing),
            icon: Icons.arrow_downward_rounded,
            iconColor: AppColors.error,
          ),
        ],
      ),
    );
  }
}
