import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class PhoneForm extends StatelessWidget {
  final TextEditingController controller;
  const PhoneForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
          title: 'Phone Number',
          hintText: 'Enter your phone number',
          controller: controller,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: context.h * 2.5),
        MyButton(text: 'Send OTP', onTap: () {}),
      ],
    );
  }
}
