import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledgify/core/widgets/app_background.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../../../core/widgets/mirror_card.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 6,
              vertical: context.h * 6,
            ),
            child: Center(
              child: MirrorCard(
                tint: MirrorCardTint.dark,
                borderRadius: AppSizes.radiusLg,
                blur: 30,
                padding: EdgeInsets.fromLTRB(
                  context.w * 5,
                  context.h * 3,
                  context.w * 5,
                  context.h * 3,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business,
                      size: AppSizes.iconXl,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: context.h * 4),
                    MyText(
                      'Welcome to Ledgify',
                      font: AppFont.inter,
                      size: AppSizes.header3,
                      color: AppColors.white,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: context.h * 1),
                    MyText(
                      'Sign in to your account',
                      font: AppFont.sourceSans,
                      size: AppSizes.subtitle,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: context.h * 6),
                    MyTextField(
                      hintText: '+92 300 1234567',
                      labelText: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: context.h * 3),
                    MyButton(text: 'Send OTP', onTap: () {}),
                    SizedBox(height: context.h * 2),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.textHint.withValues(alpha: 0.4),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w * 4,
                          ),
                          child: MyText(
                            'or',
                            font: AppFont.sourceSans,
                            size: AppSizes.subtitle,
                            color: AppColors.textHint,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.textHint.withValues(alpha: 0.4),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h * 2),
                    MyButton(
                      text: 'Use Biometric',
                      onTap: () {},
                      variant: MyButtonVariant.outlined,
                      icon: const Icon(
                        Icons.fingerprint,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
