import 'package:flutter/material.dart';

class MockLedgerEntry {
  final String id; // TODO: replace with real model when data layer is ready.
  final String title; // TODO: replace with real model when data layer is ready.
  final String
  ledgerName; // TODO: replace with real model when data layer is ready.
  final String
  category; // TODO: replace with real model when data layer is ready.
  final double
  amount; // TODO: replace with real model when data layer is ready.
  final bool
  isIncome; // TODO: replace with real model when data layer is ready.
  final DateTime
  date; // TODO: replace with real model when data layer is ready.
  final IconData
  icon; // TODO: replace with real model when data layer is ready.

  const MockLedgerEntry({
    required this.id,
    required this.title,
    required this.ledgerName,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.icon,
  });
}

class MockLedgerGroup {
  final String
  ledgerName; // TODO: replace with real model when data layer is ready.
  final IconData
  icon; // TODO: replace with real model when data layer is ready.
  final double
  totalIncome; // TODO: replace with real model when data layer is ready.
  final int
  transactionCount; // TODO: replace with real model when data layer is ready.

  const MockLedgerGroup({
    required this.ledgerName,
    required this.icon,
    required this.totalIncome,
    required this.transactionCount,
  });
}

class MockDailyTotal {
  final DateTime
  date; // TODO: replace with real model when data layer is ready.
  final double
  income; // TODO: replace with real model when data layer is ready.
  final double
  expense; // TODO: replace with real model when data layer is ready.

  const MockDailyTotal({
    required this.date,
    required this.income,
    required this.expense,
  });
}

final DateTime _now = DateTime.now();
final String mockUserName = 'Hamza';

final List<MockLedgerEntry> mockRecentEntries = [
  MockLedgerEntry(
    id: '1',
    title: 'Client payment received',
    ledgerName: 'Alpha Traders',
    category: 'Sales',
    amount: 125000,
    isIncome: true,
    date: DateTime(_now.year, _now.month, _now.day),
    icon: Icons.payments_outlined,
  ),
  MockLedgerEntry(
    id: '2',
    title: 'Office rent',
    ledgerName: 'Operations',
    category: 'Rent',
    amount: 45000,
    isIncome: false,
    date: DateTime(_now.year, _now.month, _now.day - 1),
    icon: Icons.home_work_outlined,
  ),
  MockLedgerEntry(
    id: '3',
    title: 'Wholesale order',
    ledgerName: 'Noor Fabrics',
    category: 'Bulk Sales',
    amount: 98000,
    isIncome: true,
    date: DateTime(_now.year, _now.month, _now.day - 2),
    icon: Icons.inventory_2_outlined,
  ),
  MockLedgerEntry(
    id: '4',
    title: 'Courier charges',
    ledgerName: 'Dispatch',
    category: 'Logistics',
    amount: 7200,
    isIncome: false,
    date: DateTime(_now.year, _now.month, _now.day - 3),
    icon: Icons.local_shipping_outlined,
  ),
  MockLedgerEntry(
    id: '5',
    title: 'Cash sale',
    ledgerName: 'Retail Counter',
    category: 'Walk-in Sales',
    amount: 35200,
    isIncome: true,
    date: DateTime(_now.year, _now.month, _now.day - 4),
    icon: Icons.receipt_long_outlined,
  ),
];

final List<MockLedgerGroup> mockLedgerGroups = const [
  MockLedgerGroup(
    ledgerName: 'Alpha Traders',
    icon: Icons.account_balance_wallet_outlined,
    totalIncome: 180000,
    transactionCount: 4,
  ),
  MockLedgerGroup(
    ledgerName: 'Noor Fabrics',
    icon: Icons.storefront_outlined,
    totalIncome: 145000,
    transactionCount: 3,
  ),
  MockLedgerGroup(
    ledgerName: 'Retail Counter',
    icon: Icons.point_of_sale_outlined,
    totalIncome: 112500,
    transactionCount: 6,
  ),
  MockLedgerGroup(
    ledgerName: 'Corporate Clients',
    icon: Icons.business_center_outlined,
    totalIncome: 76000,
    transactionCount: 2,
  ),
];

final List<MockDailyTotal> mockDailyTotals = List.generate(7, (index) {
  final date = DateTime(_now.year, _now.month, _now.day - (6 - index));
  const incomes = [
    18000.0,
    12000.0,
    25000.0,
    7000.0,
    22000.0,
    31000.0,
    16000.0,
  ];
  const expenses = [9000.0, 6000.0, 4000.0, 14000.0, 8000.0, 11000.0, 5000.0];
  return MockDailyTotal(
    date: date,
    income: incomes[index],
    expense: expenses[index],
  );
});

final double mockTotalIncome = mockRecentEntries
    .where((entry) => entry.isIncome)
    .fold(0, (sum, entry) => sum + entry.amount);

final double mockTotalExpense = mockRecentEntries
    .where((entry) => !entry.isIncome)
    .fold(0, (sum, entry) => sum + entry.amount);
