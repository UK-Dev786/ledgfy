import 'organization_member_kind.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? username;
  final String? accountType;
  final OrganizationMemberKind memberKind;
  final String? organizationId;
  final bool isVerified;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.username,
    this.accountType,
    this.memberKind = OrganizationMemberKind.owner,
    this.organizationId,
    this.isVerified = false,
    this.avatarUrl,
  });

  bool get isOrganizationStaff =>
      memberKind == OrganizationMemberKind.staff;

  /// Ledger and team data live under the organization owner uid.
  String? get ledgerOwnerId =>
      isOrganizationStaff ? organizationId : id;
}
