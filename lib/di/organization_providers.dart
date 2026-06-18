import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_text.dart';
import '../data/datasources/remote/organization_remote_datasource.dart';
import '../data/repositories/organization_repository_impl.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/i_organization_repository.dart';
import '../features/profile/models/ledger_staff_assignment.dart';
import '../features/profile/models/organization_team_state.dart';
import '../features/profile/models/staff_member.dart';
import 'auth_providers.dart';
import 'profile_providers.dart';

final organizationRemoteDataSourceProvider =
    Provider<OrganizationRemoteDataSource>((ref) {
  return OrganizationRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firestoreServiceProvider),
  );
});

final organizationRepositoryProvider = Provider<IOrganizationRepository>((ref) {
  return OrganizationRepositoryImpl(
    ref.watch(organizationRemoteDataSourceProvider),
  );
});

StaffMember _ownerMemberFromUser(User user) {
  final name = user.displayName?.trim().isNotEmpty == true
      ? user.displayName!.trim()
      : user.email.split('@').first;
  final username = user.username?.trim().isNotEmpty == true
      ? user.username!.trim()
      : user.email.split('@').first;

  return StaffMember(
    id: user.id,
    name: name,
    username: username,
    loginEmail: user.email,
    isOwner: true,
    status: StaffMemberStatus.active,
  );
}

final organizationTeamStreamProvider =
    StreamProvider<OrganizationTeamState>((ref) {
  final user = ref.watch(profileUserStreamProvider).valueOrNull;
  if (user == null) {
    return Stream.value(const OrganizationTeamState(members: []));
  }

  final owner = _ownerMemberFromUser(user);
  if (user.accountType != AppText.accountTypeOrganization) {
    return Stream.value(OrganizationTeamState(members: [owner]));
  }

  return ref.watch(organizationRepositoryProvider).watchTeam(user.id, owner);
});

final staffGrantsStreamProvider =
    StreamProvider<Map<String, LedgerStaffAssignment>>((ref) {
  final user = ref.watch(profileUserStreamProvider).valueOrNull;
  if (user == null ||
      !user.isOrganizationStaff ||
      user.organizationId == null) {
    return Stream.value(const {});
  }

  return ref.watch(organizationRepositoryProvider).watchStaffGrants(
        ownerId: user.organizationId!,
        staffId: user.id,
      );
});

class OrganizationController {
  OrganizationController(this._ref);

  final Ref _ref;

  IOrganizationRepository get _repository =>
      _ref.read(organizationRepositoryProvider);

  String? get _ownerId =>
      _ref.read(profileUserStreamProvider).valueOrNull?.id;

  Future<StaffMember> createStaff({
    required String name,
    required String username,
    required String loginEmail,
    required String password,
  }) async {
    final ownerId = _ownerId;
    if (ownerId == null) {
      throw StateError('No signed-in owner');
    }

    return _repository.createStaff(
      ownerId: ownerId,
      name: name,
      username: username,
      loginEmail: loginEmail,
      password: password,
    );
  }

  Future<void> removeStaff(String staffId) async {
    final ownerId = _ownerId;
    if (ownerId == null) return;

    await _repository.removeStaff(ownerId: ownerId, staffId: staffId);
  }

  Future<void> syncStaffLedgerGrants({
    required String staffId,
    required Map<String, LedgerStaffAssignment> grantsByLedgerId,
  }) async {
    final ownerId = _ownerId;
    if (ownerId == null) return;

    await _repository.syncStaffLedgerGrants(
      ownerId: ownerId,
      staffId: staffId,
      grantsByLedgerId: grantsByLedgerId,
    );
  }

  Future<void> setLedgerAssignments({
    required String ledgerId,
    required List<LedgerStaffAssignment> assignments,
  }) async {
    final ownerId = _ownerId;
    if (ownerId == null) return;

    await _repository.setLedgerAssignments(
      ownerId: ownerId,
      ledgerId: ledgerId,
      assignments: assignments,
    );
  }

  Future<void> updateLedgerAssignment({
    required String ledgerId,
    required LedgerStaffAssignment assignment,
  }) async {
    final team = _ref.read(organizationTeamStreamProvider).valueOrNull;
    if (team == null) return;

    final assignments = team
        .assignmentsForLedger(ledgerId)
        .where((item) => item.staffId != assignment.staffId)
        .toList()
      ..add(assignment);

    await setLedgerAssignments(
      ledgerId: ledgerId,
      assignments: assignments,
    );
  }

  Future<void> removeLedgerAssignment({
    required String ledgerId,
    required String staffId,
  }) async {
    final team = _ref.read(organizationTeamStreamProvider).valueOrNull;
    if (team == null) return;

    final assignments = team
        .assignmentsForLedger(ledgerId)
        .where((item) => item.staffId != staffId)
        .toList();

    await setLedgerAssignments(
      ledgerId: ledgerId,
      assignments: assignments,
    );
  }
}

final organizationControllerProvider = Provider<OrganizationController>((ref) {
  return OrganizationController(ref);
});
