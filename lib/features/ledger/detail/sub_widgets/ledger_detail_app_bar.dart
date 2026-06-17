import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/rounded_button.dart';
import '../../shared/sub_widgets/ledger_amount_toggle_button.dart';
import 'ledger_delete_dialog.dart';

class LedgerDetailAppBar extends StatelessWidget {
  final String title;
  final bool showFullAmounts;
  final bool showDeleteMenu;
  final VoidCallback onBack;
  final VoidCallback onToggleAmounts;
  final VoidCallback onDelete;

  const LedgerDetailAppBar({
    super.key,
    required this.title,
    required this.showFullAmounts,
    this.showDeleteMenu = true,
    required this.onBack,
    required this.onToggleAmounts,
    required this.onDelete,
  });

  Future<void> _handleMenu(BuildContext context, String value) async {
    if (value == 'delete') {
      final confirmed = await LedgerDeleteDialog.show(context);
      if (confirmed) onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        showDeleteMenu ? AppSizes.xs : AppSizes.md,
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
          LedgerAmountToggleButton(
            showFullAmounts: showFullAmounts,
            onToggle: onToggleAmounts,
          ),
          if (showDeleteMenu)
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
              onSelected: (value) => _handleMenu(context, value),
              itemBuilder: (_) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: AppColors.error),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        AppText.ledgerDeleteLedger,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
