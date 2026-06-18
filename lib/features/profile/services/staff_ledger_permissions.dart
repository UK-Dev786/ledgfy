import '../../../domain/entities/user.dart';
import '../../ledger/models/ledger_entry.dart';
import '../../ledger/models/ledger_item.dart';
import '../../ledger/models/ledger_party.dart';
import '../../ledger/models/ledger_type_config.dart';
import '../models/ledger_staff_assignment.dart';

class StaffLedgerPermissions {
  final User? user;
  final Map<String, LedgerStaffAssignment> grants;

  const StaffLedgerPermissions({
    required this.user,
    required this.grants,
  });

  bool get isStaff => user?.isOrganizationStaff ?? false;

  String? get userId => user?.id;

  LedgerStaffAssignment? grantFor(String ledgerId) => grants[ledgerId];

  bool get canCreateLedger => !isStaff;

  bool canManageLedger(String ledgerId) => !isStaff;

  bool canManageParties(String ledgerId) => !isStaff;

  bool canAddEntry(String ledgerId) {
    if (!isStaff) return true;
    return grantFor(ledgerId)?.access == LedgerStaffAccess.editor;
  }

  bool canEditEntry(LedgerEntry entry, String ledgerId) {
    if (!isStaff) return true;
    if (grantFor(ledgerId)?.access != LedgerStaffAccess.editor) return false;
    final authorId = entry.createdByUserId;
    if (authorId == null || authorId.isEmpty) return false;
    return authorId == userId;
  }

  bool canDeleteEntry(LedgerEntry entry, String ledgerId) =>
      canEditEntry(entry, ledgerId);

  bool canAccessParty(
    String ledgerId,
    LedgerTypeConfig config,
    String partyName,
  ) {
    if (!isStaff) return true;
    final grant = grantFor(ledgerId);
    if (grant == null) return false;
    if (grant.isWholeLedger(config)) return true;
    return grant.includesParty(partyName);
  }

  List<LedgerEntry> entriesInScope(
    String ledgerId,
    LedgerTypeConfig config,
    List<LedgerEntry> entries,
  ) {
    if (!isStaff) return entries;
    final grant = grantFor(ledgerId);
    if (grant == null) return const [];
    if (grant.isWholeLedger(config)) return entries;
    return entries
        .where(
          (entry) =>
              entry.partyName != null && grant.includesParty(entry.partyName!),
        )
        .toList();
  }

  List<LedgerParty> partiesInScope(
    String ledgerId,
    LedgerTypeConfig config,
    List<LedgerParty> parties,
  ) {
    if (!isStaff) return parties;
    final grant = grantFor(ledgerId);
    if (grant == null) return const [];
    if (grant.isWholeLedger(config)) return parties;
    return parties
        .where((party) => grant.includesParty(party.name))
        .toList();
  }

  List<LedgerItem> scopeLedgers(List<LedgerItem> ledgers) {
    if (!isStaff) return ledgers;
    return ledgers.map(_scopeLedger).toList();
  }

  LedgerItem _scopeLedger(LedgerItem ledger) {
    final config = ledger.config;
    final grant = grantFor(ledger.id);
    final wholeLedger = grant?.isWholeLedger(config) ?? false;

    return LedgerItem(
      id: ledger.id,
      title: ledger.title,
      description: ledger.description,
      type: ledger.type,
      createdAt: ledger.createdAt,
      entries: entriesInScope(ledger.id, config, ledger.entries),
      parties: partiesInScope(ledger.id, config, ledger.parties),
      openingBalance: wholeLedger ? ledger.openingBalance : 0,
    );
  }
}
