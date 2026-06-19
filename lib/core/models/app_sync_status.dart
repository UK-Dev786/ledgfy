import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text.dart';

/// Combines network + Firestore local-write state for sync UI.
class AppSyncStatus {
  final bool isOnline;
  final bool hasPendingWrites;

  const AppSyncStatus({
    required this.isOnline,
    required this.hasPendingWrites,
  });

  bool get isSynced => isOnline && !hasPendingWrites;

  String get label {
    if (!isOnline) {
      return hasPendingWrites
          ? AppText.syncOfflinePending
          : AppText.syncOffline;
    }
    if (hasPendingWrites) return AppText.syncSyncing;
    return AppText.syncSynced;
  }

  Color get color {
    if (!isOnline) return AppColors.textHint;
    if (hasPendingWrites) return const Color(0xFFE8A838);
    return AppColors.success;
  }

  IconData get icon {
    if (!isOnline) return Icons.cloud_off_outlined;
    if (hasPendingWrites) return Icons.cloud_sync_outlined;
    return Icons.cloud_done_outlined;
  }
}
