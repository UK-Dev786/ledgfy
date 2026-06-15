import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/app_text.dart';
import '../utils/auth_debug_log.dart';
import 'exceptions.dart';

abstract class AuthExceptionMapper {
  static String message(Object error) {
    AuthDebugLog.error('mapException', error);

    if (error is ValidationException) return error.message;

    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-email' => AppText.emailInvalid,
        'user-disabled' => AppText.authAccountDisabled,
        'user-not-found' => AppText.authInvalidCredentials,
        'wrong-password' => AppText.authInvalidCredentials,
        'invalid-credential' => AppText.authInvalidCredentials,
        'email-already-in-use' => AppText.authEmailInUse,
        'weak-password' => AppText.passwordTooShort,
        'too-many-requests' => AppText.authTooManyRequests,
        'network-request-failed' => AppText.authNetworkError,
        'operation-not-allowed' => AppText.authProviderDisabled,
        _ => AppText.authErrorGeneric,
      };
    }

    if (error is GoogleSignInException) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return AppText.authGoogleCancelled;
      }
      return AppText.authErrorGeneric;
    }

    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => AppText.authFirestorePermissionDenied,
        'unavailable' => AppText.authNetworkError,
        _ => AppText.authErrorGeneric,
      };
    }

    if (error is TypeError && error.toString().contains('PigeonUserDetails')) {
      return AppText.authSdkError;
    }

    return AppText.authErrorGeneric;
  }
}
