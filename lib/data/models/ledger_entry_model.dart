import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/ledger/models/ledger_entry.dart';

class LedgerEntryModel {
  final String id;
  final double amount;
  final LedgerEntryType type;
  final DateTime createdAt;
  final String? partyName;
  final String? note;
  final String? category;

  const LedgerEntryModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    this.partyName,
    this.note,
    this.category,
  });

  factory LedgerEntryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LedgerEntryModel(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      type: LedgerEntryType.values.firstWhere(
        (value) => value.name == data['type'],
        orElse: () => LedgerEntryType.expense,
      ),
      createdAt: _readDate(data['createdAt']),
      partyName: data['partyName'] as String?,
      note: data['note'] as String?,
      category: data['category'] as String?,
    );
  }

  factory LedgerEntryModel.fromEntity(LedgerEntry entry) {
    return LedgerEntryModel(
      id: entry.id,
      amount: entry.amount,
      type: entry.type,
      createdAt: entry.createdAt,
      partyName: entry.partyName,
      note: entry.note,
      category: entry.category,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (partyName != null && partyName!.isNotEmpty) 'partyName': partyName,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (category != null && category!.isNotEmpty) 'category': category,
    };
  }

  LedgerEntry toEntity() {
    return LedgerEntry(
      id: id,
      amount: amount,
      type: type,
      createdAt: createdAt,
      partyName: partyName,
      note: note,
      category: category,
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
