import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';

typedef OnPartyAdded = void Function(String name, String? description);

class AddPartyNameSheet extends StatefulWidget {
  final String title;
  final String label;
  final String hint;
  final IconData nameIcon;
  final OnPartyAdded onAdd;
  final String? initialName;
  final String? initialDescription;

  const AddPartyNameSheet({
    super.key,
    required this.title,
    required this.label,
    required this.hint,
    this.nameIcon = Icons.person_outline_rounded,
    required this.onAdd,
    this.initialName,
    this.initialDescription,
  });

  bool get _isEditing => initialName != null;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String label,
    required String hint,
    IconData nameIcon = Icons.person_outline_rounded,
    required OnPartyAdded onAdd,
    String? initialName,
    String? initialDescription,
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
        nameIcon: nameIcon,
        onAdd: onAdd,
        initialName: initialName,
        initialDescription: initialDescription,
      ),
    );
  }

  @override
  State<AddPartyNameSheet> createState() => _AddPartyNameSheetState();
}

class _AddPartyNameSheetState extends State<AddPartyNameSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    Navigator.of(context).pop();
    widget.onAdd(name, description.isEmpty ? null : description);
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
              prefixIcon: Icon(
                widget.nameIcon,
                color: AppColors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.ledgerPartyRequired;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 2),
            MyTextField(
              title: AppText.ledgerDescriptionLabel,
              hintText: AppText.ledgerDescriptionHint,
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.notes_outlined,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.h * 3),
            MyButton(
              text: widget._isEditing
                  ? AppText.ledgersSaveButton
                  : AppText.ledgerDetailAddButton,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
