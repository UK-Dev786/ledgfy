import '../../../core/constants/app_text.dart';
import '../../ledger/models/ledger_type_config.dart';

/// Per-ledger access for a staff account.
enum LedgerStaffAccess {
  editor,
  viewer,
}

class LedgerStaffAssignment {
  final String staffId;
  final LedgerStaffAccess access;

  /// `null` = whole ledger (cash / expense).
  /// Non-empty list = specific parties or projects (udhar / project).
  final List<String>? scopedPartyNames;

  const LedgerStaffAssignment({
    required this.staffId,
    required this.access,
    this.scopedPartyNames,
  });

  bool isWholeLedger(LedgerTypeConfig config) =>
      !config.supportsSubLedgers || scopedPartyNames == null;

  bool includesParty(String partyName) {
    if (scopedPartyNames == null) return true;
    final key = partyName.trim().toLowerCase();
    return scopedPartyNames!.any((name) => name.trim().toLowerCase() == key);
  }

  String scopeSummary(LedgerTypeConfig config) {
    if (!config.supportsSubLedgers || scopedPartyNames == null) {
      return AppText.staffLedgerScopeWhole;
    }
    if (scopedPartyNames!.isEmpty) return AppText.staffLedgerScopeNone;
    final label = config.isProjectLedger
        ? AppText.staffLedgerScopeProjects
        : AppText.staffLedgerScopeParties;
    return label.replaceAll('{count}', '${scopedPartyNames!.length}');
  }

  LedgerStaffAssignment copyWith({
    String? staffId,
    LedgerStaffAccess? access,
    List<String>? scopedPartyNames,
    bool clearScopedPartyNames = false,
  }) {
    return LedgerStaffAssignment(
      staffId: staffId ?? this.staffId,
      access: access ?? this.access,
      scopedPartyNames: clearScopedPartyNames
          ? null
          : (scopedPartyNames ?? this.scopedPartyNames),
    );
  }
}

/// UI draft while editing staff access to one ledger.
class StaffLedgerGrantDraft {
  final bool selected;
  final LedgerStaffAccess access;
  final Set<String> partyNames;

  const StaffLedgerGrantDraft({
    required this.selected,
    required this.access,
    this.partyNames = const {},
  });

  StaffLedgerGrantDraft copyWith({
    bool? selected,
    LedgerStaffAccess? access,
    Set<String>? partyNames,
  }) {
    return StaffLedgerGrantDraft(
      selected: selected ?? this.selected,
      access: access ?? this.access,
      partyNames: partyNames ?? this.partyNames,
    );
  }

  LedgerStaffAssignment? toAssignment({
    required String staffId,
    required LedgerTypeConfig config,
  }) {
    if (!selected) return null;
    if (config.supportsSubLedgers) {
      if (partyNames.isEmpty) return null;
      return LedgerStaffAssignment(
        staffId: staffId,
        access: access,
        scopedPartyNames: partyNames.toList(),
      );
    }
    return LedgerStaffAssignment(
      staffId: staffId,
      access: access,
    );
  }

  factory StaffLedgerGrantDraft.fromAssignment(
    LedgerStaffAssignment assignment,
    LedgerTypeConfig config,
  ) {
    return StaffLedgerGrantDraft(
      selected: true,
      access: assignment.access,
      partyNames: config.supportsSubLedgers
          ? Set<String>.from(assignment.scopedPartyNames ?? const [])
          : const {},
    );
  }
}
