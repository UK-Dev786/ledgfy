import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/auth_providers.dart';
import '../../../di/ledger_providers.dart';
import '../models/ledger_entry.dart';
import '../models/ledger_type_config.dart';
import '../models/party_balance.dart';
import '../shared/khata_report/khata_report_page.dart';
import '../shared/ledger_page_route.dart';
import 'ledger_history_page.dart';
import 'ledger_party_detail_page.dart';
import 'sub_widgets/add_ledger_entry_sheet.dart';
import 'sub_widgets/add_party_name_sheet.dart';
import 'sub_widgets/ledger_history_list.dart';
import 'sub_widgets/ledger_party_section.dart';
import 'sub_widgets/ledger_assign_staff_sheet.dart';
import 'sub_widgets/ledger_detail_app_bar.dart';
import 'sub_widgets/ledger_detail_fabs.dart';
import 'sub_widgets/ledger_detail_summary.dart';
import 'sub_widgets/ledger_delete_dialog.dart';
import 'sub_widgets/opening_balance_sheet.dart';

class LedgerDetailPage extends ConsumerWidget {
  final String ledgerId;

  const LedgerDetailPage({super.key, required this.ledgerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgersAsync = ref.watch(ledgersStreamProvider);
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));

    return ledgersAsync.when(
      loading: () => const _LedgerDetailLoading(),
      error: (error, _) => _LedgerDetailError(message: error.toString()),
      data: (_) {
        if (ledger == null) {
          return const _LedgerDetailMissing();
        }
        return _LedgerDetailBody(ledgerId: ledgerId);
      },
    );
  }
}

class _LedgerDetailBody extends ConsumerWidget {
  final String ledgerId;

  const _LedgerDetailBody({required this.ledgerId});

  Future<void> _openPartyDetail(
    BuildContext context,
    String partyName,
  ) async {
    await Navigator.of(context).push<void>(
      ledgerPageRoute(
        LedgerPartyDetailPage(
          ledgerId: ledgerId,
          partyName: partyName,
        ),
      ),
    );
  }

  void _openHistory(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push<void>(
      ledgerPageRoute(LedgerHistoryPage(ledgerId: ledgerId)),
    );
  }

