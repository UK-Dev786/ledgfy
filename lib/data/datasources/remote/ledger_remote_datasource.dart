import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/ledger/models/ledger_entry.dart';
import '../../../features/ledger/models/ledger_item.dart';
import '../../../features/ledger/models/ledger_party.dart';
import '../../../features/ledger/models/ledger_type.dart';
import '../../models/ledger_entry_model.dart';
import '../../models/ledger_item_model.dart';
import '../../models/ledger_party_model.dart';

class LedgerRemoteDataSource {
  final FirebaseFirestore _firestore;

  LedgerRemoteDataSource(this._firestore);

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
    return _ledgers(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncExpand(_watchEntriesForLedgers);
  }

  Stream<List<LedgerItem>> _watchEntriesForLedgers(
    QuerySnapshot<Map<String, dynamic>> ledgerSnapshot,
  ) {
    final docs = ledgerSnapshot.docs;
    if (docs.isEmpty) {
      return Stream.value(const []);
    }

    final controller = StreamController<List<LedgerItem>>();
    final entryLists = List<List<LedgerEntry>>.generate(
      docs.length,
      (_) => const [],
    );
    final subscriptions = <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];

    void emit() {
      if (controller.isClosed) return;
      final items = List<LedgerItem>.generate(docs.length, (index) {
        return LedgerItemModel.fromFirestore(
          docs[index],
          entries: entryLists[index],
        ).toEntity();
      });
      controller.add(items);
    }

    for (var index = 0; index < docs.length; index++) {
      final ledgerIndex = index;
      final subscription = docs[index].reference
          .collection('entries')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
        (entrySnapshot) {
          entryLists[ledgerIndex] = entrySnapshot.docs
              .map((doc) => LedgerEntryModel.fromFirestore(doc).toEntity())
              .toList();
          emit();
        },
        onError: controller.addError,
      );
      subscriptions.add(subscription);
    }

    emit();

    controller.onCancel = () async {
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
    };

    return controller.stream;
  }

  Future<String> createLedger({
    required String userId,
    required String title,
    required String description,
    required LedgerType type,
  }) async {
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
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await _deleteCollectionInBatches(ledgerRef.collection('entries'));
    await ledgerRef.delete();
  }

  Future<void> updateOpeningBalance({
    required String userId,
    required String ledgerId,
    required double openingBalance,
  }) async {
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
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ledgerRef);
      final data = snapshot.data() ?? {};
      final parties = (data['parties'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(LedgerPartyModel.fromMap)
          .toList();

      final exists = parties.any(
        (item) => item.name.toLowerCase() == party.name.toLowerCase(),
      );
      if (exists) return;

      parties.add(LedgerPartyModel.fromEntity(party));
      transaction.update(ledgerRef, {
        'parties': parties.map((item) => item.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> removeParty({
    required String userId,
    required String ledgerId,
    required String partyName,
  }) async {
    final ledgerRef = _ledgerRef(userId, ledgerId);
    final key = partyName.trim().toLowerCase();

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ledgerRef);
      final data = snapshot.data() ?? {};
      final parties = (data['parties'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(LedgerPartyModel.fromMap)
          .where((party) => party.name.toLowerCase() != key)
          .map((party) => party.toMap())
          .toList();

      transaction.update(ledgerRef, {
        'parties': parties,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    final entries = await ledgerRef.collection('entries').get();
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
    final model = LedgerEntryModel.fromEntity(entry);
    final ledgerRef = _ledgerRef(userId, ledgerId);
    await ledgerRef.collection('entries').doc(entry.id).set(model.toFirestore());
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
