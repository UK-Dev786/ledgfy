import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_card.dart';
import '../../../core/widgets/my_text.dart';
import '../models/staff_audit_event.dart';
import '../sub_widgets/profile_sub_page_scaffold.dart';

class ProfileStaffActivityPage extends StatefulWidget {
  const ProfileStaffActivityPage({super.key});

  static void open(BuildContext context) {
    ProfileSubPageScaffold.open<void>(
      context,
      const ProfileStaffActivityPage(),
    );
  }

  @override
  State<ProfileStaffActivityPage> createState() =>
      _ProfileStaffActivityPageState();
}

class _ProfileStaffActivityPageState extends State<ProfileStaffActivityPage> {
  StaffAuditCategory _filter = StaffAuditCategory.all;

  List<StaffAuditEvent> get _filteredEvents {
    if (_filter == StaffAuditCategory.all) {
      return StaffAuditMockData.events;
    }
    return StaffAuditMockData.events
        .where((event) => event.category == _filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return ProfileSubPageScaffold(
      title: AppText.staffActivityTitle,
      subtitle: AppText.staffActivitySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              children: StaffAuditCategory.values.map((category) {
                final selected = _filter == category;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: FilterChip(
                    label: Text(category.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = category),
                    labelStyle: TextStyle(
                      fontFamily: 'SourceSans3',
                      fontSize: AppSizes.caption,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? AppColors.white : AppColors.textHint,
                    ),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    backgroundColor: AppColors.white.withValues(alpha: 0.04),
                    side: BorderSide(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.55)
                          : AppColors.textHint.withValues(alpha: 0.2),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: MyCard(
              tint: MyCardTint.dark,
              borderRadius: AppSizes.radiusLg,
              blur: 20,
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: AppSizes.iconSm,
                    color: AppColors.secondary.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  const Expanded(
                    child: MyText(
                      AppText.staffAuditBackendNote,
                      font: AppFont.sourceSans,
                      size: AppSizes.caption,
                      color: AppColors.textHint,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: events.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.lg),
                      child: MyText(
                        AppText.staffActivityEmpty,
                        font: AppFont.sourceSans,
                        size: AppSizes.body,
                        color: AppColors.textHint,
                        align: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.lg,
                      0,
                      AppSizes.lg,
                      AppSizes.xxl * 2,
                    ),
                    itemCount: events.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.sm),
                    itemBuilder: (context, index) {
                      return _AuditEventCard(event: events[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuditEventCard extends StatelessWidget {
  final StaffAuditEvent event;

  const _AuditEventCard({required this.event});

  IconData get _icon => switch (event.action) {
        StaffAuditAction.entryAdded => Icons.add_circle_outline_rounded,
        StaffAuditAction.entryEdited => Icons.edit_outlined,
        StaffAuditAction.entryDeleted => Icons.delete_outline_rounded,
        StaffAuditAction.staffInvited => Icons.person_add_alt_1_outlined,
        StaffAuditAction.roleChanged => Icons.admin_panel_settings_outlined,
        StaffAuditAction.signIn => Icons.login_rounded,
      };

  Color get _iconColor => switch (event.category) {
        StaffAuditCategory.entries => AppColors.primary,
        StaffAuditCategory.team => AppColors.secondary,
        StaffAuditCategory.security => AppColors.tertiaryLight,
        StaffAuditCategory.all => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('MMM d, h:mm a').format(event.occurredAt);

    return MyCard(
      tint: MyCardTint.dark,
      borderRadius: AppSizes.radiusLg,
      blur: 20,
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            alignment: Alignment.center,
            child: Icon(_icon, color: _iconColor, size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  event.title,
                  font: AppFont.inter,
                  size: AppSizes.body,
                  color: AppColors.white,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 2),
                MyText(
                  event.detail,
                  font: AppFont.sourceSans,
                  size: AppSizes.subtitle,
                  color: AppColors.textHint,
                  height: 1.35,
                ),
                if (event.ledgerName != null) ...[
                  const SizedBox(height: 4),
                  MyText(
                    event.ledgerName!,
                    font: AppFont.sourceSans,
                    size: AppSizes.caption,
                    color: AppColors.primary,
                    weight: FontWeight.w600,
                  ),
                ],
                const SizedBox(height: AppSizes.sm),
                MyText(
                  '${event.actorName} · $timeLabel',
                  font: AppFont.sourceSans,
                  size: AppSizes.caption,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
