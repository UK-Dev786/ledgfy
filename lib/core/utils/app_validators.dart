import '../constants/app_text.dart';

/// Shared form validators. Each method matches the [FormFieldValidator<String>]
/// signature so it can be passed directly to [TextFormField.validator].
abstract class AppValidators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return AppText.nameError;
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return AppText.usernameRequired;
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return AppText.phoneRequired;
    final digits = value.replaceAll(RegExp(r'[\s\-\+]'), '');
    if (digits.length < 10) return AppText.phoneInvalid;
    if (!RegExp(r'^[\d\s\+\-]+$').hasMatch(value)) return AppText.phoneCharsInvalid;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppText.emailRequired;
    if (!RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) {
      return AppText.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppText.passwordRequired;
    if (value.length < 6) return AppText.passwordTooShort;
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() password) {
    return (String? value) {
      if (value == null || value.isEmpty) return AppText.confirmPasswordRequired;
      if (value != password()) return AppText.confirmPasswordMismatch;
      return null;
    };
  }

  static String? accountType(String? value) {
    if (value == null || value.isEmpty) return AppText.accountTypeRequired;
    return null;
  }
}
