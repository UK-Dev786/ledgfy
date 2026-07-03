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

  List<LedgerItem> _filteredLedgers(List<LedgerItem> ledgers) {
    if (_selectedTypeId == null) return ledgers;
    return ledgers
        .where((ledger) => ledger.type.id == _selectedTypeId)
        .toList();
  }

  void _openLedgerDetail(LedgerItem ledger) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => LedgerDetailPage(ledgerId: ledger.id),
      ),
    );
  }

  void _openCreateLedgerSheet() {
    CreateLedgerSheet.show(
      context,
      onSubmit: (title, type, description) {
        ref
            .read(ledgerControllerProvider)
            .createLedger(title: title, description: description, type: type);
      },
    );
  }

  void _openEditLedgerSheet(LedgerItem ledger) {
    CreateLedgerSheet.show(
      context,
      ledger: ledger,
      onSubmit: (title, _, description) {
        ref
            .read(ledgerControllerProvider)
            .updateLedger(
              ledgerId: ledger.id,
              title: title,
              description: description,
            );
      },
    );
  }

  void _deleteLedger(LedgerItem ledger) {
    ref.read(ledgerControllerProvider).deleteLedger(ledger.id);
  }

  @override
  Widget build(BuildContext context) {
    final ledgersAsync = ref.watch(ledgersStreamProvider);
    final ledgers = ref.watch(scopedLedgersProvider);
    final isStaff = ref.watch(isStaffUserProvider);

    return ThemedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: isStaff
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: LedgerFab(onTap: _openCreateLedgerSheet),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: ledgersAsync.when(
            skipLoadingOnReload: true,
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: MyText(
                  error.toString(),
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.error,
                  align: TextAlign.center,
                ),
              ),
            ),
            data: (_) {
              final filtered = _filteredLedgers(ledgers);
              final hasLedgers = ledgers.isNotEmpty;

              return SingleChildScrollView(
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
                              onLedgerEdit: isStaff
                                  ? null
                                  : _openEditLedgerSheet,
                              onLedgerDelete: isStaff ? null : _deleteLedger,
                            )
                    else
                      const LedgerEmptyState(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
