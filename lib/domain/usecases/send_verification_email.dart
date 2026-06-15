import '../repositories/i_auth_repository.dart';

class SendVerificationEmailUseCase {
  final IAuthRepository _repository;

  SendVerificationEmailUseCase(this._repository);

  Future<void> call() => _repository.sendEmailVerification();
}
