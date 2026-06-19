import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../models/app_sync_status.dart';
import 'my_text.dart';

class SyncStatusBadge extends StatelessWidget {
  final AppSyncStatus status;

  const SyncStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: status.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: AppSizes.iconSm, color: status.color),
          const SizedBox(width: AppSizes.xs),
          MyText(
            status.label,
            font: AppFont.sourceSans,
            size: AppSizes.caption,
            color: status.color,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
