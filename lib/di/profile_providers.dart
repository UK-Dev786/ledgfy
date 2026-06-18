import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/auth_remote_datasource.dart';
import '../domain/entities/user.dart';
import 'auth_providers.dart';

final profileUserStreamProvider = StreamProvider<User?>((ref) {
  final authAsync = ref.watch(authStateChangesProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  final cachedUid = ref.watch(firebaseAuthProvider).currentUser?.uid;

  if (authAsync.isLoading) {
    if (cachedUid != null) {
      return firestore.watchUserProfile(cachedUid).map(
            (model) => model?.toEntity(),
          );
    }
    return const Stream<User?>.empty();
  }

  if (authAsync.hasError) {
    if (cachedUid != null) {
      return firestore.watchUserProfile(cachedUid).map(
            (model) => model?.toEntity(),
          );
    }
    return Stream<User?>.error(authAsync.error!, authAsync.stackTrace);
  }

  final user = authAsync.valueOrNull;
  if (user == null) {
    return Stream.value(null);
  }

  return firestore.watchUserProfile(user.id).map((model) {
    if (model == null) return user;
    return model.toEntity();
  });
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
