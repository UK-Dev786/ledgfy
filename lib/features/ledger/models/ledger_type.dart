import 'package:flutter/material.dart';

import '../../../core/constants/app_text.dart';

class LedgerType {
  final String id;
  final String label;
  final IconData icon;

  const LedgerType({
    required this.id,
    required this.label,
    required this.icon,
  });

  static const general = LedgerType(
    id: 'general',
    label: AppText.ledgerTypeGeneral,
    icon: Icons.menu_book_rounded,
  );

  static const cashBook = LedgerType(
    id: 'cash_book',
    label: AppText.ledgerTypeCashBook,
    icon: Icons.payments_outlined,
  );

  static const expense = LedgerType(
    id: 'expense',
    label: AppText.ledgerTypeExpense,
    icon: Icons.receipt_long_outlined,
  );

  static const project = LedgerType(
    id: 'project',
    label: AppText.ledgerTypeProject,
    icon: Icons.work_outline_rounded,
  );

  static const List<LedgerType> all = [
    general,
    cashBook,
    expense,
    project,
  ];

  static LedgerType byId(String id) {
    return all.firstWhere(
      (type) => type.id == id,
      orElse: () => general,
    );
  }
}
