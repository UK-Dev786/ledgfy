import '../../ledger/models/ledger_entry.dart';
import '../../ledger/models/ledger_item.dart';
import '../models/home_dashboard_data.dart';

abstract final class HomeDashboardAnalytics {
  static HomeDashboardData build({
    required List<LedgerItem> ledgers,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final monthStart = DateTime(reference.year, reference.month, 1);
    final monthEnd = DateTime(reference.year, reference.month + 1, 1);

    var totalIncome = 0.0;
    var totalExpense = 0.0;
    final recentEntries = <HomeRecordItem>[];
    final ledgerGroups = <HomeLedgerGroup>[];

    for (final ledger in ledgers) {
      final config = ledger.config;
      var ledgerIncome = 0.0;
      var ledgerTxnCount = 0;

      for (final entry in ledger.entries) {
        if (entry.createdAt.isBefore(monthStart) ||
            !entry.createdAt.isBefore(monthEnd)) {
          continue;
        }

        final isCredit = config.creditTypes.contains(entry.type);
        final isDebit = config.debitTypes.contains(entry.type);
        if (!isCredit && !isDebit) continue;

        ledgerTxnCount++;
        if (isCredit) {
          totalIncome += entry.amount;
          ledgerIncome += entry.amount;
        } else {
          totalExpense += entry.amount;
        }

        recentEntries.add(
          HomeRecordItem(
            id: '${ledger.id}_${entry.id}',
            title: _entryTitle(entry, config.labelForEntry(entry.type)),
            ledgerName: ledger.title,
            category: entry.category,
            amount: entry.amount,
            isIncome: isCredit,
            date: entry.createdAt,
            icon: ledger.type.icon,
            ledgerId: ledger.id,
          ),
        );
      }

      if (ledgerTxnCount > 0) {
        ledgerGroups.add(
          HomeLedgerGroup(
            ledgerId: ledger.id,
            ledgerName: ledger.title,
            icon: ledger.type.icon,
            totalIncome: ledgerIncome,
            transactionCount: ledgerTxnCount,
          ),
        );
      }
    }

    recentEntries.sort((a, b) => b.date.compareTo(a.date));

    return HomeDashboardData(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      recentEntries: recentEntries.take(5).toList(),
      topLedgers: ledgerGroups,
    );
  }

  static String _entryTitle(LedgerEntry entry, String fallback) {
    final note = entry.note?.trim();
    if (note != null && note.isNotEmpty) return note;

    final category = entry.category?.trim();
    if (category != null && category.isNotEmpty) return category;

    final party = entry.partyName?.trim();
    if (party != null && party.isNotEmpty) return party;

    return fallback;
  }
}
