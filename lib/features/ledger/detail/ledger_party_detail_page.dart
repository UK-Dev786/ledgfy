import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_item.dart';
import '../models/party_balance.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_history_list.dart';
import 'sub_widgets/ledger_party_summary.dart';

class LedgerPartyDetailPage extends StatefulWidget {
  final LedgerItem ledger;
  final String partyName;

  const LedgerPartyDetailPage({
    super.key,
    required this.ledger,
    required this.partyName,
  });

  @override
  State<LedgerPartyDetailPage> createState() => _LedgerPartyDetailPageState();
}

class _LedgerPartyDetailPageState extends State<LedgerPartyDetailPage> {
  bool _showFullAmounts = false;

  LedgerItem get _ledger => widget.ledger;
  String get _partyName => widget.partyName;

  List<LedgerEntry> get _partyEntries {
    return _ledger.entries
        .where(
          (entry) =>
              entry.partyName != null &&
              entry.partyName!.trim().toLowerCase() ==
                  _partyName.trim().toLowerCase(),
        )
        .toList();
  }

  PartyBalance get _partyBalance {
    final existing = _ledger.partyBalances
        .where((p) => p.name.toLowerCase() == _partyName.toLowerCase())
        .toList();
    if (existing.isNotEmpty) return existing.first;
    return PartyBalance(name: _partyName, given: 0, received: 0);
  }

  void _openEntrySheet(LedgerEntryType type) {
    AddLedgerEntrySheet.show(
      context,
      config: _ledger.config,
      type: type,
      partyName: _partyName,
      onAdd: (draft) {
        setState(() {
          _ledger.entries.add(
            LedgerEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              amount: draft.amount,
              type: draft.type,
              createdAt: DateTime.now(),
              partyName: _partyName,
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
                title: _partyName,
                showFullAmounts: _showFullAmounts,
                showDeleteMenu: false,
                onBack: () => Navigator.of(context).pop(),
                onToggleAmounts: () {
                  setState(() => _showFullAmounts = !_showFullAmounts);
                },
                onDelete: () {},
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
                      LedgerPartySummary(
                        party: _partyBalance,
                        config: _ledger.config,
                        showFullAmounts: _showFullAmounts,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      LedgerHistoryList(
                        entries: _partyEntries,
                        config: _ledger.config,
                        showFullAmounts: _showFullAmounts,
                        preferDescriptionAsTitle: true,
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
