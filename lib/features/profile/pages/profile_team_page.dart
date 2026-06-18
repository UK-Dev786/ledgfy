import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../di/organization_providers.dart';
import '../models/organization_team_state.dart';
import '../models/staff_member.dart';
import '../pages/profile_staff_activity_page.dart';
import '../sub_widgets/invite_staff_sheet.dart';
import '../sub_widgets/profile_section.dart';
import '../sub_widgets/profile_sub_page_scaffold.dart';
import '../sub_widgets/staff_assign_ledgers_sheet.dart';
import '../sub_widgets/staff_manage_sheet.dart';

class ProfileTeamPage extends ConsumerWidget {
  final String ownerName;

  const ProfileTeamPage({
    super.key,
    required this.ownerName,
  });

  static void open(
    BuildContext context, {
    required String ownerName,
  }) {
    ProfileSubPageScaffold.open<void>(
      context,
      ProfileTeamPage(ownerName: ownerName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(organizationTeamStreamProvider);

    return teamAsync.when(
      loading: () => ProfileSubPageScaffold(
        title: AppText.profileTeamTitle,
        subtitle: AppText.profileTeamSubtitle,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, __) => ProfileSubPageScaffold(
        title: AppText.profileTeamTitle,
        subtitle: AppText.profileTeamSubtitle,
        child: Center(
          child: MyText(
            AppText.homeErrorGeneric,
            font: AppFont.sourceSans,
            size: AppSizes.body,
            color: AppColors.textHint,
          ),
        ),
      ),
      data: (team) => _TeamContent(
        ownerName: ownerName,
        team: team,
      ),
    );
  }
}

class _TeamContent extends ConsumerWidget {
  final String ownerName;
  final OrganizationTeamState team;

  const _TeamContent({
    required this.ownerName,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = AppText.staffTeamSummary.replaceAll(
      '{count}',
      '${team.members.length}',
    );

    return ProfileSubPageScaffold(
      title: AppText.profileTeamTitle,
      subtitle: AppText.profileTeamSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.lg,
                0,
                AppSizes.lg,
                AppSizes.md,
              ),
              children: [
                MyCard(
                  tint: MyCardTint.dark,
                  borderRadius: AppSizes.radiusLg,
                  blur: 24,
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.groups_outlined,
                        color: AppColors.secondary,
                        size: AppSizes.iconMd,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: MyText(
                          summary,
                          font: AppFont.sourceSans,
                          size: AppSizes.subtitle,
                          color: AppColors.textHint,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                MyCard(
                  tint: MyCardTint.dark,
                  borderRadius: AppSizes.radiusLg,
                  blur: 24,
                  padding: EdgeInsets.zero,
                  child: ProfileTile(
                    icon: Icons.history_rounded,
                    title: AppText.profileStaffActivity,
                    subtitle: AppText.profileStaffActivitySubtitle,
                    onTap: () => ProfileStaffActivityPage.open(context),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.xs,
                    bottom: AppSizes.sm,
                  ),
                  child: MyText(
                    AppText.profileTeamMembers,
                    font: AppFont.inter,
                    size: AppSizes.caption,
                    color: AppColors.textHint,
                    weight: FontWeight.w600,
                  ),
                ),
                if (team.staffAccounts.isEmpty)
                  MyCard(
                    tint: MyCardTint.dark,
                    borderRadius: AppSizes.radiusLg,
                    blur: 20,
                    padding: const EdgeInsets.all(AppSizes.xl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_add_outlined,
                          size: AppSizes.iconXl,
                          color: AppColors.textHint.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: AppSizes.md),
                        const MyText(
                          AppText.staffTeamEmptyTitle,
                          font: AppFont.inter,
                          size: AppSizes.body,
                          color: AppColors.white,
                          weight: FontWeight.w700,
                          align: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        const MyText(
                          AppText.staffTeamEmptySubtitle,
                          font: AppFont.sourceSans,
                          size: AppSizes.caption,
                          color: AppColors.textHint,
                          align: TextAlign.center,
                          height: 1.45,
                        ),
                      ],
                    ),
                  ),
                ...team.members.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: _StaffMemberCard(
                      member: member,
                      team: team,
                      onAssign: member.isOwner
                          ? null
                          : () async {
                              final saved = await StaffAssignLedgersSheet.show(
                                context,
                                member: member,
                              );
                              if (!saved || !context.mounted) return;
                              context.popMsg(
                                AppText.staffAssignLedgersSaved,
                                icon: Icons.check_circle_outline_rounded,
                              );
                            },
                      onDelete: member.isOwner
                          ? null
                          : () => StaffManageSheet.show(
                                context,
                                member: member,
                                assignedLedgerCount:
                                    team.assignedLedgerCount(member.id),
                                onDelete: (staffId) async {
                                  await ref
                                      .read(organizationControllerProvider)
                                      .removeStaff(staffId);
                                  if (!context.mounted) return;
                                  context.popMsg(
                                    AppText.staffDeleted,
                                    icon: Icons.delete_outline_rounded,
                                  );
                                },
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.sm,
              AppSizes.lg,
              context.h * 2,
            ),
            child: MyButton(
              text: AppText.profileInviteStaff,
              onTap: () async {
                final created = await InviteStaffSheet.show(
                  context,
                  onCreate: ({
                    required String name,
                    required String username,
                    required String loginEmail,
                    required String password,
                  }) {
                    return ref.read(organizationControllerProvider).createStaff(
                          name: name,
                          username: username,
                          loginEmail: loginEmail,
                          password: password,
                        );
                  },
                );
                if (!created || !context.mounted) return;
                context.popMsg(
                  AppText.profileInviteStaffSent,
                  icon: Icons.person_add_alt_1_outlined,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffMemberCard extends StatelessWidget {
  final StaffMember member;
  final OrganizationTeamState team;
  final VoidCallback? onAssign;
  final VoidCallback? onDelete;

  const _StaffMemberCard({
    required this.member,
    required this.team,
    this.onAssign,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ledgerCount = team.assignedLedgerCount(member.id);

    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusLg,
      blur: 20,
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAssign,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Row(
                  children: [
                    _StaffAvatar(initials: member.initials),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            member.name,
                            font: AppFont.inter,
                            size: AppSizes.body,
                            color: AppColors.white,
                            weight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            member.displayLogin,
                            font: AppFont.sourceSans,
                            size: AppSizes.caption,
                            color: AppColors.textHint,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!member.isOwner) ...[
                            const SizedBox(height: AppSizes.xs),
                            MyText(
                              member.ledgerCountLabel(ledgerCount),
                              font: AppFont.sourceSans,
                              size: AppSizes.caption,
                              color: AppColors.secondary,
                              weight: FontWeight.w600,
                            ),
                          ],
                          const SizedBox(height: AppSizes.sm),
                          Wrap(
                            spacing: AppSizes.sm,
                            runSpacing: AppSizes.xs,
                            children: [
                              if (member.isOwner)
                                _Badge(
                                  label: AppText.staffRoleOwner,
                                  color: AppColors.secondary,
                                )
                              else
                                _Badge(
                                  label: AppText.staffAccountLabel,
                                  color: AppColors.primary,
                                ),
                              _Badge(
                                label: member.status.label,
                                color: member.status == StaffMemberStatus.active
                                    ? AppColors.primary
                                    : AppColors.textHint,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (onAssign != null)
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textHint,
                        size: AppSizes.iconMd,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppSizes.sm),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error.withValues(alpha: 0.85),
                size: AppSizes.iconMd,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: MyText(
        label,
        font: AppFont.sourceSans,
        size: AppSizes.caption,
        color: color,
        weight: FontWeight.w600,
      ),
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  final String initials;

  const _StaffAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      child: MyText(
        initials,
        font: AppFont.inter,
        size: AppSizes.body,
        color: AppColors.primary,
        weight: FontWeight.w700,
      ),
    );
  }
}
