import 'ledger_entry.dart';
import 'ledger_type.dart';

class LedgerItem {
  final String id;
  final String title;
  final String description;
  final LedgerType type;
  final DateTime createdAt;
  final List<LedgerEntry> entries;

  LedgerItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.createdAt,
    List<LedgerEntry>? entries,
  }) : entries = entries ?? [];

  double get income => entries
      .where((entry) => entry.type == LedgerEntryType.income)
      .fold(0.0, (sum, entry) => sum + entry.amount);

  double get outgoing => entries
      .where((entry) => entry.type == LedgerEntryType.outgoing)
      .fold(0.0, (sum, entry) => sum + entry.amount);

  double get subtotal => income - outgoing;

  bool get hasDescription => description.trim().isNotEmpty;
}
