import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../../ledger/models/ledger_item.dart';

typedef PartyScopeChanged = void Function(Set<String> partyNames);

class StaffLedgerScopePanel extends StatelessWidget {
  final LedgerItem ledger;
  final Set<String> selectedPartyNames;
  final PartyScopeChanged onChanged;

  const StaffLedgerScopePanel({
    super.key,
    required this.ledger,
    required this.selectedPartyNames,
    required this.onChanged,
  });

  String get _sectionLabel => ledger.config.isProjectLedger
      ? AppText.staffLedgerPickProjects
      : AppText.staffLedgerPickParties;

  List<String> get _partyNames {
    final fromParties = ledger.parties.map((party) => party.name.trim());
    final fromEntries = ledger.entries
        .map((entry) => entry.partyName?.trim())
        .whereType<String>()
        .where((name) => name.isNotEmpty);
    return {...fromParties, ...fromEntries}.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final parties = _partyNames;

    if (parties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.md,
          top: AppSizes.sm,
        ),
        child: MyText(
          ledger.config.isProjectLedger
              ? AppText.staffLedgerNoProjects
              : AppText.staffLedgerNoParties,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
          height: 1.35,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        top: AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            _sectionLabel,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: AppSizes.sm),
          ...parties.map((name) {
            final selected = selectedPartyNames.contains(name);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.xs),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final next = Set<String>.from(selectedPartyNames);
                    if (selected) {
                      next.remove(name);
                    } else {
                      next.add(name);
                    }
                    onChanged(next);
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color:
                              selected ? AppColors.primary : AppColors.textHint,
                          size: AppSizes.iconSm,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: MyText(
                            name,
                            font: AppFont.sourceSans,
                            size: AppSizes.caption,
                            color: selected
                                ? AppColors.white
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
