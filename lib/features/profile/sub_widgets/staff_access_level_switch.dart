import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../profile/models/ledger_staff_assignment.dart';

class StaffAccessLevelSwitch extends StatelessWidget {
  final LedgerStaffAccess access;
  final ValueChanged<LedgerStaffAccess> onChanged;

  const StaffAccessLevelSwitch({
    super.key,
    required this.access,
    required this.onChanged,
  });

  String get _hint => switch (access) {
        LedgerStaffAccess.editor => AppText.staffRoleEditorHint,
        LedgerStaffAccess.viewer => AppText.staffRoleViewerHint,
      };

  @override
  Widget build(BuildContext context) {
    final isViewer = access == LedgerStaffAccess.viewer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MyText(
          AppText.staffInviteRoleLabel,
          font: AppFont.sourceSans,
          size: AppSizes.subtitle,
          color: AppColors.textHint,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: AppSizes.sm),
        MyCard(
          tint: MyCardTint.dark,
          borderRadius: AppSizes.radiusMd,
          blur: 16,
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AccessChip(
                      label: AppText.staffAccessEditor,
                      selected: !isViewer,
                      onTap: () => onChanged(LedgerStaffAccess.editor),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _AccessChip(
                      label: AppText.staffAccessViewer,
                      selected: isViewer,
                      onTap: () => onChanged(LedgerStaffAccess.viewer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              MyText(
                _hint,
                font: AppFont.sourceSans,
                size: AppSizes.caption,
                color: AppColors.textHint,
                height: 1.35,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccessChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AccessChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.16)
                : AppColors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.textHint.withValues(alpha: 0.2),
            ),
          ),
          alignment: Alignment.center,
          child: MyText(
            label,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: selected ? AppColors.white : AppColors.textHint,
            weight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
