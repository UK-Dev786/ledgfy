class KhataReportSummaryRow {
  final String label;
  final double amount;

  const KhataReportSummaryRow({
    required this.label,
    required this.amount,
  });
}

class KhataReportEntryRow {
  final DateTime date;
  final String title;
  final String typeLabel;
  final double amount;

  const KhataReportEntryRow({
    required this.date,
    required this.title,
    required this.typeLabel,
    required this.amount,
  });
}

class KhataReportData {
  final String ledgerTitle;
  final String? ledgerDescription;
  final String ledgerTypeLabel;
  final String? subLedgerName;
  final String? subLedgerDescription;
  final double openingBalance;
  final bool showOpeningBalance;
  final List<KhataReportSummaryRow> summaryRows;
  final double balance;
  final String balanceLabel;
  final List<KhataReportEntryRow> entries;
  final DateTime generatedAt;

  const KhataReportData({
    required this.ledgerTitle,
    this.ledgerDescription,
    required this.ledgerTypeLabel,
    this.subLedgerName,
    this.subLedgerDescription,
    this.openingBalance = 0,
    this.showOpeningBalance = false,
    required this.summaryRows,
    required this.balance,
    required this.balanceLabel,
    required this.entries,
    required this.generatedAt,
  });

  String get reportTitle {
    if (subLedgerName != null && subLedgerName!.trim().isNotEmpty) {
      return subLedgerName!.trim();
    }
    return ledgerTitle;
  }

  String get pdfFileName {
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
