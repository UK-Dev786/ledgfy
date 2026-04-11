import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class EmailForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const EmailForm({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
          hintText: 'you@example.com',
          labelText: 'Email Address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: context.h * 1.5),
        MyTextField(
          hintText: '••••••••',
          labelText: 'Password',
          controller: passwordController,
          obscure: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
        SizedBox(height: context.h * 2.5),
        MyButton(text: 'Sign In', onTap: () {}),
      ],
    );
  }
}
