import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import 'ledger_accounting_mode.dart';
import 'ledger_entry.dart';
import 'ledger_type.dart';

class LedgerTypeConfig {
  final LedgerType type;
  final LedgerAccountingMode mode;
  final String creditLabel;
  final String debitLabel;
  final String balanceLabel;
  final String addCreditTitle;
  final String addDebitTitle;
  final IconData creditIcon;
  final IconData debitIcon;
  final List<LedgerEntryType> creditTypes;
  final List<LedgerEntryType> debitTypes;
  final bool requiresParty;
  final bool requiresCategory;
  final bool requiresNote;
  final String partyLabel;
  final String partyHint;
  final String noteLabel;
  final String noteHint;
  final String emptyHistoryMessage;
  final String typeDescription;

  const LedgerTypeConfig({
    required this.type,
    required this.mode,
    required this.creditLabel,
    required this.debitLabel,
    required this.balanceLabel,
    required this.addCreditTitle,
    required this.addDebitTitle,
    required this.creditIcon,
    required this.debitIcon,
    required this.creditTypes,
    required this.debitTypes,
    this.requiresParty = false,
    this.requiresCategory = false,
    this.requiresNote = false,
    this.partyLabel = '',
    this.partyHint = '',
    this.noteLabel = '',
    this.noteHint = '',
    required this.emptyHistoryMessage,
    required this.typeDescription,
  });

  bool get isExpenseOnly => mode == LedgerAccountingMode.expenseOnly;

  /// Expense shows one total — full PKR by default, no compact toggle.
  bool get showsFullAmountsByDefault => isExpenseOnly;

  bool get showAmountExpandButton => !isExpenseOnly;

  bool get hasDualEntry => !isExpenseOnly;

  bool get supportsPartyLedger => mode == LedgerAccountingMode.udhar;

  bool get supportsSubLedgers =>
      mode == LedgerAccountingMode.udhar ||
      mode == LedgerAccountingMode.project;

  bool get isProjectLedger => mode == LedgerAccountingMode.project;

  String get addSubLedgerTitle => isProjectLedger
      ? AppText.ledgerAddProject
      : AppText.ledgerAddParty;

  String get subLedgerSectionTitle => isProjectLedger
      ? AppText.ledgerProjectsTitle
      : AppText.ledgerPartiesTitle;

  String get subLedgerSectionSubtitle => isProjectLedger
      ? AppText.ledgerProjectsSubtitle
      : AppText.ledgerPartiesSubtitle;

  String get subLedgerEmptyMessage => isProjectLedger
      ? AppText.ledgerProjectsEmpty
      : AppText.ledgerPartiesEmpty;

  String get subLedgerHistoryEmpty => isProjectLedger
      ? AppText.ledgerHistoryProjectEmpty
      : AppText.ledgerHistoryPartyEmpty;

  String get deleteSubLedgerLabel => isProjectLedger
      ? AppText.ledgerDeleteProject
      : AppText.ledgerDeleteParty;

  String get deleteSubLedgerTitle => isProjectLedger
      ? AppText.ledgerDeleteProjectTitle
      : AppText.ledgerDeletePartyTitle;

  String get deleteSubLedgerMessage => isProjectLedger
      ? AppText.ledgerDeleteProjectMessage
      : AppText.ledgerDeletePartyMessage;

  IconData get subLedgerIcon => isProjectLedger
      ? Icons.work_outline_rounded
      : Icons.person_outline_rounded;

  IconData get addSubLedgerFabIcon => isProjectLedger
      ? Icons.add_business_outlined
      : Icons.person_add_alt_1_rounded;

  Color get creditColor => AppColors.success;

  Color get debitColor => AppColors.error;

  Color get outflowColor => creditColor;

  Color get inflowColor => debitColor;

  IconData get outflowIcon => creditIcon;

  IconData get inflowIcon => debitIcon;

  String get outflowLabel => creditLabel;

  String get inflowLabel => debitLabel;

  LedgerEntryType get outflowEntryType => creditEntryType;

  LedgerEntryType get inflowEntryType => debitEntryType!;

  double outflowAmount({required double creditTotal, required double debitTotal}) =>
      creditTotal;

  double inflowAmount({required double creditTotal, required double debitTotal}) =>
      debitTotal;

  LedgerEntryType get creditEntryType => creditTypes.first;

  LedgerEntryType? get debitEntryType =>
      debitTypes.isEmpty ? null : debitTypes.first;

  LedgerEntryType get singleEntryType => debitTypes.first;

  static LedgerTypeConfig forType(LedgerType type) {
    return _configs.firstWhere(
      (config) => config.type.id == type.id,
      orElse: () => _configs.first,
    );
  }

  String labelForEntry(LedgerEntryType entryType) {
    if (creditTypes.contains(entryType)) return creditLabel;
    if (debitTypes.contains(entryType)) return debitLabel;
    return entryType.name;
  }

  IconData iconForEntry(LedgerEntryType entryType) {
    if (creditTypes.contains(entryType)) return creditIcon;
    if (debitTypes.contains(entryType)) return debitIcon;
    return Icons.receipt_long_outlined;
  }

  Color colorForEntry(LedgerEntryType entryType) {
    if (creditTypes.contains(entryType)) return outflowColor;
    if (debitTypes.contains(entryType)) return inflowColor;
    return AppColors.textTertiary;
  }

