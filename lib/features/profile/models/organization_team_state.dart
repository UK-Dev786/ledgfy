import 'ledger_staff_assignment.dart';
import 'staff_member.dart';

class OrganizationTeamState {
  final List<StaffMember> members;
  final Map<String, List<LedgerStaffAssignment>> ledgerAssignments;

  const OrganizationTeamState({
    required this.members,
    this.ledgerAssignments = const {},
  });

  factory OrganizationTeamState.empty() =>
      const OrganizationTeamState(members: []);

  List<StaffMember> get staffAccounts =>
      members.where((member) => !member.isOwner).toList();

  List<LedgerStaffAssignment> assignmentsForLedger(String ledgerId) =>
      ledgerAssignments[ledgerId] ?? const [];

  StaffMember? memberById(String staffId) {
    for (final member in members) {
      if (member.id == staffId) return member;
    }
    return null;
  }

  LedgerStaffAssignment? assignmentFor({
    required String ledgerId,
    required String staffId,
  }) {
    for (final item in assignmentsForLedger(ledgerId)) {
      if (item.staffId == staffId) return item;
    }
    return null;
  }

  int assignedLedgerCount(String staffId) {
    var count = 0;
    for (final assignments in ledgerAssignments.values) {
      if (assignments.any((item) => item.staffId == staffId)) {
        count++;
      }
    }
    return count;
  }

  OrganizationTeamState copyWith({
    List<StaffMember>? members,
    Map<String, List<LedgerStaffAssignment>>? ledgerAssignments,
  }) {
    return OrganizationTeamState(
      members: members ?? this.members,
      ledgerAssignments: ledgerAssignments ?? this.ledgerAssignments,
    );
  }
}
