import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/rounded_button.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../models/ledger_item.dart';
import '../ledger_page_route.dart';
import 'khata_report_bottom_bar.dart';
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
    openWithData(
      context,
      data: KhataReportBuilder.fromLedger(ledger, partyName: partyName),
    );
  }

  static void openWithData(
    BuildContext context, {
    required KhataReportData data,
  }) {
    Navigator.of(context).push<void>(
      ledgerPageRoute(KhataReportPage(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _KhataReportAppBar(data: data),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    0,
                    AppSizes.lg,
                    AppSizes.sm,
                  ),
                  child: MyCard(
                    tint: MyCardTint.dark,
                    borderRadius: AppSizes.radiusLg,
                    blur: 28,
                    padding: const EdgeInsets.all(AppSizes.sm),
                    child: PdfPreview(
                      maxPageWidth: 520,
                      canChangeOrientation: false,
                      canChangePageFormat: false,
                      canDebug: false,
                      useActions: false,
                      pdfFileName: '${data.pdfFileName}.pdf',
                      scrollViewDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      pdfPreviewPageDecoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.22),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      previewPageMargin: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.md,
                      ),
                      padding: EdgeInsets.zero,
                      loadingWidget: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2.5,
                        ),
                      ),
                      build: (_) => KhataReportPdf.build(data),
                    ),
                  ),
                ),
              ),
              KhataReportBottomBar(data: data),
            ],
          ),
        ),
      ),
    );
  }
}

class _KhataReportAppBar extends StatelessWidget {
  final KhataReportData data;

  const _KhataReportAppBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final headerTitle =
        data.isAnalytics ? AppText.reportsPrintTitle : AppText.ledgerReportTitle;
    final subtitle = data.isAnalytics
        ? '${data.periodLabel} · ${data.periodRangeLabel}'
        : data.reportTitle;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.md,
      ),
      child: Row(
        children: [
          RoundedButton(
            onTap: () => Navigator.of(context).pop(),
            icon: Icons.arrow_back_rounded,
            size: 44,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  headerTitle,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                MyText(
                  subtitle,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                MyText(
                  '${AppText.appName} · ${AppText.appTagline}',
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.primary.withValues(alpha: 0.85),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
