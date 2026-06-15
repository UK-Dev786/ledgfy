import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text.dart';
import '../widgets/my_button.dart';
import '../widgets/my_card.dart';
import '../widgets/my_text.dart';
import 'context_extensions.dart';

/// Center popups using [MyCard] + [MyText] — matches login/signup styling.
extension AppPopup on BuildContext {
  Future<void> popMsg(
    String message, {
    Color color = AppColors.primary,
    IconData icon = Icons.info_outline_rounded,
    String? title,
    String? okText,
    VoidCallback? onOk,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 6),
          child: Material(
            color: Colors.transparent,
            child: MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusLg,
              blur: 30,
              padding: EdgeInsets.fromLTRB(w * 5, h * 3, w * 5, h * 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: AppSizes.iconXl),
                  SizedBox(height: h * 2),
                  if (title != null) ...[
                    MyText(
                      title,
                      font: AppFont.inter,
                      size: AppSizes.header3,
                      color: AppColors.white,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                    SizedBox(height: h * 1),
                  ],
                  MyText(
                    message,
                    font: AppFont.sourceSans,
                    size: AppSizes.body,
                    color: AppColors.textHint,
                    align: TextAlign.center,
                    height: 1.45,
                  ),
                  SizedBox(height: h * 3),
                  MyButton(
                    text: okText ?? AppText.dialogOk,
                    color: color,
                    onTap: () {
                      Navigator.pop(ctx);
                      onOk?.call();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> popSuccess(String message, {String? title, VoidCallback? onOk}) =>
      popMsg(
        message,
        icon: Icons.check_circle_outline_rounded,
        title: title ?? AppText.dialogSuccessTitle,
        onOk: onOk,
      );

  /// Shown after signup — verify email message, login button, resend link.
  Future<void> popSignUpVerification({
    required VoidCallback onLogin,
    required Future<void> Function() onResend,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 6),
          child: Material(
            color: Colors.transparent,
            child: MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusLg,
              blur: 30,
              padding: EdgeInsets.fromLTRB(w * 5, h * 3, w * 5, h * 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    color: AppColors.primary,
                    size: AppSizes.iconXl,
                  ),
                  SizedBox(height: h * 2),
                  MyText(
                    AppText.signUpVerifyPopupTitle,
                    font: AppFont.inter,
                    size: AppSizes.header3,
                    color: AppColors.white,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: h * 1),
                  MyText(
                    AppText.signUpVerifyPopupMessage,
                    font: AppFont.sourceSans,
                    size: AppSizes.body,
                    color: AppColors.textHint,
                    align: TextAlign.center,
                    height: 1.45,
                  ),
                  SizedBox(height: h * 3),
                  MyButton(
                    text: AppText.goToLogin,
                    onTap: () {
                      Navigator.pop(ctx);
                      onLogin();
                    },
                  ),
                  SizedBox(height: h * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '${AppText.verificationNotReceived} ',
                        font: AppFont.sourceSans,
                        size: AppSizes.caption,
                        color: AppColors.textHint,
                      ),
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await onResend();
                        },
                        child: MyText(
                          AppText.resendHere,
                          font: AppFont.sourceSans,
                          size: AppSizes.caption,
                          color: AppColors.primary,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shown on login when email is not verified yet.
  Future<void> popEmailVerificationRequired({
    required Future<void> Function() onResend,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 6),
          child: Material(
            color: Colors.transparent,
            child: MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusLg,
              blur: 30,
              padding: EdgeInsets.fromLTRB(w * 5, h * 3, w * 5, h * 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    color: AppColors.primary,
                    size: AppSizes.iconXl,
                  ),
                  SizedBox(height: h * 2),
                  MyText(
                    AppText.authEmailNotVerified,
                    font: AppFont.sourceSans,
                    size: AppSizes.body,
                    color: AppColors.textHint,
                    align: TextAlign.center,
                    height: 1.45,
                  ),
                  SizedBox(height: h * 3),
                  MyButton(
                    text: AppText.dialogOk,
                    onTap: () => Navigator.pop(ctx),
                  ),
                  SizedBox(height: h * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        '${AppText.verificationNotReceived} ',
                        font: AppFont.sourceSans,
                        size: AppSizes.caption,
                        color: AppColors.textHint,
                      ),
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await onResend();
                        },
                        child: MyText(
                          AppText.resendHere,
                          font: AppFont.sourceSans,
                          size: AppSizes.caption,
                          color: AppColors.primary,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
