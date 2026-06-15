import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_debug_log.dart';
import '../../../../di/auth_providers.dart';
import '../../../../domain/usecases/sign_in_with_email.dart';
import '../../../../domain/usecases/sign_in_with_google.dart';

class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  LoginViewModel(this._signInWithEmail, this._signInWithGoogle)
    : super(const AsyncValue.data(null));

  final SignInWithEmailUseCase _signInWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;

  Future<void> login(String email, String password) async {
    AuthDebugLog.step('LoginViewModel.login: $email');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _signInWithEmail(email, password);
        AuthDebugLog.step('LoginViewModel.login: success');
      } catch (error, stackTrace) {
        AuthDebugLog.error('LoginViewModel.login', error, stackTrace);
        rethrow;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    AuthDebugLog.step('LoginViewModel.signInWithGoogle');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _signInWithGoogle();
        AuthDebugLog.step('LoginViewModel.signInWithGoogle: success');
      } catch (error, stackTrace) {
        AuthDebugLog.error('LoginViewModel.signInWithGoogle', error, stackTrace);
        rethrow;
      }
    });
  }

  void reset() => state = const AsyncValue.data(null);
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<void>>((ref) {
      return LoginViewModel(
        ref.watch(signInWithEmailUseCaseProvider),
        ref.watch(signInWithGoogleUseCaseProvider),
      );
    });
