import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_entrance_animation.dart';

class HomeGreetingHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;

  const HomeGreetingHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 12 && hour <= 17) return AppText.homeGreetingAfternoon;
    if (hour >= 18) return AppText.homeGreetingEvening;
    return AppText.homeGreetingMorning;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          AppSizes.sm,
        ),
        child: SharedEntranceAnimation(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      '$_greeting,',
                      font: AppFont.sourceSans,
                      size: AppSizes.subtitle,
                      color: AppColors.textHint,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    MyText(
                      userName,
                      font: AppFont.inter,
                      size: AppSizes.header2,
                      color: AppColors.white,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onProfileTap,
                    child: CircleAvatar(
                      radius: AppSizes.lg,
                      backgroundColor: AppColors.primaryDark.withValues(
                        alpha: 0.2,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primary,
                        size: AppSizes.iconMd,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  MyText(
                    DateFormat('MMM yyyy').format(DateTime.now()),
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
