import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/ledger/models/ledger_entry.dart';

class LedgerEntryModel {
  final String id;
  final double amount;
  final LedgerEntryType type;
  final DateTime createdAt;
  final DateTime occurredAt;
  final String? partyName;
  final String? note;
  final String? category;
  final String? createdByUserId;

  const LedgerEntryModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.occurredAt,
    this.partyName,
    this.note,
    this.category,
    this.createdByUserId,
  });

  factory LedgerEntryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final createdAt = _readDate(data['createdAt']);
    return LedgerEntryModel(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      type: LedgerEntryType.values.firstWhere(
        (value) => value.name == data['type'],
        orElse: () => LedgerEntryType.expense,
      ),
      createdAt: createdAt,
      occurredAt: data['occurredAt'] != null
          ? _readDate(data['occurredAt'])
          : createdAt,
      partyName: data['partyName'] as String?,
      note: data['note'] as String?,
      category: data['category'] as String?,
      createdByUserId: data['createdByUserId'] as String?,
    );
  }

  factory LedgerEntryModel.fromEntity(LedgerEntry entry) {
    return LedgerEntryModel(
      id: entry.id,
      amount: entry.amount,
      type: entry.type,
      createdAt: entry.createdAt,
      occurredAt: entry.occurredAt,
      partyName: entry.partyName,
      note: entry.note,
      category: entry.category,
      createdByUserId: entry.createdByUserId,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'occurredAt': Timestamp.fromDate(occurredAt),
      if (partyName != null && partyName!.isNotEmpty) 'partyName': partyName,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (category != null && category!.isNotEmpty) 'category': category,
      if (createdByUserId != null && createdByUserId!.isNotEmpty)
        'createdByUserId': createdByUserId,
    };
  }

  LedgerEntry toEntity() {
    return LedgerEntry(
      id: id,
      amount: amount,
      type: type,
      createdAt: createdAt,
      occurredAt: occurredAt,
      partyName: partyName,
      note: note,
      category: category,
      createdByUserId: createdByUserId,
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
