import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../home_screen.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onProfileTap: () => setState(() => _currentIndex = 3)),
          const _PlaceholderTab(
            icon: Icons.menu_book_rounded,
            label: AppText.homeLedgersTab,
          ),
          const _PlaceholderTab(
            icon: Icons.insert_chart_outlined_rounded,
            label: AppText.homeAnalyticsTab,
          ),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            0,
            AppSizes.md,
            AppSizes.md,
          ),
          child: MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusFull,
            blur: 30,
            padding: const EdgeInsets.all(AppSizes.xs + 1),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  selected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.menu_book_rounded,
                  selected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.insert_chart_outlined_rounded,
                  selected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  selected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
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
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 1.2,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: AppSizes.iconMd,
            color: selected ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlaceholderTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppSizes.iconLg, color: AppColors.primary),
                const SizedBox(height: AppSizes.md),
                MyText(
                  label,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: AppSizes.xs),
                MyText(
                  AppText.homeComingSoon,
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
