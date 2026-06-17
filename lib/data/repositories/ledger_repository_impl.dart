import '../../features/ledger/models/ledger_entry.dart';
import '../../features/ledger/models/ledger_item.dart';
import '../../features/ledger/models/ledger_party.dart';
import '../../features/ledger/models/ledger_type.dart';
import '../../domain/repositories/i_ledger_repository.dart';
import '../datasources/remote/ledger_remote_datasource.dart';

class LedgerRepositoryImpl implements ILedgerRepository {
  final LedgerRemoteDataSource _remoteDataSource;

  LedgerRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<LedgerItem>> watchLedgers(String userId) {
    return _remoteDataSource.watchLedgers(userId);
  }

  @override
  Future<String> createLedger({
    required String userId,
    required String title,
    required String description,
    required LedgerType type,
  }) {
    return _remoteDataSource.createLedger(
      userId: userId,
      title: title,
      description: description,
      type: type,
    );
  }

  @override
  Future<void> deleteLedger({
    required String userId,
    required String ledgerId,
  }) {
    return _remoteDataSource.deleteLedger(
      userId: userId,
      ledgerId: ledgerId,
    );
  }

  @override
  Future<void> updateLedger({
    required String userId,
    required String ledgerId,
    required String title,
    required String description,
  }) {
    return _remoteDataSource.updateLedger(
      userId: userId,
      ledgerId: ledgerId,
      title: title,
      description: description,
    );
  }

  @override
  Future<void> updateOpeningBalance({
    required String userId,
    required String ledgerId,
    required double openingBalance,
  }) {
    return _remoteDataSource.updateOpeningBalance(
      userId: userId,
      ledgerId: ledgerId,
      openingBalance: openingBalance,
    );
  }

  @override
  Future<void> addParty({
    required String userId,
    required String ledgerId,
    required LedgerParty party,
  }) {
    return _remoteDataSource.addParty(
      userId: userId,
      ledgerId: ledgerId,
      party: party,
    );
  }

  @override
  Future<void> updateParty({
    required String userId,
    required String ledgerId,
    required String currentName,
    required LedgerParty party,
  }) {
    return _remoteDataSource.updateParty(
      userId: userId,
      ledgerId: ledgerId,
      currentName: currentName,
      party: party,
    );
  }

  @override
  Future<void> removeParty({
    required String userId,
    required String ledgerId,
    required String partyName,
  }) {
    return _remoteDataSource.removeParty(
      userId: userId,
      ledgerId: ledgerId,
      partyName: partyName,
    );
  }

  @override
  Future<void> addEntry({
    required String userId,
    required String ledgerId,
    required LedgerEntry entry,
  }) {
    return _remoteDataSource.addEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: entry,
    );
  }

  @override
  Future<void> updateEntry({
    required String userId,
    required String ledgerId,
    required LedgerEntry entry,
  }) {
    return _remoteDataSource.updateEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: entry,
    );
  }

  @override
  Future<void> deleteEntry({
    required String userId,
    required String ledgerId,
    required String entryId,
  }) {
    return _remoteDataSource.deleteEntry(
      userId: userId,
      ledgerId: ledgerId,
      entryId: entryId,
    );
  }
}
