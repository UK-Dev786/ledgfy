import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final String? title;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.title,
    this.onChanged,
    this.validator,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Inter',
              fontSize: AppSizes.subtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          _buildField(),
        ],
      );
    }
    return _buildField();
  }

  Widget _buildField() {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: const TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontSize: AppSizes.body,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.textHint),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: const Color(0xFF0A181C),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textHint,
                  size: AppSizes.iconMd,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(
            color: AppColors.textHint.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(
            color: AppColors.textHint.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
