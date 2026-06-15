class SignUpParams {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String accountType;

  const SignUpParams({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.accountType,
  });
}
