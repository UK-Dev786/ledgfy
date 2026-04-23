import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_card.dart';
import '../../../../../../core/widgets/my_text.dart';
import '../../../../../../core/widgets/themed_gradient_bg.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const _length = 6;
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verify() {
    if (_formKey.currentState!.validate()) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 46,
      height: 54,
      textStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent, width: 1.5),
      ),
    );

    return ThemedGradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: context.screenHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w * 6,
                  vertical: context.h * 5,
                ),
                child: Center(
                  child: MyCard(
                    tint: MyCardTint.dark,
                    borderRadius: AppSizes.radiusLg,
                    blur: 30,
                    padding: EdgeInsets.fromLTRB(
                      context.w * 5,
                      context.h * 4,
                      context.w * 5,
                      context.h * 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Icon ─────────────────────────────────────────────
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
                            Icons.phone_android_outlined,
                            color: AppColors.primary,
                            size: AppSizes.iconLg,
                          ),
                        ),

                        SizedBox(height: context.h * 2.5),

                        MyText(
                          AppText.otpTitle,
                          font: AppFont.inter,
                          size: AppSizes.header3,
                          color: AppColors.white,
                          weight: FontWeight.bold,
                          align: TextAlign.center,
                        ),

                        SizedBox(height: context.h * 0.8),

                        MyText(
                          AppText.otpSubtitle,
                          font: AppFont.sourceSans,
                          size: AppSizes.subtitle,
                          color: AppColors.textHint,
                          align: TextAlign.center,
                        ),

                        SizedBox(height: context.h * 0.5),

                        MyText(
                          widget.phoneNumber,
                          font: AppFont.inter,
                          size: AppSizes.subtitle,
                          color: AppColors.primary,
                          weight: FontWeight.w600,
                          align: TextAlign.center,
                        ),

                        SizedBox(height: context.h * 4),

                        // ── Pinput ────────────────────────────────────────────
                        Form(
                          key: _formKey,
                          child: Pinput(
                            length: _length,
                            controller: _pinController,
                            defaultPinTheme: defaultTheme,
                            focusedPinTheme: focusedTheme,
                            errorPinTheme: errorTheme,
                            separatorBuilder: (_) => const SizedBox(width: 8),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.length < _length) {
                                return AppText.otpRequired;
                              }
                              return null;
                            },
                            errorTextStyle: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontFamily: 'SourceSans3',
                            ),
                          ),
                        ),

                        SizedBox(height: context.h * 4),

                        // ── Verify button ─────────────────────────────────────
                        MyButton(text: AppText.otpVerify, onTap: _verify),

                        SizedBox(height: context.h * 2.5),

                        // ── Resend ────────────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyText(
                              "Didn't receive the code? ",
                              font: AppFont.sourceSans,
                              size: AppSizes.caption,
                              color: AppColors.textHint,
                            ),
                            Bounce(
                              duration: const Duration(milliseconds: 110),
                              onTap: () {
                                // TODO: resend OTP
                              },
                              child: MyText(
                                AppText.otpResend,
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
          ),
        ),
      ),
    );
  }
}
