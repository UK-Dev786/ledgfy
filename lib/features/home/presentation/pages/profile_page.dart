import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/models/app_sync_status.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../../../di/auth_providers.dart';
import '../../../../di/sync_providers.dart';
import '../../../../domain/entities/user.dart';
import '../sub_widgets/profile_avatar.dart';
import '../sub_widgets/profile_edit_sheet.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _displayName;
  String? _username;
  String _accountType = AppText.accountTypeIndividual;
  File? _avatarFile;
  String _language = AppText.profileLanguageEnglish;
  bool _notificationsEnabled = true;
  String? _boundUserId;

  void _bindUser(User user) {
    if (_boundUserId == user.id) return;
    _boundUserId = user.id;
    _displayName = user.displayName;
    _username = user.username;
    _accountType = user.accountType ?? AppText.accountTypeIndividual;
  }

  String _resolvedName(User user) =>
      _displayName?.trim().isNotEmpty == true
          ? _displayName!.trim()
          : (user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : user.email.split('@').first);

  String _resolvedUsername(User user) =>
      _username?.trim().isNotEmpty == true
          ? _username!.trim()
          : (user.username?.trim().isNotEmpty == true
                ? user.username!.trim()
                : user.email.split('@').first);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final signOutState = ref.watch(profileViewModelProvider);
    final syncStatus = ref.watch(appSyncStatusProvider);
    final isSigningOut = signOutState.isLoading;

    ref.listen(profileViewModelProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && previous?.isLoading == true) {
        context.go('/login');
        ref.read(profileViewModelProvider.notifier).reset();
      }
    });

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: authState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
            error: (_, __) => Center(
              child: MyText(
                AppText.homeErrorGeneric,
                font: AppFont.sourceSans,
                size: AppSizes.body,
                color: AppColors.textHint,
              ),
            ),
            data: (user) {
              if (user == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) context.go('/login');
                });
                return const SizedBox.shrink();
              }

              _bindUser(user);
              final displayName = _resolvedName(user);
              final username = _resolvedUsername(user);

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
                              displayName,
                              fallback: username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : '?',
                            ),
                            imageFile: _avatarFile,
                            onImageChanged: (file) {
                              setState(() => _avatarFile = file);
                            },
                          ),
                          SizedBox(height: context.h * 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: MyText(
                                  displayName,
                                  font: AppFont.inter,
                                  size: AppSizes.title,
                                  color: AppColors.white,
                                  weight: FontWeight.w700,
                                  align: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () => ProfileEditSheet.show(
                                  context,
                                  field: ProfileEditField.name,
                                  initialValue: displayName,
                                  onSave: (value) {
                                    setState(() => _displayName = value);
                                  },
                                ),
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.textHint,
                                  size: AppSizes.iconSm,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          SizedBox(height: context.h * 0.4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                '@$username',
                                font: AppFont.sourceSans,
                                size: AppSizes.subtitle,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(width: AppSizes.xs),
                              IconButton(
                                onPressed: () => ProfileEditSheet.show(
                                  context,
                                  field: ProfileEditField.username,
                                  initialValue: username,
                                  onSave: (value) {
                                    setState(() => _username = value);
                                  },
                                ),
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.textHint,
                                  size: AppSizes.iconSm,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          SizedBox(height: context.h * 1.2),
                          _VerifiedBadge(isVerified: user.isVerified),
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
                        ],
                      ),
                    ),
                    SizedBox(height: context.h * 2),
                    _ProfileSection(
                      title: AppText.profileSectionAccount,
                      children: [
                        _ProfileTile(
                          icon: Icons.email_outlined,
                          title: AppText.emailLabel,
                          subtitle: user.email,
                          showChevron: false,
                        ),
                        _ProfileTile(
                          icon: Icons.business_center_outlined,
                          title: AppText.accountTypeLabel,
                          subtitle: _accountType,
                          onTap: () => ProfileEditSheet.show(
                            context,
                            field: ProfileEditField.accountType,
                            initialValue: _accountType,
                            onSave: (value) {
                              setState(() => _accountType = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h * 2),
                    _ProfileSection(
                      title: AppText.profileSectionPreferences,
                      children: [
                        _ProfileTile(
                          icon: Icons.language_rounded,
                          title: AppText.profileLanguage,
                          subtitle: _language,
                          onTap: () => _pickLanguage(context),
                        ),
                        _ProfileTile(
                          icon: Icons.notifications_outlined,
                          title: AppText.profileNotifications,
                          subtitle: AppText.profileNotificationsSubtitle,
                          trailing: Switch.adaptive(
                            value: _notificationsEnabled,
                            activeTrackColor: AppColors.primary.withValues(
                              alpha: 0.45,
                            ),
                            activeThumbColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() => _notificationsEnabled = value);
                            },
                          ),
                          showChevron: false,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h * 2),
                    _ProfileSection(
                      title: AppText.profileSectionSubscription,
                      children: [
                        _SubscriptionCard(
                          onUpgrade: () => context.popMsg(
                            AppText.profileComingSoon,
                            icon: Icons.workspace_premium_outlined,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h * 2),
                    _ProfileSection(
                      title: AppText.profileSectionApp,
                      children: [
                        _ProfileTile(
                          icon: Icons.lock_outline_rounded,
                          title: AppText.profileSecurity,
                          subtitle: AppText.profileSecuritySubtitle,
                          onTap: () => context.popMsg(AppText.profileComingSoon),
                        ),
                        _ProfileTile(
                          icon: Icons.help_outline_rounded,
                          title: AppText.profileHelp,
                          onTap: () => context.popMsg(AppText.profileComingSoon),
                        ),
                        _ProfileTile(
                          icon: Icons.privacy_tip_outlined,
                          title: AppText.profilePrivacy,
                          onTap: () => context.popMsg(AppText.profileComingSoon),
                        ),
                        _ProfileTile(
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
                          : () => ref
                                .read(profileViewModelProvider.notifier)
                                .signOut(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSizes.lg),
              child: MyText(
                AppText.profileLanguage,
                font: AppFont.inter,
                size: AppSizes.title,
                color: AppColors.textPrimary,
                weight: FontWeight.w700,
              ),
            ),
            for (final option in [
              AppText.profileLanguageEnglish,
              AppText.profileLanguageUrdu,
            ])
              ListTile(
                title: Text(option),
                trailing: _language == option
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _language = option);
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
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

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;

  const _ProfileTile({
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

class _SubscriptionCard extends StatelessWidget {
  final VoidCallback onUpgrade;

  const _SubscriptionCard({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        gradient: const LinearGradient(
          colors: AppColors.gradientPremium,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: const MyText(
                  AppText.profilePlanFree,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          const MyText(
            AppText.profilePlanPro,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w800,
          ),
          const SizedBox(height: AppSizes.xs),
          const MyText(
            AppText.profilePlanProSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.white,
            height: 1.4,
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: MyButton(
              text: AppText.profileUpgrade,
              color: AppColors.white,
              textColor: AppColors.tertiary,
              onTap: onUpgrade,
            ),
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

class _VerifiedBadge extends StatelessWidget {
  final bool isVerified;

  const _VerifiedBadge({required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: (isVerified ? AppColors.primary : AppColors.textHint)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: (isVerified ? AppColors.primary : AppColors.textHint)
              .withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.info_outline_rounded,
            size: AppSizes.iconSm,
            color: isVerified ? AppColors.primary : AppColors.textHint,
          ),
          const SizedBox(width: AppSizes.xs),
          MyText(
            isVerified ? AppText.profileVerified : AppText.profileNotVerified,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: isVerified ? AppColors.primary : AppColors.textHint,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
