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
  static const verificationNotReceived = "Don't received a verification email?";
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
  static const homeGuestName = 'there';

  // Home — Hero card (neutral labels across udhar, cash, expense & project)
  static const homeOverviewSuffix = 'Overview';
  static const homeIncome = 'Money In';
  static const homeExpense = 'Money Out';
  static const homeNetBalance = 'Net Flow';

  // Home — Quick actions
  static const homeAddRecord = '+ Add Record';
  static const homeThisMonth = 'This Month';

  // Home — Recent records
  static const homeRecentRecords = 'Recent Records';
  static const homeSeeAll = 'See All';

  // Home — Summary
  static const homeMonthlySummary = 'Monthly Summary';
  static const homeTopLedgers = 'Top Ledgers';
  static const homeNoIncome = 'No transactions recorded this month.';
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
  static const homeChartIncomeLegend = 'Money In';
  static const homeChartExpenseLegend = 'Money Out';

  // Home — Empty state / shell
  static const homeNoRecordsTitle = 'No records yet';
  static const homeNoRecordsSubtitle = 'Tap + Add Record to get started.';
  static const homeAddFirstRecord = '+ Add Your First Record';
  static const homeLedgersTab = 'Ledgers';
  static const homeReportsTab = 'Reports';
  static const homeAnalyticsTab = 'Analytics';
  static const homeProfileTab = 'Profile';
  static const homeComingSoon = 'Coming soon';

  // Profile
  static const profileTitle = 'Profile';
  static const profileSignOut = 'Sign Out';
  static const profileVerified = 'Verified';
  static const profileNotVerified = 'Not verified';
  static const profileEditPhoto = 'Change profile photo';
  static const profileChooseGallery = 'Choose from gallery';
  static const profileRemovePhoto = 'Remove photo';
  static const profileEditUsername = 'Edit username';
  static const profileEditAccountType = 'Edit account type';
  static const profileEditName = 'Edit name';
  static const profileSave = 'Save';
  static const profileSectionAccount = 'Account';
  static const profileSectionPreferences = 'Preferences';
  static const profileSectionSubscription = 'Subscription';
  static const profileSectionApp = 'App';
  static const profileLanguage = 'Language';
  static const profileLanguageEnglish = 'English';
  static const profileLanguageUrdu = 'Urdu';
  static const profileNotifications = 'Notifications';
  static const profileNotificationsSubtitle = 'Payment reminders & sync alerts';
  static const profileSecurity = 'Security';
  static const profileSecuritySubtitle = 'Password & sign-in methods';
  static const profileHelp = 'Help & Support';
  static const profilePrivacy = 'Privacy Policy';
  static const profileAbout = 'About Ledgify';
  static const profilePlanFree = 'Free plan';
  static const profilePlanPro = 'Ledgify Pro';
  static const profilePlanProSubtitle =
      'PDF reports, multi-device sync, reminders & more';
  static const profileUpgrade = 'Upgrade';
  static const profileCurrentPlan = 'Current plan';
  static const profileComingSoon = 'Coming soon';
  static const profileLanguageTitle = 'Language';
  static const profileLanguageSubtitle =
      'Choose the language you want to use across Ledgify.';
  static const profileLanguageEnglishNative = 'English';
  static const profileLanguageUrduNative = 'اردو';
  static const profileSubscriptionTitle = 'Subscription';
  static const profileSubscriptionSubtitle =
      'Your plan, pricing, and what is included today.';
  static const profileCurrentPlanTitle = 'Your current plan';
  static const profileTrialBadge = 'Free · {months}-month trial';
  static const profileTrialNote =
      'Add entries freely for 2 months. After that, subscribe to keep recording transactions on this account.';
  static const profileFreemiumFeaturesTitle = 'Included now';
  static const profileTeamOrgOnlyTitle = 'Organization only';
  static const profileTeamOrgOnlyNote =
      'Team members are available on Organization accounts. Switch account type in Profile to unlock.';
  static const profilePaidUnlockTitle = 'Unlocked with subscription';
  static const profileChoosePlan = 'Choose your plan';
  static const profileBillingMonthly = 'Monthly';
  static const profileBillingSixMonths = '6 Months';
  static const profileBillingYearly = 'Yearly';
  static const profileBillingPerMonth = '/ month';
  static const profileBillingPerSixMonths = '/ 6 months';
  static const profileBillingPerYear = '/ year';
  static const profileBillingSaveSixMonths = 'Save 17%';
  static const profileBillingSaveYearly = 'Save 25%';
  static const profileSubscribe = 'Subscribe';
  static const profilePlanIndividual = 'Individual plan';
  static const profilePlanOrganization = 'Organization plan';
  static const profileProBenefitsTitle = 'Everything in Pro';
  static const profileFreeIncludesTitle = 'Included in Free';
  static const profileProPriceLabel = 'PKR 499';
  static const profileProPricePeriod = '/ month';
  static const profileAccountTypeIndividualHint =
      'Personal khata, cash book & expense tracking.';
  static const profileAccountTypeOrganizationHint =
      'Teams, staff roles & business ledgers.';
  static const profileSecurityTitle = 'Security';
  static const profileChangePassword = 'Change password';
  static const profileChangePasswordSubtitle =
      'Use a strong password to protect your ledger data.';
  static const profileCurrentPassword = 'Current password';
  static const profileCurrentPasswordHint = 'Enter your current password';
  static const profileNewPassword = 'New password';
  static const profileNewPasswordHint = 'Enter a new password';
  static const profileConfirmNewPassword = 'Confirm new password';
  static const profileConfirmNewPasswordHint = 'Re-enter your new password';
  static const profilePasswordUpdated = 'Password updated successfully.';
  static const profilePasswordStepCurrent = 'Verify your current password';
  static const profilePasswordStepNew = 'Choose a new password';
  static const profilePasswordStepConfirm = 'Confirm your new password';
  static const profileContinue = 'Continue';
  static const profileUpdatePassword = 'Update password';
  static const profileStepLabel = 'Step';
  static const profileViewPlan = 'View plans';
  static const profileBack = 'Back';
  static const profileLanguageFootnote =
      'Language changes apply across Ledgify. Urdu layout support is rolling out.';

  // Team & staff (organization)
  static const profileSectionTeam = 'Team & staff';
  static const profileTeamTitle = 'Team members';
  static const profileTeamSubtitle =
      'Create staff logins here. Tap a member to assign ledgers, or use ⋮ on each ledger.';
  static const profileTeamMembers = 'Team members';
  static const profileTeamMembersSubtitle = 'Add, edit & remove staff accounts';
  static const profileStaffActivity = 'Activity & audit';
  static const profileStaffActivitySubtitle = 'Who changed entries and when';
  static const profileInviteStaff = 'Add staff member';
  static const profileInviteStaffSent =
      'Staff account saved locally. Firebase login will be created when backend is connected.';
  static const staffRoleOwner = 'Owner';
  static const staffRoleEditor = 'Editor';
  static const staffRoleViewer = 'Viewer';
  static const staffStatusActive = 'Active';
  static const staffStatusDisabled = 'Disabled';
  static const staffOwnerLoginLabel = 'Owner account';
  static const staffInviteTitle = 'Add staff account';
  static const staffInviteNameLabel = 'Full name';
  static const staffInviteNameHint = 'e.g. Sara Ahmed';
  static const staffInviteUsernameLabel = 'Username';
  static const staffInviteUsernameHint = 'e.g. sara_cashier';
  static const staffInviteEmailLabel = 'Login email';
  static const staffInviteEmailHint =
      'e.g. sara@mainstore (does not need to be real)';
  static const staffInviteEmailNote =
      'This is the staff login ID. It can be a shop-made address — no inbox required.';
  static const staffInvitePasswordLabel = 'Password';
  static const staffInvitePasswordHint = 'Staff will use this to sign in';
  static const staffInviteConfirmPasswordLabel = 'Confirm password';
  static const staffInviteConfirmPasswordHint = 'Re-enter the password';
  static const staffInviteRoleLabel = 'Access level';
  static const staffInviteCreate = 'Create staff account';
  static const staffInviteLedgerNote =
      'Assign this staff to ledgers later from the ledger ⋮ menu.';
  static const staffRoleEditorHint =
      'Add entries · edit or delete only their own entries';
  static const staffRoleViewerHint =
      'View assigned ledgers · no adding or editing';
  static const staffAccessEditor = 'Editor';
  static const staffAccessViewer = 'Viewer';
  static const staffTeamEmptyTitle = 'No staff yet';
  static const staffTeamEmptySubtitle =
      'Create a staff login, then open any ledger → ⋮ → Assign staff.';
  static const staffTeamSummary =
      '{count} members · Assign access from each ledger ⋮ menu.';
  static const staffAccountLabel = 'Staff';
  static const staffManageLedgerHint =
      'Open a ledger → ⋮ → Assign staff to set Editor or Viewer for that book.';
  static const staffDeleteTitle = 'Remove staff account?';
  static const staffDeleteMessage =
      'This removes the login and their access from all ledgers. This cannot be undone.';
  static const staffDeleteConfirm = 'Remove staff';
  static const staffDeleted = 'Staff account removed.';
  static const ledgerAssignStaff = 'Assign staff';
  static const ledgerAssignStaffTitle = 'Ledger staff access';
  static const ledgerAssignStaffSubtitle =
      'Choose who can work on this ledger and set Editor or Viewer.';
  static const ledgerAssignStaffScopedSubtitle =
      'Pick staff, then choose specific parties or projects — not the whole udhar/project book.';
  static const ledgerAssignStaffEmpty = 'No staff assigned to this ledger yet.';
  static const ledgerAssignStaffAdd = 'Add staff to this ledger';
  static const ledgerAssignStaffConfirm = 'Add to ledger';
  static const ledgerStaffAssigned = 'Staff added to this ledger.';
  static const staffSubscriptionExpiredTitle =
      'Organization subscription expired';
  static const staffSubscriptionExpiredMessage =
      'Your organization plan is not active. Please contact your owner to renew the subscription.';
  static const staffLoginRequired = 'Login email is required';
  static const staffUsernameRequired = 'Username is required';
  static const staffAssignLedgersTitle = 'Assign ledgers';
  static const staffAssignLedgersSubtitle =
      'Staff only see home, reports, and entries for the ledgers you select.';
  static const staffAssignLedgersEmpty =
      'Create a ledger first, then assign it to this staff member.';
  static const staffAssignLedgersNone = 'No ledgers assigned';
  static const staffAssignLedgersCount = '{count} ledgers assigned';
  static const staffAssignLedgersSaved = 'Ledger access updated.';
  static const staffLedgerScopeWhole = 'Whole ledger';
  static const staffLedgerScopeNone = 'No parties selected';
  static const staffLedgerScopeParties = '{count} parties';
  static const staffLedgerScopeProjects = '{count} projects';
  static const staffLedgerPickParties = 'Select parties';
  static const staffLedgerPickProjects = 'Select projects';
  static const staffLedgerNoParties = 'Add parties to this udhar ledger first.';
  static const staffLedgerNoProjects = 'Add projects to this ledger first.';
  static const staffLedgerScopePartiesRequired =
      'Select at least one party for this udhar ledger.';
  static const staffLedgerScopeProjectsRequired =
      'Select at least one project for this ledger.';
  static const staffAssignLedgersUpdated = 'Ledger access updated.';
  static const staffAssignLedgersSection = 'Ledger access';
  static const profileStaffOrgBadge = 'Staff account';
  static const profileStaffOrgNote =
      'Your organization manages the subscription. Contact your owner if access stops.';
  static const profileStaffSectionAccount = 'My account';
  static const staffActivityTitle = 'Activity & audit';
  static const staffActivitySubtitle =
      'A record of staff actions across your ledgers.';
  static const staffActivityEmpty = 'No activity recorded yet.';
  static const staffAuditFilterAll = 'All';
  static const staffAuditFilterEntries = 'Entries';
  static const staffAuditFilterTeam = 'Team';
  static const staffAuditFilterSecurity = 'Security';
  static const staffAuditEntryAdded = 'Entry added';
  static const staffAuditEntryEdited = 'Entry edited';
  static const staffAuditEntryDeleted = 'Entry deleted';
  static const staffAuditStaffInvited = 'Staff invited';
  static const staffAuditRoleChanged = 'Role updated';
  static const staffAuditSignIn = 'Signed in';
  static const staffAuditBackendNote =
      'Live audit sync will connect when organization backend is enabled.';
  static const syncLabel = 'Sync';
  static const syncSynced = 'Synced';
  static const syncSyncing = 'Syncing…';
  static const syncOffline = 'Offline';
  static const syncOfflinePending = 'Offline · saved on device';

  // Home — Errors
  static const homeErrorGeneric = 'Something went wrong.';
  static const homeRetry = 'Retry';

  static const homeMonthlyOverview = 'Monthly Overview';
  static const homeStatusPositive = 'SURPLUS';
  static const homeStatusNegative = 'DEFICIT';
  static const homeStatusNeutral = 'BALANCED';
  static const homeNetPositiveHint = 'More money in than out this month';
  static const homeNetNegativeHint = 'More money out than in this month';
  static const homeNetNeutralHint = 'Money in and out are balanced this month';

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
  static const ledgersEditTitle = 'Edit Ledger';
  static const ledgersSaveButton = 'Save Changes';
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
  static const ledgerEntryDateLabel = 'Date';
  static const ledgerEditEntryTitle = 'Edit Entry';
  static const ledgerEditPartyTitle = 'Edit Party';
  static const ledgerDeleteEntryTitle = 'Delete this entry?';
  static const ledgerDeleteEntryMessage =
      'This transaction will be permanently removed from your ledger.';

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

  // Khata report & opening balance
  static const ledgerReportTitle = 'Khata Report';
  static const ledgerReportSummary = 'Summary';
  static const ledgerReportEntries = 'Entries';
  static const ledgerReportNoEntries = 'No entries in this report.';
  static const ledgerReportGenerated = 'Generated';
  static const ledgerReportParentLedger = 'Ledger';
  static const ledgerReportColDate = 'Date';
  static const ledgerReportColDetails = 'Details';
  static const ledgerReportColType = 'Type';
  static const ledgerReportColAmount = 'Amount';
  static const ledgerReportPage = 'Page';
  static const ledgerReportFooter =
      'Generated by Ledgify — Pro Digital Khata. Find Ledgify on Google Play & App Store.';
  static const ledgerReportShareBody =
      'Khata report from Ledgify — your pro digital khata app. '
      'Download Ledgify on Google Play & App Store.';
  static const ledgerReportPrint = 'Print';
  static const ledgerReportShare = 'Share';
  static const ledgerOpeningBalance = 'Opening Balance';
  static const ledgerOpeningBalanceTitle = 'Set Opening Balance';
  static const ledgerOpeningBalanceSubtitle =
      'Starting balance for this ledger before your recorded entries.';
  static const ledgerOpeningBalanceHint = 'e.g. 50000 or -10000';
  static const ledgerOpeningBalanceSave = 'Save Balance';
  static const ledgerOpeningBalanceInvalid = 'Enter a valid amount';
  static const ledgerSetOpeningBalance = 'Opening Balance';

  // Reports (navbar index 2)
  static const reportsTitle = 'Reports';
  static const reportsSubtitle = 'Daily & monthly P&L with party insights';
  static const reportsEmpty =
      'Add ledgers and entries to see P&L charts and party breakdowns here.';
  static const reportsPeriodToday = 'Today';
  static const reportsPeriodThisWeek = 'This Week';
  static const reportsPeriodThisMonth = 'This Month';
  static const reportsPeriodThisYear = 'This Year';
  static const reportsPeriodEmpty =
      'No income or expense in this period. Try another filter.';
  static const reportsIncome = 'Income';
  static const reportsExpense = 'Expense';
  static const reportsNetPl = 'Net P&L';
  static const reportsPlChartTitle = 'Income vs Expense';
  static const reportsPlChartSubtitle =
      'Compare money in and money out for the selected period.';
  static const reportsNetPlChartTitle = 'Net P&L Trend';
  static const reportsNetPlChartSubtitle =
      'Track profit or loss over time after expenses.';
  static const reportsPartyRoleChartTitle = 'Customer vs Supplier';
  static const reportsPartyRoleChartSubtitle =
      'Outstanding udhar balances by party role — positive balance means customer owes you.';
  static const reportsPartyRoleEmpty =
      'Add parties in your Udhar or Project ledgers to see role breakdown.';
  static const reportsCustomerRole = 'Customers';
  static const reportsSupplierRole = 'Suppliers';
  static const reportsPrint = 'Print report';
  static const reportsPrintTitle = 'Analytics Report';
  static const reportsPrintPeriod = 'Period';
  static const reportsPrintBreakdown = 'Period breakdown';
  static const reportsPrintTransactions = 'Transactions';
  static const reportsPrintOutstanding = 'Outstanding udhar (as of today)';
  static const reportsPrintColLedger = 'Ledger';
  static const reportsPrintColNet = 'Net';
  static const reportsPrintNoTransactions = 'No transactions in this period.';
  static const reportsPrintNothingToPrint =
      'No data to print for the selected period.';
}
