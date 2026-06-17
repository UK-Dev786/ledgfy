import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_item.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/ledger_party_section.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_detail_summary.dart';
import 'sub_widgets/ledger_history_list.dart';

class LedgerDetailPage extends StatefulWidget {
  final LedgerItem ledger;

  const LedgerDetailPage({super.key, required this.ledger});

  @override
  State<LedgerDetailPage> createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends State<LedgerDetailPage> {
  LedgerItem get _ledger => widget.ledger;

  void _openEntrySheet(LedgerEntryType type) {
    AddLedgerEntrySheet.show(
      context,
      config: _ledger.config,
      type: type,
      onAdd: (draft) {
        setState(() {
          _ledger.entries.add(
            LedgerEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              amount: draft.amount,
              type: draft.type,
              createdAt: DateTime.now(),
              partyName: draft.partyName,
              note: draft.note,
              category: draft.category,
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: LedgerDetailFabs(
          config: _ledger.config,
          onAddTap: _openEntrySheet,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerDetailAppBar(
                ledger: _ledger,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    0,
                    AppSizes.lg,
                    AppSizes.xxl * 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LedgerDetailSummary(ledger: _ledger),
                      if (_ledger.config.supportsPartyLedger) ...[
                        const SizedBox(height: AppSizes.lg),
                        LedgerPartySection(
                          parties: _ledger.partyBalances,
                          config: _ledger.config,
                        ),
                      ],
                      const SizedBox(height: AppSizes.lg),
                      LedgerHistoryList(
                        entries: _ledger.entries,
                        config: _ledger.config,
                      ),
                    ],
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
