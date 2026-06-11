import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/extensions/popup_extensions.dart';
import '../../../../../../core/utils/app_validators.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class SignupEmailForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignupEmailForm({
    super.key,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<SignupEmailForm> createState() => _SignupEmailFormState();
}

class _SignupEmailFormState extends State<SignupEmailForm> {
  final _formKey = GlobalKey<FormState>();
  String? _accountType;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_accountType == null) return;

    // TODO: wire Firebase sign-up + send verification email
    if (!mounted) return;

    await context.popSignUpVerification(
      onLogin: () => context.go('/login'),
      onResend: () async {
        // TODO: wire resend verification email
        if (!mounted) return;
        await context.popSuccess(AppText.verificationResent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            title: AppText.enterFullName,
            hintText: AppText.nameHint,
            controller: widget.nameController,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
            validator: AppValidators.name,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.usernameLabel,
            hintText: AppText.usernameHint,
            controller: widget.usernameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.alternate_email, color: AppColors.primary),
            validator: AppValidators.username,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.emailLabel,
            hintText: AppText.emailHint,
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
            validator: AppValidators.email,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.accountTypeLabel,
            hintText: AppText.accountTypeHint,
            prefixIcon: const Icon(Icons.business_center_outlined, color: AppColors.primary),
            dropdownItems: const [
              AppText.accountTypeIndividual,
              AppText.accountTypeOrganization,
            ],
            dropdownValue: _accountType,
            onDropdownChanged: (val) => setState(() => _accountType = val),
            validator: AppValidators.accountType,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.passwordLabel,
            hintText: AppText.passwordHint,
            controller: widget.passwordController,
            obscure: true,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            validator: AppValidators.password,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.confirmPasswordLabel,
            hintText: AppText.confirmPasswordHint,
            controller: widget.confirmPasswordController,
            obscure: true,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            validator: AppValidators.confirmPassword(
              () => widget.passwordController.text,
            ),
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: AppText.signUp,
            onTap: _signUp,
          ),
        ],
      ),
    );
  }
}
