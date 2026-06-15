import '../../core/errors/exceptions.dart';
import '../../core/utils/app_validators.dart';
import '../repositories/i_auth_repository.dart';

class ForgotPasswordUseCase {
  final IAuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<void> call(String email) async {
    final emailError = AppValidators.email(email);
    if (emailError != null) throw ValidationException(emailError);

    await _repository.sendPasswordResetEmail(email.trim());
  }
}
