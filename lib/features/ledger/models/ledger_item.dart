import 'ledger_entry.dart';
import 'ledger_type.dart';
import 'ledger_type_config.dart';
import 'party_balance.dart';

class LedgerItem {
  final String id;
  final String title;
  final String description;
  final LedgerType type;
  final DateTime createdAt;
  final List<LedgerEntry> entries;
  final double openingBalance;

  LedgerItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.createdAt,
    List<LedgerEntry>? entries,
    this.openingBalance = 0,
  }) : entries = entries ?? [];

  LedgerTypeConfig get config => LedgerTypeConfig.forType(type);

  double get creditTotal => entries
      .where((entry) => config.creditTypes.contains(entry.type))
      .fold(0.0, (sum, entry) => sum + entry.amount);

  double get debitTotal => entries
      .where((entry) => config.debitTypes.contains(entry.type))
      .fold(0.0, (sum, entry) => sum + entry.amount);

  double get balance {
    if (config.isExpenseOnly) return debitTotal;
    return openingBalance + creditTotal - debitTotal;
  }

  List<PartyBalance> get partyBalances =>
      PartyBalanceCalculator.fromEntries(entries: entries, config: config);

  bool get hasDescription => description.trim().isNotEmpty;

  // Legacy aliases for list tiles during transition.
  double get income => creditTotal;

  double get outgoing => debitTotal;

  double get subtotal => balance;
}
