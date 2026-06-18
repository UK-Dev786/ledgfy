import '../../../core/constants/app_text.dart';

enum StaffAuditCategory {
  all,
  entries,
  team,
  security,
}

extension StaffAuditCategoryLabels on StaffAuditCategory {
  String get label => switch (this) {
        StaffAuditCategory.all => AppText.staffAuditFilterAll,
        StaffAuditCategory.entries => AppText.staffAuditFilterEntries,
        StaffAuditCategory.team => AppText.staffAuditFilterTeam,
        StaffAuditCategory.security => AppText.staffAuditFilterSecurity,
      };
}

enum StaffAuditAction {
  entryAdded,
  entryEdited,
  entryDeleted,
  staffInvited,
  roleChanged,
  signIn,
}

class StaffAuditEvent {
  final String id;
  final StaffAuditAction action;
  final StaffAuditCategory category;
  final String title;
  final String detail;
  final String actorName;
  final String? ledgerName;
  final DateTime occurredAt;

  const StaffAuditEvent({
    required this.id,
    required this.action,
    required this.category,
    required this.title,
    required this.detail,
    required this.actorName,
    this.ledgerName,
    required this.occurredAt,
  });
}

/// Sample audit trail until profile backend is wired.
abstract final class StaffAuditMockData {
  static final List<StaffAuditEvent> events = [
    StaffAuditEvent(
      id: 'audit-1',
      action: StaffAuditAction.entryAdded,
      category: StaffAuditCategory.entries,
      title: AppText.staffAuditEntryAdded,
      detail: 'PKR 5,000 given · Ahmed Traders',
      actorName: 'Bilal Khan',
      ledgerName: 'Main Store Udhar',
      occurredAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StaffAuditEvent(
      id: 'audit-2',
      action: StaffAuditAction.entryEdited,
      category: StaffAuditCategory.entries,
      title: AppText.staffAuditEntryEdited,
      detail: 'PKR 12,000 received · Updated note',
      actorName: 'Sara Ahmed',
      ledgerName: 'Main Store Udhar',
      occurredAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StaffAuditEvent(
      id: 'audit-3',
      action: StaffAuditAction.staffInvited,
      category: StaffAuditCategory.team,
      title: AppText.staffAuditStaffInvited,
      detail: 'Bilal Khan · Editor access',
      actorName: 'You',
      occurredAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    StaffAuditEvent(
      id: 'audit-4',
      action: StaffAuditAction.entryDeleted,
      category: StaffAuditCategory.entries,
      title: AppText.staffAuditEntryDeleted,
      detail: 'PKR 800 expense · Tea & snacks',
      actorName: 'Sara Ahmed',
      ledgerName: 'Shop Expenses',
      occurredAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    StaffAuditEvent(
      id: 'audit-5',
      action: StaffAuditAction.roleChanged,
      category: StaffAuditCategory.team,
      title: AppText.staffAuditRoleChanged,
      detail: 'Sara Ahmed · Viewer → Editor',
      actorName: 'You',
      occurredAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    StaffAuditEvent(
      id: 'audit-6',
      action: StaffAuditAction.signIn,
      category: StaffAuditCategory.security,
      title: AppText.staffAuditSignIn,
      detail: 'Android device · Lahore',
      actorName: 'Sara Ahmed',
      occurredAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}
