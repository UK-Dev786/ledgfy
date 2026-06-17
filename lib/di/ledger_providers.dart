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
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(const []);
  }

  final repository = ref.watch(ledgerRepositoryProvider);
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
}

final ledgerControllerProvider = Provider<LedgerController>((ref) {
  return LedgerController(ref);
});
