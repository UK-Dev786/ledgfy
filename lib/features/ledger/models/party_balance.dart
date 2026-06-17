import 'ledger_entry.dart';
import 'ledger_party.dart';
import 'ledger_type_config.dart';

class PartyBalance {
  final String name;
  final double given;
  final double received;
  final String? description;

  const PartyBalance({
    required this.name,
    required this.given,
    required this.received,
    this.description,
  });

  double get balance => given - received;
}

abstract final class PartyBalanceCalculator {
  static List<PartyBalance> calculate({
    required List<LedgerEntry> entries,
    required LedgerTypeConfig config,
    List<LedgerParty> parties = const [],
  }) {
    if (!config.supportsSubLedgers) return const [];

    final totals = <String, ({double given, double received})>{};
    final descriptions = <String, String>{};

    for (final party in parties) {
      final name = party.name.trim();
      if (name.isEmpty) continue;
      final key = name.toLowerCase();
      totals.putIfAbsent(key, () => (given: 0.0, received: 0.0));
      if (party.description != null && party.description!.trim().isNotEmpty) {
        descriptions[key] = party.description!.trim();
      }
    }

    for (final entry in entries) {
      final name = entry.partyName?.trim();
      if (name == null || name.isEmpty) continue;

      final key = name.toLowerCase();
      totals.putIfAbsent(key, () => (given: 0.0, received: 0.0));

      final current = totals[key]!;
      if (config.creditTypes.contains(entry.type)) {
        totals[key] = (
          given: current.given + entry.amount,
          received: current.received,
        );
      } else if (config.debitTypes.contains(entry.type)) {
        totals[key] = (
          given: current.given,
          received: current.received + entry.amount,
        );
      }
    }

    final displayNames = <String, String>{};
    for (final party in parties) {
      final name = party.name.trim();
      if (name.isNotEmpty) displayNames[name.toLowerCase()] = name;
    }
    for (final entry in entries) {
      final name = entry.partyName?.trim();
      if (name != null && name.isNotEmpty) {
        displayNames.putIfAbsent(name.toLowerCase(), () => name);
      }
    }

    final result = displayNames.entries
        .map((entry) {
          final totalsForParty =
              totals[entry.key] ?? (given: 0.0, received: 0.0);
          return PartyBalance(
            name: entry.value,
            given: totalsForParty.given,
            received: totalsForParty.received,
            description: descriptions[entry.key],
          );
        })
        .toList()
      ..sort((a, b) => b.balance.abs().compareTo(a.balance.abs()));

    return result;
  }
}
