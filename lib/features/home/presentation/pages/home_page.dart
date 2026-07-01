import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_card.dart';
import '../../../../core/widgets/themed_gradient_bg.dart';
import '../../home_screen.dart';
import '../../../ledger/list/ledger_screen.dart';
import '../../../reports/reports_screen.dart';
import '../../../profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(
              onProfileTap: () => setState(() => _currentIndex = 3),
              onLedgerTap: () => setState(() => _currentIndex = 1),
            ),
            const LedgerScreen(),
            const ReportsScreen(),
            const ProfileScreen(),
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
              border: false,
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