  static final List<LedgerTypeConfig> _configs = [
    LedgerTypeConfig(
      type: LedgerType.general,
      mode: LedgerAccountingMode.udhar,
      creditLabel: AppText.ledgerEntryGiven,
      debitLabel: AppText.ledgerEntryReceived,
      balanceLabel: AppText.ledgerDetailBalance,
      addCreditTitle: AppText.ledgerAddGiven,
      addDebitTitle: AppText.ledgerAddReceived,
      creditIcon: Icons.call_received_rounded,
      debitIcon: Icons.call_made_rounded,
      creditTypes: const [LedgerEntryType.given],
      debitTypes: const [LedgerEntryType.received],
      requiresParty: true,
      partyLabel: AppText.ledgerPartyLabel,
      partyHint: AppText.ledgerPartyHint,
      noteLabel: AppText.ledgerNoteLabel,
      noteHint: AppText.ledgerNoteHint,
      emptyHistoryMessage: AppText.ledgerEmptyUdhar,
      typeDescription: AppText.ledgerTypeDescUdhar,
    ),
    LedgerTypeConfig(
      type: LedgerType.wholesale,
      mode: LedgerAccountingMode.udhar,
      creditLabel: AppText.ledgerEntryCreditSale,
      debitLabel: AppText.ledgerEntryPayment,
      balanceLabel: AppText.ledgerDetailBalance,
      addCreditTitle: AppText.ledgerAddCreditSale,
      addDebitTitle: AppText.ledgerAddPayment,
      creditIcon: Icons.local_shipping_outlined,
      debitIcon: Icons.payments_outlined,
      creditTypes: const [LedgerEntryType.given],
      debitTypes: const [LedgerEntryType.received],
      requiresParty: true,
      partyLabel: AppText.ledgerWholesalePartyLabel,
      partyHint: AppText.ledgerWholesalePartyHint,
      requiresNote: true,
      noteLabel: AppText.ledgerBillLabel,
      noteHint: AppText.ledgerBillHint,
      emptyHistoryMessage: AppText.ledgerEmptyWholesale,
      typeDescription: AppText.ledgerTypeDescWholesale,
    ),
    LedgerTypeConfig(
      type: LedgerType.retail,
      mode: LedgerAccountingMode.udhar,
      creditLabel: AppText.ledgerEntryUdhaar,
      debitLabel: AppText.ledgerEntryWasooli,
      balanceLabel: AppText.ledgerDetailBalance,
      addCreditTitle: AppText.ledgerAddUdhaar,
      addDebitTitle: AppText.ledgerAddWasooli,
      creditIcon: Icons.shopping_cart_outlined,
      debitIcon: Icons.account_balance_wallet_outlined,
      creditTypes: const [LedgerEntryType.given],
      debitTypes: const [LedgerEntryType.received],
      requiresParty: true,
      partyLabel: AppText.ledgerCustomerLabel,
      partyHint: AppText.ledgerCustomerHint,
      emptyHistoryMessage: AppText.ledgerEmptyRetail,
      typeDescription: AppText.ledgerTypeDescRetail,
    ),
    LedgerTypeConfig(
      type: LedgerType.cashBook,
      mode: LedgerAccountingMode.cashBook,
      creditLabel: AppText.ledgerEntryCashIn,
      debitLabel: AppText.ledgerEntryCashOut,
      balanceLabel: AppText.ledgerDetailBalance,
      addCreditTitle: AppText.ledgerAddCashIn,
      addDebitTitle: AppText.ledgerAddCashOut,
      creditIcon: Icons.arrow_upward_rounded,
      debitIcon: Icons.arrow_downward_rounded,
      creditTypes: const [LedgerEntryType.income],
      debitTypes: const [LedgerEntryType.outgoing],
      requiresNote: true,
      noteLabel: AppText.ledgerNoteLabel,
      noteHint: AppText.ledgerCashNoteHint,
      emptyHistoryMessage: AppText.ledgerEmptyCashBook,
      typeDescription: AppText.ledgerTypeDescCashBook,
    ),
    LedgerTypeConfig(
      type: LedgerType.expense,
      mode: LedgerAccountingMode.expenseOnly,
      creditLabel: AppText.ledgerEntryExpense,
      debitLabel: AppText.ledgerEntryExpense,
      balanceLabel: AppText.ledgerTotalSpent,
      addCreditTitle: AppText.ledgerAddExpense,
      addDebitTitle: AppText.ledgerAddExpense,
      creditIcon: Icons.receipt_long_outlined,
      debitIcon: Icons.receipt_long_outlined,
      creditTypes: const [],
      debitTypes: const [LedgerEntryType.expense],
      requiresCategory: true,
      requiresNote: true,
      noteLabel: AppText.ledgerNoteLabel,
      noteHint: AppText.ledgerExpenseNoteHint,
      emptyHistoryMessage: AppText.ledgerEmptyExpense,
      typeDescription: AppText.ledgerTypeDescExpense,
    ),
    LedgerTypeConfig(
      type: LedgerType.project,
      mode: LedgerAccountingMode.project,
      creditLabel: AppText.ledgerEntryProjectIncome,
      debitLabel: AppText.ledgerEntryProjectCost,
      balanceLabel: AppText.ledgerDetailBalance,
      addCreditTitle: AppText.ledgerAddProjectIncome,
      addDebitTitle: AppText.ledgerAddProjectCost,
      creditIcon: Icons.trending_up_rounded,
      debitIcon: Icons.construction_outlined,
      creditTypes: const [LedgerEntryType.income],
      debitTypes: const [LedgerEntryType.outgoing],
      partyLabel: AppText.ledgerProjectLabel,
      partyHint: AppText.ledgerProjectHint,
      requiresNote: true,
      noteLabel: AppText.ledgerMilestoneLabel,
      noteHint: AppText.ledgerMilestoneHint,
      emptyHistoryMessage: AppText.ledgerEmptyProject,
      typeDescription: AppText.ledgerTypeDescProject,
    ),
  ];
}
