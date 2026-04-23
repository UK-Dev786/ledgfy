import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/utils/app_validators.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class SignupEmailForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupEmailForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignupEmailForm> createState() => _SignupEmailFormState();
}

class _SignupEmailFormState extends State<SignupEmailForm> {
  final _formKey = GlobalKey<FormState>();

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
            validator: AppValidators.email,
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
            validator: AppValidators.password,
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: AppText.signUp,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implement email signup logic
              }
            },
          ),
        ],
      ),
    );
  }
}
