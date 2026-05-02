import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';

class HomeGreetingHeader extends StatefulWidget {
  final String userName;
  final VoidCallback onProfileTap;

  const HomeGreetingHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
  });

  @override
  State<HomeGreetingHeader> createState() => _HomeGreetingHeaderState();
}

class _HomeGreetingHeaderState extends State<HomeGreetingHeader>
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
    _slide = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curved);
    unawaited(Future<void>.delayed(Duration.zero, _controller.forward));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 12 && hour <= 17) return AppText.homeGreetingAfternoon;
    if (hour >= 18) return AppText.homeGreetingEvening;
    return AppText.homeGreetingMorning;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          AppSizes.sm,
        ),
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        _greeting + ",",
                        font: AppFont.sourceSans,
                        size: AppSizes.subtitle,
                        color: AppColors.textHint,
                        weight: FontWeight.w500,
                      ),
                      const SizedBox(height: AppSizes.xs),
                      MyText(
                        widget.userName,
                        font: AppFont.inter,
                        size: AppSizes.header2,
                        color: AppColors.white,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: widget.onProfileTap,
                      child: CircleAvatar(
                        radius: AppSizes.lg,
                        backgroundColor: AppColors.primaryDark.withValues(
                          alpha: 0.2,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primary,
                          size: AppSizes.iconMd,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    MyText(
                      DateFormat('MMM yyyy').format(DateTime.now()),
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
