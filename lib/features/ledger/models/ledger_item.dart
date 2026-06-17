import 'ledger_type.dart';

class LedgerItem {
  final String id;
  final String title;
  final LedgerType type;
  final DateTime createdAt;

  const LedgerItem({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });
}
