import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';

import '../../../core/utils/auth_token_helper.dart';
import '../../../features/profile/models/ledger_staff_assignment.dart';
import '../../../features/profile/models/organization_team_state.dart';
import '../../../features/profile/models/staff_member.dart';
import '../../../firebase_options.dart';
import '../../models/ledger_grant_model.dart';
import '../../models/staff_member_model.dart';
import '../../models/user_model.dart';
import 'auth_remote_datasource.dart';

class OrganizationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirestoreService _firestoreService;

  OrganizationRemoteDataSource(
    this._firestore,
    this._firestoreService,
  );

  CollectionReference<Map<String, dynamic>> _staffCol(String ownerId) =>
      _firestore.collection('users').doc(ownerId).collection('staff');

  CollectionReference<Map<String, dynamic>> _grantsCol(String ownerId) =>
      _firestore.collection('users').doc(ownerId).collection('ledgerGrants');

  Stream<OrganizationTeamState> watchTeam(
    String ownerId,
    StaffMember owner,
  ) {
    final controller = StreamController<OrganizationTeamState>();
    QuerySnapshot<Map<String, dynamic>>? staffSnap;
    QuerySnapshot<Map<String, dynamic>>? grantsSnap;

    void emit() {
      if (staffSnap == null || grantsSnap == null) return;
      controller.add(_mapTeamState(owner, staffSnap!, grantsSnap!));
    }

    final staffSub = _staffCol(ownerId).snapshots().listen(
      (snapshot) {
        staffSnap = snapshot;
        emit();
      },
      onError: controller.addError,
    );

    final grantsSub = _grantsCol(ownerId).snapshots().listen(
      (snapshot) {
        grantsSnap = snapshot;
        emit();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await staffSub.cancel();
      await grantsSub.cancel();
    };

    return controller.stream;
  }

  Stream<Map<String, LedgerStaffAssignment>> watchStaffGrants({
    required String ownerId,
    required String staffId,
  }) {
    return _grantsCol(ownerId)
        .where('staffId', isEqualTo: staffId)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      final grants = <String, LedgerStaffAssignment>{};
      for (final doc in snapshot.docs) {
        final model = LedgerGrantModel.fromFirestore(doc.data(), doc.id);
        grants[model.ledgerId] = model.toEntity();
      }
      return grants;
    });
  }

  Future<StaffMember> createStaff({
    required String ownerId,
    required String name,
    required String username,
    required String loginEmail,
    required String password,
  }) async {
    final staffUid = await _createStaffAuthUser(
      email: loginEmail,
      password: password,
    );

    final staffProfile = UserModel(
      id: staffUid,
      email: loginEmail,
      displayName: name,
      username: username,
      memberKind: OrganizationMemberKind.staff,
      organizationId: ownerId,
      isVerified: true,
    );

    final staffMember = StaffMemberModel(
      id: staffUid,
      name: name,
      username: username,
      loginEmail: loginEmail,
      status: StaffMemberStatus.active,
      joinedAt: DateTime.now(),
    );

    await _firestoreService.createUserProfile(staffProfile);
    await _staffCol(ownerId).doc(staffUid).set(staffMember.toFirestore());

    return staffMember.toEntity();
  }

  Future<void> removeStaff({
    required String ownerId,
    required String staffId,
  }) async {
    final grants = await _grantsCol(ownerId)
        .where('staffId', isEqualTo: staffId)
        .get();
    final batch = _firestore.batch();
    for (final doc in grants.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_staffCol(ownerId).doc(staffId));
    batch.delete(_firestore.collection('users').doc(staffId));
    await batch.commit();
  }

  Future<void> syncStaffLedgerGrants({
    required String ownerId,
    required String staffId,
    required Map<String, LedgerStaffAssignment> grantsByLedgerId,
  }) async {
    final existing = await _grantsCol(ownerId)
        .where('staffId', isEqualTo: staffId)
        .get();
    final batch = _firestore.batch();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final entry in grantsByLedgerId.entries) {
      final assignment = entry.value;
      final grant = LedgerGrantModel(
        id: LedgerGrantModel.documentId(
          ledgerId: entry.key,
          staffId: staffId,
        ),
        staffId: staffId,
        ledgerId: entry.key,
        access: assignment.access,
        scopedPartyNames: assignment.scopedPartyNames,
      );
      batch.set(
        _grantsCol(ownerId).doc(grant.id),
        grant.toFirestore(),
      );
    }
    await batch.commit();
  }

  Future<void> setLedgerAssignments({
    required String ownerId,
    required String ledgerId,
    required List<LedgerStaffAssignment> assignments,
  }) async {
    final existing = await _grantsCol(ownerId)
        .where('ledgerId', isEqualTo: ledgerId)
        .get();
    final batch = _firestore.batch();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final assignment in assignments) {
      final grant = LedgerGrantModel(
        id: LedgerGrantModel.documentId(
          ledgerId: ledgerId,
          staffId: assignment.staffId,
        ),
        staffId: assignment.staffId,
        ledgerId: ledgerId,
        access: assignment.access,
        scopedPartyNames: assignment.scopedPartyNames,
      );
      batch.set(
        _grantsCol(ownerId).doc(grant.id),
        grant.toFirestore(),
      );
    }
    await batch.commit();
  }

  OrganizationTeamState _mapTeamState(
    StaffMember owner,
    QuerySnapshot<Map<String, dynamic>> staffSnap,
    QuerySnapshot<Map<String, dynamic>> grantsSnap,
  ) {
    final members = <StaffMember>[
      owner,
      ...staffSnap.docs.map(
        (doc) => StaffMemberModel.fromFirestore(doc.data(), doc.id).toEntity(),
      ),
    ];

    final ledgerAssignments = <String, List<LedgerStaffAssignment>>{};
    for (final doc in grantsSnap.docs) {
      final grant = LedgerGrantModel.fromFirestore(doc.data(), doc.id);
      final assignment = grant.toEntity();
      final list = <LedgerStaffAssignment>[
        ...(ledgerAssignments[grant.ledgerId] ?? const <LedgerStaffAssignment>[]),
      ];
      list.add(assignment);
      ledgerAssignments[grant.ledgerId] = list;
    }

    return OrganizationTeamState(
      members: members,
      ledgerAssignments: ledgerAssignments,
    );
  }

  Future<String> _createStaffAuthUser({
    required String email,
    required String password,
  }) async {
    final app = await Firebase.initializeApp(
      name: 'staffCreator_${DateTime.now().microsecondsSinceEpoch}',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      final secondaryAuth = firebase_auth.FirebaseAuth.instanceFor(app: app);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw StateError('Staff auth user was not created');
      }
      await ensureAuthToken(user);
      return user.uid;
    } finally {
      await app.delete();
    }
  }
}
