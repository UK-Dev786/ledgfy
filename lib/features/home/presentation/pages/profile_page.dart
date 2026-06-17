import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../../../core/models/app_sync_status.dart';
import '../../../../di/auth_providers.dart';
import '../../../../di/sync_providers.dart';
import '../../../../domain/entities/user.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _initials(User user) {
    final name = user.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w * 6,
                  vertical: context.h * 3,
                ),
                child: Column(
                  children: [
                    MyText(
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
                          CircleAvatar(
                            radius: AppSizes.xl,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.15,
                            ),
                            child: MyText(
                              _initials(user),
                              font: AppFont.inter,
                              size: AppSizes.header3,
                              color: AppColors.primary,
                              weight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.h * 2),
                          MyText(
                            user.displayName ?? user.username ?? user.email,
                            font: AppFont.inter,
                            size: AppSizes.title,
                            color: AppColors.white,
                            weight: FontWeight.w700,
                            align: TextAlign.center,
                          ),
                          if (user.username != null) ...[
                            SizedBox(height: context.h * 0.5),
                            MyText(
                              '@${user.username}',
                              font: AppFont.sourceSans,
                              size: AppSizes.subtitle,
                              color: AppColors.textHint,
                            ),
                          ],
                          SizedBox(height: context.h * 1.2),
                          _VerifiedBadge(isVerified: user.isVerified),
                          SizedBox(height: context.h * 1.2),
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
                          SizedBox(height: context.h * 2.5),
                          _ProfileInfoRow(
                            label: AppText.emailLabel,
                            value: user.email,
                            icon: Icons.email_outlined,
                          ),
                          if (user.accountType != null) ...[
                            SizedBox(height: context.h * 1.5),
                            _ProfileInfoRow(
                              label: AppText.accountTypeLabel,
                              value: user.accountType!,
                              icon: Icons.business_center_outlined,
                            ),
                          ],
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

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileInfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                label,
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.textHint,
              ),
              const SizedBox(height: AppSizes.xs),
              MyText(
                value,
                font: AppFont.sourceSans,
                size: AppSizes.body,
                color: AppColors.white,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
