import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/app_sync_status.dart';
import 'ledger_providers.dart';

/// Online when any network interface is available.
final connectivityOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  final initial = await connectivity.checkConnectivity();
  yield initial.any((result) => result != ConnectivityResult.none);
  yield* connectivity.onConnectivityChanged.map(
    (results) => results.any((result) => result != ConnectivityResult.none),
  );
});

/// True when entry writes are still queued locally (not yet on server).
final pendingWritesProvider = StreamProvider<bool>((ref) {
  ref.watch(ledgersStreamProvider);
  return ref.watch(ledgerRemoteDataSourceProvider).pendingWrites;
});

/// Reactive merge of connectivity + Firestore pending entry writes.
final appSyncStatusProvider = StreamProvider<AppSyncStatus>((ref) {
  ref.watch(ledgersStreamProvider);

  final connectivity = Connectivity();
  final pendingStream = ref.watch(ledgerRemoteDataSourceProvider).pendingWrites;

  StreamSubscription<bool>? pendingSub;
  StreamSubscription<List<ConnectivityResult>>? connectivitySub;

  var isOnline = true;
  var hasPendingWrites = false;

  final controller = StreamController<AppSyncStatus>();

  void emit() {
    if (controller.isClosed) return;
    controller.add(
      AppSyncStatus(
        isOnline: isOnline,
        hasPendingWrites: hasPendingWrites,
      ),
    );
  }

  controller.onListen = () async {
    final initial = await connectivity.checkConnectivity();
    isOnline = initial.any((result) => result != ConnectivityResult.none);

    pendingSub = pendingStream.listen((pending) {
      hasPendingWrites = pending;
      emit();
    });

    connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      isOnline = results.any((result) => result != ConnectivityResult.none);
      emit();
    });

    emit();
  };

  ref.onDispose(() async {
    await pendingSub?.cancel();
    await connectivitySub?.cancel();
    await controller.close();
  });

  return controller.stream;
});
