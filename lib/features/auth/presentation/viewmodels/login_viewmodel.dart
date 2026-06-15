import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_debug_log.dart';
import '../../../../di/auth_providers.dart';
import '../../../../domain/usecases/sign_in_with_email.dart';
import '../../../../domain/usecases/sign_in_with_google.dart';
import 'auth_ui_state.dart';

class LoginViewModel extends StateNotifier<LoginUiState> {
  LoginViewModel(this._signInWithEmail, this._signInWithGoogle)
    : super(const LoginUiState(status: AsyncValue.data(null)));

  final SignInWithEmailUseCase _signInWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;

  Future<void> login(String email, String password) async {
    AuthDebugLog.step('LoginViewModel.login: $email');
    state = const LoginUiState(
      status: AsyncValue.loading(),
      action: AuthActionType.email,
    );
    final result = await AsyncValue.guard(() async {
      await _signInWithEmail(email, password);
      AuthDebugLog.step('LoginViewModel.login: success');
    });
    state = LoginUiState(status: result);
  }

  Future<void> signInWithGoogle() async {
    AuthDebugLog.step('LoginViewModel.signInWithGoogle');
    state = const LoginUiState(
      status: AsyncValue.loading(),
      action: AuthActionType.google,
    );
    final result = await AsyncValue.guard(() async {
      await _signInWithGoogle();
      AuthDebugLog.step('LoginViewModel.signInWithGoogle: success');
    });
    state = LoginUiState(status: result);
  }

  void reset() => state = const LoginUiState(status: AsyncValue.data(null));
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginUiState>((ref) {
      return LoginViewModel(
        ref.watch(signInWithEmailUseCaseProvider),
        ref.watch(signInWithGoogleUseCaseProvider),
      );
    });
