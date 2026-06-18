import '../../../features/profile/models/ledger_staff_assignment.dart';
import '../../../features/profile/models/organization_team_state.dart';
import '../../../features/profile/models/staff_member.dart';
import '../../domain/repositories/i_organization_repository.dart';
import '../datasources/remote/organization_remote_datasource.dart';

class OrganizationRepositoryImpl implements IOrganizationRepository {
  final OrganizationRemoteDataSource _remoteDataSource;

  OrganizationRepositoryImpl(this._remoteDataSource);

  @override
  Stream<OrganizationTeamState> watchTeam(
    String ownerId,
    StaffMember owner,
  ) {
    return _remoteDataSource.watchTeam(ownerId, owner);
  }

  @override
  Stream<Map<String, LedgerStaffAssignment>> watchStaffGrants({
    required String ownerId,
    required String staffId,
  }) {
    return _remoteDataSource.watchStaffGrants(
      ownerId: ownerId,
      staffId: staffId,
    );
  }

  @override
  Future<StaffMember> createStaff({
    required String ownerId,
    required String name,
    required String username,
    required String loginEmail,
    required String password,
  }) {
    return _remoteDataSource.createStaff(
      ownerId: ownerId,
      name: name,
      username: username,
      loginEmail: loginEmail,
      password: password,
    );
  }

  @override
  Future<void> removeStaff({
    required String ownerId,
    required String staffId,
  }) {
    return _remoteDataSource.removeStaff(ownerId: ownerId, staffId: staffId);
  }

  @override
  Future<void> syncStaffLedgerGrants({
    required String ownerId,
    required String staffId,
    required Map<String, LedgerStaffAssignment> grantsByLedgerId,
  }) {
    return _remoteDataSource.syncStaffLedgerGrants(
      ownerId: ownerId,
      staffId: staffId,
      grantsByLedgerId: grantsByLedgerId,
    );
  }

  @override
  Future<void> setLedgerAssignments({
    required String ownerId,
    required String ledgerId,
    required List<LedgerStaffAssignment> assignments,
  }) {
    return _remoteDataSource.setLedgerAssignments(
      ownerId: ownerId,
      ledgerId: ledgerId,
      assignments: assignments,
    );
  }
}
