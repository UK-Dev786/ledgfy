import '../../features/ledger/models/ledger_party.dart';

class LedgerPartyModel {
  final String name;
  final String? description;

  const LedgerPartyModel({
    required this.name,
    this.description,
  });

  factory LedgerPartyModel.fromMap(Map<String, dynamic> data) {
    return LedgerPartyModel(
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
    );
  }

  factory LedgerPartyModel.fromEntity(LedgerParty party) {
    return LedgerPartyModel(
      name: party.name,
      description: party.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }

  LedgerParty toEntity() {
    return LedgerParty(
      name: name,
      description: description,
    );
  }
}
