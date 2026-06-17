import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/ledger_remote_datasource.dart';
import '../data/repositories/ledger_repository_impl.dart';
import '../domain/repositories/i_ledger_repository.dart';
import '../features/ledger/models/ledger_entry.dart';
import '../features/ledger/models/ledger_item.dart';
import '../features/ledger/models/ledger_party.dart';
import '../features/ledger/models/ledger_type.dart';
import 'auth_providers.dart';

final ledgerRemoteDataSourceProvider = Provider<LedgerRemoteDataSource>((ref) {
  return LedgerRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

final ledgerRepositoryProvider = Provider<ILedgerRepository>((ref) {
  return LedgerRepositoryImpl(ref.watch(ledgerRemoteDataSourceProvider));
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull?.id;
});

final ledgersStreamProvider = StreamProvider<List<LedgerItem>>((ref) {
  final authAsync = ref.watch(authStateChangesProvider);
  final repository = ref.watch(ledgerRepositoryProvider);
  final cachedUid = ref.watch(firebaseAuthProvider).currentUser?.uid;

  if (authAsync.isLoading) {
    if (cachedUid != null) {
      return repository.watchLedgers(cachedUid);
    }
    return const Stream<List<LedgerItem>>.empty();
  }

  if (authAsync.hasError) {
    if (cachedUid != null) {
      return repository.watchLedgers(cachedUid);
    }
    return Stream<List<LedgerItem>>.error(
      authAsync.error!,
      authAsync.stackTrace,
    );
  }

  final userId = authAsync.valueOrNull?.id;
  if (userId == null) {
    return Stream.value(const []);
  }

  return repository.watchLedgers(userId);
});

final ledgersProvider = Provider<List<LedgerItem>>((ref) {
  return ref.watch(ledgersStreamProvider).maybeWhen(
        data: (ledgers) => ledgers,
        orElse: () => const [],
      );
});

final ledgerByIdProvider = Provider.family<LedgerItem?, String>((ref, ledgerId) {
  final ledgers = ref.watch(ledgersProvider);
  for (final ledger in ledgers) {
    if (ledger.id == ledgerId) return ledger;
  }
  return null;
});

class LedgerController {
  LedgerController(this._ref);

  final Ref _ref;

  ILedgerRepository get _repository => _ref.read(ledgerRepositoryProvider);

  String? get _userId => _ref.read(currentUserIdProvider);

  Future<void> createLedger({
    required String title,
    required String description,
    required LedgerType type,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.createLedger(
      userId: userId,
      title: title,
      description: description,
      type: type,
    );
  }

  Future<void> deleteLedger(String ledgerId) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.deleteLedger(userId: userId, ledgerId: ledgerId);
  }

  Future<void> updateLedger({
    required String ledgerId,
    required String title,
    required String description,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.updateLedger(
      userId: userId,
      ledgerId: ledgerId,
      title: title,
      description: description,
    );
  }

  Future<void> updateOpeningBalance({
    required String ledgerId,
    required double openingBalance,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.updateOpeningBalance(
      userId: userId,
      ledgerId: ledgerId,
      openingBalance: openingBalance,
    );
  }

  Future<void> addParty({
    required String ledgerId,
    required String name,
    String? description,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    await _repository.addParty(
      userId: userId,
      ledgerId: ledgerId,
      party: LedgerParty(
        name: trimmed,
        description: description?.trim().isEmpty == true
            ? null
            : description?.trim(),
      ),
    );
  }

  Future<void> updateParty({
    required String ledgerId,
    required String currentName,
    required String name,
    String? description,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    await _repository.updateParty(
      userId: userId,
      ledgerId: ledgerId,
      currentName: currentName,
      party: LedgerParty(
        name: trimmed,
        description: description?.trim().isEmpty == true
            ? null
            : description?.trim(),
      ),
    );
  }

  Future<void> removeParty({
    required String ledgerId,
    required String partyName,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.removeParty(
      userId: userId,
      ledgerId: ledgerId,
      partyName: partyName,
    );
  }

  Future<void> addEntry({
    required String ledgerId,
    required LedgerEntryDraft draft,
    String? partyName,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.addEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: LedgerEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: draft.amount,
        type: draft.type,
        createdAt: DateTime.now(),
        partyName: partyName ?? draft.partyName,
        note: draft.note,
        category: draft.category,
      ),
    );
  }

  Future<void> updateEntry({
    required String ledgerId,
    required LedgerEntry entry,
    required LedgerEntryDraft draft,
    String? partyName,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.updateEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: LedgerEntry(
        id: entry.id,
        amount: draft.amount,
        type: entry.type,
        createdAt: entry.createdAt,
        partyName: partyName ?? draft.partyName ?? entry.partyName,
        note: draft.note,
        category: draft.category,
      ),
    );
  }

  Future<void> deleteEntry({
    required String ledgerId,
    required String entryId,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    await _repository.deleteEntry(
      userId: userId,
      ledgerId: ledgerId,
      entryId: entryId,
    );
  }
}

final ledgerControllerProvider = Provider<LedgerController>((ref) {
  return LedgerController(ref);
});
