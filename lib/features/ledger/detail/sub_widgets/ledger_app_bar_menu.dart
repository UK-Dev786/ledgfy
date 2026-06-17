import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import 'ledger_detail_app_bar.dart';

abstract final class LedgerAppBarMenu {
  static Future<String?> show(
    BuildContext context, {
    required List<LedgerAppBarMenuOption> options,
  }) {
    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.sm,
                    right: AppSizes.md,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: MyCard(
                      tint: MyCardTint.dark,
                      borderRadius: AppSizes.radiusMd,
                      blur: 24,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.xs,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options
                            .map((option) => _MenuRow(option: option))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuRow extends StatelessWidget {
  final LedgerAppBarMenuOption option;

  const _MenuRow({required this.option});

  @override
  Widget build(BuildContext context) {
    final color = option.color ?? AppColors.white;

    return InkWell(
      onTap: () => Navigator.pop(context, option.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm + 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              color: option.color ?? AppColors.textHint,
              size: AppSizes.iconSm,
            ),
            const SizedBox(width: AppSizes.sm),
            MyText(
              option.label,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: color,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
