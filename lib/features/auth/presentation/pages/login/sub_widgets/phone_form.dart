import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/utils/app_validators.dart';
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


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            title: AppText.phoneLabel,
            hintText: AppText.phoneHint,
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primary,
            ),
            validator: AppValidators.phone,
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: AppText.phoneSendOtp,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                context.go('/otp/${widget.controller.text.trim()}');
              }
            },
          ),
        ],
      ),
    );
  }
}
