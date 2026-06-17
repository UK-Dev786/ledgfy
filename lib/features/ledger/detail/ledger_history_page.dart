import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_item.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_history_list.dart';

class LedgerHistoryPage extends StatelessWidget {
  final LedgerItem ledger;
  final String? partyName;
  final bool preferDescriptionAsTitle;

  const LedgerHistoryPage({
    super.key,
    required this.ledger,
    this.partyName,
    this.preferDescriptionAsTitle = false,
  });

  List<LedgerEntry> _entries() {
    final party = partyName;
    if (party == null) return ledger.entries;
    return ledger.entries
        .where(
          (entry) =>
              entry.partyName != null &&
              entry.partyName!.trim().toLowerCase() ==
                  party.trim().toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerDetailAppBar(
                title: AppText.ledgerDetailHistory,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    0,
                    AppSizes.lg,
                    AppSizes.xxl,
                  ),
                  child: LedgerHistoryList(
                    entries: _entries(),
                    config: ledger.config,
                    showFullAmounts: false,
                    preferDescriptionAsTitle: preferDescriptionAsTitle,
                    showHeader: false,
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
