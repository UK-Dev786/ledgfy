import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class PhoneForm extends StatefulWidget {
  final TextEditingController controller;
  const PhoneForm({super.key, required this.controller});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.replaceAll(RegExp(r'[\s\-\+]'), '');
    if (digits.length < 10) {
      return 'Enter a valid phone number';
    }
    if (!RegExp(r'^[\d\s\+\-]+$').hasMatch(value)) {
      return 'Only digits, spaces, + and - are allowed';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            title: 'Phone Number',
            hintText: 'Enter your phone number',
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primary,
            ),
            validator: _validatePhone,
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: 'Send OTP',
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implement phone OTP logic
              }
            },
          ),
        ],
      ),
    );
  }
}
