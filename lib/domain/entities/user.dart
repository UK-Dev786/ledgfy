import 'organization_member_kind.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? username;
  final String? accountType;
  final OrganizationMemberKind memberKind;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.username,
    this.accountType,
    this.memberKind = OrganizationMemberKind.owner,
    this.isVerified = false,
  });

  bool get isOrganizationStaff =>
      memberKind == OrganizationMemberKind.staff;
}
