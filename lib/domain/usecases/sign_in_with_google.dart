import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithGoogleUseCase {
  final IAuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<User> call() => _repository.signInWithGoogle();
}
