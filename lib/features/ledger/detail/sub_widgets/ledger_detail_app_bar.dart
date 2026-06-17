import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/my_text.dart';
import '../../models/ledger_item.dart';
import '../../../../core/widgets/rounded_button.dart';

class LedgerDetailAppBar extends StatelessWidget {
  final LedgerItem ledger;
  final VoidCallback onBack;

  const LedgerDetailAppBar({
    super.key,
    required this.ledger,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
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
              ledger.title,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textHint,
              size: AppSizes.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}
