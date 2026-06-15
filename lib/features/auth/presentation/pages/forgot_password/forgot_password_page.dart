import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/errors/auth_exception_mapper.dart';
import '../../../../../core/extensions/popup_extensions.dart';
import '../../../../../core/utils/app_validators.dart';
import '../../../../../core/widgets/my_button.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';
import '../../../../../core/widgets/my_text_field.dart';
import '../../../../../core/widgets/themed_gradient_bg.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(forgotPasswordViewModelProvider.notifier)
        .sendResetLink(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordViewModelProvider);
    final isLoading = forgotPasswordState.isLoading;

    ref.listen(forgotPasswordViewModelProvider, (previous, next) async {
      if (next.hasError) {
        context.popMsg(
          AuthExceptionMapper.message(next.error!),
          icon: Icons.error_outline_rounded,
          color: AppColors.primary,
        );
        ref.read(forgotPasswordViewModelProvider.notifier).reset();
      } else if (!next.isLoading &&
          next.hasValue &&
          previous?.isLoading == true) {
        await context.popSuccess(
          AppText.passwordResetSentMessage,
          title: AppText.passwordResetSentTitle,
          onOk: () => context.go('/login'),
        );
        ref.read(forgotPasswordViewModelProvider.notifier).reset();
      }
    });

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
                      context.h * 3,
                      context.w * 5,
                      context.h * 3,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_reset_rounded,
                            size: AppSizes.iconXl,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: context.h * 2),
                          MyText(
                            AppText.forgotPasswordTitle,
                            font: AppFont.inter,
                            size: AppSizes.header3,
                            color: AppColors.white,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: context.h * 0.6),
                          MyText(
                            AppText.forgotPasswordSubtitle,
                            font: AppFont.sourceSans,
                            size: AppSizes.subtitle,
                            color: AppColors.textHint,
                            align: TextAlign.center,
                            height: 1.4,
                          ),
                          SizedBox(height: context.h * 3),
                          MyTextField(
                            title: AppText.emailLabel,
                            hintText: AppText.emailHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.primary,
                            ),
                            validator: AppValidators.email,
                          ),
                          SizedBox(height: context.h * 2.5),
                          MyButton(
                            text: AppText.sendResetLink,
                            loading: isLoading,
                            onTap: _sendResetLink,
                          ),
                          SizedBox(height: context.h * 2.5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Bounce(
                              onTap: () => context.go('/login'),
                              child: MyText(
                                AppText.backToLogin,
                                font: AppFont.sourceSans,
                                size: AppSizes.caption,
                                color: AppColors.primary,
                                weight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }
}
