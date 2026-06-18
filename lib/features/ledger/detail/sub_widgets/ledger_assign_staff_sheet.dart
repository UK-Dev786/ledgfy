import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';
import '../../../../di/ledger_providers.dart';
import '../../../../di/organization_providers.dart';
import '../../../profile/models/ledger_staff_assignment.dart';
import '../../../profile/models/staff_member.dart';
import '../../../profile/sub_widgets/staff_access_level_switch.dart';
import '../../../profile/sub_widgets/staff_ledger_scope_panel.dart';
import '../../models/ledger_item.dart';

class LedgerAssignStaffSheet extends ConsumerStatefulWidget {
  final String ledgerId;
  final String ledgerTitle;

  const LedgerAssignStaffSheet({
    super.key,
    required this.ledgerId,
    required this.ledgerTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required String ledgerId,
    required String ledgerTitle,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LedgerAssignStaffSheet(
        ledgerId: ledgerId,
        ledgerTitle: ledgerTitle,
      ),
    );
  }

  @override
  ConsumerState<LedgerAssignStaffSheet> createState() =>
      _LedgerAssignStaffSheetState();
}

class _LedgerAssignStaffSheetState extends ConsumerState<LedgerAssignStaffSheet> {
  String? _addingStaffId;
  LedgerStaffAccess _newAccess = LedgerStaffAccess.editor;
  Set<String> _newPartyNames = {};

  Future<void> _saveAssignment(LedgerStaffAssignment assignment) async {
    await ref.read(organizationControllerProvider).updateLedgerAssignment(
          ledgerId: widget.ledgerId,
          assignment: assignment,
        );
  }

