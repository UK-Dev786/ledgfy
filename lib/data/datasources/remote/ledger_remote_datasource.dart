import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features/ledger/models/ledger_entry.dart';
import '../../../features/ledger/models/ledger_item.dart';
import '../../../features/ledger/models/ledger_party.dart';
import '../../../features/ledger/models/ledger_type.dart';
import '../../models/ledger_entry_model.dart';
import '../../models/ledger_item_model.dart';
import '../../models/ledger_party_model.dart';
import '../../../core/utils/auth_token_helper.dart';

class LedgerRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  LedgerRemoteDataSource(this._firestore, this._auth);

  final _pendingController = StreamController<bool>.broadcast();

  /// Reactive pending-write flag — fed by [watchLedgers] snapshot metadata.
  Stream<bool> get pendingWrites => _pendingController.stream;

  CollectionReference<Map<String, dynamic>> _ledgers(String userId) {
    return _firestore.collection('users').doc(userId).collection('ledgers');
  }

  DocumentReference<Map<String, dynamic>> _ledgerRef(
    String userId,
    String ledgerId,
  ) {
    return _ledgers(userId).doc(ledgerId);
  }

  Stream<List<LedgerItem>> watchLedgers(String userId) {
    late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
        ledgerSubscription;
    final entrySubscriptions =
        <String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>{};
    final entryLists = <String, List<LedgerEntry>>{};
    final entryReady = <String, bool>{};
    final latestEntrySnapshots =
        <String, QuerySnapshot<Map<String, dynamic>>>{};
    var latestDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    final controller = StreamController<List<LedgerItem>>.broadcast();

    if (!_pendingController.isClosed) {
      _pendingController.add(false);
    }

    void emitPending() {
      if (_pendingController.isClosed) return;
      final entriesPending = latestEntrySnapshots.values.any(
        (snapshot) =>
            snapshot.docs.any((doc) => doc.metadata.hasPendingWrites),
      );
      _pendingController.add(entriesPending);
    }

    List<LedgerItem> buildItems() {
      return latestDocs
          .map(
            (doc) => LedgerItemModel.fromFirestore(
              doc,
              entries: entryLists[doc.id] ?? const [],
            ).toEntity(),
          )
          .toList();
    }

    void emitItems() {
      if (controller.isClosed) return;
      controller.add(buildItems());
    }

    void emitWhenEntriesReady() {
      if (controller.isClosed) return;
      if (latestDocs.isEmpty) {
        controller.add(const []);
        return;
      }

      final allReady = latestDocs.every((doc) => entryReady[doc.id] == true);
      if (allReady) {
        emitItems();
      }
    }

    void syncEntryListeners() {
      final activeIds = latestDocs.map((doc) => doc.id).toSet();
      var removedLedger = false;

      for (final ledgerId in entrySubscriptions.keys.toList()) {
        if (!activeIds.contains(ledgerId)) {
          entrySubscriptions.remove(ledgerId)?.cancel();
          entryLists.remove(ledgerId);
          entryReady.remove(ledgerId);
          latestEntrySnapshots.remove(ledgerId);
          removedLedger = true;
        }
      }

      if (removedLedger) {
        emitWhenEntriesReady();
        emitPending();
      }

      for (final doc in latestDocs) {
        final ledgerId = doc.id;
        if (entrySubscriptions.containsKey(ledgerId)) continue;

        entryReady[ledgerId] = false;
        entrySubscriptions[ledgerId] = doc.reference
            .collection('entries')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen(
          (entrySnapshot) {
            latestEntrySnapshots[ledgerId] = entrySnapshot;
            entryLists[ledgerId] = entrySnapshot.docs
                .map(
                  (entryDoc) =>
                      LedgerEntryModel.fromFirestore(entryDoc).toEntity(),
                )
                .toList();

            final wasReady = entryReady[ledgerId] == true;
            entryReady[ledgerId] = true;

            if (!wasReady) {
              emitWhenEntriesReady();
            } else {
              emitItems();
            }
            emitPending();
          },
          onError: controller.addError,
        );
      }
    }

    ledgerSubscription = _ledgers(userId)
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen(
      (ledgerSnapshot) {
        latestDocs = ledgerSnapshot.docs;
        syncEntryListeners();

        if (latestDocs.isEmpty) {
          controller.add(const []);
          emitPending();
          return;
        }

        if (latestDocs.every((doc) => entryReady[doc.id] == true)) {
          emitItems();
        }
        emitPending();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await ledgerSubscription.cancel();
      for (final subscription in entrySubscriptions.values) {
        await subscription.cancel();
      }
      entrySubscriptions.clear();
      entryLists.clear();
      entryReady.clear();
      latestEntrySnapshots.clear();
    };

    return controller.stream;
  }

  Future<void> _ensureAuthReady() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await ensureAuthToken(user);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getLedgerDoc(
    DocumentReference<Map<String, dynamic>> ledgerRef,
  ) async {
    try {
      final cached = await ledgerRef.get(const GetOptions(source: Source.cache));
      if (cached.exists) return cached;
    } catch (_) {}

    return ledgerRef.get(const GetOptions(source: Source.serverAndCache));
  }

  Future<List<LedgerPartyModel>> _readParties(
    DocumentReference<Map<String, dynamic>> ledgerRef,
  ) async {
    final snapshot = await _getLedgerDoc(ledgerRef);
    final data = snapshot.data() ?? {};
    return (data['parties'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(LedgerPartyModel.fromMap)
        .toList();
  }

  Future<void> _writeParties(
    DocumentReference<Map<String, dynamic>> ledgerRef,
    List<LedgerPartyModel> parties,
  ) async {
    await ledgerRef.set({
      'parties': parties.map((party) => party.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> createLedger({
    required String userId,
    required String title,
    required String description,
    required LedgerType type,
  }) async {
    await _ensureAuthReady();
    final now = DateTime.now();
    final doc = await _ledgers(userId).add({
      'title': title,
      'description': description,
      'type': type.id,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'openingBalance': 0,
      'parties': <Map<String, dynamic>>[],
    });
    return doc.id;
  }

  Future<void> deleteLedger({
    required String userId,
    required String ledgerId,
  }) async {
    await _ensureAuthReady();
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await _deleteCollectionInBatches(ledgerRef.collection('entries'));
    await ledgerRef.delete();
  }

  Future<void> updateLedger({
    required String userId,
    required String ledgerId,
    required String title,
    required String description,
  }) async {
    await _ensureAuthReady();
    await _ledgerRef(userId, ledgerId).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateOpeningBalance({
    required String userId,
    required String ledgerId,
    required double openingBalance,
  }) async {
    await _ensureAuthReady();
    await _ledgerRef(userId, ledgerId).update({
      'openingBalance': openingBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addParty({
    required String userId,
    required String ledgerId,
    required LedgerParty party,
  }) async {
    await _ensureAuthReady();
    final ledgerRef = _ledgerRef(userId, ledgerId);
    final parties = await _readParties(ledgerRef);

    final exists = parties.any(
      (item) => item.name.toLowerCase() == party.name.toLowerCase(),
    );
    if (exists) return;

    final partyMap = LedgerPartyModel.fromEntity(party).toMap();
    await ledgerRef.set({
      'parties': FieldValue.arrayUnion([partyMap]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateParty({
    required String userId,
    required String ledgerId,
    required String currentName,
    required LedgerParty party,
  }) async {
    await _ensureAuthReady();
    final ledgerRef = _ledgerRef(userId, ledgerId);
    final currentKey = currentName.trim().toLowerCase();
    final newName = party.name.trim();
    final renamed = newName.toLowerCase() != currentKey;

    final parties = await _readParties(ledgerRef);
    final index = parties.indexWhere(
      (item) => item.name.toLowerCase() == currentKey,
    );
    if (index < 0) return;

    if (renamed &&
        parties.any(
          (item) => item.name.toLowerCase() == newName.toLowerCase(),
        )) {
      return;
    }

    parties[index] = LedgerPartyModel.fromEntity(party);
    await _writeParties(ledgerRef, parties);

    if (!renamed) return;

    final entries = await ledgerRef.collection('entries').get(
      const GetOptions(source: Source.serverAndCache),
    );
    final matching = entries.docs.where((doc) {
      final name = doc.data()['partyName'] as String?;
      return name != null && name.trim().toLowerCase() == currentKey;
    }).toList();

    for (var index = 0; index < matching.length; index += 450) {
      final batch = _firestore.batch();
      final chunk = matching.skip(index).take(450);
      for (final doc in chunk) {
        batch.update(doc.reference, {'partyName': newName});
      }
      await batch.commit();
    }
  }

  Future<void> removeParty({
    required String userId,
    required String ledgerId,
    required String partyName,
  }) async {
    await _ensureAuthReady();
    final ledgerRef = _ledgerRef(userId, ledgerId);
    final key = partyName.trim().toLowerCase();

    final parties = await _readParties(ledgerRef);
    final filtered = parties
        .where((party) => party.name.toLowerCase() != key)
        .toList();
    await _writeParties(ledgerRef, filtered);

    final entries = await ledgerRef.collection('entries').get(
      const GetOptions(source: Source.serverAndCache),
    );
    await _deleteDocsInBatches(
      entries.docs.where((doc) {
        final name = doc.data()['partyName'] as String?;
        return name != null && name.trim().toLowerCase() == key;
      }),
    );
  }

  Future<void> addEntry({
    required String userId,
    required String ledgerId,
    required LedgerEntry entry,
  }) async {
    await _ensureAuthReady();
    final model = LedgerEntryModel.fromEntity(entry);
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await ledgerRef.collection('entries').doc(entry.id).set(model.toFirestore());
    await ledgerRef.update({'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateEntry({
    required String userId,
    required String ledgerId,
    required LedgerEntry entry,
  }) async {
    await _ensureAuthReady();
    final model = LedgerEntryModel.fromEntity(entry);
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await ledgerRef
        .collection('entries')
        .doc(entry.id)
        .update(model.toFirestore());
    await ledgerRef.update({'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteEntry({
    required String userId,
    required String ledgerId,
    required String entryId,
  }) async {
    await _ensureAuthReady();
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await ledgerRef.collection('entries').doc(entryId).delete();
    await ledgerRef.update({'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> _deleteCollectionInBatches(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    while (true) {
      final snapshot = await collection.limit(450).get();
      if (snapshot.docs.isEmpty) return;
      await _deleteDocsInBatches(snapshot.docs);
    }
  }

  Future<void> _deleteDocsInBatches(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final docsList = docs.toList();
    if (docsList.isEmpty) return;

    for (var index = 0; index < docsList.length; index += 450) {
      final batch = _firestore.batch();
      final chunk = docsList.skip(index).take(450);
      for (final doc in chunk) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
