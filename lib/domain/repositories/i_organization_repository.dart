import '../../features/profile/models/ledger_staff_assignment.dart';
import '../../features/profile/models/organization_team_state.dart';
import '../../features/profile/models/staff_member.dart';

abstract class IOrganizationRepository {
  Stream<OrganizationTeamState> watchTeam(String ownerId, StaffMember owner);

  Stream<Map<String, LedgerStaffAssignment>> watchStaffGrants({
    required String ownerId,
    required String staffId,
  });

  Future<StaffMember> createStaff({
    required String ownerId,
    required String name,
    required String username,
    required String loginEmail,
    required String password,
  });

  Future<void> removeStaff({
    required String ownerId,
    required String staffId,
  });

  Future<void> syncStaffLedgerGrants({
    required String ownerId,
    required String staffId,
    required Map<String, LedgerStaffAssignment> grantsByLedgerId,
  });

  Future<void> setLedgerAssignments({
    required String ownerId,
    required String ledgerId,
    required List<LedgerStaffAssignment> assignments,
  });
}