  void _openAddSubLedger(BuildContext context, WidgetRef ref) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    final config = ledger.config;
    AddPartyNameSheet.show(
      context,
      title: config.addSubLedgerTitle,
      label: config.partyLabel,
      hint: config.partyHint,
      nameIcon: config.subLedgerIcon,
      onAdd: (name, description) async {
        await ref.read(ledgerControllerProvider).addParty(
              ledgerId: ledgerId,
              name: name,
              description: description,
            );
        if (!context.mounted) return;
        await _openPartyDetail(context, name.trim());
      },
    );
  }

  void _openEditPartySheet(
    BuildContext context,
    WidgetRef ref,
    PartyBalance party,
  ) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    final config = ledger.config;
    AddPartyNameSheet.show(
      context,
      title: AppText.ledgerEditPartyTitle,
      label: config.partyLabel,
      hint: config.partyHint,
      nameIcon: config.subLedgerIcon,
      initialName: party.name,
      initialDescription: party.description,
      onAdd: (name, description) {
        ref.read(ledgerControllerProvider).updateParty(
              ledgerId: ledgerId,
              currentName: party.name,
              name: name,
              description: description,
            );
      },
    );
  }

  Future<void> _deleteParty(
    BuildContext context,
    WidgetRef ref,
    PartyBalance party,
  ) async {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    await ref.read(ledgerControllerProvider).removeParty(
          ledgerId: ledgerId,
          partyName: party.name,
        );
  }

  void _openEntrySheet(
    BuildContext context,
    WidgetRef ref,
    LedgerEntryType type,
  ) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    AddLedgerEntrySheet.show(
      context,
      config: ledger.config,
      type: type,
      onAdd: (draft) {
        ref.read(ledgerControllerProvider).addEntry(
              ledgerId: ledgerId,
              draft: draft,
            );
      },
    );
  }

  void _openEditEntrySheet(
    BuildContext context,
    WidgetRef ref,
    LedgerEntry entry,
  ) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    AddLedgerEntrySheet.show(
      context,
      config: ledger.config,
      type: entry.type,
      entry: entry,
      partyName: entry.partyName,
      onAdd: (draft) {
        ref.read(ledgerControllerProvider).updateEntry(
              ledgerId: ledgerId,
              entry: entry,
              draft: draft,
            );
      },
    );
  }

  void _deleteEntry(WidgetRef ref, LedgerEntry entry) {
    ref.read(ledgerControllerProvider).deleteEntry(
          ledgerId: ledgerId,
          entryId: entry.id,
        );
  }

  void _openReport(BuildContext context, WidgetRef ref) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;
    KhataReportPage.open(context, ledger: ledger);
  }

  void _openOpeningBalance(BuildContext context, WidgetRef ref) {
    final ledger = ref.read(ledgerByIdProvider(ledgerId));
    if (ledger == null) return;

    OpeningBalanceSheet.show(
      context,
      initialBalance: ledger.openingBalance,
      onSave: (balance) {
        ref.read(ledgerControllerProvider).updateOpeningBalance(
              ledgerId: ledgerId,
              openingBalance: balance,
            );
      },
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await LedgerDeleteDialog.show(context);
    if (!confirmed || !context.mounted) return;

    await ref.read(ledgerControllerProvider).deleteLedger(ledgerId);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  void _handleMenu(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'delete':
        _handleDelete(context, ref);
      case 'opening_balance':
        _openOpeningBalance(context, ref);
      case 'assign_staff':
        final ledger = ref.read(ledgerByIdProvider(ledgerId));
        if (ledger == null) return;
        LedgerAssignStaffSheet.show(
          context,
          ledgerId: ledgerId,
          ledgerTitle: ledger.title,
        );
    }
  }

  bool _isOrganization(WidgetRef ref) {
    final accountType =
        ref.watch(authStateChangesProvider).valueOrNull?.accountType;
    return accountType == AppText.accountTypeOrganization;
  }

  List<LedgerAppBarMenuOption> _menuOptions(
    WidgetRef ref,
    LedgerTypeConfig config,
  ) {
    return [
      if (_isOrganization(ref))
        const LedgerAppBarMenuOption(
          id: 'assign_staff',
          label: AppText.ledgerAssignStaff,
          icon: Icons.groups_outlined,
        ),
      if (!config.isExpenseOnly)
        const LedgerAppBarMenuOption(
          id: 'opening_balance',
          label: AppText.ledgerSetOpeningBalance,
          icon: Icons.savings_outlined,
        ),
      const LedgerAppBarMenuOption(
        id: 'delete',
        label: AppText.ledgerDeleteLedger,
        icon: Icons.delete_outline_rounded,
        color: AppColors.error,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = ref.watch(ledgerByIdProvider(ledgerId));
    if (ledger == null) {
      return const _LedgerDetailMissing();
    }

    final config = ledger.config;
    final supportsSubLedgers = config.supportsSubLedgers;
    final showInlineHistory = !supportsSubLedgers;
    final showFullAmounts = config.showsFullAmountsByDefault;

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: LedgerDetailFabs(
          config: config,
          onAddTap: supportsSubLedgers
              ? null
              : (type) => _openEntrySheet(context, ref, type),
          onAddSubLedger:
              supportsSubLedgers ? () => _openAddSubLedger(context, ref) : null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerDetailAppBar(
                title: ledger.title,
                onBack: () => Navigator.of(context).pop(),
                showHistoryButton: supportsSubLedgers,
                onHistoryTap:
                    supportsSubLedgers ? () => _openHistory(context, ref) : null,
                onReportTap: () => _openReport(context, ref),
                menuOptions: _menuOptions(ref, config),
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
                      LedgerDetailSummary(ledger: ledger),
                      if (supportsSubLedgers) ...[
                        const SizedBox(height: AppSizes.lg),
                        LedgerPartySection(
                          parties: ledger.partyBalances,
                          config: config,
                          showFullAmounts: false,
                          onPartyTap: (partyName) =>
                              _openPartyDetail(context, partyName),
                          onPartyEdit: (party) =>
                              _openEditPartySheet(context, ref, party),
                          onPartyDelete: (party) =>
                              _deleteParty(context, ref, party),
                        ),
                      ],
                      if (showInlineHistory) ...[
                        const SizedBox(height: AppSizes.lg),
                        LedgerHistoryList(
                          entries: ledger.entries,
                          config: config,
                          showFullAmounts: showFullAmounts,
                          onEntryEdit: (entry) =>
                              _openEditEntrySheet(context, ref, entry),
                          onEntryDelete: (entry) => _deleteEntry(ref, entry),
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

class _LedgerDetailLoading extends StatelessWidget {
  const _LedgerDetailLoading();

  @override
  Widget build(BuildContext context) {
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
}

class _LedgerDetailMissing extends StatelessWidget {
  const _LedgerDetailMissing();

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              LedgerDetailAppBar(
                title: AppText.ledgersTitle,
                onBack: () => Navigator.of(context).pop(),
              ),
              const Expanded(
                child: Center(
                  child: MyText(
                    AppText.homeErrorGeneric,
                    font: AppFont.sourceSans,
                    size: AppSizes.subtitle,
                    color: AppColors.textHint,
                    align: TextAlign.center,
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

class _LedgerDetailError extends StatelessWidget {
  final String message;

  const _LedgerDetailError({required this.message});

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: MyText(
                message,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.error,
                align: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
