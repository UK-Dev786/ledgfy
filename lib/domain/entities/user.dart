class User {
  final String id;
  final String email;
  final String? displayName;
  final String? username;
  final String? accountType;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.username,
    this.accountType,
    this.isVerified = false,
  });
}
