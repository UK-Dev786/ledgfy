import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../home_mock_data.dart';
import 'home_record_tile.dart';

class HomeRecentRecords extends StatefulWidget {
  final List<MockLedgerEntry> entries;

  const HomeRecentRecords({super.key, required this.entries});

  @override
  State<HomeRecentRecords> createState() => _HomeRecentRecordsState();
}

class _HomeRecentRecordsState extends State<HomeRecentRecords>
    with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final List<AnimationController> _tileControllers;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _tileControllers = List.generate(
      widget.entries.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
    );
    unawaited(_startAnimations());
  }

  Future<void> _startAnimations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _headerController.forward();
    for (var i = 0; i < _tileControllers.length; i++) {
      Future<void>.delayed(Duration(milliseconds: 360 + (i * 60)), () {
        if (mounted) _tileControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    for (final controller in _tileControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerCurve = CurvedAnimation(parent: _headerController, curve: Curves.easeOut);

    return Column(
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(headerCurve),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(headerCurve),
            child: Row(
              children: [
                Expanded(
                  child: MyText(
                    AppText.homeRecentRecords,
                    font: AppFont.inter,
                    size: AppSizes.title,
                    color: AppColors.white,
                    weight: FontWeight.w700,
                  ),
                ),
                MyText(
                  AppText.homeSeeAll,
                  font: AppFont.inter,
                  size: AppSizes.subtitle,
                  color: AppColors.primary,
                  weight: FontWeight.w600,
                  isOnTap: true,
                  onTap: () {
                    // TODO: navigate to Ledger tab.
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        ...List.generate(widget.entries.length, (index) {
          final curve = CurvedAnimation(
            parent: _tileControllers[index],
            curve: Curves.easeOut,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.md),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(curve),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(curve),
                child: HomeRecordTile(entry: widget.entries[index]),
              ),
            ),
          );
        }),
      ],
    );
  }
}
