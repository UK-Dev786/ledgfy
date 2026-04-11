import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';

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
                    _TabSwitcher(currentTab: _currentTab, onSwitch: _switchTab),

                    SizedBox(height: context.h * 3),

                    // ── Swipeable form pages ─────────────────────────────
                    SizedBox(
                      height: context.h * 26,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _currentTab = i),
                        children: [
                          _PhoneForm(controller: _phoneController),
                          _EmailForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.h * 2),

                    // ── Divider ──────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.textHint.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w * 3,
                          ),
                          child: MyText(
                            'or continue with',
                            font: AppFont.sourceSans,
                            size: AppSizes.caption,
                            color: AppColors.textHint,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.textHint.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.h * 2),

                    // ── Biometric ─────────────────────────────────────────
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

// ── Tab Switcher ──────────────────────────────────────────────────────────────

class _TabSwitcher extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSwitch;

  const _TabSwitcher({required this.currentTab, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusMd,
      blur: 30,
      height: 45,
      padding: EdgeInsetsGeometry.zero,
      child: Row(
        children: [
          _TabItem(
            label: 'Phone',
            icon: Icons.phone_outlined,
            selected: currentTab == 0,
            onTap: () => onSwitch(0),
          ),
          _TabItem(
            label: 'Email',
            icon: Icons.email_outlined,
            selected: currentTab == 1,
            onTap: () => onSwitch(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              right: selected ? Radius.circular(12) : Radius.zero,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppSizes.iconSm,
                color: selected ? AppColors.white : AppColors.textHint,
              ),
              const SizedBox(width: 6),
              MyText(
                label,
                font: AppFont.inter,
                size: AppSizes.subtitle,
                color: selected ? AppColors.white : AppColors.textHint,
                weight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Phone form ────────────────────────────────────────────────────────────────

class _PhoneForm extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
          hintText: '+92 300 1234567',
          labelText: 'Phone Number',
          controller: controller,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: context.h * 2.5),
        MyButton(text: 'Send OTP', onTap: () {}),
      ],
    );
  }
}

// ── Email form ────────────────────────────────────────────────────────────────

class _EmailForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _EmailForm({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
          hintText: 'you@example.com',
          labelText: 'Email Address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: context.h * 1.5),
        MyTextField(
          hintText: '••••••••',
          labelText: 'Password',
          controller: passwordController,
          obscure: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
        SizedBox(height: context.h * 2.5),
        MyButton(text: 'Sign In', onTap: () {}),
      ],
    );
  }
}
