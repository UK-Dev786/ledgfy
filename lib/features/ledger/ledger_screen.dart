import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/widgets/themed_gradient_bg.dart';
import 'models/ledger_item.dart';
import 'sub_widgets/create_ledger_sheet.dart';
import 'sub_widgets/ledger_empty_state.dart';
import 'sub_widgets/ledger_fab.dart';
import 'sub_widgets/ledger_header.dart';
import 'sub_widgets/ledger_list_view.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final List<LedgerItem> _ledgers = [];

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
                const SizedBox(height: AppSizes.lg),
                if (hasLedgers)
                  LedgerListView(ledgers: _ledgers)
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
