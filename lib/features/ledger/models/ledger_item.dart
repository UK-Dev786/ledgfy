import 'ledger_type.dart';

class LedgerItem {
  final String id;
  final String title;
  final String description;
  final LedgerType type;
  final DateTime createdAt;
  final double income;
  final double outgoing;

  const LedgerItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.createdAt,
    this.income = 0,
    this.outgoing = 0,
  });

  double get subtotal => income - outgoing;

  bool get hasDescription => description.trim().isNotEmpty;
}
