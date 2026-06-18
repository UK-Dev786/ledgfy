import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/my_text_field.dart';
import '../../../core/widgets/shared_bottom_sheet.dart';

enum ProfileEditField { name, username, accountType }

abstract final class ProfileEditSheet {
  static Future<void> show(
    BuildContext context, {
    required ProfileEditField field,
    required String initialValue,
    required ValueChanged<String> onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileEditSheet(
        field: field,
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }
}

class _ProfileEditSheet extends StatefulWidget {
  final ProfileEditField field;
  final String initialValue;
  final ValueChanged<String> onSave;

  const _ProfileEditSheet({
    required this.field,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
  late final TextEditingController _controller;
  late String _accountType;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _accountType = widget.initialValue.isEmpty
        ? AppText.accountTypeIndividual
        : widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title => switch (widget.field) {
        ProfileEditField.name => AppText.profileEditName,
        ProfileEditField.username => AppText.profileEditUsername,
        ProfileEditField.accountType => AppText.profileEditAccountType,
      };

  void _submit() {
    final value = widget.field == ProfileEditField.accountType
        ? _accountType
        : _controller.text.trim();
    if (value.isEmpty) return;
    widget.onSave(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SharedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            _title,
            font: AppFont.inter,
            size: AppSizes.title,
            color: AppColors.white,
            weight: FontWeight.w700,
            align: TextAlign.center,
          ),
          SizedBox(height: context.h * 2.5),
          if (widget.field == ProfileEditField.accountType) ...[
            _AccountTypeOption(
              title: AppText.accountTypeIndividual,
              subtitle: AppText.profileAccountTypeIndividualHint,
              icon: Icons.person_outline_rounded,
              selected: _accountType == AppText.accountTypeIndividual,
              onTap: () => setState(
                () => _accountType = AppText.accountTypeIndividual,
              ),
            ),
            SizedBox(height: context.h * 1.2),
            _AccountTypeOption(
              title: AppText.accountTypeOrganization,
              subtitle: AppText.profileAccountTypeOrganizationHint,
              icon: Icons.storefront_outlined,
              selected: _accountType == AppText.accountTypeOrganization,
              onTap: () => setState(
                () => _accountType = AppText.accountTypeOrganization,
              ),
            ),
          ] else
            MyTextField(
              title: widget.field == ProfileEditField.username
                  ? AppText.usernameLabel
                  : AppText.enterFullName,
              hintText: widget.field == ProfileEditField.username
                  ? AppText.usernameHint
                  : AppText.nameHint,
              controller: _controller,
              keyboardType: TextInputType.name,
              prefixIcon: Icon(
                widget.field == ProfileEditField.username
                    ? Icons.alternate_email_rounded
                    : Icons.person_outline_rounded,
                color: AppColors.primary,
              ),
            ),
          SizedBox(height: context.h * 3),
          MyButton(
            text: AppText.profileSave,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

class _AccountTypeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AccountTypeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.textHint.withValues(alpha: 0.2),
            ),
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
                      font: AppFont.inter,
                      size: AppSizes.body,
                      color: AppColors.white,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    MyText(
                      subtitle,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                      height: 1.35,
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? AppColors.primary : AppColors.textHint,
                size: AppSizes.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
