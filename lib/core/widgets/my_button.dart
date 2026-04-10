import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'my_text.dart';

enum MyButtonVariant { filled, outlined }

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final MyButtonVariant variant;
  final double? width;
  final double? height;
  final bool loading;
  final Widget? icon;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
    this.borderColor,
    this.variant = MyButtonVariant.filled,
    this.width,
    this.height,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.primary;
    final fgColor = textColor ?? AppColors.white;
    final btnHeight = height ?? AppSizes.buttonHeight;

    if (variant == MyButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, btnHeight),
          side: BorderSide(color: borderColor ?? bgColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
        ),
        child: _child(fgColor == AppColors.white ? bgColor : fgColor),
      );
    }

    return ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: Size(width ?? double.infinity, btnHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      child: _child(fgColor),
    );
  }

  Widget _child(Color color) {
    if (loading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          MyText(
            text,
            font: AppFont.inter,
            size: AppSizes.subtitle,
            color: color,
            weight: FontWeight.w600,
          ),
        ],
      );
    }
    return MyText(
      text,
      font: AppFont.inter,
      size: AppSizes.subtitle,
      color: color,
      weight: FontWeight.w600,
    );
  }
}
