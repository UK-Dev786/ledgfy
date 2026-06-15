import '../../core/errors/exceptions.dart';
import '../../core/utils/app_validators.dart';
import '../entities/sign_up_params.dart';
import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class SignUpWithEmailUseCase {
  final IAuthRepository _repository;

  SignUpWithEmailUseCase(this._repository);

  Future<User> call(SignUpParams params) async {
    final nameError = AppValidators.name(params.fullName);
    if (nameError != null) throw ValidationException(nameError);

    final usernameError = AppValidators.username(params.username);
    if (usernameError != null) throw ValidationException(usernameError);

    final emailError = AppValidators.email(params.email);
    if (emailError != null) throw ValidationException(emailError);

    final accountTypeError = AppValidators.accountType(params.accountType);
    if (accountTypeError != null) throw ValidationException(accountTypeError);

    final passwordError = AppValidators.password(params.password);
    if (passwordError != null) throw ValidationException(passwordError);

    return _repository.signUpWithEmail(
      SignUpParams(
        fullName: params.fullName.trim(),
        username: params.username.trim(),
        email: params.email.trim(),
        password: params.password,
        accountType: params.accountType,
      ),
    );
  }
}
