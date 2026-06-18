import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_bottom_sheet.dart';
import '../models/staff_member.dart';

typedef OnStaffDeleted = void Function(String staffId);

class StaffManageSheet extends StatelessWidget {
  final StaffMember member;
  final int assignedLedgerCount;
  final OnStaffDeleted onDelete;

  const StaffManageSheet({
    super.key,
    required this.member,
    required this.assignedLedgerCount,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required StaffMember member,
    required int assignedLedgerCount,
    required OnStaffDeleted onDelete,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StaffManageSheet(
        member: member,
        assignedLedgerCount: assignedLedgerCount,
        onDelete: onDelete,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A1820),
        title: const MyText(
          AppText.staffDeleteTitle,
          font: AppFont.inter,
          size: AppSizes.body,
          color: AppColors.white,
          weight: FontWeight.w700,
        ),
        content: MyText(
          AppText.staffDeleteMessage,
          font: AppFont.sourceSans,
          size: AppSizes.subtitle,
          color: AppColors.textHint,
          height: 1.4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const MyText(
              AppText.ledgerDeleteCancel,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const MyText(
              AppText.staffDeleteConfirm,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.error,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    onDelete(member.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SharedBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            member.name,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w700,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          MyText(
            member.displayLogin,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: AppColors.textHint,
            align: TextAlign.center,
          ),
          SizedBox(height: context.h * 2),
          MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusMd,
            blur: 16,
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  member.ledgerCountLabel(assignedLedgerCount),
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.secondary,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: AppSizes.sm),
                const MyText(
                  AppText.staffManageLedgerHint,
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  height: 1.4,
                ),
              ],
            ),
          ),
          SizedBox(height: context.h * 2),
          MyButton(
            text: AppText.staffDeleteConfirm,
            color: AppColors.error,
            onTap: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
}
