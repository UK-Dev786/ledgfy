import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/app_validators.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/my_text_field.dart';
import '../../../core/widgets/shared_bottom_sheet.dart';
import '../models/staff_member.dart';

typedef OnStaffCreated = void Function(StaffMember member);

class InviteStaffSheet extends StatefulWidget {
  final OnStaffCreated onCreate;

  const InviteStaffSheet({
    super.key,
    required this.onCreate,
  });

  static Future<void> show(
    BuildContext context, {
    required OnStaffCreated onCreate,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteStaffSheet(onCreate: onCreate),
    );
  }

  @override
  State<InviteStaffSheet> createState() => _InviteStaffSheetState();
}

class _InviteStaffSheetState extends State<InviteStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _loginEmailValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppText.staffLoginRequired;
    if (trimmed.contains(' ')) return AppText.staffLoginRequired;
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final member = StaffMember(
      id: 'staff-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      loginEmail: _emailController.text.trim().toLowerCase(),
      status: StaffMemberStatus.active,
      joinedAt: DateTime.now(),
    );

    widget.onCreate(member);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SharedBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MyText(
              AppText.staffInviteTitle,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            const MyText(
              AppText.staffInviteLedgerNote,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
              height: 1.4,
              align: TextAlign.center,
            ),
            SizedBox(height: context.h * 2),
            MyTextField(
              title: AppText.staffInviteNameLabel,
              hintText: AppText.staffInviteNameHint,
              controller: _nameController,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.enterFullName;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 1.5),
            MyTextField(
              title: AppText.staffInviteUsernameLabel,
              hintText: AppText.staffInviteUsernameHint,
              controller: _usernameController,
              prefixIcon: const Icon(
                Icons.alternate_email_rounded,
                color: AppColors.primary,
              ),
              validator: AppValidators.username,
            ),
            SizedBox(height: context.h * 1.5),
            MyTextField(
              title: AppText.staffInviteEmailLabel,
              hintText: AppText.staffInviteEmailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.primary,
              ),
              validator: _loginEmailValidator,
            ),
            const SizedBox(height: AppSizes.sm),
            const MyText(
              AppText.staffInviteEmailNote,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
              height: 1.4,
            ),
            SizedBox(height: context.h * 1.5),
            MyTextField(
              title: AppText.staffInvitePasswordLabel,
              hintText: AppText.staffInvitePasswordHint,
              controller: _passwordController,
              obscure: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
              ),
              validator: AppValidators.password,
            ),
            SizedBox(height: context.h * 1.5),
            MyTextField(
              title: AppText.staffInviteConfirmPasswordLabel,
              hintText: AppText.staffInviteConfirmPasswordHint,
              controller: _confirmPasswordController,
              obscure: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
              ),
              validator: AppValidators.confirmPassword(
                () => _passwordController.text,
              ),
            ),
            SizedBox(height: context.h * 2),
            MyButton(
              text: AppText.staffInviteCreate,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
