import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/ledger_remote_datasource.dart';
import '../data/repositories/ledger_repository_impl.dart';
import '../domain/repositories/i_ledger_repository.dart';
import '../features/ledger/models/ledger_entry.dart';
import '../features/ledger/models/ledger_item.dart';
import '../features/ledger/models/ledger_party.dart';
import '../features/ledger/models/ledger_type.dart';
import '../features/profile/models/ledger_staff_assignment.dart';
import '../features/profile/services/staff_ledger_permissions.dart';
import 'auth_providers.dart';
import 'profile_providers.dart';
import 'organization_providers.dart';

final ledgerRemoteDataSourceProvider = Provider<LedgerRemoteDataSource>((ref) {
  return LedgerRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

final ledgerRepositoryProvider = Provider<ILedgerRepository>((ref) {
  return LedgerRepositoryImpl(ref.watch(ledgerRemoteDataSourceProvider));
});

final ledgersStreamProvider = StreamProvider<List<LedgerItem>>((ref) {
  final ownerId = ref.watch(ledgerOwnerIdProvider);
  final cachedUid = ref.watch(firebaseAuthProvider).currentUser?.uid;
  final userId = ownerId ?? cachedUid;
  if (userId == null) {
    return const Stream<List<LedgerItem>>.empty();
  }
  return ref.watch(ledgerRepositoryProvider).watchLedgers(userId);
});

final ledgersProvider = Provider<List<LedgerItem>>((ref) {
  return ref.watch(ledgersStreamProvider).maybeWhen(
        data: (ledgers) => ledgers,
        orElse: () => const [],
      );
});

final staffLedgerPermissionsProvider = Provider<StaffLedgerPermissions>((ref) {
  final user = ref.watch(profileUserStreamProvider).valueOrNull;
  final grants = ref.watch(staffGrantsStreamProvider).valueOrNull ?? const {};
  return StaffLedgerPermissions(user: user, grants: grants);
});

/// True when signed-in user is organization staff (`memberKind: staff`).
final isStaffUserProvider = Provider<bool>((ref) {
  return ref.watch(profileUserStreamProvider).valueOrNull?.isOrganizationStaff ??
      false;
});

final isStaffViewerForLedgerProvider = Provider.family<bool, String>((
  ref,
  ledgerId,
) {
  if (!ref.watch(isStaffUserProvider)) return false;
  final grant = ref.watch(staffGrantsStreamProvider).valueOrNull?[ledgerId];
  return grant?.access == LedgerStaffAccess.viewer;
});

final isStaffEditorForLedgerProvider = Provider.family<bool, String>((
  ref,
  ledgerId,
) {
  if (!ref.watch(isStaffUserProvider)) return false;
  final grant = ref.watch(staffGrantsStreamProvider).valueOrNull?[ledgerId];
  return grant?.access == LedgerStaffAccess.editor;
});

final scopedLedgersProvider = Provider<List<LedgerItem>>((ref) {
  final ledgers = ref.watch(ledgersProvider);
  final permissions = ref.watch(staffLedgerPermissionsProvider);
  if (!permissions.isStaff) {
    return ledgers;
  }
  if (permissions.grants.isEmpty) {
    return const [];
  }
  final grantedLedgers = ledgers
      .where((ledger) => permissions.grants.containsKey(ledger.id))
      .toList();
  return permissions.scopeLedgers(grantedLedgers);
});

final ledgerByIdProvider = Provider.family<LedgerItem?, String>((ref, ledgerId) {
  final ledgers = ref.watch(scopedLedgersProvider);
  for (final ledger in ledgers) {
    if (ledger.id == ledgerId) return ledger;
  }
  return null;
});

class LedgerController {
  LedgerController(this._ref);

  final Ref _ref;

  ILedgerRepository get _repository => _ref.read(ledgerRepositoryProvider);

  String? get _ledgerOwnerId => _ref.read(ledgerOwnerIdProvider);

  String? get _actorUserId => _ref.read(currentUserIdProvider);

  StaffLedgerPermissions get _permissions =>
      _ref.read(staffLedgerPermissionsProvider);

  Future<void> createLedger({
    required String title,
    required String description,
    required LedgerType type,
  }) async {
    if (!_permissions.canCreateLedger) return;

    final userId = _ledgerOwnerId;
    if (userId == null) return;

    await _repository.createLedger(
      userId: userId,
      title: title,
      description: description,
      type: type,
    );
  }

  Future<void> deleteLedger(String ledgerId) async {
    if (!_permissions.canManageLedger(ledgerId)) return;

    final userId = _ledgerOwnerId;
    if (userId == null) return;

    await _repository.deleteLedger(userId: userId, ledgerId: ledgerId);
  }

  Future<void> updateLedger({
    required String ledgerId,
    required String title,
    required String description,
  }) async {
    if (!_permissions.canManageLedger(ledgerId)) return;

    final userId = _ledgerOwnerId;
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
    if (!_permissions.canManageLedger(ledgerId)) return;

    final userId = _ledgerOwnerId;
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
    if (!_permissions.canManageParties(ledgerId)) return;

    final userId = _ledgerOwnerId;
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
    if (!_permissions.canManageParties(ledgerId)) return;

    final userId = _ledgerOwnerId;
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
    if (!_permissions.canManageParties(ledgerId)) return;

    final userId = _ledgerOwnerId;
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
    if (!_permissions.canAddEntry(ledgerId)) return;

    final userId = _ledgerOwnerId;
    if (userId == null) return;

    final now = DateTime.now();
    final date = draft.occurredAt ?? now;
    final occurredAt = DateTime(
      date.year,
      date.month,
      date.day,
      now.hour,
      now.minute,
      now.second,
    );

    await _repository.addEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: LedgerEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: draft.amount,
        type: draft.type,
        createdAt: now,
        occurredAt: occurredAt,
        partyName: partyName ?? draft.partyName,
        note: draft.note,
        category: draft.category,
        createdByUserId: _actorUserId,
      ),
    );
  }

  Future<void> updateEntry({
    required String ledgerId,
    required LedgerEntry entry,
    required LedgerEntryDraft draft,
    String? partyName,
  }) async {
    if (!_permissions.canEditEntry(entry, ledgerId)) return;

    final userId = _ledgerOwnerId;
    if (userId == null) return;

    final date = draft.occurredAt ?? entry.occurredAt;
    final occurredAt = DateTime(
      date.year,
      date.month,
      date.day,
      entry.occurredAt.hour,
      entry.occurredAt.minute,
      entry.occurredAt.second,
    );

    await _repository.updateEntry(
      userId: userId,
      ledgerId: ledgerId,
      entry: LedgerEntry(
        id: entry.id,
        amount: draft.amount,
        type: entry.type,
        createdAt: entry.createdAt,
        occurredAt: occurredAt,
        partyName: partyName ?? draft.partyName ?? entry.partyName,
        note: draft.note,
        category: draft.category,
        createdByUserId: entry.createdByUserId,
      ),
    );
  }

  Future<void> deleteEntry({
    required String ledgerId,
    required String entryId,
  }) async {
    final ledger = _ref.read(ledgerByIdProvider(ledgerId));
    final entry = ledger?.entries.where((item) => item.id == entryId).firstOrNull;
    if (entry == null || !_permissions.canDeleteEntry(entry, ledgerId)) return;

    final userId = _ledgerOwnerId;
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
