import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';
import '../../models/ledger_item.dart';
import '../../models/ledger_type.dart';
import '../../models/ledger_type_config.dart';
import 'ledger_type_picker.dart';

typedef OnLedgerSubmitted = void Function(
  String title,
  LedgerType type,
  String description,
);

class CreateLedgerSheet extends StatefulWidget {
  final LedgerItem? ledger;
  final OnLedgerSubmitted onSubmit;

  const CreateLedgerSheet({
    super.key,
    this.ledger,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    LedgerItem? ledger,
    required OnLedgerSubmitted onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CreateLedgerSheet(
        ledger: ledger,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<CreateLedgerSheet> createState() => _CreateLedgerSheetState();
}

class _CreateLedgerSheetState extends State<CreateLedgerSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late LedgerType _selectedType;

  bool get _isEditing => widget.ledger != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ledger?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.ledger?.description ?? '');
    _selectedType = widget.ledger?.type ?? LedgerType.general;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _titleController.text.trim(),
      _selectedType,
      _descriptionController.text.trim(),
    );
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
            const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
                size: AppSizes.iconLg,
              ),
            ),
            SizedBox(height: context.h * 1.5),
            MyText(
              _isEditing ? AppText.ledgersEditTitle : AppText.ledgersCreateTitle,
              font: AppFont.inter,
              size: AppSizes.header3,
              color: AppColors.white,
              weight: FontWeight.bold,
              align: TextAlign.center,
            ),
            SizedBox(height: context.h * 2.5),
            MyTextField(
              title: AppText.ledgersNameLabel,
              hintText: AppText.ledgersNameHint,
              controller: _titleController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.ledgersNameRequired;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 2),
            MyTextField(
              title: AppText.ledgersDescriptionLabel,
              hintText: AppText.ledgersDescriptionHint,
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.notes_outlined,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.h * 2),
            MyText(
              AppText.ledgersTypeLabel,
              font: AppFont.inter,
              size: AppSizes.body,
              color: AppColors.white,
              weight: FontWeight.w600,
            ),
            SizedBox(height: context.h * 1.2),
            AbsorbPointer(
              absorbing: _isEditing,
              child: Opacity(
                opacity: _isEditing ? 0.55 : 1,
                child: LedgerTypePicker(
                  selected: _selectedType,
                  onSelected: (type) => setState(() => _selectedType = type),
                ),
              ),
            ),
            SizedBox(height: context.h * 1.2),
            MyText(
              LedgerTypeConfig.forType(_selectedType).typeDescription,
              font: AppFont.sourceSans,
              size: AppSizes.caption,
              color: AppColors.textHint,
              height: 1.4,
            ),
            SizedBox(height: context.h * 3),
            MyButton(
              text: _isEditing
                  ? AppText.ledgersSaveButton
                  : AppText.ledgersCreateButton,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
