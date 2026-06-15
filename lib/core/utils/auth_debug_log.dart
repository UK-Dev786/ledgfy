import 'package:flutter/foundation.dart';

/// Debug-only auth flow logging. Filter logcat/console with `[Auth]`.
abstract class AuthDebugLog {
  static void step(String message) {
    if (kDebugMode) debugPrint('[Auth] $message');
  }

  static void error(String step, Object error, [StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    debugPrint('[Auth][ERROR] $step: $error (${error.runtimeType})');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }
}
