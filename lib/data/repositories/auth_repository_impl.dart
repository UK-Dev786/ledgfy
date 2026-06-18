import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../core/constants/app_text.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/auth_debug_log.dart';
import '../../../domain/entities/organization_member_kind.dart';
import '../../../domain/entities/sign_up_params.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FirestoreService _firestoreService;

  AuthRepositoryImpl(this._remoteDataSource, this._firestoreService);

  @override
  Stream<User?> get authStateChanges {
    return _remoteDataSource.authStateChanges.asyncMap(_mapFirebaseUser);
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    AuthDebugLog.step('signInWithEmail (repo): $email');
    final firebaseUser = await _remoteDataSource.signInWithEmail(email, password);
    return _resolveUserAfterAuth(
      firebaseUser,
      requireVerified: true,
    );
  }

  @override
  Future<User> signUpWithEmail(SignUpParams params) async {
    AuthDebugLog.step('signUpWithEmail (repo): ${params.email}');
    try {
      return await _createEmailAccount(params);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      AuthDebugLog.error('signUpWithEmail (repo)', error, stackTrace);
      if (error.code == 'email-already-in-use') {
        AuthDebugLog.step('signUpWithEmail: recovering incomplete signup');
        return _recoverIncompleteSignup(params);
      }
      rethrow;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    AuthDebugLog.step('signInWithGoogle (repo)');
    final credential = await _remoteDataSource.signInWithGoogle();
    final firebaseUser = credential.user!;
    var profile = await _firestoreService.getUserProfile(firebaseUser.uid);

    final isVerified = firebaseUser.emailVerified;

    if (profile == null) {
      profile = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        isVerified: isVerified,
        createdAt: DateTime.now(),
      );
      await _firestoreService.createUserProfile(profile);
    } else if (isVerified && !profile.isVerified) {
      await _firestoreService.updateIsVerified(firebaseUser.uid, true);
      profile = profile.copyWith(isVerified: true);
    }

    return profile.toEntity();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() {
    return _remoteDataSource.sendEmailVerification();
  }

  @override
  Future<void> resendVerificationEmail(String email, String password) async {
    AuthDebugLog.step('resendVerificationEmail: $email');
    await _remoteDataSource.signInWithEmail(email, password);
    try {
      await _remoteDataSource.sendEmailVerification();
    } finally {
      await _remoteDataSource.signOut();
    }
    AuthDebugLog.step('resendVerificationEmail: success');
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  Future<User> _createEmailAccount(SignUpParams params) async {
    AuthDebugLog.step('_createEmailAccount: ${params.email}');

    final firebaseUser = await _remoteDataSource.signUpWithEmail(
      params.email,
      params.password,
    );

    await firebaseUser.getIdToken(true);

    final userModel = UserModel(
      id: firebaseUser.uid,
      email: params.email,
      displayName: params.fullName,
      username: params.username,
      accountType: params.accountType,
      isVerified: false,
    );

    AuthDebugLog.step('_createEmailAccount: saving Firestore profile');
    await _firestoreService.createUserProfile(userModel);

    try {
      AuthDebugLog.step('_createEmailAccount: updating display name');
      await _remoteDataSource.updateDisplayName(params.fullName);
    } catch (error, stackTrace) {
      AuthDebugLog.error('_createEmailAccount:updateDisplayName', error, stackTrace);
    }

    try {
      AuthDebugLog.step('_createEmailAccount: sending verification email');
      await _remoteDataSource.sendEmailVerification();
    } catch (error, stackTrace) {
      AuthDebugLog.error('_createEmailAccount:sendEmailVerification', error, stackTrace);
    }

    AuthDebugLog.step('_createEmailAccount: signing out');
    await _remoteDataSource.signOut();

    AuthDebugLog.step('_createEmailAccount: complete uid=${userModel.id}');
    return userModel.toEntity();
  }

  Future<User> _recoverIncompleteSignup(SignUpParams params) async {
    AuthDebugLog.step('_recoverIncompleteSignup: ${params.email}');

    final firebaseUser = await _remoteDataSource.signInWithEmail(
      params.email,
      params.password,
    );

    await firebaseUser.getIdToken(true);
    var profile = await _firestoreService.getUserProfile(firebaseUser.uid);

    if (profile == null) {
      AuthDebugLog.step('_recoverIncompleteSignup: creating missing profile');
      profile = UserModel(
        id: firebaseUser.uid,
        email: params.email,
        displayName: params.fullName,
        username: params.username,
        accountType: params.accountType,
        isVerified: false,
      );
      await _firestoreService.createUserProfile(profile);

      try {
        await _remoteDataSource.updateDisplayName(params.fullName);
      } catch (error, stackTrace) {
        AuthDebugLog.error('_recoverIncompleteSignup:updateDisplayName', error, stackTrace);
      }

      try {
        await _remoteDataSource.sendEmailVerification();
      } catch (error, stackTrace) {
        AuthDebugLog.error('_recoverIncompleteSignup:sendEmailVerification', error, stackTrace);
      }
    }

    AuthDebugLog.step('_recoverIncompleteSignup: signing out');
    await _remoteDataSource.signOut();

    AuthDebugLog.step('_recoverIncompleteSignup: complete uid=${profile.id}');
    return profile.toEntity();
  }

  Future<User> _resolveUserAfterAuth(
    firebase_auth.User firebaseUser, {
    required bool requireVerified,
  }) async {
    AuthDebugLog.step('_resolveUserAfterAuth: uid=${firebaseUser.uid}');

    await _remoteDataSource.reloadUser();
    final refreshed = _remoteDataSource.currentUser ?? firebaseUser;
    final authVerified = refreshed.emailVerified;
    AuthDebugLog.step('_resolveUserAfterAuth: emailVerified=$authVerified');

    var profile = await _firestoreService.getUserProfile(refreshed.uid);
    final isStaff =
        profile?.memberKind == OrganizationMemberKind.staff;

    if (requireVerified && !authVerified && !isStaff) {
      await _remoteDataSource.signOut();
      throw const ValidationException(AppText.authEmailNotVerified);
    }

    if (profile != null) {
      if ((authVerified || isStaff) && !profile.isVerified) {
        await _firestoreService.updateIsVerified(refreshed.uid, true);
        profile = profile.copyWith(isVerified: true);
      }
      return profile.toEntity();
    }

    final fallback = UserModel.fromFirebaseUser(
      uid: refreshed.uid,
      email: refreshed.email,
      displayName: refreshed.displayName,
      isVerified: authVerified || isStaff,
    );

    if (authVerified || isStaff) {
      await _firestoreService.createUserProfile(fallback);
    }

    return fallback.toEntity();
  }

  Future<User?> _mapFirebaseUser(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) return null;

    AuthDebugLog.step('_mapFirebaseUser: uid=${firebaseUser.uid}');
    await _remoteDataSource.reloadUser();
    final refreshed = _remoteDataSource.currentUser ?? firebaseUser;

    final profile = await _firestoreService.getUserProfile(refreshed.uid);
    final isStaff =
        profile?.memberKind == OrganizationMemberKind.staff;

    if (!refreshed.emailVerified && !isStaff) {
      AuthDebugLog.step('_mapFirebaseUser: not verified — treating as signed out');
      return null;
    }

    if (profile != null) {
      var resolved = profile;
      if (!resolved.isVerified) {
        try {
          await _firestoreService.updateIsVerified(refreshed.uid, true);
        } catch (_) {}
        resolved = resolved.copyWith(isVerified: true);
      }
      return resolved.toEntity();
    }

    return UserModel.fromFirebaseUser(
      uid: refreshed.uid,
      email: refreshed.email,
      displayName: refreshed.displayName,
      isVerified: refreshed.emailVerified || isStaff,
    ).toEntity();
  }
}
