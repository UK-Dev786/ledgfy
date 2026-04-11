import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class EmailForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const EmailForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppText.emailRequired;
    }
    if (!RegExp(
      r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return AppText.emailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppText.passwordRequired;
    }
    if (value.length < 6) {
      return AppText.passwordTooShort;
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
            title: AppText.emailLabel,
            hintText: AppText.emailHint,
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
            ),
            validator: _validateEmail,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.passwordLabel,
            hintText: AppText.passwordHint,
            controller: widget.passwordController,
            obscure: true,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            validator: _validatePassword,
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: AppText.signIn,
            onTap: () {
              if (_formKey.currentState!.validate()) {}
            },
          ),
        ],
      ),
    );
  }
}
