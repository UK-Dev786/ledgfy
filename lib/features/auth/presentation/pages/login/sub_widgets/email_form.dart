import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
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
      return 'Email address is required';
    }
    if (!RegExp(
      r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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
            title: 'Email Address',
            hintText: 'Enter your email address',
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
            title: 'Password',
            hintText: 'Enter your password',
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
            text: 'Sign In',
            onTap: () {
              if (_formKey.currentState!.validate()) {}
            },
          ),
        ],
      ),
    );
  }
}
