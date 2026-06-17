import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/themed_gradient_bg.dart';
import '../detail/ledger_detail_page.dart';
import '../models/ledger_item.dart';
import 'sub_widgets/create_ledger_sheet.dart';
import 'sub_widgets/ledger_empty_state.dart';
import 'sub_widgets/ledger_fab.dart';
import 'sub_widgets/ledger_header.dart';
import 'sub_widgets/ledger_list_view.dart';
import 'sub_widgets/ledger_type_filter_chips.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final List<LedgerItem> _ledgers = [];
  String? _selectedTypeId;

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
            setState(() {
              _ledgers.removeWhere((item) => item.id == deletedId);
            });
          } else {
            setState(() {});
          }
        });
  }

  void _openCreateLedgerSheet() {
    CreateLedgerSheet.show(
      context,
      onCreate: (title, type, description) {
        setState(() {
          _ledgers.add(
            LedgerItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              description: description,
              type: type,
              createdAt: DateTime.now(),
            ),
          );
        });
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
