/// All user-facing strings in the app, organized by feature/screen.
///
/// Use these constants everywhere instead of hardcoded string literals so
/// that copy changes and future localization only need to touch one file.
abstract class AppText {
  // ── App ─────────────────────────────────────────────────────────────────
  static const appName = 'Ledgify';
  static const appTagline = 'Ledger Simplify';

  // ── Auth — Login page ────────────────────────────────────────────────────
  static const loginWelcome = 'Welcome to Ledgify';
  static const loginSubtitle = 'Sign in to your account';
  static const doNotHaveAccount = "Don't have an account?";
  static const signupHere = "Sign up here";

  // ── Auth — Tab switcher ──────────────────────────────────────────────────
  static const tabPhone = 'Phone';
  static const tabEmail = 'Email';

  // ── Auth — Phone form ────────────────────────────────────────────────────
  static const phoneLabel = 'Phone Number';
  static const phoneHint = 'Enter your phone number';
  static const phoneSendOtp = 'Send OTP';

  // ── Auth — Phone validators ──────────────────────────────────────────────
  static const phoneRequired = 'Phone number is required';
  static const phoneInvalid = 'Enter a valid phone number';
  static const phoneCharsInvalid = 'Only digits, spaces, + and - are allowed';

  // ── Auth — Email form ────────────────────────────────────────────────────
  static const emailLabel = 'Email Address';
  static const emailHint = 'Enter your email address';
  static const passwordLabel = 'Password';
  static const passwordHint = 'Enter your password';
  static const signIn = 'Sign In';
  static const forgotPassword = 'Forgot Password';

  // ── Auth — Email / password validators ──────────────────────────────────
  static const emailRequired = 'Email address is required';
  static const emailInvalid = 'Enter a valid email address';
  static const passwordRequired = 'Password is required';
  static const passwordTooShort = 'Password must be at least 6 characters';
}
