import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text.dart';
import '../../../../../../core/utils/app_validators.dart';
import '../../../../../../core/widgets/my_button.dart';
import '../../../../../../core/widgets/my_text_field.dart';

class SignupPhoneForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const SignupPhoneForm({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  State<SignupPhoneForm> createState() => _SignupPhoneFormState();
}

class _SignupPhoneFormState extends State<SignupPhoneForm> {
  final _formKey = GlobalKey<FormState>();
  String? _accountType;

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
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
            ),
            validator: AppValidators.name,
          ),
          SizedBox(height: context.h * 1.5),
          MyTextField(
            title: AppText.accountTypeLabel,
            hintText: AppText.accountTypeHint,
            prefixIcon: const Icon(
              Icons.business_center_outlined,
              color: AppColors.primary,
            ),
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
            title: AppText.phoneLabel,
            hintText: AppText.phoneHint,
            controller: widget.phoneController,
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
                // TODO: Implement phone OTP logic
              }
            },
          ),
        ],
      ),
    );
  }
}
