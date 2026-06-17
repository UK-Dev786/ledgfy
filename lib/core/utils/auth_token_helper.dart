import 'package:firebase_auth/firebase_auth.dart';

/// Refreshes the ID token when online; falls back to cached token offline.
Future<void> ensureAuthToken(User? user, {Duration timeout = const Duration(seconds: 4)}) async {
  if (user == null) return;
  try {
    await user.getIdToken(true).timeout(timeout);
  } catch (_) {
    await user.getIdToken(false);
  }
}
