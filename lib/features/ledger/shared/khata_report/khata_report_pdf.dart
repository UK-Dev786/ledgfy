import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/constants/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'khata_report_data.dart';

abstract final class KhataReportPdf {
  static Future<Uint8List> build(KhataReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        header: (context) => _brandHeader(
          headerLabel:
              data.isAnalytics ? AppText.reportsTitle : AppText.ledgerReportTitle,
        ),
        footer: (context) => _brandFooter(context),
        build: (context) =>
            data.isAnalytics ? _analyticsContent(data) : _ledgerContent(data),
      ),
    );

    return doc.save();
  }

  static List<pw.Widget> _ledgerContent(KhataReportData data) {
    final dateFormat = DateFormat('dd MMM yyyy, h:mm a');
    final entryDateFormat = DateFormat('dd MMM yyyy');

    return [
      pw.SizedBox(height: 8),
      pw.Text(
        data.reportTitle,
        style: pw.TextStyle(
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 6),
      pw.Text(
        data.ledgerTypeLabel,
        style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
      ),
      if (data.subLedgerName != null &&
          data.subLedgerName!.trim().isNotEmpty &&
          data.ledgerTitle.trim().toLowerCase() !=
              data.subLedgerName!.trim().toLowerCase()) ...[
        pw.SizedBox(height: 4),
        pw.Text(
          '${AppText.ledgerReportParentLedger}: ${data.ledgerTitle}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
      if (data.ledgerDescription != null &&
          data.ledgerDescription!.trim().isNotEmpty) ...[
        pw.SizedBox(height: 4),
        pw.Text(
          data.ledgerDescription!.trim(),
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
      if (data.subLedgerDescription != null &&
          data.subLedgerDescription!.trim().isNotEmpty) ...[
        pw.SizedBox(height: 4),
        pw.Text(
          data.subLedgerDescription!.trim(),
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
      pw.SizedBox(height: 4),
      pw.Text(
        '${AppText.ledgerReportGenerated}: ${dateFormat.format(data.generatedAt)}',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      ),
      pw.SizedBox(height: 18),
      pw.Text(
        AppText.ledgerReportSummary,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          for (final row in data.summaryRows)
            _summaryTableRow(row.label, row.amount),
          _summaryTableRow(
            data.balanceLabel,
            data.balance,
            bold: true,
          ),
        ],
      ),
      pw.SizedBox(height: 20),
      pw.Text(
        AppText.ledgerReportEntries,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      if (data.entries.isEmpty)
        pw.Text(
          AppText.ledgerReportNoEntries,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        )
      else
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.2),
            1: const pw.FlexColumnWidth(2.2),
            2: const pw.FlexColumnWidth(1.2),
            3: const pw.FlexColumnWidth(1.2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableHeaderCell(AppText.ledgerReportColDate),
                _tableHeaderCell(AppText.ledgerReportColDetails),
                _tableHeaderCell(AppText.ledgerReportColType),
                _tableHeaderCell(AppText.ledgerReportColAmount),
              ],
            ),
            for (final entry in data.entries)
              pw.TableRow(
                children: [
                  _tableCell(entryDateFormat.format(entry.date)),
                  _tableCell(entry.title),
                  _tableCell(entry.typeLabel),
                  _tableCell(
                    CurrencyFormatter.format(entry.amount),
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
          ],
        ),
    ];
  }

  static List<pw.Widget> _analyticsContent(KhataReportData data) {
    final dateFormat = DateFormat('dd MMM yyyy, h:mm a');
    final entryDateFormat = DateFormat('dd MMM yyyy, h:mm a');

    return [
      pw.SizedBox(height: 8),
      pw.Text(
        data.reportTitle,
        style: pw.TextStyle(
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 6),
      pw.Text(
        data.ledgerTypeLabel,
        style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        '${AppText.ledgerReportGenerated}: ${dateFormat.format(data.generatedAt)}',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      ),
      pw.SizedBox(height: 18),
      pw.Text(
        AppText.ledgerReportSummary,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          for (final row in data.summaryRows)
            _summaryTableRow(
              row.label,
              row.amount,
              bold: row.label == AppText.reportsNetPl,
            ),
        ],
      ),
      pw.SizedBox(height: 20),
      pw.Text(
        AppText.reportsPrintBreakdown,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      if (data.breakdownRows.isEmpty)
        pw.Text(
          AppText.reportsPeriodEmpty,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        )
      else
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.2),
            1: const pw.FlexColumnWidth(1.2),
            2: const pw.FlexColumnWidth(1.2),
            3: const pw.FlexColumnWidth(1.2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableHeaderCell('Label'),
                _tableHeaderCell(AppText.reportsIncome),
                _tableHeaderCell(AppText.reportsExpense),
                _tableHeaderCell(AppText.reportsPrintColNet),
              ],
            ),
            for (final row in data.breakdownRows)
              pw.TableRow(
                children: [
                  _tableCell(row.label),
                  _tableCell(
                    CurrencyFormatter.format(row.income),
                    align: pw.TextAlign.right,
                  ),
                  _tableCell(
                    CurrencyFormatter.format(row.expense),
                    align: pw.TextAlign.right,
                  ),
                  _tableCell(
                    CurrencyFormatter.format(row.net),
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
          ],
        ),
      if (data.partyRoleRows.isNotEmpty) ...[
        pw.SizedBox(height: 20),
        pw.Text(
          AppText.reportsPrintOutstanding,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            for (final row in data.partyRoleRows)
              _summaryTableRow(row.label, row.amount),
          ],
        ),
      ],
      pw.SizedBox(height: 20),
      pw.Text(
        AppText.reportsPrintTransactions,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      if (data.entries.isEmpty)
        pw.Text(
          AppText.reportsPrintNoTransactions,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        )
      else
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.3),
            1: const pw.FlexColumnWidth(1.1),
            2: const pw.FlexColumnWidth(1.8),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableHeaderCell(AppText.ledgerReportColDate),
                _tableHeaderCell(AppText.reportsPrintColLedger),
                _tableHeaderCell(AppText.ledgerReportColDetails),
                _tableHeaderCell(AppText.ledgerReportColType),
                _tableHeaderCell(AppText.ledgerReportColAmount),
              ],
            ),
            for (final entry in data.entries)
              pw.TableRow(
                children: [
                  _tableCell(entryDateFormat.format(entry.date)),
                  _tableCell(entry.ledgerName ?? ''),
                  _tableCell(entry.title),
                  _tableCell(entry.typeLabel),
                  _tableCell(
                    '${entry.isIncome == true ? '+' : '-'}${CurrencyFormatter.format(entry.amount)}',
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
          ],
        ),
    ];
  }

  static pw.Widget _brandHeader({required String headerLabel}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  AppText.appName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.Text(
                  AppText.appTagline,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Text(
              headerLabel,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey400, thickness: 0.8),
      ],
    );
  }

  static pw.Widget _brandFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400, thickness: 0.8),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              AppText.ledgerReportFooter,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.Text(
              '${AppText.ledgerReportPage} ${context.pageNumber} / ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _summaryTableRow(
    String label,
    double amount, {
    bool bold = false,
  }) {
    final style = pw.TextStyle(
      fontSize: 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label, style: style),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            CurrencyFormatter.format(amount),
            style: style,
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _tableCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
        textAlign: align,
      ),
    );
  }
}
