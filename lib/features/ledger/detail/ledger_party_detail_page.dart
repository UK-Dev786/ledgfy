import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/auth_providers.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_item.dart';
import '../models/party_balance.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/add_party_name_sheet.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_delete_dialog.dart';
import 'sub_widgets/ledger_history_list.dart';
import 'sub_widgets/ledger_party_summary.dart';

class LedgerPartyDetailPage extends ConsumerStatefulWidget {
  final LedgerItem ledger;
  final String partyName;

  const LedgerPartyDetailPage({
    super.key,
    required this.ledger,
    required this.partyName,
  });

  @override
  ConsumerState<LedgerPartyDetailPage> createState() =>
      _LedgerPartyDetailPageState();
}

class _LedgerPartyDetailPageState extends ConsumerState<LedgerPartyDetailPage> {
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

  bool get _isOrganization {
    final accountType =
        ref.watch(authStateChangesProvider).valueOrNull?.accountType;
    return accountType == AppText.accountTypeOrganization;
  }

  List<LedgerAppBarMenuOption> get _menuOptions {
    return [
      const LedgerAppBarMenuOption(
        id: 'add_opponent',
        label: AppText.ledgerAddOpponent,
        icon: Icons.person_add_outlined,
      ),
      if (_isOrganization)
        const LedgerAppBarMenuOption(
          id: 'add_team',
          label: AppText.ledgerAddTeam,
          icon: Icons.groups_outlined,
        ),
      const LedgerAppBarMenuOption(
        id: 'delete',
        label: AppText.ledgerDeleteParty,
        icon: Icons.delete_outline_rounded,
        color: AppColors.error,
      ),
    ];
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

  void _openNewParty({required bool isTeam}) {
    AddPartyNameSheet.show(
      context,
      title: isTeam ? AppText.ledgerAddTeam : AppText.ledgerAddOpponent,
      label: isTeam
          ? AppText.ledgerTeamNameLabel
          : AppText.ledgerOpponentNameLabel,
      hint: isTeam ? AppText.ledgerTeamNameHint : AppText.ledgerOpponentNameHint,
      onAdd: (name) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => LedgerPartyDetailPage(
              ledger: _ledger,
              partyName: name,
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteParty() async {
    final confirmed = await LedgerDeleteDialog.show(
      context,
      title: AppText.ledgerDeletePartyTitle,
      message: AppText.ledgerDeletePartyMessage,
    );
    if (!confirmed || !mounted) return;

    _ledger.entries.removeWhere(
      (entry) =>
          entry.partyName != null &&
          entry.partyName!.trim().toLowerCase() ==
              _partyName.trim().toLowerCase(),
    );
    Navigator.of(context).pop();
  }

  void _handleMenu(String value) {
    switch (value) {
      case 'delete':
        _deleteParty();
      case 'add_opponent':
        _openNewParty(isTeam: false);
      case 'add_team':
        _openNewParty(isTeam: true);
    }
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
                onBack: () => Navigator.of(context).pop(),
                menuOptions: _menuOptions,
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
                      LedgerPartySummary(
                        party: _partyBalance,
                        config: _ledger.config,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      LedgerHistoryList(
                        entries: _partyEntries,
                        config: _ledger.config,
                        showFullAmounts: false,
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
