import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/auth_debug_log.dart';
import '../../models/user_model.dart';
import '../../../core/utils/auth_token_helper.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(this._firebaseAuth, {GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<void> reloadUser() async {
    AuthDebugLog.step('reloadUser: uid=${currentUser?.uid}');
    try {
      await currentUser?.reload().timeout(const Duration(seconds: 3));
    } catch (_) {
      // Offline — keep cached Firebase user.
    }
  }

  Future<firebase_auth.User> signInWithEmail(
    String email,
    String password,
  ) async {
    AuthDebugLog.step('signInWithEmail: $email');
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const ValidationException(AppText.authErrorGeneric);
      }
      AuthDebugLog.step('signInWithEmail: success uid=${user.uid}');
      return user;
    } catch (error, stackTrace) {
      final recovered = _recoverUserAfterPigeonError(error, expectedEmail: email);
      if (recovered != null) return recovered;
      AuthDebugLog.error('signInWithEmail', error, stackTrace);
      rethrow;
    }
  }

  Future<firebase_auth.User> signUpWithEmail(
    String email,
    String password,
  ) async {
    AuthDebugLog.step('signUpWithEmail: $email');
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const ValidationException(AppText.authErrorGeneric);
      }
      AuthDebugLog.step('signUpWithEmail: success uid=${user.uid}');
      return user;
    } catch (error, stackTrace) {
      final recovered = _recoverUserAfterPigeonError(error, expectedEmail: email);
      if (recovered != null) return recovered;
      AuthDebugLog.error('signUpWithEmail', error, stackTrace);
      rethrow;
    }
  }

  firebase_auth.User? _recoverUserAfterPigeonError(
    Object error, {
    required String expectedEmail,
  }) {
    if (!_isPigeonDecodeError(error)) return null;

    final user = currentUser;
    if (user != null &&
        user.email?.toLowerCase() == expectedEmail.toLowerCase()) {
      AuthDebugLog.step(
        'Recovered Firebase user after Pigeon decode bug uid=${user.uid}',
      );
      return user;
    }
    return null;
  }

  bool _isPigeonDecodeError(Object error) {
    return error is TypeError &&
        error.toString().contains('PigeonUserDetails');
  }

  Future<firebase_auth.UserCredential> signInWithGoogle() async {
    AuthDebugLog.step('signInWithGoogle: start');
    await _googleSignIn.initialize();

    try {
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      AuthDebugLog.step('signInWithGoogle: success uid=${result.user?.uid}');
      return result;
    } on GoogleSignInException catch (error) {
      AuthDebugLog.error('signInWithGoogle', error);
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const ValidationException(AppText.authGoogleCancelled);
      }
      rethrow;
    } catch (error, stackTrace) {
      AuthDebugLog.error('signInWithGoogle', error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    AuthDebugLog.step('updateDisplayName: $displayName');
    try {
      await currentUser?.updateDisplayName(displayName);
      AuthDebugLog.step('updateDisplayName: success');
    } catch (error, stackTrace) {
      AuthDebugLog.error('updateDisplayName', error, stackTrace);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    AuthDebugLog.step('sendPasswordResetEmail: $email');
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AuthDebugLog.step('sendPasswordResetEmail: success');
    } catch (error, stackTrace) {
      AuthDebugLog.error('sendPasswordResetEmail', error, stackTrace);
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    AuthDebugLog.step('sendEmailVerification: uid=${currentUser?.uid}');
    final user = currentUser;
    if (user == null) {
      AuthDebugLog.step('sendEmailVerification: skipped — no current user');
      return;
    }
    try {
      await user.sendEmailVerification();
      AuthDebugLog.step('sendEmailVerification: success');
    } catch (error, stackTrace) {
      AuthDebugLog.error('sendEmailVerification', error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    AuthDebugLog.step('signOut: start');
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      AuthDebugLog.step('signOut: success');
    } catch (error, stackTrace) {
      AuthDebugLog.error('signOut', error, stackTrace);
      rethrow;
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  FirestoreService(this._firestore, this._auth);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// Ensures Firestore has a fresh auth token before the first write after signup.
  Future<void> _ensureAuthReady() async {
    final user = _auth.currentUser;
    if (user == null) {
      AuthDebugLog.step('Firestore: no auth user before write');
      return;
    }
    await ensureAuthToken(user);
    AuthDebugLog.step('Firestore: auth token ready uid=${user.uid}');
  }

  Future<void> _runAuthenticatedWrite(
    String step,
    Future<void> Function() action,
  ) async {
    await _ensureAuthReady();
    try {
      await action();
    } on FirebaseException catch (error, stackTrace) {
      if (error.code == 'permission-denied') {
        AuthDebugLog.step('$step: permission-denied — retrying after token refresh');
        await _ensureAuthReady();
        await action();
        return;
      }
      AuthDebugLog.error(step, error, stackTrace);
      rethrow;
    }
  }

  Future<void> createUserProfile(UserModel user) async {
    AuthDebugLog.step('createUserProfile: uid=${user.id}');
    await _runAuthenticatedWrite('createUserProfile', () async {
      await _users.doc(user.id).set(user.toFirestore());
      AuthDebugLog.step('createUserProfile: success uid=${user.id}');
    });
  }

  Future<void> updateIsVerified(String uid, bool isVerified) async {
    AuthDebugLog.step('updateIsVerified: uid=$uid isVerified=$isVerified');
    await _runAuthenticatedWrite('updateIsVerified', () async {
      await _users.doc(uid).set({
        'isVerified': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      AuthDebugLog.step('updateIsVerified: success');
    });
  }

  Future<UserModel?> getUserProfile(String uid) async {
    AuthDebugLog.step('getUserProfile: uid=$uid');
    try {
      final cached = await _users
          .doc(uid)
          .get(const GetOptions(source: Source.cache));
      if (cached.exists && cached.data() != null) {
        AuthDebugLog.step('getUserProfile: cache hit uid=$uid');
        return UserModel.fromFirestore(cached.data()!, cached.id);
      }
    } catch (_) {}

    try {
      await _ensureAuthReady();
      final doc = await _users.doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        AuthDebugLog.step('getUserProfile: not found uid=$uid');
        return null;
      }
      AuthDebugLog.step('getUserProfile: found uid=$uid');
      return UserModel.fromFirestore(doc.data()!, doc.id);
    } catch (error, stackTrace) {
      AuthDebugLog.error('getUserProfile', error, stackTrace);
      try {
        final cached = await _users
            .doc(uid)
            .get(const GetOptions(source: Source.cache));
        if (cached.exists && cached.data() != null) {
          return UserModel.fromFirestore(cached.data()!, cached.id);
        }
      } catch (_) {}
      return null;
    }
  }
}
