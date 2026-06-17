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

  // ── Auth — Signup page ────────────────────────────────────────────────────
  static const signupWelcome = 'Create an Account';
  static const signupSubtitle = 'Sign up to get started';
  static const signUp = 'Sign Up';
  static const alreadyHaveAccount = "Already have an account?";
  static const loginHere = "Login here";
  static const goToLogin = 'Login Now';

  // ── Auth — name form ────────────────────────────────────────────────────
  static const enterFullName = "Full Name";
  static const nameHint = "Enter your full name";
  static const nameError = "Full name is required";
  static const usernameLabel = 'Username';
  static const usernameHint = 'Enter your username';
  static const usernameRequired = 'Username is required';

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
  static const orContinueWith = 'or continue with';
  static const forgotPassword = 'Forgot Password';
  static const forgotPasswordTitle = 'Forgot Password';
  static const forgotPasswordSubtitle =
      'Enter your email address and we will send you a link to reset your password.';
  static const sendResetLink = 'Send Reset Link';
  static const backToLogin = 'Back to Login';
  static const passwordResetSentTitle = 'Email Sent';
  static const passwordResetSentMessage =
      'Check your inbox for the password reset link.';
  static const signUpVerifyPopupTitle = 'Check Your Email';
  static const signUpVerifyPopupMessage =
      'We sent a verification email to you. Open the link to verify your account, then sign in.';
  static const verificationNotReceived =
      "Don't received a verification email?";
  static const resendHere = 'Resend here';
  static const verificationResent =
      'Verification email sent again. Check your inbox.';
  static const dialogOk = 'OK';
  static const dialogSuccessTitle = 'Success';
  static const verifyEmailTitle = 'One More Step';
  static const verifyEmailSubtitle =
      'Your account is almost ready. We sent a verification link to';
  static const verifyEmailDescription =
      'Please check your inbox and tap the link to verify your email. Once that is done, come back and log in to start using Ledgify.';
  static const verifyEmailHint =
      'If you cannot find it, check your spam or promotions folder too.';
  static const verificationEmailMissing = "Didn't get the email?";
  static const resendVerification = 'Resend';

  // ── Auth — OTP page ──────────────────────────────────────────────────────
  static const otpTitle = 'Verify Your Number';
  static const otpSubtitle = 'Enter the 6-digit code sent to';
  static const otpResend = 'Resend OTP';
  static const otpVerify = 'Verify';
  static const otpRequired = 'Please enter the complete OTP';

  // ── Auth — Account type ──────────────────────────────────────────────────
  static const accountTypeLabel = 'Account Type';
  static const accountTypeHint = 'Select account type';
  static const accountTypeRequired = 'Please select an account type';
  static const accountTypeIndividual = 'Individual';
  static const accountTypeOrganization = 'Organization';

  // ── Auth — Confirm password ──────────────────────────────────────────────
  static const confirmPasswordLabel = 'Confirm Password';
  static const confirmPasswordHint = 'Re-enter your password';
  static const confirmPasswordRequired = 'Please confirm your password';
  static const confirmPasswordMismatch = 'Passwords do not match';

  // ── Auth — Email / password validators ──────────────────────────────────
  static const emailRequired = 'Email address is required';
  static const emailInvalid = 'Enter a valid email address';
  static const passwordRequired = 'Password is required';
  static const passwordTooShort = 'Password must be at least 6 characters';
  static const dontReceiveCode = "Didn't receive the code?";

  // ── Auth — Firebase errors ───────────────────────────────────────────────
  static const authErrorGeneric = 'Something went wrong. Please try again.';
  static const authInvalidCredentials = 'Invalid email or password.';
  static const authEmailInUse = 'An account with this email already exists.';
  static const authAccountDisabled = 'This account has been disabled.';
  static const authTooManyRequests =
      'Too many attempts. Please wait and try again.';
  static const authNetworkError =
      'Network error. Check your connection and try again.';
  static const authProviderDisabled =
      'This sign-in method is not enabled. Please contact support.';
  static const authGoogleCancelled = 'Google sign-in was cancelled.';
  static const authEmailNotVerified =
      'Please verify your email before signing in. Check your inbox for the verification link.';
  static const authFirestorePermissionDenied =
      'Could not save your profile. Please check Firestore rules and try again.';
  static const authSdkError =
      'Authentication SDK error. Run flutter clean, then try again.';

  // Home — Greeting
  static const homeGreetingMorning = 'Good morning';
  static const homeGreetingAfternoon = 'Good afternoon';
  static const homeGreetingEvening = 'Good evening';

  // Home — Hero card
  static const homeOverviewSuffix = 'Overview';
  static const homeIncome = 'Income';
  static const homeExpense = 'Expense';
  static const homeNetBalance = 'Net';

  // Home — Quick actions
  static const homeAddRecord = '+ Add Record';
  static const homeThisMonth = 'This Month';

  // Home — Recent records
  static const homeRecentRecords = 'Recent Records';
  static const homeSeeAll = 'See All';

  // Home — Summary
  static const homeMonthlySummary = 'Monthly Summary';
  static const homeTopLedgers = 'Top Ledgers';
  static const homeNoIncome = 'No income recorded this month.';
  static const homeTransaction = 'transaction';
  static const homeTransactions = 'transactions';

  // Home — Chart
  static const homeChartDayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const homeChartIncomeLegend = 'Income';
  static const homeChartExpenseLegend = 'Expense';

  // Home — Empty state / shell
  static const homeNoRecordsTitle = 'No records yet';
  static const homeNoRecordsSubtitle = 'Tap + Add Record to get started.';
  static const homeAddFirstRecord = '+ Add Your First Record';
  static const homeLedgersTab = 'Ledgers';
  static const homeAnalyticsTab = 'Analytics';
  static const homeProfileTab = 'Profile';
  static const homeComingSoon = 'Coming soon';

  // Profile
  static const profileTitle = 'Profile';
  static const profileSignOut = 'Sign Out';
  static const profileVerified = 'Verified';
  static const profileNotVerified = 'Not verified';

  // Home — Errors
  static const homeErrorGeneric = 'Something went wrong.';
  static const homeRetry = 'Retry';

  static const homeMonthlyOverview = 'Monthly Overview';
  static const homeStatusPositive = 'POSITIVE';
  static const homeStatusNegative = 'NEGATIVE';
  static const homeStatusNeutral = 'NEUTRAL';
  static const homeNetPositiveHint = 'Income exceeds expenses this month';
  static const homeNetNegativeHint = 'Expenses exceed income this month';
  static const homeNetNeutralHint = 'Income and expenses are balanced';

  // Ledgers
  static const ledgersTitle = 'Ledgers';
  static const ledgersSubtitle = 'Organize your books by purpose';
  static const ledgersEmptyTitle = 'No ledgers yet';
  static const ledgersEmptySubtitle =
      'Create your first ledger to start tracking income and expenses.';
  static const ledgersCreateTitle = 'Create Ledger';
  static const ledgersNameLabel = 'Ledger Name';
  static const ledgersNameHint = 'e.g. Main Store, Personal Budget';
  static const ledgersNameRequired = 'Ledger name is required';
  static const ledgersDescriptionLabel = 'Description (Optional)';
  static const ledgersDescriptionHint = 'e.g. Monthly shop records';
  static const ledgersTypeLabel = 'Ledger Type';
  static const ledgersCreateButton = 'Create Ledger';
  static const ledgerTypeGeneral = 'General Ledger';
  static const ledgerTypeWholesale = 'Wholesale';
  static const ledgerTypeRetail = 'Retail';
  static const ledgerTypeCashBook = 'Cash Book';
  static const ledgerTypeExpense = 'Expense Tracker';
  static const ledgerTypeProject = 'Project';

  // Ledger detail
  static const ledgerDetailIncome = 'Income';
  static const ledgerDetailOutgoing = 'Outgoing';
  static const ledgerDetailSubtotal = 'Subtotal';
  static const ledgerDetailHistory = 'History';
  static const ledgerDetailEmptyHistory =
      'No transactions yet. Use the buttons below to add income or outgoing.';
  static const ledgerDetailAddIncome = 'Add Income';
  static const ledgerDetailAddOutgoing = 'Add Outgoing';
  static const ledgerDetailAmountLabel = 'Amount';
  static const ledgerDetailAmountHint = 'Enter amount';
  static const ledgerDetailAmountRequired = 'Amount is required';
  static const ledgerDetailAmountInvalid =
      'Enter a valid amount greater than zero';
  static const ledgerDetailAddButton = 'Add';
}
