import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';

typedef OnPartyNameAdded = void Function(String name);

class AddPartyNameSheet extends StatefulWidget {
  final String title;
  final String label;
  final String hint;
  final OnPartyNameAdded onAdd;

  const AddPartyNameSheet({
    super.key,
    required this.title,
    required this.label,
    required this.hint,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String label,
    required String hint,
    required OnPartyNameAdded onAdd,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPartyNameSheet(
        title: title,
        label: label,
        hint: hint,
        onAdd: onAdd,
      ),
    );
  }

  @override
  State<AddPartyNameSheet> createState() => _AddPartyNameSheetState();
}

class _AddPartyNameSheetState extends State<AddPartyNameSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(_nameController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SharedBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              widget.title,
              font: AppFont.inter,
              size: AppSizes.header3,
              color: AppColors.white,
              weight: FontWeight.bold,
              align: TextAlign.center,
            ),
            SizedBox(height: context.h * 2.5),
            MyTextField(
              title: widget.label,
              hintText: widget.hint,
              controller: _nameController,
              keyboardType: TextInputType.name,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.ledgerPartyRequired;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 3),
            MyButton(
              text: AppText.ledgerDetailAddButton,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
