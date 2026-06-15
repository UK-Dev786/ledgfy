import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_debug_log.dart';
import '../../../../di/auth_providers.dart';
import '../../../../domain/entities/sign_up_params.dart';
import '../../../../domain/usecases/send_verification_email.dart';
import '../../../../domain/usecases/sign_up_with_email.dart';
import 'auth_ui_state.dart';

class SignupViewModel extends StateNotifier<SignupUiState> {
  SignupViewModel(
    this._signUpWithEmail,
    this._sendVerificationEmail,
  ) : super(const SignupUiState(status: AsyncValue.data(null)));

  final SignUpWithEmailUseCase _signUpWithEmail;
  final SendVerificationEmailUseCase _sendVerificationEmail;

  String? _lastSignedUpEmail;

  String? get lastSignedUpEmail => _lastSignedUpEmail;

  Future<void> signUp(SignUpParams params) async {
    AuthDebugLog.step('SignupViewModel.signUp: ${params.email}');
    state = const SignupUiState(
      status: AsyncValue.loading(),
      action: AuthActionType.email,
    );
    final result = await AsyncValue.guard(() async {
      final user = await _signUpWithEmail(params);
      _lastSignedUpEmail = user.email;
      AuthDebugLog.step('SignupViewModel.signUp: success');
    });
    state = SignupUiState(status: result);
  }

  Future<void> resendVerificationEmail() async {
    AuthDebugLog.step('SignupViewModel.resendVerificationEmail');
    try {
      await _sendVerificationEmail();
      AuthDebugLog.step('SignupViewModel.resendVerificationEmail: success');
    } catch (error, stackTrace) {
      AuthDebugLog.error('SignupViewModel.resendVerificationEmail', error, stackTrace);
      rethrow;
    }
  }

  void reset() => state = const SignupUiState(status: AsyncValue.data(null));
}

final signupViewModelProvider =
    StateNotifierProvider<SignupViewModel, SignupUiState>((ref) {
      return SignupViewModel(
        ref.watch(signUpWithEmailUseCaseProvider),
        ref.watch(sendVerificationEmailUseCaseProvider),
      );
    });
