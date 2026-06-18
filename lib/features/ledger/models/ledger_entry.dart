enum LedgerEntryType {
  given,
  received,
  income,
  outgoing,
  expense,
}

class LedgerEntry {
  final String id;
  final double amount;
  final LedgerEntryType type;
  final DateTime createdAt;
  final DateTime occurredAt;
  final String? partyName;
  final String? note;
  final String? category;

  const LedgerEntry({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.occurredAt,
    this.partyName,
    this.note,
    this.category,
  });
}

class LedgerEntryDraft {
  final double amount;
  final LedgerEntryType type;
  final DateTime? occurredAt;
  final String? partyName;
  final String? note;
  final String? category;

  const LedgerEntryDraft({
    required this.amount,
    required this.type,
    this.occurredAt,
    this.partyName,
    this.note,
    this.category,
  });
}
