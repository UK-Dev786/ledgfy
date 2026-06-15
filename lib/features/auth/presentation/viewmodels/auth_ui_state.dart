import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthActionType { none, email, google }

class LoginUiState {
  final AsyncValue<void> status;
  final AuthActionType action;

  const LoginUiState({
    required this.status,
    this.action = AuthActionType.none,
  });

  bool get isEmailLoading =>
      status.isLoading && action == AuthActionType.email;

  bool get isGoogleLoading =>
      status.isLoading && action == AuthActionType.google;

  bool get isLoading => status.isLoading;
}

class SignupUiState {
  final AsyncValue<void> status;
  final AuthActionType action;

  const SignupUiState({
    required this.status,
    this.action = AuthActionType.none,
  });

  bool get isEmailLoading =>
      status.isLoading && action == AuthActionType.email;

  bool get isLoading => status.isLoading;
}
