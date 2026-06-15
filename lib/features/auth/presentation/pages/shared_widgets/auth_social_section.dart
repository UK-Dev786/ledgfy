import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../core/widgets/my_text.dart';
import 'google_sign_in_card.dart';

/// "Or continue with" + Google logo card — UI only.
class AuthSocialSection extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final bool googleLoading;

  const AuthSocialSection({
    super.key,
    this.onGoogleTap,
    this.googleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: context.h * 2),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.textHint.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w * 3),
              child: MyText(
                AppText.orContinueWith,
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
        SizedBox(height: context.h * 1.1),
        Center(
          child: GoogleSignInCard(
            onTap: onGoogleTap,
            loading: googleLoading,
          ),
        ),
      ],
    );
  }
}
