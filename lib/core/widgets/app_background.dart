import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// LIGHT PROFESSIONAL THEME - Vibrant Green/Teal Fintech Design
/// Clean, bright background with white cards
/// Professional banking aesthetic for all-day use
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Light professional background - clean & bright
        color: Color(0xFFF5F7FA),
      ),
      child: child,
    );
  }
}
