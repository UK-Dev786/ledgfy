import 'ledger_entry.dart';
import 'ledger_type_config.dart';

class PartyBalance {
  final String name;
  final double given;
  final double received;

  const PartyBalance({
    required this.name,
    required this.given,
    required this.received,
  });

  double get balance => given - received;
}

abstract final class PartyBalanceCalculator {
  static List<PartyBalance> fromEntries({
    required List<LedgerEntry> entries,
    required LedgerTypeConfig config,
  }) {
    if (!config.supportsPartyLedger) return const [];

    final totals = <String, ({double given, double received})>{};

    for (final entry in entries) {
      final name = entry.partyName?.trim();
      if (name == null || name.isEmpty) continue;

      final current = totals[name] ?? (given: 0.0, received: 0.0);
      if (config.creditTypes.contains(entry.type)) {
        totals[name] = (
          given: current.given + entry.amount,
          received: current.received,
        );
      } else if (config.debitTypes.contains(entry.type)) {
        totals[name] = (
          given: current.given,
          received: current.received + entry.amount,
        );
      }
    }

    final parties = totals.entries
        .map(
          (entry) => PartyBalance(
            name: entry.key,
            given: entry.value.given,
            received: entry.value.received,
          ),
        )
        .toList()
      ..sort((a, b) => b.balance.abs().compareTo(a.balance.abs()));

    return parties;
  }
}
