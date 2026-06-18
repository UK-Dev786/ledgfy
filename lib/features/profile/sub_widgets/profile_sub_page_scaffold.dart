import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/rounded_button.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../ledger/shared/ledger_page_route.dart';

class ProfileSubPageScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const ProfileSubPageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  static Future<T?> open<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(ledgerPageRoute(page));
  }

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.sm,
                  AppSizes.md,
                  AppSizes.md,
                ),
                child: Row(
                  children: [
                    RoundedButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icons.arrow_back_rounded,
                      size: 44,
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            title,
                            font: AppFont.inter,
                            size: AppSizes.title,
                            color: AppColors.white,
                            weight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            MyText(
                              subtitle!,
                              font: AppFont.sourceSans,
                              size: AppSizes.caption,
                              color: AppColors.textHint,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
