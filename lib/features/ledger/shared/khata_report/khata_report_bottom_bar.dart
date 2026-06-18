import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import 'khata_report_data.dart';
import 'khata_report_pdf.dart';

class KhataReportBottomBar extends StatelessWidget {
  final KhataReportData data;

  const KhataReportBottomBar({super.key, required this.data});

  static Future<void> printPdf(KhataReportData data) {
    return Printing.layoutPdf(
      onLayout: (_) => KhataReportPdf.build(data),
      name: data.pdfFileName,
    );
  }

  Future<void> _print() => printPdf(data);

  Future<void> _share() async {
    await Printing.sharePdf(
      bytes: await KhataReportPdf.build(data),
      filename: '${data.pdfFileName}.pdf',
      subject: '${AppText.appName} — ${data.reportTitle}',
      body: AppText.ledgerReportShareBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.md,
      ),
      child: MyCard(
        tint: MyCardTint.dark,
        borderRadius: AppSizes.radiusFull,
        blur: 30,
        padding: const EdgeInsets.all(AppSizes.xs + 2),
        child: Row(
          children: [
            Expanded(
              child: _ActionTile(
                icon: Icons.print_rounded,
                label: AppText.ledgerReportPrint,
                onTap: _print,
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: AppColors.divider.withValues(alpha: 0.12),
            ),
            Expanded(
              child: _ActionTile(
                icon: Icons.ios_share_rounded,
                label: AppText.ledgerReportShare,
                onTap: _share,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: AppSizes.iconSm + 2),
              const SizedBox(width: AppSizes.sm),
              MyText(
                label,
                font: AppFont.inter,
                size: AppSizes.subtitle,
                color: AppColors.white,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
