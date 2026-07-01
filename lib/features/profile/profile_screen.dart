import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text.dart';
import '../../core/widgets/my_button.dart';
import '../../core/widgets/my_text.dart';
import '../../core/widgets/themed_gradient_bg.dart';
import '../../di/auth_providers.dart';
import '../../di/profile_providers.dart';
import '../../domain/entities/user.dart';
import 'pages/profile_language_page.dart';
import 'pages/profile_security_page.dart';
import 'pages/profile_subscription_page.dart';
import 'pages/profile_team_page.dart';
import 'profile_staff_screen.dart';
import 'sub_widgets/profile_avatar.dart';
import 'sub_widgets/profile_edit_sheet.dart';
import 'sub_widgets/profile_section.dart';
import '../auth/presentation/viewmodels/login_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _displayName;
  String? _username;
  String _accountType = AppText.accountTypeIndividual;
  File? _avatarFile;
  String _language = AppText.profileLanguageEnglish;
  bool _notificationsEnabled = true;

  void _bindUser(User user) {
    _displayName = user.displayName;
    _username = user.username;
    _accountType = user.accountType ?? AppText.accountTypeIndividual;
  }

  String _resolvedName(User user) => _displayName?.trim().isNotEmpty == true
      ? _displayName!.trim()
      : (user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : user.email.split('@').first);

  String _resolvedUsername(User user) => _username?.trim().isNotEmpty == true
      ? _username!.trim()
      : (user.username?.trim().isNotEmpty == true
            ? user.username!.trim()
            : user.email.split('@').first);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(profileUserStreamProvider);
    final signOutState = ref.watch(profileViewModelProvider);
    final isSigningOut = signOutState.isLoading;

    ref.listen(profileViewModelProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && previous?.isLoading == true) {
        ref.read(loginViewModelProvider.notifier).reset();
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
                if (ref.read(firebaseAuthProvider).currentUser != null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      strokeWidth: 2,
                    ),
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) context.go('/login');
                });
                return const SizedBox.shrink();
              }

              _bindUser(user);
              final displayName = _resolvedName(user);
              final username = _resolvedUsername(user);

              if (user.isOrganizationStaff) {
                return ProfileStaffScreen(user: user);
              }

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
                    _ProfileHeaderCard(
                      displayName: displayName,
                      username: username,
                      accountType: _accountType,
                      isVerified: user.isVerified,
                      avatarFile: _avatarFile,
                      onImageChanged: (file) =>
                          setState(() => _avatarFile = file),
                    ),
                    SizedBox(height: context.h * 2),
                    ProfileSection(
                      title: AppText.profileSectionAccount,
                      children: [
                        ProfileTile(
                          icon: Icons.email_outlined,
                          title: AppText.emailLabel,
                          subtitle: user.email,
                          showChevron: false,
                        ),
                        ProfileTile(
                          icon: Icons.person_outline_rounded,
                          title: AppText.enterFullName,
                          subtitle: displayName,
                          onTap: () => ProfileEditSheet.show(
                            context,
                            field: ProfileEditField.name,
                            initialValue: displayName,
                            onSave: (value) async {
                              await ref
                                  .read(profileControllerProvider)
                                  .updateDisplayName(value);
                            },
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.alternate_email_rounded,
                          title: AppText.usernameLabel,
                          subtitle: username,
                          onTap: () => ProfileEditSheet.show(
                            context,
                            field: ProfileEditField.username,
                            initialValue: username,
                            onSave: (value) async {
                              await ref
                                  .read(profileControllerProvider)
                                  .updateUsername(value);
                            },
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.business_center_outlined,
                          title: AppText.accountTypeLabel,
                          subtitle: _accountType,
                          onTap: () => ProfileEditSheet.show(
                            context,
                            field: ProfileEditField.accountType,
                            initialValue: _accountType,
                            onSave: (value) async {
                              await ref
                                  .read(profileControllerProvider)
                                  .updateAccountType(value);
                              setState(() => _accountType = value);
                            },
                          ),
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
                        ProfileTile(
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
                    if (_accountType == AppText.accountTypeOrganization)
                      ProfileSection(
                        title: AppText.profileSectionTeam,
                        children: [
                          ProfileTile(
                            icon: Icons.groups_outlined,
                            title: AppText.profileTeamMembers,
                            subtitle: AppText.profileTeamMembersSubtitle,
                            onTap: () => ProfileTeamPage.open(
                              context,
                              ownerName: displayName,
                            ),
                          ),
                        ],
                      ),
                    if (_accountType == AppText.accountTypeOrganization)
                      SizedBox(height: context.h * 2),
                    ProfileSection(
                      title: AppText.profileSectionSubscription,
                      children: [
                        ProfileTile(
                          icon: Icons.workspace_premium_outlined,
                          title: AppText.profilePlanPro,
                          subtitle:
                              '${AppText.profileCurrentPlan}: ${AppText.profilePlanFree}',
                          onTap: () => ProfileSubscriptionPage.open(
                            context,
                            accountType: _accountType,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h * 2),
                    ProfileSection(
                      title: AppText.profileSectionApp,
                      children: [
                        ProfileTile(
                          icon: Icons.lock_outline_rounded,
                          title: AppText.profileSecurity,
                          subtitle: AppText.profileSecuritySubtitle,
                          onTap: () => ProfileSecurityPage.open(context),
                        ),
                        ProfileTile(
                          icon: Icons.help_outline_rounded,
                          title: AppText.profileHelp,
                          onTap: () =>
                              context.popMsg(AppText.profileComingSoon),
                        ),
                        ProfileTile(
                          icon: Icons.privacy_tip_outlined,
                          title: AppText.profilePrivacy,
                          onTap: () =>
                              context.popMsg(AppText.profileComingSoon),
                        ),
                        ProfileTile(
                          icon: Icons.info_outline_rounded,
                          title: AppText.profileAbout,
                          subtitle:
                              '${AppText.appName} · ${AppText.appTagline}',
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
}

class _ProfileHeaderCard extends StatelessWidget {
  final String displayName;
  final String username;
  final String accountType;
  final bool isVerified;
  final File? avatarFile;
  final ValueChanged<File?> onImageChanged;

  const _ProfileHeaderCard({
    required this.displayName,
    required this.username,
    required this.accountType,
    required this.isVerified,
    required this.avatarFile,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF0D1E16);
    const bannerH = 120.0;
    const ringThickness = 3.0;
    const avatarW = 104.0;
    const containerW = avatarW + ringThickness * 4;
    const overlap = containerW / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: bannerH + overlap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient banner
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: bannerH,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF00573A), AppColors.primary],
                              ),
                            ),
                          ),
                        ),
                        // Decorative blobs
                        Positioned(
                          top: -28,
                          right: -18,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.09),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -22,
                          left: -12,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.07),
                            ),
                          ),
                        ),
                        // Account type chip — top-left
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.business_rounded,
                                  size: AppSizes.iconSm,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 4),
                                MyText(
                                  accountType,
                                  font: AppFont.sourceSans,
                                  size: AppSizes.caption,
                                  color: AppColors.white,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar with gradient ring — centered at banner bottom
                  Positioned(
                    top: bannerH - overlap,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(ringThickness),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 22,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(ringThickness),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: cardBg,
                          ),
                          child: ProfileAvatar(
                            initials: ProfileAvatar.initialsFromName(
                              displayName,
                              fallback: username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : '?',
                            ),
                            imageFile: avatarFile,
                            onImageChanged: onImageChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Name + username
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w * 5,
                context.h * 1.5,
                context.w * 5,
                context.h * 3,
              ),
              child: Column(
                children: [
                  // Name with inline verified checkmark (Facebook-style)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                      if (isVerified) ...[
                        const SizedBox(width: 3),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: context.h * 0.5),
                  MyText(
                    '@$username',
                    font: AppFont.sourceSans,
                    size: AppSizes.subtitle,
                    color: AppColors.textHint,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
