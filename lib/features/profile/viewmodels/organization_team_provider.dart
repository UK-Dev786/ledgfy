import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/auth_providers.dart';
import '../models/ledger_staff_assignment.dart';
import '../models/organization_team_state.dart';
import '../models/staff_member.dart';

final organizationTeamProvider =
    NotifierProvider<OrganizationTeamNotifier, OrganizationTeamState>(
  OrganizationTeamNotifier.new,
);

class OrganizationTeamNotifier extends Notifier<OrganizationTeamState> {
  @override
  OrganizationTeamState build() {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    final ownerName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email.split('@').first ?? 'Owner');
    return OrganizationTeamState.fromMock(ownerName);
  }

  void addStaff(StaffMember member) {
    state = state.copyWith(members: [...state.members, member]);
  }

  void updateStaff(StaffMember member) {
    state = state.copyWith(
      members: state.members
          .map((item) => item.id == member.id ? member : item)
          .toList(),
    );
  }

  void removeStaff(String staffId) {
    final nextAssignments = <String, List<LedgerStaffAssignment>>{};
    state.ledgerAssignments.forEach((ledgerId, assignments) {
      final filtered =
          assignments.where((item) => item.staffId != staffId).toList();
      if (filtered.isNotEmpty) {
        nextAssignments[ledgerId] = filtered;
      }
    });

    state = state.copyWith(
      members: state.members.where((item) => item.id != staffId).toList(),
      ledgerAssignments: nextAssignments,
    );
  }

  void setLedgerAssignments({
    required String ledgerId,
    required List<LedgerStaffAssignment> assignments,
  }) {
    final next = Map<String, List<LedgerStaffAssignment>>.from(
      state.ledgerAssignments,
    );
    if (assignments.isEmpty) {
      next.remove(ledgerId);
    } else {
      next[ledgerId] = assignments;
    }
    state = state.copyWith(ledgerAssignments: next);
  }

  void updateLedgerAssignmentAccess({
    required String ledgerId,
    required String staffId,
    required LedgerStaffAccess access,
  }) {
    final assignments = [...state.assignmentsForLedger(ledgerId)];
    final index = assignments.indexWhere((item) => item.staffId == staffId);
    if (index == -1) return;
    assignments[index] = assignments[index].copyWith(access: access);
    setLedgerAssignments(ledgerId: ledgerId, assignments: assignments);
  }

  void removeLedgerAssignment({
    required String ledgerId,
    required String staffId,
  }) {
    final assignments = state
        .assignmentsForLedger(ledgerId)
        .where((item) => item.staffId != staffId)
        .toList();
    setLedgerAssignments(ledgerId: ledgerId, assignments: assignments);
  }

  void syncStaffLedgerGrants({
    required String staffId,
    required Map<String, LedgerStaffAssignment> grantsByLedgerId,
  }) {
    final next = Map<String, List<LedgerStaffAssignment>>.from(
      state.ledgerAssignments,
    );

    for (final ledgerId in next.keys.toList()) {
      final filtered =
          next[ledgerId]!.where((item) => item.staffId != staffId).toList();
      if (filtered.isEmpty) {
        next.remove(ledgerId);
      } else {
        next[ledgerId] = filtered;
      }
    }

    for (final entry in grantsByLedgerId.entries) {
      final list = [...(next[entry.key] ?? const <LedgerStaffAssignment>[])];
      list.add(entry.value);
      next[entry.key] = list;
    }

    state = state.copyWith(ledgerAssignments: next);
  }

  void updateLedgerAssignment({
    required String ledgerId,
    required LedgerStaffAssignment assignment,
  }) {
    final assignments = state
        .assignmentsForLedger(ledgerId)
        .where((item) => item.staffId != assignment.staffId)
        .toList()
      ..add(assignment);
    setLedgerAssignments(ledgerId: ledgerId, assignments: assignments);
  }
}
