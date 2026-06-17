enum LedgerEntryType { income, outgoing }

class LedgerEntry {
  final String id;
  final double amount;
  final LedgerEntryType type;
  final DateTime createdAt;

  const LedgerEntry({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
  });
}
