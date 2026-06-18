import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';
import 'package:ledgify/core/extensions/popup_extensions.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/app_validators.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/my_text_field.dart';
import '../sub_widgets/profile_sub_page_scaffold.dart';

class ProfileSecurityPage extends StatefulWidget {
  const ProfileSecurityPage({super.key});

  static void open(BuildContext context) {
    ProfileSubPageScaffold.open<void>(
      context,
      const ProfileSecurityPage(),
    );
  }

  @override
  State<ProfileSecurityPage> createState() => _ProfileSecurityPageState();
}

class _ProfileSecurityPageState extends State<ProfileSecurityPage> {
  static const _totalSteps = 3;

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _stepTitle => switch (_step) {
        0 => AppText.profilePasswordStepCurrent,
        1 => AppText.profilePasswordStepNew,
        _ => AppText.profilePasswordStepConfirm,
      };

  TextEditingController get _activeController => switch (_step) {
        0 => _currentPasswordController,
        1 => _newPasswordController,
        _ => _confirmPasswordController,
      };

  String get _activeTitle => switch (_step) {
        0 => AppText.profileCurrentPassword,
        1 => AppText.profileNewPassword,
        _ => AppText.profileConfirmNewPassword,
      };

  String get _activeHint => switch (_step) {
        0 => AppText.profileCurrentPasswordHint,
        1 => AppText.profileNewPasswordHint,
        _ => AppText.profileConfirmNewPasswordHint,
      };

  String? Function(String?) get _activeValidator => switch (_step) {
        0 => AppValidators.password,
        1 => AppValidators.password,
        _ => AppValidators.confirmPassword(
            () => _newPasswordController.text,
          ),
      };

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    await context.popMsg(
      AppText.profilePasswordUpdated,
      title: AppText.dialogSuccessTitle,
      icon: Icons.check_circle_outline_rounded,
    );
    if (mounted) Navigator.of(context).pop();
  }

  void _backStep() {
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSubPageScaffold(
      title: AppText.profileSecurityTitle,
      subtitle: AppText.profileChangePasswordSubtitle,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.lg,
          0,
          AppSizes.lg,
          context.h * 4,
        ),
        children: [
          MyCard(
            tint: MyCardTint.dark,
            borderRadius: AppSizes.radiusLg,
            blur: 24,
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: MyText(
                        AppText.profileChangePassword,
                        font: AppFont.inter,
                        size: AppSizes.body,
                        color: AppColors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.lg),
                _StepIndicator(current: _step, total: _totalSteps),
                const SizedBox(height: AppSizes.lg),
                MyText(
                  '${AppText.profileStepLabel} ${_step + 1} / $_totalSteps',
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: AppSizes.xs),
                MyText(
                  _stepTitle,
                  font: AppFont.inter,
                  size: AppSizes.title,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
                SizedBox(height: context.h * 2),
                Form(
                  key: _formKey,
                  child: MyTextField(
                    key: ValueKey(_step),
                    title: _activeTitle,
                    hintText: _activeHint,
                    controller: _activeController,
                    obscure: true,
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primary,
                    ),
                    validator: _activeValidator,
                  ),
                ),
                SizedBox(height: context.h * 3),
                MyButton(
                  text: _step == _totalSteps - 1
                      ? AppText.profileUpdatePassword
                      : AppText.profileContinue,
                  loading: _isSubmitting,
                  onTap: _isSubmitting ? () {} : _continue,
                ),
                if (_step > 0) ...[
                  const SizedBox(height: AppSizes.sm),
                  Center(
                    child: TextButton(
                      onPressed: _isSubmitting ? null : _backStep,
                      child: const MyText(
                        AppText.profileBack,
                        font: AppFont.sourceSans,
                        size: AppSizes.subtitle,
                        color: AppColors.textHint,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _StepIndicator({
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isActive = index <= current;
        final isCurrent = index == current;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == total - 1 ? 0 : AppSizes.xs),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: isCurrent ? 1 : 0.45)
                  : AppColors.textHint.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
        );
      }),
    );
  }
}
