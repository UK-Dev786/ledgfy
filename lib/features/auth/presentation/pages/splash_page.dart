import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../di/auth_providers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _minDelayComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _minDelayComplete = true);
    });
  }

  void _navigateIfReady(AsyncValue<dynamic> authState) {
    if (!_minDelayComplete) return;
    if (!authState.hasValue) return;

    final user = authState.value;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    ref.listen(authStateChangesProvider, (previous, next) {
      _navigateIfReady(next);
    });

    if (_minDelayComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateIfReady(authState);
      });
    }

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
                AppText.appName,
                font: AppFont.inter,
                size: AppSizes.header1,
                color: AppColors.white,
                weight: FontWeight.bold,
                letterSpacing: -1,
              ),
              SizedBox(height: context.h * 1),
              MyText(
                AppText.appTagline,
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
