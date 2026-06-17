import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ledger/models/ledger_item.dart';

class LedgersNotifier extends StateNotifier<List<LedgerItem>> {
  LedgersNotifier() : super(const []);

  void add(LedgerItem ledger) {
    state = [...state, ledger];
  }

  void remove(String id) {
    state = state.where((ledger) => ledger.id != id).toList();
  }

  void notifyChanged() {
    state = [...state];
  }
}

final ledgersProvider =
    StateNotifierProvider<LedgersNotifier, List<LedgerItem>>(
  (ref) => LedgersNotifier(),
);
