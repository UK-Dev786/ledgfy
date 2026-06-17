/// All user-facing strings in the app, organized by feature/screen.
///
/// Use these constants everywhere instead of hardcoded string literals so
/// that copy changes and future localization only need to touch one file.
abstract class AppText {
  // ── App ─────────────────────────────────────────────────────────────────
  static const appName = 'Ledgify';
  static const appTagline = 'Pro Digital Khata';

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
  static const ledgersSubtitle =
      'Pro khata books — udhar, cash, expenses & projects in one place';
  static const ledgersEmptyTitle = 'No ledgers yet';
  static const ledgersEmptySubtitle =
      'Create your first pro khata book. Each type has its own smart entry method — like Easy Khata, but built for serious business.';
  static const ledgerProBadge = 'PRO';
  static const ledgersFilterAll = 'All';
  static const ledgersFilterEmpty = 'No ledgers for this type yet.';
  static const ledgerPartiesSearchHint = 'Search parties...';
  static const ledgerPartiesSearchEmpty = 'No parties match your search.';
  static const ledgerShowFullAmounts = 'Show full amounts';
  static const ledgerShowShortAmounts = 'Show short amounts';
  static const ledgerDeleteLedger = 'Delete Ledger';
  static const ledgerDeleteTitle = 'Delete this ledger?';
  static const ledgerDeleteMessage =
      'This will permanently delete this ledger and all its entries. '
      'This action cannot be undone and your data will never return.';
  static const ledgerDeleteConfirm = 'Delete Forever';
  static const ledgerDeleteCancel = 'Cancel';
  static const ledgerDeleteParty = 'Delete Party';
  static const ledgerDeletePartyTitle = 'Delete this party?';
  static const ledgerDeletePartyMessage =
      'This will permanently delete all entries for this party. '
      'This action cannot be undone and your data will never return.';
  static const ledgerAddOpponent = 'Add Opponent';
  static const ledgerAddTeam = 'Add Team';
  static const ledgerAddParty = 'Add Party';
  static const ledgerOpponentNameLabel = 'Opponent Name';
  static const ledgerOpponentNameHint = 'e.g. Ahmed Traders';
  static const ledgerTeamNameLabel = 'Team Member Name';
  static const ledgerTeamNameHint = 'e.g. Sales team lead';
  static const ledgerHistoryPartyEmpty = 'No entries for this party yet.';
  static const ledgerDefaultEntryName = 'Entry';
  static const ledgerPartiesTitle = 'Parties';
  static const ledgerPartiesSubtitle =
      'Per-customer udhar balance — auto-calculated from your entries.';
  static const ledgerPartiesEmpty =
      'Add entries with a party name to see customer-wise balances here.';
  static const ledgersCreateTitle = 'Create Ledger';
  static const ledgersNameLabel = 'Ledger Name';
  static const ledgersNameHint = 'e.g. Main Store, Personal Budget';
  static const ledgersNameRequired = 'Ledger name is required';
  static const ledgersDescriptionLabel = 'Description (Optional)';
  static const ledgersDescriptionHint = 'e.g. Monthly shop records';
  static const ledgersTypeLabel = 'Ledger Type';
  static const ledgersCreateButton = 'Create Ledger';
  static const ledgerTypeGeneral = 'Udhar Book';
  static const ledgerTypeWholesale = 'Wholesale';
  static const ledgerTypeRetail = 'Retail';
  static const ledgerTypeCashBook = 'Cash Book';
  static const ledgerTypeExpense = 'Expense Tracker';
  static const ledgerTypeProject = 'Project';

  // Ledger detail
  static const ledgerDetailIncome = 'Income';
  static const ledgerDetailOutgoing = 'Outgoing';
  static const ledgerDetailBalance = 'Balance';
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

  // Ledger entry labels — Udhar
  static const ledgerEntryGiven = 'Given';
  static const ledgerEntryReceived = 'Received';
  static const ledgerAddGiven = 'Add Given (Udhaar)';
  static const ledgerAddReceived = 'Add Received (Wasooli)';
  static const ledgerPartyLabel = 'Party Name';
  static const ledgerPartyHint = 'Customer or supplier name';
  static const ledgerNoteLabel = 'Note (Optional)';
  static const ledgerNoteHint = 'Add a short note';
  static const ledgerDescriptionLabel = 'Description (Optional)';
  static const ledgerDescriptionHint = 'e.g. Bill #12, monthly rent';
  static const ledgerEntryNameLabel = 'Name';
  static const ledgerEntryNameHint = 'e.g. Daily sales, rent paid';
  static const ledgerEmptyUdhar =
      'No entries yet. Add Given when you give credit, Received when payment comes back.';

