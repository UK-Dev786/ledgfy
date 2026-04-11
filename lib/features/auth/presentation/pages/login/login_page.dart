import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/my_button.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';
import '../../../../../core/widgets/my_text_field.dart';
import '../../../../../core/widgets/themed_gradient_bg.dart';
import '../shared_widgets/tab_item.dart';
import 'sub_widgets/email_form.dart';
import 'sub_widgets/phone_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pageController = PageController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _currentTab = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() => _currentTab = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        // ── Logo ────────────────────────────────────────────
                        Icon(
                          Icons.business,
                          size: AppSizes.iconXl,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: context.h * 2),
                        MyText(
                          'Welcome to Ledgify',
                          font: AppFont.inter,
                          size: AppSizes.header3,
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: context.h * 0.6),
                        MyText(
                          'Sign in to your account',
                          font: AppFont.sourceSans,
                          size: AppSizes.subtitle,
                          color: AppColors.textHint,
                        ),

                        SizedBox(height: context.h * 3),

                        // ── Tab switcher ─────────────────────────────────────
                        TabSwitcher(
                          currentTab: _currentTab,
                          onSwitch: _switchTab,
                        ),

                        SizedBox(height: context.h * 3),

                        // ── Swipeable form pages ─────────────────────────────
                        SizedBox(
                          height: context.h * 30,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (i) =>
                                setState(() => _currentTab = i),
                            children: [
                              PhoneForm(controller: _phoneController),
                              EmailForm(
                                emailController: _emailController,
                                passwordController: _passwordController,
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: context.h * 2),

                        // ── Divider ──────────────────────────────────────────
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         color: AppColors.textHint.withValues(alpha: 0.3),
                        //         thickness: 1,
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(
                        //         horizontal: context.w * 3,
                        //       ),
                        //       child: MyText(
                        //         'or continue with',
                        //         font: AppFont.sourceSans,
                        //         size: AppSizes.caption,
                        //         color: AppColors.textHint,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Divider(
                        //         color: AppColors.textHint.withValues(alpha: 0.3),
                        //         thickness: 1,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: context.h * 2),

                        // ── Biometric ─────────────────────────────────────────
                        // MyButton(
                        //   text: 'Use Biometric',
                        //   onTap: () {},
                        //   variant: MyButtonVariant.outlined,
                        //   icon: const Icon(
                        //     Icons.fingerprint,
                        //     color: AppColors.primary,
                        //   ),
                        // ),
                      ],
                    ),
                  ), // MyCard
                ), // Center
              ), // Padding
            ), // ConstrainedBox
          ), // SingleChildScrollView
        ), // SafeArea
      ), // Scaffold
    ); // ThemedGradientBackground
  }
}
