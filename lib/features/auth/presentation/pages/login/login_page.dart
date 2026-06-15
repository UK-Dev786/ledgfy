import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/errors/auth_exception_mapper.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/extensions/popup_extensions.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';
import '../../../../../core/widgets/themed_gradient_bg.dart';
import '../../../../../di/auth_providers.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../shared_widgets/auth_social_section.dart';
import 'sub_widgets/email_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(loginViewModelProvider.notifier).signInWithGoogle();
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await ref
          .read(authRepositoryProvider)
          .resendVerificationEmail(
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (!mounted) return;
      await context.popSuccess(AppText.verificationResent);
    } catch (error) {
      if (!mounted) return;
      await context.popMsg(
        AuthExceptionMapper.message(error),
        icon: Icons.error_outline_rounded,
        color: AppColors.primary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final isLoading = loginState.isLoading;

    ref.listen(loginViewModelProvider, (previous, next) async {
      if (next.hasError) {
        final error = next.error!;
        if (error is ValidationException &&
            error.message == AppText.authEmailNotVerified) {
          await context.popEmailVerificationRequired(
            onResend: () async {
              await _resendVerificationEmail();
            },
          );
        } else {
          context.popMsg(
            AuthExceptionMapper.message(error),
            icon: Icons.error_outline_rounded,
            color: AppColors.primary,
          );
        }
        ref.read(loginViewModelProvider.notifier).reset();
      } else if (!next.isLoading &&
          next.hasValue &&
          previous?.isLoading == true) {
        context.go('/home');
        ref.read(loginViewModelProvider.notifier).reset();
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.business,
                          size: AppSizes.iconXl,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: context.h * 2),
                        MyText(
                          AppText.loginWelcome,
                          font: AppFont.inter,
                          size: AppSizes.header3,
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: context.h * 0.6),
                        MyText(
                          AppText.loginSubtitle,
                          font: AppFont.sourceSans,
                          size: AppSizes.subtitle,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: context.h * 3),
                        EmailForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          loading: isLoading,
                          onSignIn: (email, password) => ref
                              .read(loginViewModelProvider.notifier)
                              .login(email, password),
                        ),
                        AuthSocialSection(
                          onGoogleTap: isLoading ? null : _signInWithGoogle,
                        ),
                        SizedBox(height: context.h * 2),
                        Divider(
                          color: AppColors.textHint.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                        SizedBox(height: context.h * 2),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: MyText(
                                    "${AppText.doNotHaveAccount} ",
                                    font: AppFont.sourceSans,
                                    size: AppSizes.caption,
                                    color: AppColors.white,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Bounce(
                                    onTap: () => context.go('/signup'),
                                    child: MyText(
                                      AppText.signupHere,
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