  // Wholesale
  static const ledgerEntryCreditSale = 'Credit Sale';
  static const ledgerEntryPayment = 'Payment';
  static const ledgerAddCreditSale = 'Add Credit Sale';
  static const ledgerAddPayment = 'Add Payment';
  static const ledgerWholesalePartyLabel = 'Party Name';
  static const ledgerWholesalePartyHint = 'Wholesaler or buyer name';
  static const ledgerBillLabel = 'Bill / Invoice (Optional)';
  static const ledgerBillHint = 'e.g. Invoice #1042';
  static const ledgerEmptyWholesale =
      'No wholesale entries yet. Record credit sales and payments received.';

  // Retail
  static const ledgerEntryUdhaar = 'Udhaar';
  static const ledgerEntryWasooli = 'Wasooli';
  static const ledgerAddUdhaar = 'Add Udhaar';
  static const ledgerAddWasooli = 'Add Wasooli';
  static const ledgerCustomerLabel = 'Customer Name';
  static const ledgerCustomerHint = 'e.g. Ali Ahmed';
  static const ledgerEmptyRetail =
      'No retail khata yet. Record udhaar given and wasooli received.';

  // Cash book
  static const ledgerEntryCashIn = 'Cash In';
  static const ledgerEntryCashOut = 'Cash Out';
  static const ledgerAddCashIn = 'Add Cash In';
  static const ledgerAddCashOut = 'Add Cash Out';
  static const ledgerCashNoteHint = 'e.g. Daily sales, rent paid';
  static const ledgerEmptyCashBook =
      'No cash entries yet. Record cash in and cash out.';

  // Expense tracker
  static const ledgerEntryExpense = 'Expense';
  static const ledgerAddExpense = 'Add Expense';
  static const ledgerTotalSpent = 'Total Spent';
  static const ledgerExpenseCategoryLabel = 'Category';
  static const ledgerExpenseNoteHint = 'What was this expense for?';
  static const ledgerExpenseCategoryRent = 'Rent';
  static const ledgerExpenseCategoryStock = 'Stock';
  static const ledgerExpenseCategorySalary = 'Salary';
  static const ledgerExpenseCategoryUtilities = 'Utilities';
  static const ledgerExpenseCategoryOther = 'Other';
  static const ledgerEmptyExpense =
      'No expenses yet. Tap + to record your first expense.';

  // Project
  static const ledgerEntryProjectIncome = 'Income';
  static const ledgerEntryProjectCost = 'Cost';
  static const ledgerAddProjectIncome = 'Add Project Income';
  static const ledgerAddProjectCost = 'Add Project Cost';
  static const ledgerAddProject = 'Add Project';
  static const ledgerProjectLabel = 'Project Name';
  static const ledgerProjectHint = 'e.g. House construction, shop renovation';
  static const ledgerProjectsTitle = 'Projects';
  static const ledgerProjectsSubtitle =
      'Per-project income and cost — tap a project to add entries.';
  static const ledgerProjectsEmpty =
      'Tap + to add your first project with an optional description.';
  static const ledgerDeleteProject = 'Delete Project';
  static const ledgerDeleteProjectTitle = 'Delete this project?';
  static const ledgerDeleteProjectMessage =
      'This will permanently delete all entries for this project. '
      'This action cannot be undone and your data will never return.';
  static const ledgerHistoryProjectEmpty = 'No entries for this project yet.';
  static const ledgerMilestoneLabel = 'Milestone (Optional)';
  static const ledgerMilestoneHint = 'e.g. Phase 1, Material purchase';
  static const ledgerEmptyProject =
      'No project entries yet. Track income and costs for this project.';

  static const ledgerPartyRequired = 'Party name is required';
  static const ledgerCategoryRequired = 'Please select a category';

  static const ledgerTypeDescUdhar =
      'Customer udhar khata — record Given and Received with party name.';
  static const ledgerTypeDescWholesale =
      'B2B credit sales — track credit sales and payments with bill details.';
  static const ledgerTypeDescRetail =
      'Shop udhar khata — record udhaar and wasooli per customer.';
  static const ledgerTypeDescCashBook =
      'Daily cash flow — record cash in and cash out.';
  static const ledgerTypeDescExpense =
      'Expense only — track spending by category.';
  static const ledgerTypeDescProject =
      'Project budget — add projects, then track income and costs per project.';
}
