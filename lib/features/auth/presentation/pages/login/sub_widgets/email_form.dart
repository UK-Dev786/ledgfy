import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/utils/app_validators.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text.dart';
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
          SizedBox(height: context.h * 1.5),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: MyText(
              isOnTap: true,
              onTap: () => context.push('/forgot-password'),
              AppText.forgotPassword,
              font: AppFont.sourceSans,
              size: AppSizes.body,
              color: AppColors.primary,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.h * 2.5),
          MyButton(
            text: AppText.signIn,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                context.go('/home');
              }
            },
          ),
        ],
      ),
    );
  }
}
