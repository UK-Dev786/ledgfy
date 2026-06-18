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
import '../../../core/widgets/shared_bottom_sheet.dart';
import '../../../di/ledger_providers.dart';
import '../../../di/organization_providers.dart';
import '../../ledger/models/ledger_item.dart';
import '../models/ledger_staff_assignment.dart';
import '../models/staff_member.dart';
import '../sub_widgets/staff_access_level_switch.dart';
import '../sub_widgets/staff_ledger_scope_panel.dart';

class StaffAssignLedgersSheet extends ConsumerStatefulWidget {
  final StaffMember member;

  const StaffAssignLedgersSheet({
    super.key,
    required this.member,
  });

  static Future<bool> show(
    BuildContext context, {
    required StaffMember member,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StaffAssignLedgersSheet(member: member),
    ).then((value) => value ?? false);
  }

  @override
  ConsumerState<StaffAssignLedgersSheet> createState() =>
      _StaffAssignLedgersSheetState();
}

class _StaffAssignLedgersSheetState
    extends ConsumerState<StaffAssignLedgersSheet> {
  late Map<String, StaffLedgerGrantDraft> _drafts;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _drafts = {};
  }

  void _seedDrafts(List<LedgerItem> ledgers) {
    if (_drafts.isNotEmpty) return;
    final team = ref.read(organizationTeamStreamProvider).valueOrNull;
    if (team == null) return;
    _drafts = {
      for (final ledger in ledgers)
        ledger.id: () {
          final existing = team.assignmentFor(
            ledgerId: ledger.id,
            staffId: widget.member.id,
          );
          if (existing != null) {
            return StaffLedgerGrantDraft.fromAssignment(
              existing,
              ledger.config,
            );
          }
          return const StaffLedgerGrantDraft(
            selected: false,
            access: LedgerStaffAccess.editor,
          );
        }(),
    };
  }

  Future<void> _save(List<LedgerItem> ledgers) async {
    if (_saving) return;

    final grants = <String, LedgerStaffAssignment>{};

    for (final ledger in ledgers) {
      final draft = _drafts[ledger.id];
      if (draft == null || !draft.selected) continue;

      final assignment = draft.toAssignment(
        staffId: widget.member.id,
        config: ledger.config,
      );

      if (assignment == null) {
        context.popMsg(
          ledger.config.isProjectLedger
              ? AppText.staffLedgerScopeProjectsRequired
              : AppText.staffLedgerScopePartiesRequired,
          icon: Icons.warning_amber_rounded,
        );
        return;
      }

      grants[ledger.id] = assignment;
    }

    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    try {
      await ref.read(organizationControllerProvider).syncStaffLedgerGrants(
            staffId: widget.member.id,
            grantsByLedgerId: grants,
          );
    } catch (_) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    if (!mounted) return;
    navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ledgers = ref.watch(scopedLedgersProvider);
    _seedDrafts(ledgers);

    return SharedBottomSheet(
      maxHeightFactor: 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MyText(
            AppText.staffAssignLedgersTitle,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w700,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          MyText(
            widget.member.name,
            font: AppFont.sourceSans,
            size: AppSizes.subtitle,
            color: AppColors.textHint,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          const MyText(
            AppText.staffAssignLedgersSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            height: 1.4,
            align: TextAlign.center,
          ),
          SizedBox(height: context.h * 2),
          if (ledgers.isEmpty)
            const MyText(
              AppText.staffAssignLedgersEmpty,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              align: TextAlign.center,
            )
          else
            ...ledgers.map((ledger) {
              final draft = _drafts[ledger.id]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: _LedgerGrantCard(
                  ledger: ledger,
                  draft: draft,
                  onChanged: (next) => setState(() => _drafts[ledger.id] = next),
                ),
              );
            }),
          SizedBox(height: context.h * 2),
          MyButton(
            text: AppText.profileSave,
            loading: _saving,
            onTap: _saving ? () {} : () => _save(ledgers),
          ),
        ],
      ),
    );
  }
}

class _LedgerGrantCard extends StatelessWidget {
  final LedgerItem ledger;
  final StaffLedgerGrantDraft draft;
  final ValueChanged<StaffLedgerGrantDraft> onChanged;

  const _LedgerGrantCard({
    required this.ledger,
    required this.draft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final config = ledger.config;
    final selected = draft.selected;

    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusLg,
      blur: 18,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onChanged(
                draft.copyWith(selected: !selected),
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: selected ? AppColors.primary : AppColors.textHint,
                    size: AppSizes.iconMd,
                  ),
                  const SizedBox(width: AppSizes.md),
                  Icon(
                    ledger.type.icon,
                    color: AppColors.secondary,
                    size: AppSizes.iconSm,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          ledger.title,
                          font: AppFont.inter,
                          size: AppSizes.body,
                          color: AppColors.white,
                          weight: FontWeight.w600,
                        ),
                        MyText(
                          ledger.type.label,
                          font: AppFont.sourceSans,
                          size: AppSizes.caption,
                          color: AppColors.textHint,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selected && config.supportsSubLedgers)
            StaffLedgerScopePanel(
              ledger: ledger,
              selectedPartyNames: draft.partyNames,
              onChanged: (names) => onChanged(draft.copyWith(partyNames: names)),
            ),
          if (selected) ...[
            const SizedBox(height: AppSizes.sm),
            StaffAccessLevelSwitch(
              access: draft.access,
              onChanged: (access) => onChanged(draft.copyWith(access: access)),
            ),
          ],
        ],
      ),
    );
  }
}
