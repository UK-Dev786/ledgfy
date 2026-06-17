import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../models/ledger_item.dart';
import '../ledger_page_route.dart';
import 'khata_report_builder.dart';
import 'khata_report_data.dart';
import 'khata_report_pdf.dart';

class KhataReportPage extends StatelessWidget {
  final KhataReportData data;

  const KhataReportPage({super.key, required this.data});

  static void open(
    BuildContext context, {
    required LedgerItem ledger,
    String? partyName,
  }) {
    Navigator.of(context).push<void>(
      ledgerPageRoute(
        KhataReportPage(
          data: KhataReportBuilder.fromLedger(ledger, partyName: partyName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyText(
                AppText.ledgerReportTitle,
                font: AppFont.inter,
                size: AppSizes.subtitle,
                color: AppColors.white,
                weight: FontWeight.w700,
              ),
              MyText(
                '${AppText.appName} · ${AppText.appTagline}',
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
        body: PdfPreview(
          maxPageWidth: 680,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          pdfFileName: '${data.pdfFileName}.pdf',
          shareActionExtraBody: AppText.ledgerReportShareBody,
          shareActionExtraSubject:
              '${AppText.appName} — ${data.reportTitle}',
          build: (_) => KhataReportPdf.build(data),
        ),
      ),
    );
  }
}
