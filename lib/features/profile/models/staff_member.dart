import '../../../core/constants/app_text.dart';

export '../../../domain/entities/organization_member_kind.dart';

enum StaffMemberStatus {
  active,
  disabled,
}

extension StaffMemberStatusLabels on StaffMemberStatus {
  String get label => switch (this) {
        StaffMemberStatus.active => AppText.staffStatusActive,
        StaffMemberStatus.disabled => AppText.staffStatusDisabled,
      };
}

/// Staff login created by the organization owner (UI model until Firebase is wired).
class StaffMember {
  final String id;
  final String name;
  final String username;
  final String loginEmail;
  final bool isOwner;
  final StaffMemberStatus status;
  final DateTime? joinedAt;

  const StaffMember({
    required this.id,
    required this.name,
    required this.username,
    required this.loginEmail,
    this.isOwner = false,
    required this.status,
    this.joinedAt,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    String? username,
    String? loginEmail,
    bool? isOwner,
    StaffMemberStatus? status,
    DateTime? joinedAt,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      loginEmail: loginEmail ?? this.loginEmail,
      isOwner: isOwner ?? this.isOwner,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
    final list = parts.toList();
    if (list.length >= 2) {
      return '${list.first[0]}${list.last[0]}'.toUpperCase();
    }
    if (list.isEmpty) return '?';
    return list.first[0].toUpperCase();
  }

  String get displayLogin => '@$username · $loginEmail';

  String ledgerCountLabel(int count) {
    if (count == 0) return AppText.staffAssignLedgersNone;
    return AppText.staffAssignLedgersCount.replaceAll(
      '{count}',
      '$count',
    );
  }
}

/// Sample team data until organization backend is wired.
abstract final class StaffTeamMockData {
  static List<StaffMember> sampleMembers(String ownerName) => [
        StaffMember(
          id: 'owner',
          name: ownerName,
          username: 'owner',
          loginEmail: AppText.staffOwnerLoginLabel,
          isOwner: true,
          status: StaffMemberStatus.active,
          joinedAt: DateTime.now().subtract(const Duration(days: 120)),
        ),
        const StaffMember(
          id: 'staff-1',
          name: 'Sara Ahmed',
          username: 'sara_staff',
          loginEmail: 'sara@mainstore',
          status: StaffMemberStatus.active,
        ),
        const StaffMember(
          id: 'staff-2',
          name: 'Bilal Khan',
          username: 'bilal_udhar',
          loginEmail: 'bilal@mainstore',
          status: StaffMemberStatus.active,
        ),
      ];
}
