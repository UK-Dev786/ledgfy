import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../../../di/ledger_providers.dart';
import '../detail/ledger_detail_page.dart';
import '../models/ledger_item.dart';
import 'sub_widgets/create_ledger_sheet.dart';
import 'sub_widgets/ledger_empty_state.dart';
import 'sub_widgets/ledger_fab.dart';
import 'sub_widgets/ledger_header.dart';
import 'sub_widgets/ledger_list_view.dart';
import 'sub_widgets/ledger_type_filter_chips.dart';

class LedgerScreen extends ConsumerStatefulWidget {
  const LedgerScreen({super.key});

  @override
  ConsumerState<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends ConsumerState<LedgerScreen> {
  String? _selectedTypeId;

  List<LedgerItem> get _ledgers => ref.watch(ledgersProvider);

  List<LedgerItem> get _filteredLedgers {
    if (_selectedTypeId == null) return _ledgers;
    return _ledgers
        .where((ledger) => ledger.type.id == _selectedTypeId)
        .toList();
  }

  void _openLedgerDetail(LedgerItem ledger) {
    Navigator.of(context)
        .push<String?>(
          MaterialPageRoute<String?>(
            builder: (_) => LedgerDetailPage(ledger: ledger),
          ),
        )
        .then((deletedId) {
          if (deletedId != null) {
            ref.read(ledgersProvider.notifier).remove(deletedId);
          } else {
            ref.read(ledgersProvider.notifier).notifyChanged();
            setState(() {});
          }
        });
  }

  void _openCreateLedgerSheet() {
    CreateLedgerSheet.show(
      context,
      onCreate: (title, type, description) {
        ref.read(ledgersProvider.notifier).add(
              LedgerItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                description: description,
                type: type,
                createdAt: DateTime.now(),
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLedgers = _ledgers.isNotEmpty;
    final filtered = _filteredLedgers;

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: LedgerFab(onTap: _openCreateLedgerSheet),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg,
              AppSizes.md,
              AppSizes.lg,
              AppSizes.xxl * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LedgerHeader(),
                if (hasLedgers) ...[
                  const SizedBox(height: AppSizes.md),
                  LedgerTypeFilterChips(
                    selectedTypeId: _selectedTypeId,
                    onSelected: (typeId) {
                      setState(() => _selectedTypeId = typeId);
                    },
                  ),
                ],
                const SizedBox(height: AppSizes.lg),
                if (hasLedgers)
                  filtered.isEmpty
                      ? MyCard(
                          borderRadius: AppSizes.radiusMd,
                          child: const MyText(
                            AppText.ledgersFilterEmpty,
                            font: AppFont.sourceSans,
                            size: AppSizes.subtitle,
                            color: AppColors.textHint,
                            align: TextAlign.center,
                            height: 1.45,
                          ),
                        )
                      : LedgerListView(
                          ledgers: filtered,
                          onLedgerTap: _openLedgerDetail,
                        )
                else
                  const LedgerEmptyState(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
