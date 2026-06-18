enum KhataReportKind {
  ledger,
  analytics,
}

class KhataReportSummaryRow {
  final String label;
  final double amount;

  const KhataReportSummaryRow({
    required this.label,
    required this.amount,
  });
}

class KhataReportBreakdownRow {
  final String label;
  final double income;
  final double expense;

  const KhataReportBreakdownRow({
    required this.label,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;
}

class KhataReportEntryRow {
  final DateTime date;
  final String title;
  final String typeLabel;
  final double amount;
  final String? ledgerName;
  final bool? isIncome;

  const KhataReportEntryRow({
    required this.date,
    required this.title,
    required this.typeLabel,
    required this.amount,
    this.ledgerName,
    this.isIncome,
  });
}

class KhataReportData {
  final KhataReportKind kind;
  final String ledgerTitle;
  final String? ledgerDescription;
  final String ledgerTypeLabel;
  final String? subLedgerName;
  final String? subLedgerDescription;
  final String? periodLabel;
  final String? periodRangeLabel;
  final double openingBalance;
  final bool showOpeningBalance;
  final List<KhataReportSummaryRow> summaryRows;
  final List<KhataReportBreakdownRow> breakdownRows;
  final List<KhataReportSummaryRow> partyRoleRows;
  final double balance;
  final String balanceLabel;
  final List<KhataReportEntryRow> entries;
  final DateTime generatedAt;

  const KhataReportData({
    this.kind = KhataReportKind.ledger,
    required this.ledgerTitle,
    this.ledgerDescription,
    required this.ledgerTypeLabel,
    this.subLedgerName,
    this.subLedgerDescription,
    this.periodLabel,
    this.periodRangeLabel,
    this.openingBalance = 0,
    this.showOpeningBalance = false,
    required this.summaryRows,
    this.breakdownRows = const [],
    this.partyRoleRows = const [],
    required this.balance,
    required this.balanceLabel,
    required this.entries,
    required this.generatedAt,
  });

  bool get isAnalytics => kind == KhataReportKind.analytics;

  String get reportTitle {
    if (isAnalytics) return ledgerTitle;
    if (subLedgerName != null && subLedgerName!.trim().isNotEmpty) {
      return subLedgerName!.trim();
    }
    return ledgerTitle;
  }

  String get pdfFileName {
    if (isAnalytics) {
      final safe = (periodLabel ?? ledgerTitle)
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '_')
          .toLowerCase();
      return 'ledgify_reports_${safe.isEmpty ? 'report' : safe}';
    }

    final base = subLedgerName?.trim().isNotEmpty == true
        ? subLedgerName!.trim()
        : ledgerTitle.trim();
    final safe = base
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    return 'ledgify_khata_${safe.isEmpty ? 'report' : safe}';
  }
}