  Future<void> _addStaff(StaffMember staff) async {
    final ledger = ref.read(ledgerByIdProvider(widget.ledgerId));
    if (ledger == null) return;

    final draft = StaffLedgerGrantDraft(
      selected: true,
      access: _newAccess,
      partyNames: _newPartyNames,
    );
    final assignment = draft.toAssignment(
      staffId: staff.id,
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

    await _saveAssignment(assignment);
    if (!mounted) return;
    setState(() {
      _addingStaffId = null;
      _newAccess = LedgerStaffAccess.editor;
      _newPartyNames = {};
    });
    context.popMsg(
      AppText.ledgerStaffAssigned,
      icon: Icons.person_add_alt_1_outlined,
    );
  }

  Future<void> _removeAssignment(String staffId) async {
    await ref.read(organizationControllerProvider).removeLedgerAssignment(
          ledgerId: widget.ledgerId,
          staffId: staffId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(organizationTeamStreamProvider);
    final team = teamAsync.valueOrNull;
    if (team == null) {
      return const SharedBottomSheet(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeWidth: 2,
          ),
        ),
      );
    }

    final ledger = ref.watch(ledgerByIdProvider(widget.ledgerId));
    final assignments = team.assignmentsForLedger(widget.ledgerId);
    final assignedIds = assignments.map((item) => item.staffId).toSet();
    final availableStaff = team.staffAccounts
        .where((member) => !assignedIds.contains(member.id))
        .toList();
    final supportsScope = ledger?.config.supportsSubLedgers ?? false;

    return SharedBottomSheet(
      maxHeightFactor: 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MyText(
            AppText.ledgerAssignStaffTitle,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w700,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          MyText(
            widget.ledgerTitle,
            font: AppFont.sourceSans,
            size: AppSizes.subtitle,
            color: AppColors.textHint,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          MyText(
            supportsScope
                ? AppText.ledgerAssignStaffScopedSubtitle
                : AppText.ledgerAssignStaffSubtitle,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            height: 1.4,
            align: TextAlign.center,
          ),
          SizedBox(height: context.h * 2),
          if (assignments.isEmpty)
            MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusMd,
              blur: 16,
              padding: const EdgeInsets.all(AppSizes.lg),
              child: const MyText(
                AppText.ledgerAssignStaffEmpty,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                align: TextAlign.center,
                height: 1.4,
              ),
            )
          else if (ledger != null)
            ...assignments.map((assignment) {
              final member = team.memberById(assignment.staffId);
              if (member == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: _AssignedStaffCard(
                  ledger: ledger,
                  member: member,
                  assignment: assignment,
                  onChanged: (next) => _saveAssignment(next),
                  onRemove: () => _removeAssignment(member.id),
                ),
              );
            }),
          if (availableStaff.isNotEmpty && ledger != null) ...[
            SizedBox(height: context.h * 1.5),
            const MyText(
              AppText.ledgerAssignStaffAdd,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: AppSizes.sm),
            if (_addingStaffId == null)
              ...availableStaff.map(
                (staff) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: _PickStaffTile(
                    member: staff,
                    onTap: () => setState(() => _addingStaffId = staff.id),
                  ),
                ),
              )
            else ...[
              if (supportsScope)
                StaffLedgerScopePanel(
                  ledger: ledger,
                  selectedPartyNames: _newPartyNames,
                  onChanged: (names) => setState(() => _newPartyNames = names),
                ),
              SizedBox(height: context.h * 1.5),
              StaffAccessLevelSwitch(
                access: _newAccess,
                onChanged: (access) => setState(() => _newAccess = access),
              ),
              SizedBox(height: context.h * 1.5),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      text: AppText.profileBack,
                      variant: MyButtonVariant.outlined,
                      color: AppColors.primary,
                      onTap: () => setState(() {
                        _addingStaffId = null;
                        _newPartyNames = {};
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: MyButton(
                      text: AppText.ledgerAssignStaffConfirm,
                      onTap: () async {
                        final staff = team.memberById(_addingStaffId!);
                        if (staff != null) await _addStaff(staff);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _AssignedStaffCard extends StatefulWidget {
  final LedgerItem ledger;
  final StaffMember member;
  final LedgerStaffAssignment assignment;
  final ValueChanged<LedgerStaffAssignment> onChanged;
  final VoidCallback onRemove;

  const _AssignedStaffCard({
    required this.ledger,
    required this.member,
    required this.assignment,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<_AssignedStaffCard> createState() => _AssignedStaffCardState();
}

class _AssignedStaffCardState extends State<_AssignedStaffCard> {
  late LedgerStaffAccess _access;
  late Set<String> _partyNames;

  @override
  void initState() {
    super.initState();
    _access = widget.assignment.access;
    _partyNames = Set<String>.from(
      widget.assignment.scopedPartyNames ?? const [],
    );
  }

  void _emit() {
    final config = widget.ledger.config;
    final draft = StaffLedgerGrantDraft(
      selected: true,
      access: _access,
      partyNames: _partyNames,
    );
    final next = draft.toAssignment(
      staffId: widget.member.id,
      config: config,
    );
    if (next != null) widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.ledger.config;

    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusLg,
      blur: 20,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      widget.member.name,
                      font: AppFont.inter,
                      size: AppSizes.body,
                      color: AppColors.white,
                      weight: FontWeight.w700,
                    ),
                    MyText(
                      widget.member.displayLogin,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      widget.assignment.scopeSummary(config),
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.secondary,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.error,
                  size: AppSizes.iconMd,
                ),
              ),
            ],
          ),
          if (config.supportsSubLedgers)
            StaffLedgerScopePanel(
              ledger: widget.ledger,
              selectedPartyNames: _partyNames,
              onChanged: (names) {
                setState(() => _partyNames = names);
                _emit();
              },
            ),
          const SizedBox(height: AppSizes.sm),
          StaffAccessLevelSwitch(
            access: _access,
            onChanged: (access) {
              setState(() => _access = access);
              _emit();
            },
          ),
        ],
      ),
    );
  }
}

class _PickStaffTile extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onTap;

  const _PickStaffTile({
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: MyCard(
          tint: MyCardTint.dark,
          borderRadius: AppSizes.radiusMd,
          blur: 16,
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              const Icon(
                Icons.person_add_alt_1_outlined,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
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
                      weight: FontWeight.w600,
                    ),
                    MyText(
                      member.displayLogin,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
