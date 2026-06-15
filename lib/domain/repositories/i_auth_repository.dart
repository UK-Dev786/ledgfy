import '../entities/sign_up_params.dart';
import '../entities/user.dart';

abstract class IAuthRepository {
  Stream<User?> get authStateChanges;

  Future<User> signInWithEmail(String email, String password);

  Future<User> signUpWithEmail(SignUpParams params);

  Future<User> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();

  Future<void> resendVerificationEmail(String email, String password);

  Future<void> signOut();
}
