import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';

abstract final class LedgerDeleteDialog {
  static Future<bool> show(
    BuildContext context, {
    String title = AppText.ledgerDeleteTitle,
    String message = AppText.ledgerDeleteMessage,
    String confirmText = AppText.ledgerDeleteConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ctx.w * 6),
          child: Material(
            color: Colors.transparent,
            child: MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusLg,
              blur: 30,
              padding: EdgeInsets.fromLTRB(
                ctx.w * 5,
                ctx.h * 3,
                ctx.w * 5,
                ctx.h * 3,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: AppSizes.iconXl,
                  ),
                  SizedBox(height: ctx.h * 2),
                  MyText(
                    title,
                    font: AppFont.inter,
                    size: AppSizes.header3,
                    color: AppColors.white,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: ctx.h * 1.5),
                  MyText(
                    message,
                    font: AppFont.sourceSans,
                    size: AppSizes.body,
                    color: AppColors.textHint,
                    align: TextAlign.center,
                    height: 1.45,
                  ),
                  SizedBox(height: ctx.h * 3),
                  MyButton(
                    text: confirmText,
                    color: AppColors.error,
                    onTap: () => Navigator.pop(ctx, true),
                  ),
                  SizedBox(height: ctx.h * 1.5),
                  MyButton(
                    text: AppText.ledgerDeleteCancel,
                    color: AppColors.textHint,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return confirmed ?? false;
  }
}
