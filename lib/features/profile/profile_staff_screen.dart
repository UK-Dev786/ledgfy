import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text.dart';
import '../../core/models/app_sync_status.dart';
import '../../core/widgets/my_button.dart';
import '../../core/widgets/my_card.dart';
import '../../core/widgets/my_text.dart';
import '../../di/sync_providers.dart';
import '../../domain/entities/user.dart';
import 'pages/profile_language_page.dart';
import 'sub_widgets/profile_avatar.dart';
import 'sub_widgets/profile_section.dart';
import 'viewmodels/profile_viewmodel.dart';

class ProfileStaffScreen extends ConsumerStatefulWidget {
  final User user;

  const ProfileStaffScreen({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ProfileStaffScreen> createState() => _ProfileStaffScreenState();
}

class _ProfileStaffScreenState extends ConsumerState<ProfileStaffScreen> {
  File? _avatarFile;
  String _language = AppText.profileLanguageEnglish;

  String get _displayName {
    final name = widget.user.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return widget.user.email.split('@').first;
  }

  String get _username {
    final value = widget.user.username?.trim();
    if (value != null && value.isNotEmpty) return value;
    return widget.user.email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    final signOutState = ref.watch(profileViewModelProvider);
    final syncStatus = ref.watch(appSyncStatusProvider);
    final isSigningOut = signOutState.isLoading;

    ref.listen(profileViewModelProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && previous?.isLoading == true) {
        context.go('/login');
        ref.read(profileViewModelProvider.notifier).reset();
      }
    });

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        context.w * 6,
        context.h * 2,
        context.w * 6,
        context.h * 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MyText(
            AppText.profileTitle,
            font: AppFont.inter,
            size: AppSizes.header3,
            color: AppColors.white,
            weight: FontWeight.bold,
          ),
          SizedBox(height: context.h * 3),
          MyCard(
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
              children: [
                ProfileAvatar(
                  initials: ProfileAvatar.initialsFromName(
                    _displayName,
                    fallback: _username.isNotEmpty
                        ? _username[0].toUpperCase()
                        : '?',
                  ),
                  imageFile: _avatarFile,
                  onImageChanged: (file) {
                    setState(() => _avatarFile = file);
                  },
                ),
                SizedBox(height: context.h * 2),
                MyText(
                  _displayName,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                  align: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.h * 0.4),
                MyText(
                  '@$_username',
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.textHint,
                  align: TextAlign.center,
                ),
                SizedBox(height: context.h * 1.2),
                _StaffBadge(),
                SizedBox(height: context.h * 1),
                syncStatus.when(
                  data: (status) => _SyncStatusBadge(status: status),
                  loading: () => const _SyncStatusBadge(
                    status: AppSyncStatus(
                      isOnline: true,
                      hasPendingWrites: false,
                    ),
                  ),
                  error: (_, __) => const _SyncStatusBadge(
                    status: AppSyncStatus(
                      isOnline: true,
                      hasPendingWrites: false,
                    ),
                  ),
                ),
                SizedBox(height: context.h * 1.2),
                const MyText(
                  AppText.profileStaffOrgNote,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  align: TextAlign.center,
                  height: 1.45,
                ),
              ],
            ),
          ),
          SizedBox(height: context.h * 2),
          ProfileSection(
            title: AppText.profileStaffSectionAccount,
            children: [
              ProfileTile(
                icon: Icons.email_outlined,
                title: AppText.emailLabel,
                subtitle: widget.user.email,
                showChevron: false,
              ),
              ProfileTile(
                icon: Icons.person_outline_rounded,
                title: AppText.enterFullName,
                subtitle: _displayName,
                showChevron: false,
              ),
              ProfileTile(
                icon: Icons.alternate_email_rounded,
                title: AppText.usernameLabel,
                subtitle: _username,
                showChevron: false,
              ),
            ],
          ),
          SizedBox(height: context.h * 2),
          ProfileSection(
            title: AppText.profileSectionPreferences,
            children: [
              ProfileTile(
                icon: Icons.language_rounded,
                title: AppText.profileLanguage,
                subtitle: _language,
                onTap: () async {
                  final picked = await ProfileLanguagePage.open(
                    context,
                    initialLanguage: _language,
                  );
                  if (picked != null) {
                    setState(() => _language = picked);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: context.h * 2),
          ProfileSection(
            title: AppText.profileSectionApp,
            children: [
              ProfileTile(
                icon: Icons.help_outline_rounded,
                title: AppText.profileHelp,
                onTap: () => context.popMsg(AppText.profileComingSoon),
              ),
              ProfileTile(
                icon: Icons.privacy_tip_outlined,
                title: AppText.profilePrivacy,
                onTap: () => context.popMsg(AppText.profileComingSoon),
              ),
              ProfileTile(
                icon: Icons.info_outline_rounded,
                title: AppText.profileAbout,
                subtitle: '${AppText.appName} · ${AppText.appTagline}',
                onTap: () => context.popMsg(
                  '${AppText.appName}\n${AppText.appTagline}',
                  title: AppText.profileAbout,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h * 3),
          MyButton(
            text: AppText.profileSignOut,
            variant: MyButtonVariant.outlined,
            color: AppColors.primary,
            loading: isSigningOut,
            onTap: isSigningOut
                ? () {}
                : () => ref.read(profileViewModelProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}

class _StaffBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.badge_outlined,
            size: AppSizes.iconSm,
            color: AppColors.secondary,
          ),
          const SizedBox(width: AppSizes.xs),
          MyText(
            AppText.profileStaffOrgBadge,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.secondary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final AppSyncStatus status;

  const _SyncStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: status.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: AppSizes.iconSm, color: status.color),
          const SizedBox(width: AppSizes.xs),
          MyText(
            status.label,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: status.color,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
