import '../../../../core/constants/app_text.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_item.dart';
import '../../models/party_balance.dart';
import 'khata_report_data.dart';

abstract final class KhataReportBuilder {
  static KhataReportData fromLedger(
    LedgerItem ledger, {
    String? partyName,
  }) {
    final config = ledger.config;
    final subName = partyName?.trim();
    final hasSubLedger = subName != null && subName.isNotEmpty;

    final entries = _entriesForScope(ledger, partyName: subName);
    final sorted = [...entries]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    final entryRows = sorted
        .map(
          (entry) => KhataReportEntryRow(
            date: entry.occurredAt,
            title: _entryTitle(entry, ledger, preferNote: hasSubLedger),
            typeLabel: config.labelForEntry(entry.type),
            amount: entry.amount,
          ),
        )
        .toList();

    String? subDescription;
    if (hasSubLedger) {
      final party = ledger.parties
          .where((p) => p.name.toLowerCase() == subName.toLowerCase())
          .toList();
      if (party.isNotEmpty) {
        subDescription = party.first.description;
      }
    }

    if (config.isExpenseOnly) {
      return KhataReportData(
        ledgerTitle: ledger.title,
        ledgerDescription: ledger.hasDescription ? ledger.description : null,
        ledgerTypeLabel: ledger.type.label,
        subLedgerName: subName,
        subLedgerDescription: subDescription,
        summaryRows: [
          KhataReportSummaryRow(
            label: config.balanceLabel,
            amount: ledger.debitTotal,
          ),
        ],
        balance: ledger.balance,
        balanceLabel: config.balanceLabel,
        entries: entryRows,
        generatedAt: DateTime.now(),
      );
    }

    if (hasSubLedger) {
      final balance = _partyBalance(ledger, subName);
      return KhataReportData(
        ledgerTitle: ledger.title,
        ledgerDescription: ledger.hasDescription ? ledger.description : null,
        ledgerTypeLabel: ledger.type.label,
        subLedgerName: subName,
        subLedgerDescription: subDescription,
        summaryRows: [
          KhataReportSummaryRow(
            label: config.creditLabel,
            amount: balance.given,
          ),
          KhataReportSummaryRow(
            label: config.debitLabel,
            amount: balance.received,
          ),
        ],
        balance: balance.balance,
        balanceLabel: config.balanceLabel,
        entries: entryRows,
        generatedAt: DateTime.now(),
      );
    }

    final showOpening = !config.isExpenseOnly;
    final summaryRows = <KhataReportSummaryRow>[
      if (showOpening && ledger.openingBalance != 0)
        KhataReportSummaryRow(
          label: AppText.ledgerOpeningBalance,
          amount: ledger.openingBalance,
        ),
      KhataReportSummaryRow(
        label: config.outflowLabel,
        amount: config.outflowAmount(
          creditTotal: ledger.creditTotal,
          debitTotal: ledger.debitTotal,
        ),
      ),
      KhataReportSummaryRow(
        label: config.inflowLabel,
        amount: config.inflowAmount(
          creditTotal: ledger.creditTotal,
          debitTotal: ledger.debitTotal,
        ),
      ),
    ];

    return KhataReportData(
      ledgerTitle: ledger.title,
      ledgerDescription: ledger.hasDescription ? ledger.description : null,
      ledgerTypeLabel: ledger.type.label,
      openingBalance: ledger.openingBalance,
      showOpeningBalance: showOpening,
      summaryRows: summaryRows,
      balance: ledger.balance,
      balanceLabel: config.balanceLabel,
      entries: entryRows,
      generatedAt: DateTime.now(),
    );
  }

  static List<LedgerEntry> _entriesForScope(
    LedgerItem ledger, {
    String? partyName,
  }) {
    if (partyName == null || partyName.trim().isEmpty) {
      return ledger.entries;
    }
    final key = partyName.trim().toLowerCase();
    return ledger.entries
        .where(
          (entry) =>
              entry.partyName != null &&
              entry.partyName!.trim().toLowerCase() == key,
        )
        .toList();
  }

  static PartyBalance _partyBalance(LedgerItem ledger, String partyName) {
    final existing = ledger.partyBalances
        .where((p) => p.name.toLowerCase() == partyName.toLowerCase())
        .toList();
    if (existing.isNotEmpty) return existing.first;
    return PartyBalance(name: partyName, given: 0, received: 0);
  }

  static String _entryTitle(
    LedgerEntry entry,
    LedgerItem ledger, {
    required bool preferNote,
  }) {
    if (preferNote) {
      if (entry.note != null && entry.note!.trim().isNotEmpty) {
        return entry.note!.trim();
      }
      return AppText.ledgerDefaultEntryName;
    }

    if (entry.partyName != null && entry.partyName!.trim().isNotEmpty) {
      return entry.partyName!.trim();
    }
    if (entry.note != null && entry.note!.trim().isNotEmpty) {
      return entry.note!.trim();
    }
    if (entry.category != null && entry.category!.trim().isNotEmpty) {
      return entry.category!.trim();
    }
    return ledger.config.labelForEntry(entry.type);
  }
}
