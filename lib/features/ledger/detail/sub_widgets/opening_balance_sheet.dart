import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/shared_bottom_sheet.dart';

typedef OnOpeningBalanceSaved = void Function(double balance);

class OpeningBalanceSheet extends StatefulWidget {
  final double initialBalance;
  final OnOpeningBalanceSaved onSave;

  const OpeningBalanceSheet({
    super.key,
    required this.initialBalance,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialBalance,
    required OnOpeningBalanceSaved onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OpeningBalanceSheet(
        initialBalance: initialBalance,
        onSave: onSave,
      ),
    );
  }

  @override
  State<OpeningBalanceSheet> createState() => _OpeningBalanceSheetState();
}

class _OpeningBalanceSheetState extends State<OpeningBalanceSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialBalance;
    _controller = TextEditingController(
      text: initial == 0 ? '' : initial.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final text = _controller.text.trim();
    final value = text.isEmpty ? 0.0 : double.parse(text);
    Navigator.of(context).pop();
    widget.onSave(value);
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
            const MyText(
              AppText.ledgerOpeningBalanceTitle,
              font: AppFont.inter,
              size: AppSizes.header3,
              color: AppColors.white,
              weight: FontWeight.bold,
              align: TextAlign.center,
            ),
            SizedBox(height: context.h * 1),
            const MyText(
              AppText.ledgerOpeningBalanceSubtitle,
              font: AppFont.sourceSans,
              size: AppSizes.subtitle,
              color: AppColors.textHint,
              height: 1.45,
            ),
            SizedBox(height: context.h * 2.5),
            MyTextField(
              title: AppText.ledgerOpeningBalance,
              hintText: AppText.ledgerOpeningBalanceHint,
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              prefixIcon: const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final parsed = double.tryParse(value.trim());
                if (parsed == null) {
                  return AppText.ledgerOpeningBalanceInvalid;
                }
                return null;
              },
            ),
            SizedBox(height: context.h * 3),
            MyButton(
              text: AppText.ledgerOpeningBalanceSave,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
