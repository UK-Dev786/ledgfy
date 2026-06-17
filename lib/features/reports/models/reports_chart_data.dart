enum ReportsPeriod { daily, monthly }

class PeriodPlPoint {
  final String label;
  final DateTime periodStart;
  final double income;
  final double expense;

  const PeriodPlPoint({
    required this.label,
    required this.periodStart,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;
}

class PartyRoleSlice {
  final String role;
  final double amount;

  const PartyRoleSlice({
    required this.role,
    required this.amount,
  });
}

class ReportsSnapshot {
  final List<PeriodPlPoint> plPoints;
  final List<PartyRoleSlice> partyRoles;
  final double totalIncome;
  final double totalExpense;
  final double netPl;

  const ReportsSnapshot({
    required this.plPoints,
    required this.partyRoles,
    required this.totalIncome,
    required this.totalExpense,
    required this.netPl,
  });

  bool get hasPlData => plPoints.any((point) => point.income > 0 || point.expense > 0);

  bool get hasPartyRoleData =>
      partyRoles.any((slice) => slice.amount > 0);
}
