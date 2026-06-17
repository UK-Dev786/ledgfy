import 'package:flutter/material.dart';

import '../../../../core/widgets/rounded_button.dart';

class LedgerFab extends StatelessWidget {
  final VoidCallback onTap;

  const LedgerFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onTap: onTap,
      icon: Icons.add_rounded,
    );
  }
}
