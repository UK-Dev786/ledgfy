import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/auth_providers.dart';
import '../../../di/ledger_providers.dart';
import '../models/ledger_entry.dart';
import '../models/party_balance.dart';
import '../shared/khata_report/khata_report_page.dart';
import '../shared/ledger_page_route.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/add_party_name_sheet.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_delete_dialog.dart';
import 'sub_widgets/ledger_history_list.dart';
import 'sub_widgets/ledger_party_summary.dart';

class LedgerPartyDetailPage extends ConsumerWidget {
  final String ledgerId;
  final String partyName;

  const LedgerPartyDetailPage({
    super.key,
    required this.ledgerId,
    required this.partyName,
  });

  List<LedgerEntry> _partyEntries(WidgetRef ref) {
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));
    if (ledger == null) return const [];

    final key = partyName.trim().toLowerCase();
    return ledger.entries
        .where(
          (entry) =>
              entry.partyName != null &&
              entry.partyName!.trim().toLowerCase() == key,
        )
        .toList();
  }

  PartyBalance _partyBalance(WidgetRef ref) {
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));
    if (ledger == null) {
      return PartyBalance(name: partyName, given: 0, received: 0);
    }

    final existing = ledger.partyBalances
        .where((party) => party.name.toLowerCase() == partyName.toLowerCase())
        .toList();
    if (existing.isNotEmpty) return existing.first;
    return PartyBalance(name: partyName, given: 0, received: 0);
  }

  bool _isOrganization(WidgetRef ref) {
    final accountType =
        ref.watch(authStateChangesProvider).valueOrNull?.accountType;
    return accountType == AppText.accountTypeOrganization;
  }

  List<LedgerAppBarMenuOption> _menuOptions(WidgetRef ref) {
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));
    if (ledger == null) return const [];

    if (ledger.config.isProjectLedger) {
      return [
        LedgerAppBarMenuOption(
          id: 'delete',
          label: ledger.config.deleteSubLedgerLabel,
          icon: Icons.delete_outline_rounded,
          color: AppColors.error,
        ),
      ];
    }

    return [
      const LedgerAppBarMenuOption(
        id: 'add_opponent',
        label: AppText.ledgerAddOpponent,
        icon: Icons.person_add_outlined,
      ),
      if (_isOrganization(ref))
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

  void _openEntrySheet(BuildContext context, WidgetRef ref, LedgerEntryType type) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    AddLedgerEntrySheet.show(
      context,
      config: ledger.config,
      type: type,
      partyName: partyName,
      onAdd: (draft) {
        ref.read(ledgerControllerProvider).addEntry(
              ledgerId: ledgerId,
              draft: draft,
              partyName: partyName,
            );
      },
    );
  }

  void _openNewParty(
    BuildContext context,
    WidgetRef ref, {
    required bool isTeam,
  }) {
    AddPartyNameSheet.show(
      context,
      title: isTeam ? AppText.ledgerAddTeam : AppText.ledgerAddOpponent,
      label: isTeam
          ? AppText.ledgerTeamNameLabel
          : AppText.ledgerOpponentNameLabel,
      hint: isTeam ? AppText.ledgerTeamNameHint : AppText.ledgerOpponentNameHint,
      onAdd: (name, description) async {
        await ref.read(ledgerControllerProvider).addParty(
              ledgerId: ledgerId,
              name: name,
              description: description,
            );
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          ledgerPageRoute(
            LedgerPartyDetailPage(
              ledgerId: ledgerId,
              partyName: name.trim(),
            ),
          ),
        );
      },
    );
  }

  void _openReport(BuildContext context, WidgetRef ref) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    KhataReportPage.open(
      context,
      ledger: ledger,
      partyName: partyName,
    );
  }

  Future<void> _deleteSubLedger(BuildContext context, WidgetRef ref) async {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    final config = ledger.config;
    final confirmed = await LedgerDeleteDialog.show(
      context,
      title: config.deleteSubLedgerTitle,
      message: config.deleteSubLedgerMessage,
    );
    if (!confirmed || !context.mounted) return;

    await ref.read(ledgerControllerProvider).removeParty(
          ledgerId: ledgerId,
          partyName: partyName,
        );
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  void _handleMenu(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'delete':
        _deleteSubLedger(context, ref);
      case 'add_opponent':
        _openNewParty(context, ref, isTeam: false);
      case 'add_team':
        _openNewParty(context, ref, isTeam: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));
    if (ledger == null) {
      return const ThemedGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    final config = ledger.config;
    final partyEntries = _partyEntries(ref);
    final partyBalance = _partyBalance(ref);

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: LedgerDetailFabs(
          config: config,
          onAddTap: (type) => _openEntrySheet(context, ref, type),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerDetailAppBar(
                title: partyName,
                onBack: () => Navigator.of(context).pop(),
                onReportTap: () => _openReport(context, ref),
                menuOptions: _menuOptions(ref),
                onMenuSelected: (value) => _handleMenu(context, ref, value),
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
                        party: partyBalance,
                        config: config,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      LedgerHistoryList(
                        entries: partyEntries,
                        config: config,
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
