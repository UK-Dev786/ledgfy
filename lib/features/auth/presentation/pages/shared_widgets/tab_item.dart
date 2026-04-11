import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/my_card.dart';
import '../../../../../core/widgets/my_text.dart';

class TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            // borderRadius: BorderRadius.horizontal(
            //   right: selected ? Radius.zero : Radius.zero,
            // ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          // SizedBox.expand makes the container fill the full height of MyCard
          child: SizedBox.expand(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconSm,
                  color: selected ? AppColors.white : AppColors.textHint,
                ),
                const SizedBox(width: 6),
                MyText(
                  label,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: selected ? AppColors.white : AppColors.textHint,
                  weight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ],
            ),
          ), // SizedBox.expand
        ), // AnimatedContainer
      ), // GestureDetector
    ); // Expanded
  }
}

class TabSwitcher extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSwitch;

  const TabSwitcher({required this.currentTab, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusMd,
      blur: 30,
      height: 45,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          TabItem(
            label: 'Phone',
            icon: Icons.phone_outlined,
            selected: currentTab == 0,
            onTap: () => onSwitch(0),
          ),
          TabItem(
            label: 'Email',
            icon: Icons.email_outlined,
            selected: currentTab == 1,
            onTap: () => onSwitch(1),
          ),
        ],
      ),
    );
  }
}
