/// Whether the signed-in user owns the organization or is staff under one.
enum OrganizationMemberKind {
  owner,
  staff,
}

extension OrganizationMemberKindParsing on OrganizationMemberKind {
  static OrganizationMemberKind? fromFirestore(String? value) {
    return switch (value) {
      'staff' => OrganizationMemberKind.staff,
      'owner' => OrganizationMemberKind.owner,
      _ => null,
    };
  }

  String get firestoreValue => switch (this) {
        OrganizationMemberKind.owner => 'owner',
        OrganizationMemberKind.staff => 'staff',
      };
}
