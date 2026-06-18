import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.xs,
            bottom: AppSizes.sm,
          ),
          child: MyText(
            title,
            font: AppFont.inter,
            size: AppSizes.caption,
            color: AppColors.textHint,
            weight: FontWeight.w600,
          ),
        ),
        MyCard(
          tint: MyCardTint.dark,
          borderRadius: AppSizes.radiusLg,
          blur: 24,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: AppSizes.lg + AppSizes.iconMd + AppSizes.md,
                    color: AppColors.divider.withValues(alpha: 0.12),
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  title,
                  font: AppFont.sourceSans,
                  size: AppSizes.body,
                  color: AppColors.white,
                  weight: FontWeight.w600,
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
          if (trailing != null)
            trailing!
          else if (showChevron && onTap != null)
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: AppSizes.iconMd,
            ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: content,
      ),
    );
  }
}
