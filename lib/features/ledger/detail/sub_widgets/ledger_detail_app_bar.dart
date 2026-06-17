import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/rounded_button.dart';
import '../../shared/sub_widgets/ledger_amount_toggle_button.dart';

class LedgerAppBarMenuOption {
  final String id;
  final String label;
  final IconData icon;
  final Color? color;

  const LedgerAppBarMenuOption({
    required this.id,
    required this.label,
    required this.icon,
    this.color,
  });
}

class LedgerDetailAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final bool showHistoryButton;
  final VoidCallback? onHistoryTap;
  final bool showAmountToggle;
  final bool showFullAmounts;
  final VoidCallback? onToggleAmounts;
  final List<LedgerAppBarMenuOption> menuOptions;
  final ValueChanged<String>? onMenuSelected;

  const LedgerDetailAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.showHistoryButton = false,
    this.onHistoryTap,
    this.showAmountToggle = false,
    this.showFullAmounts = false,
    this.onToggleAmounts,
    this.menuOptions = const [],
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final hasMenu = menuOptions.isNotEmpty && onMenuSelected != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        hasMenu ? AppSizes.xs : AppSizes.md,
        AppSizes.md,
      ),
      child: Row(
        children: [
          RoundedButton(
            onTap: onBack,
            icon: Icons.arrow_back_rounded,
            size: 44,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: MyText(
              title,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showHistoryButton && onHistoryTap != null)
            IconButton(
              onPressed: onHistoryTap,
              tooltip: AppText.ledgerDetailHistory,
              icon: const Icon(
                Icons.history_rounded,
                color: AppColors.textHint,
                size: AppSizes.iconMd,
              ),
            ),
          if (showAmountToggle && onToggleAmounts != null)
            LedgerAmountToggleButton(
              showFullAmounts: showFullAmounts,
              onToggle: onToggleAmounts!,
            ),
          if (hasMenu)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textHint,
                size: AppSizes.iconMd,
              ),
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              onSelected: onMenuSelected,
              itemBuilder: (_) => menuOptions
                  .map(
                    (option) => PopupMenuItem<String>(
                      value: option.id,
                      child: Row(
                        children: [
                          Icon(
                            option.icon,
                            color: option.color ?? AppColors.textHint,
                            size: AppSizes.iconSm,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            option.label,
                            style: TextStyle(
                              color: option.color ?? AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
