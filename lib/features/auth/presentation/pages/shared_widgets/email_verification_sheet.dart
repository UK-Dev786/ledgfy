import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/widgets/my_button.dart';
import '../../../../../core/widgets/my_text.dart';

class EmailVerificationSheet extends StatelessWidget {
  final String email;
  final VoidCallback? onResend;

  const EmailVerificationSheet({
    super.key,
    required this.email,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.mark_email_unread_outlined,
            color: AppColors.primary,
            size: AppSizes.iconLg,
          ),
        ),
        SizedBox(height: context.h * 2.5),
        MyText(
          AppText.verifyEmailTitle,
          font: AppFont.inter,
          size: AppSizes.header3,
          color: AppColors.white,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
        SizedBox(height: context.h * 0.8),
        MyText(
          AppText.verifyEmailSubtitle,
          font: AppFont.sourceSans,
          size: AppSizes.subtitle,
          color: AppColors.textHint,
          align: TextAlign.center,
        ),
        SizedBox(height: context.h * 0.5),
        MyText(
          email,
          font: AppFont.inter,
          size: AppSizes.subtitle,
          color: AppColors.primary,
          weight: FontWeight.w600,
          align: TextAlign.center,
        ),
        SizedBox(height: context.h * 1.4),
        MyText(
          AppText.verifyEmailDescription,
          font: AppFont.sourceSans,
          size: AppSizes.body,
          color: AppColors.white,
          align: TextAlign.center,
          height: 1.45,
        ),
        SizedBox(height: context.h * 1),
        MyText(
          AppText.verifyEmailHint,
          font: AppFont.sourceSans,
          size: AppSizes.caption,
          color: AppColors.textHint,
          align: TextAlign.center,
          height: 1.4,
        ),
        SizedBox(height: context.h * 3.5),
        MyButton(
          text: AppText.goToLogin,
          onTap: () {
            context.go('/login');
          },
        ),
        SizedBox(height: context.h * 2.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyText(
              '${AppText.verificationEmailMissing} ',
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
            ),
            Bounce(
              duration: const Duration(milliseconds: 110),
              onTap: onResend,
              child: MyText(
                AppText.resendVerification,
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.primary,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
