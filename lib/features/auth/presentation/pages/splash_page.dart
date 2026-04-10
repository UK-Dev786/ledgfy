import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/my_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1017),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppBackgroundGradients.splashGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                'Ledgify',
                font: AppFont.inter,
                size: AppSizes.header1,
                color: AppColors.white,
                weight: FontWeight.bold,
                letterSpacing: -1,
              ),
              SizedBox(height: context.h * 1),
              MyText(
                'Ledger Simplify',
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                weight: FontWeight.w400,
              ),
              SizedBox(height: context.h * 7),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
