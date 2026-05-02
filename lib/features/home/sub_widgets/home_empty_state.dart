import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';

class HomeEmptyState extends StatefulWidget {
  const HomeEmptyState({super.key});

  @override
  State<HomeEmptyState> createState() => _HomeEmptyStateState();
}

class _HomeEmptyStateState extends State<HomeEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fade = Tween(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved);
    unawaited(_startAnimation());
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MyCard(
          borderRadius: AppSizes.radiusLg,
          child: Column(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.textHint,
                size: AppSizes.iconLg,
              ),
              const SizedBox(height: AppSizes.md),
              MyText(
                AppText.homeNoRecordsTitle,
                font: AppFont.inter,
                size: AppSizes.title,
                color: AppColors.white,
                weight: FontWeight.w700,
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              MyText(
                AppText.homeNoRecordsSubtitle,
                font: AppFont.sourceSans,
                size: AppSizes.subtitle,
                color: AppColors.textHint,
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),
              MyButton(
                text: AppText.homeAddFirstRecord,
                onTap: () {
                  // TODO: navigate to Add Ledger Entry.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
