import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/my_text_field.dart';
import '../../../core/widgets/shared_bottom_sheet.dart';
import '../models/ledger_entry.dart';

typedef OnAmountAdded = void Function(double amount);

class AddLedgerAmountSheet extends StatefulWidget {
  final LedgerEntryType type;
  final OnAmountAdded onAdd;

  const AddLedgerAmountSheet({
    super.key,
    required this.type,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required LedgerEntryType type,
    required OnAmountAdded onAdd,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddLedgerAmountSheet(type: type, onAdd: onAdd),
    );
  }

  bool get _isIncome => type == LedgerEntryType.income;

  Color get _accentColor =>
      _isIncome ? AppColors.success : AppColors.error;

  IconData get _icon => _isIncome
      ? Icons.arrow_upward_rounded
      : Icons.arrow_downward_rounded;

  String get _title => _isIncome
      ? AppText.ledgerDetailAddIncome
      : AppText.ledgerDetailAddOutgoing;

  @override
  State<AddLedgerAmountSheet> createState() => _AddLedgerAmountSheetState();
}

class _AddLedgerAmountSheetState extends State<AddLedgerAmountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    widget.onAdd(amount);
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
            SizedBox(height: context.h * 2.5),
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
            SizedBox(height: context.h * 3),
            MyButton(
              text: AppText.ledgerDetailAddButton,
              color: widget._accentColor,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
