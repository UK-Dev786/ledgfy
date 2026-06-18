import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../sub_widgets/profile_sub_page_scaffold.dart';

class ProfileLanguageOption {
  final String id;
  final String title;
  final String nativeTitle;
  final String subtitle;

  const ProfileLanguageOption({
    required this.id,
    required this.title,
    required this.nativeTitle,
    required this.subtitle,
  });
}

class ProfileLanguagePage extends StatefulWidget {
  final String initialLanguage;

  const ProfileLanguagePage({
    super.key,
    required this.initialLanguage,
  });

  static Future<String?> open(
    BuildContext context, {
    required String initialLanguage,
  }) {
    return ProfileSubPageScaffold.open<String>(
      context,
      ProfileLanguagePage(initialLanguage: initialLanguage),
    );
  }

  static const options = <ProfileLanguageOption>[
    ProfileLanguageOption(
      id: AppText.profileLanguageEnglish,
      title: AppText.profileLanguageEnglishNative,
      nativeTitle: 'English',
      subtitle: 'Default · left-to-right',
    ),
    ProfileLanguageOption(
      id: AppText.profileLanguageUrdu,
      title: AppText.profileLanguageUrduNative,
      nativeTitle: 'Urdu',
      subtitle: 'اردو · right-to-left ready',
    ),
  ];

  @override
  State<ProfileLanguagePage> createState() => _ProfileLanguagePageState();
}

class _ProfileLanguagePageState extends State<ProfileLanguagePage> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSubPageScaffold(
      title: AppText.profileLanguageTitle,
      subtitle: AppText.profileLanguageSubtitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          0,
          AppSizes.lg,
          AppSizes.xxl * 2,
        ),
        children: [
          MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            blur: 24,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < ProfileLanguagePage.options.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: AppSizes.lg + 48 + AppSizes.md,
                      color: AppColors.divider.withValues(alpha: 0.12),
                    ),
                  _LanguageTile(
                    option: ProfileLanguagePage.options[i],
                    selected: _selected == ProfileLanguagePage.options[i].id,
                    onTap: () {
                      setState(
                        () => _selected = ProfileLanguagePage.options[i].id,
                      );
                      Navigator.of(context).pop(_selected);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.xs),
            child: MyText(
              AppText.profileLanguageFootnote,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final ProfileLanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                alignment: Alignment.center,
                child: MyText(
                  option.nativeTitle.substring(0, 1).toUpperCase(),
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      option.title,
                      font: AppFont.inter,
                      size: AppSizes.body,
                      color: AppColors.white,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    MyText(
                      option.subtitle,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: selected ? AppColors.primary : AppColors.textHint,
                size: AppSizes.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
