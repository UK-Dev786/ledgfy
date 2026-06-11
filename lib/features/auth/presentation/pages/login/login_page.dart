import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';
import '../../../../../core/widgets/themed_gradient_bg.dart';
import '../shared_widgets/auth_social_section.dart';
// import '../shared_widgets/tab_item.dart';
import 'sub_widgets/email_form.dart';
// import 'sub_widgets/phone_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // int _currentTab = 0;

  @override
  void dispose() {
    // _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _switchTab(int index) {
  //   setState(() => _currentTab = index);
  // }

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

                        // Phone auth disabled until billing is enabled.
                        // TabSwitcher(
                        //   currentTab: _currentTab,
                        //   onSwitch: _switchTab,
                        // ),
                        // SizedBox(height: context.h * 3),
                        // AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 320),
                        //   switchInCurve: Curves.easeInOut,
                        //   switchOutCurve: Curves.easeInOut,
                        //   transitionBuilder: (child, animation) {
                        //     final isPhone = child.key == const ValueKey(0);
                        //     final offset = isPhone
                        //         ? const Offset(-1, 0)
                        //         : const Offset(1, 0);
                        //     return SlideTransition(
                        //       position: Tween(
                        //         begin: offset,
                        //         end: Offset.zero,
                        //       ).animate(animation),
                        //       child: FadeTransition(
                        //         opacity: animation,
                        //         child: child,
                        //       ),
                        //     );
                        //   },
                        //   child: _currentTab == 0
                        //       ? PhoneForm(
                        //           key: const ValueKey(0),
                        //           controller: _phoneController,
                        //         )
                        //       : EmailForm(
                        //           key: const ValueKey(1),
                        //           emailController: _emailController,
                        //           passwordController: _passwordController,
                        //         ),
                        // ),
                        EmailForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),

                        const AuthSocialSection(
                          // TODO: wire Google sign-in
                          onGoogleTap: null,
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
