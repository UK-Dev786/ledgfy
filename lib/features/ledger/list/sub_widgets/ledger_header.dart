import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/models/app_sync_status.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/shared_entrance_animation.dart';
import '../../../../core/widgets/sync_status_badge.dart';
import '../../../../di/sync_providers.dart';

class LedgerHeader extends ConsumerWidget {
  const LedgerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(appSyncStatusProvider);

    return SharedEntranceAnimation(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  AppText.ledgersTitle,
                  font: AppFont.inter,
                  size: AppSizes.header2,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
                SizedBox(height: AppSizes.xs),
                MyText(
                  AppText.ledgersSubtitle,
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          syncStatus.when(
            data: (status) => SyncStatusBadge(status: status),
            loading: () => const SyncStatusBadge(
              status: AppSyncStatus(
                isOnline: true,
                hasPendingWrites: false,
              ),
            ),
            error: (_, __) => const SyncStatusBadge(
              status: AppSyncStatus(
                isOnline: true,
                hasPendingWrites: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
