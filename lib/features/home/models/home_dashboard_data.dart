import 'package:flutter/material.dart';

class HomeRecordItem {
  final String id;
  final String title;
  final String ledgerName;
  final String? category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final IconData icon;
  final String ledgerId;

  const HomeRecordItem({
    required this.id,
    required this.title,
    required this.ledgerName,
    this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.icon,
    required this.ledgerId,
  });
}

class HomeLedgerGroup {
  final String ledgerId;
  final String ledgerName;
  final IconData icon;
  final double totalIncome;
  final int transactionCount;

  const HomeLedgerGroup({
    required this.ledgerId,
    required this.ledgerName,
    required this.icon,
    required this.totalIncome,
    required this.transactionCount,
  });
}

class HomeDashboardData {
  final double totalIncome;
  final double totalExpense;
  final List<HomeRecordItem> recentEntries;
  final List<HomeLedgerGroup> topLedgers;

  const HomeDashboardData({
    required this.totalIncome,
    required this.totalExpense,
    required this.recentEntries,
    required this.topLedgers,
  });

  bool get hasRecords => recentEntries.isNotEmpty;
}
