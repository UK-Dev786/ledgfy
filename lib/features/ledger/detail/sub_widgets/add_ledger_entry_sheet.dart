import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';
import '../../models/ledger_accounting_mode.dart';
import '../../models/ledger_entry.dart';
import '../../models/ledger_type_config.dart';
import 'expense_category_picker.dart';

typedef OnLedgerEntryAdded = void Function(LedgerEntryDraft draft);

class AddLedgerEntrySheet extends StatefulWidget {
  final LedgerTypeConfig config;
  final LedgerEntryType type;
  final OnLedgerEntryAdded onAdd;
  final String? partyName;

  const AddLedgerEntrySheet({
    super.key,
    required this.config,
    required this.type,
    required this.onAdd,
    this.partyName,
  });

  static Future<void> show(
    BuildContext context, {
    required LedgerTypeConfig config,
    required LedgerEntryType type,
    required OnLedgerEntryAdded onAdd,
    String? partyName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddLedgerEntrySheet(
        config: config,
        type: type,
        onAdd: onAdd,
        partyName: partyName,
      ),
    );
  }

  bool get _isCredit => config.creditTypes.contains(type);

  Color get _accentColor =>
      _isCredit ? config.creditColor : config.debitColor;

  IconData get _icon => config.iconForEntry(type);

  String get _title {
    if (config.isExpenseOnly) return config.addDebitTitle;
    return _isCredit ? config.addCreditTitle : config.addDebitTitle;
  }

  @override
  State<AddLedgerEntrySheet> createState() => _AddLedgerEntrySheetState();
}

class _AddLedgerEntrySheetState extends State<AddLedgerEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _partyController = TextEditingController();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;

  LedgerTypeConfig get _config => widget.config;
  bool get _inPartyContext => widget.partyName != null;
  bool get _showNameField =>
      !_inPartyContext &&
      !_config.requiresParty &&
      !_config.isExpenseOnly &&
      _config.mode != LedgerAccountingMode.cashBook;

  @override
  void dispose() {
    _amountController.dispose();
    _partyController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _buildNote() {
    final name = _showNameField
        ? _nameController.text.trim()
        : '';
    final desc = _noteController.text.trim();
    if (name.isNotEmpty && desc.isNotEmpty) return '$name · $desc';
    if (name.isNotEmpty) return name;
    if (desc.isNotEmpty) return desc;
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final party = _inPartyContext
        ? widget.partyName
        : (_partyController.text.trim().isEmpty
              ? null
              : _partyController.text.trim());

    widget.onAdd(
      LedgerEntryDraft(
        amount: double.parse(_amountController.text.trim()),
        type: widget.type,
        partyName: party,
        note: _buildNote(),
        category: _selectedCategory,
      ),
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
            Center(
              child: Icon(
                widget._icon,
                color: widget._accentColor,
                size: AppSizes.iconLg,
              ),
            ),
            SizedBox(height: context.h * 1.5),
            MyText(
              widget._title,
              font: AppFont.inter,
              size: AppSizes.header3,
              color: AppColors.white,
              weight: FontWeight.bold,
              align: TextAlign.center,
            ),
            if (_inPartyContext) ...[
              SizedBox(height: context.h * 1),
              MyText(
                widget.partyName!,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                align: TextAlign.center,
              ),
            ],
            SizedBox(height: context.h * 2.5),
            if (!_inPartyContext && _config.requiresParty) ...[
              MyTextField(
                title: _config.partyLabel,
                hintText: _config.partyHint,
                controller: _partyController,
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
              SizedBox(height: context.h * 2),
            ],
            if (!_inPartyContext && _config.requiresCategory) ...[
              MyText(
                AppText.ledgerExpenseCategoryLabel,
                font: AppFont.inter,
                size: AppSizes.body,
                color: AppColors.white,
                weight: FontWeight.w600,
              ),
              SizedBox(height: context.h * 1.2),
              ExpenseCategoryPicker(
                selected: _selectedCategory,
                onSelected: (value) => setState(() => _selectedCategory = value),
              ),
              SizedBox(height: context.h * 2),
            ],
            if (_showNameField) ...[
              MyTextField(
                title: AppText.ledgerEntryNameLabel,
                hintText: AppText.ledgerEntryNameHint,
                controller: _nameController,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.label_outline_rounded,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: context.h * 2),
            ],
            MyTextField(
              title: AppText.ledgerDetailAmountLabel,
              hintText: AppText.ledgerDetailAmountHint,
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icon(
                widget._icon,
                color: widget._accentColor,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.ledgerDetailAmountRequired;
                }
                final amount = double.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return AppText.ledgerDetailAmountInvalid;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 2),
            MyTextField(
              title: AppText.ledgerDescriptionLabel,
              hintText: AppText.ledgerDescriptionHint,
              controller: _noteController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.notes_outlined,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.h * 3),
            MyButton(
              text: AppText.ledgerDetailAddButton,
              color: widget._accentColor,
              onTap: () {
                if (_config.requiresCategory && _selectedCategory == null) {
                  context.popMsg(
                    AppText.ledgerCategoryRequired,
                    color: AppColors.error,
                    icon: Icons.error_outline_rounded,
                  );
                  return;
                }
                _submit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
