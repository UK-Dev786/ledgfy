import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/ledger/models/ledger_entry.dart';
import '../../features/ledger/models/ledger_item.dart';
import '../../features/ledger/models/ledger_type.dart';
import 'ledger_party_model.dart';

class LedgerItemModel {
  final String id;
  final String title;
  final String description;
  final LedgerType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double openingBalance;
  final List<LedgerPartyModel> parties;
  final List<LedgerEntry> entries;

  const LedgerItemModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.openingBalance = 0,
    this.parties = const [],
    this.entries = const [],
  });

  factory LedgerItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    List<LedgerEntry> entries = const [],
  }) {
    final data = doc.data() ?? {};
    final partyMaps = (data['parties'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(LedgerPartyModel.fromMap)
        .toList();

    return LedgerItemModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      type: LedgerType.byId(data['type'] as String? ?? LedgerType.general.id),
      createdAt: _readDate(data['createdAt']),
      updatedAt: _readDate(data['updatedAt'] ?? data['createdAt']),
      openingBalance: (data['openingBalance'] as num?)?.toDouble() ?? 0,
      parties: partyMaps,
      entries: entries,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.id,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'openingBalance': openingBalance,
      'parties': parties.map((party) => party.toMap()).toList(),
    };
  }

  LedgerItem toEntity() {
    return LedgerItem(
      id: id,
      title: title,
      description: description,
      type: type,
      createdAt: createdAt,
      openingBalance: openingBalance,
      entries: List<LedgerEntry>.from(entries),
      parties: parties.map((party) => party.toEntity()).toList(),
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
