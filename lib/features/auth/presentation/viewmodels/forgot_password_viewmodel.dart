import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/auth_debug_log.dart';
import '../../../../di/auth_providers.dart';
import '../../../../domain/usecases/forgot_password.dart';

class ForgotPasswordViewModel extends StateNotifier<AsyncValue<void>> {
  ForgotPasswordViewModel(this._forgotPassword) : super(const AsyncValue.data(null));

  final ForgotPasswordUseCase _forgotPassword;

  Future<void> sendResetLink(String email) async {
    AuthDebugLog.step('ForgotPasswordViewModel.sendResetLink: $email');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _forgotPassword(email);
        AuthDebugLog.step('ForgotPasswordViewModel.sendResetLink: success');
      } catch (error, stackTrace) {
        AuthDebugLog.error('ForgotPasswordViewModel.sendResetLink', error, stackTrace);
        rethrow;
      }
    });
  }

  void reset() => state = const AsyncValue.data(null);
}

final forgotPasswordViewModelProvider =
    StateNotifierProvider<ForgotPasswordViewModel, AsyncValue<void>>((ref) {
      return ForgotPasswordViewModel(ref.watch(forgotPasswordUseCaseProvider));
    });
