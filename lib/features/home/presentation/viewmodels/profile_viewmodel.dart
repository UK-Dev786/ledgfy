import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../di/auth_providers.dart';
import '../../../../domain/usecases/sign_out.dart';

class ProfileViewModel extends StateNotifier<AsyncValue<void>> {
  ProfileViewModel(this._signOut) : super(const AsyncValue.data(null));

  final SignOutUseCase _signOut;

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _signOut());
  }

  void reset() => state = const AsyncValue.data(null);
}

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<void>>((ref) {
      return ProfileViewModel(ref.watch(signOutUseCaseProvider));
    });
