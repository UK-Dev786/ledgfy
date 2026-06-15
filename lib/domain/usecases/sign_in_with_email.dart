import '../../core/errors/exceptions.dart';
import '../../core/utils/app_validators.dart';
import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithEmailUseCase {
  final IAuthRepository _repository;

  SignInWithEmailUseCase(this._repository);

  Future<User> call(String email, String password) async {
    final emailError = AppValidators.email(email);
    if (emailError != null) throw ValidationException(emailError);

    final passwordError = AppValidators.password(password);
    if (passwordError != null) throw ValidationException(passwordError);

    return _repository.signInWithEmail(email.trim(), password);
  }
}
