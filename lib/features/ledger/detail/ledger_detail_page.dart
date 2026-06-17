import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_item.dart';
import '../shared/ledger_page_route.dart';
import 'ledger_history_page.dart';
import 'ledger_party_detail_page.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/add_party_name_sheet.dart';
import 'sub_widgets/ledger_history_list.dart';
import 'sub_widgets/ledger_party_section.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_detail_summary.dart';
import 'sub_widgets/ledger_delete_dialog.dart';

class LedgerDetailPage extends StatefulWidget {
  final LedgerItem ledger;

  const LedgerDetailPage({super.key, required this.ledger});

  @override
  State<LedgerDetailPage> createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends State<LedgerDetailPage> {
  LedgerItem get _ledger => widget.ledger;

  Future<void> _openPartyDetail(String partyName) async {
    await Navigator.of(context).push<void>(
      ledgerPageRoute(
        LedgerPartyDetailPage(
          ledger: _ledger,
          partyName: partyName,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  void _openHistory() {
    Navigator.of(context).push<void>(
      ledgerPageRoute(LedgerHistoryPage(ledger: _ledger)),
    );
  }

  void _openAddSubLedger() {
    final config = _ledger.config;
    AddPartyNameSheet.show(
      context,
      title: config.addSubLedgerTitle,
      label: config.partyLabel,
      hint: config.partyHint,
      nameIcon: config.subLedgerIcon,
      onAdd: (name, description) {
        setState(() => _ledger.addParty(name, description: description));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _openPartyDetail(name);
        });
      },
    );
  }

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

  Future<void> _handleDelete() async {
    final confirmed = await LedgerDeleteDialog.show(context);
    if (confirmed && mounted) {
      Navigator.of(context).pop(_ledger.id);
    }
  }

  void _handleMenu(String value) {
    if (value == 'delete') _handleDelete();
  }

  @override
  Widget build(BuildContext context) {
    final config = _ledger.config;
    final supportsSubLedgers = config.supportsSubLedgers;
    final showInlineHistory = !supportsSubLedgers;
    final showFullAmounts = config.showsFullAmountsByDefault;

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: LedgerDetailFabs(
          config: config,
          onAddTap: supportsSubLedgers ? null : _openEntrySheet,
          onAddSubLedger: supportsSubLedgers ? _openAddSubLedger : null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerDetailAppBar(
                title: _ledger.title,
                onBack: () => Navigator.of(context).pop(),
                showHistoryButton: supportsSubLedgers,
                onHistoryTap: supportsSubLedgers ? _openHistory : null,
                menuOptions: const [
                  LedgerAppBarMenuOption(
                    id: 'delete',
                    label: AppText.ledgerDeleteLedger,
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                ],
                onMenuSelected: _handleMenu,
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
                      if (supportsSubLedgers) ...[
                        const SizedBox(height: AppSizes.lg),
                        LedgerPartySection(
                          parties: _ledger.partyBalances,
                          config: config,
                          showFullAmounts: false,
                          onPartyTap: _openPartyDetail,
                        ),
                      ],
                      if (showInlineHistory) ...[
                        const SizedBox(height: AppSizes.lg),
                        LedgerHistoryList(
                          entries: _ledger.entries,
                          config: config,
                          showFullAmounts: showFullAmounts,
                        ),
                      ],
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
