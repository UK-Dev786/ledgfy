import '../../features/ledger/models/ledger_entry.dart';
import '../../features/ledger/models/ledger_item.dart';
import '../../features/ledger/models/ledger_party.dart';
import '../../features/ledger/models/ledger_type.dart';

abstract class ILedgerRepository {
  Stream<List<LedgerItem>> watchLedgers(String userId);

  Future<String> createLedger({
    required String userId,
    required String title,
    required String description,
    required LedgerType type,
  });

  Future<void> deleteLedger({
    required String userId,
    required String ledgerId,
  });

  Future<void> updateLedger({
    required String userId,
    required String ledgerId,
    required String title,
    required String description,
  });

  Future<void> updateOpeningBalance({
    required String userId,
    required String ledgerId,
    required double openingBalance,
  });

  Future<void> addParty({
    required String userId,
    required String ledgerId,
    required LedgerParty party,
  });

  Future<void> removeParty({
    required String userId,
    required String ledgerId,
    required String partyName,
  });

  Future<void> addEntry({
    required String userId,
    required String ledgerId,
    required LedgerEntry entry,
  });
}
