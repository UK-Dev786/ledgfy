import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/features/auth/presentation/pages/signup/sub_widgets/signup_email_form.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/errors/auth_exception_mapper.dart';
import '../../../../../core/extensions/popup_extensions.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';
import '../../../../../core/widgets/themed_gradient_bg.dart';
import '../../../../../di/auth_providers.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/signup_viewmodel.dart';
import '../shared_widgets/auth_social_section.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(loginViewModelProvider.notifier).signInWithGoogle();
  }

  Future<void> _showVerificationDialog() async {
    if (!mounted) return;
    await context.popSignUpVerification(
      onLogin: () => context.go('/login'),
      onResend: () async {
        try {
          await ref.read(authRepositoryProvider).resendVerificationEmail(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupViewModelProvider);
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen(signupViewModelProvider, (previous, next) async {
      if (next.status.hasError) {
        context.popMsg(
          AuthExceptionMapper.message(next.status.error!),
          icon: Icons.error_outline_rounded,
          color: AppColors.primary,
        );
        ref.read(signupViewModelProvider.notifier).reset();
      } else if (!next.status.isLoading &&
          next.status.hasValue &&
          previous?.status.isLoading == true) {
        await _showVerificationDialog();
        ref.read(signupViewModelProvider.notifier).reset();
      }
    });

    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.status.hasError) {
        context.popMsg(
          AuthExceptionMapper.message(next.status.error!),
          icon: Icons.error_outline_rounded,
          color: AppColors.primary,
        );
        ref.read(loginViewModelProvider.notifier).reset();
      } else if (!next.status.isLoading &&
          next.status.hasValue &&
          previous?.status.isLoading == true) {
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
                  horizontal: context.w * 5,
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
                          AppText.signupWelcome,
                          font: AppFont.inter,
                          size: AppSizes.header3,
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: context.h * 0.6),
                        MyText(
                          AppText.signupSubtitle,
                          font: AppFont.sourceSans,
                          size: AppSizes.subtitle,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: context.h * 3),
                        SignupEmailForm(
                          nameController: _nameController,
                          usernameController: _usernameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          loading: signupState.isEmailLoading,
                          onSignUp: (params) => ref
                              .read(signupViewModelProvider.notifier)
                              .signUp(params),
                        ),
                        AuthSocialSection(
                          googleLoading: loginState.isGoogleLoading,
                          onGoogleTap: signupState.isLoading ||
                                  loginState.isLoading
                              ? null
                              : _signInWithGoogle,
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
                                    "${AppText.alreadyHaveAccount} ",
                                    font: AppFont.sourceSans,
                                    size: AppSizes.caption,
                                    color: AppColors.white,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Bounce(
                                    onTap: () => context.go('/login'),
                                    child: MyText(
                                      AppText.loginHere,
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
