import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user.dart';
import 'auth_providers.dart';

final profileUserStreamProvider = StreamProvider<User?>((ref) {
  final authAsync = ref.watch(authStateChangesProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final cachedUid = firebaseAuth.currentUser?.uid;
  final authUser = authAsync.valueOrNull;

  User? firebaseFallback() {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      isVerified: firebaseUser.emailVerified,
    ).toEntity();
  }

  Stream<User?> watchProfileForUid(String uid, {User? fallback}) {
    return firestore.watchUserProfile(uid).map((model) {
      if (model != null) return model.toEntity();
      return fallback;
    });
  }

  // Firebase session exists but mapped auth user is still resolving.
  final resolvingSession =
      cachedUid != null && (authAsync.isLoading || authUser == null);

  if (resolvingSession) {
    return watchProfileForUid(cachedUid, fallback: firebaseFallback());
  }

  if (authAsync.hasError) {
    if (cachedUid != null) {
      return watchProfileForUid(cachedUid, fallback: firebaseFallback());
    }
    return Stream<User?>.error(authAsync.error!, authAsync.stackTrace);
  }

  if (authUser == null) {
    return Stream.value(null);
  }

  return watchProfileForUid(authUser.id, fallback: authUser);
});

class ProfileController {
  ProfileController(this._ref);

  final Ref _ref;

  FirestoreService get _firestore => _ref.read(firestoreServiceProvider);

  String? get _userId => _ref.read(currentUserIdProvider);

  Future<void> updateDisplayName(String displayName) async {
    final userId = _userId;
    if (userId == null) return;
    await _firestore.updateUserProfile(userId, {
      'displayName': displayName.trim(),
    });
  }

  Future<void> updateUsername(String username) async {
    final userId = _userId;
    if (userId == null) return;
    await _firestore.updateUserProfile(userId, {
      'username': username.trim(),
    });
  }

  Future<void> updateAccountType(String accountType) async {
    final userId = _userId;
    if (userId == null) return;
    await _firestore.updateUserProfile(userId, {
      'accountType': accountType,
    });
  }
}

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref);
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(profileUserStreamProvider).valueOrNull?.id ??
      ref.watch(authStateChangesProvider).valueOrNull?.id;
});

final ledgerOwnerIdProvider = Provider<String?>((ref) {
  final user = ref.watch(profileUserStreamProvider).valueOrNull ??
      ref.watch(authStateChangesProvider).valueOrNull;
  return user?.ledgerOwnerId;
});
