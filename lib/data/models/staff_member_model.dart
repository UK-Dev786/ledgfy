import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/profile/models/staff_member.dart';

class StaffMemberModel {
  final String id;
  final String name;
  final String username;
  final String loginEmail;
  final StaffMemberStatus status;
  final DateTime? joinedAt;

  const StaffMemberModel({
    required this.id,
    required this.name,
    required this.username,
    required this.loginEmail,
    required this.status,
    this.joinedAt,
  });

  factory StaffMemberModel.fromFirestore(Map<String, dynamic> data, String id) {
    return StaffMemberModel(
      id: id,
      name: data['name'] as String? ?? '',
      username: data['username'] as String? ?? '',
      loginEmail: data['loginEmail'] as String? ?? '',
      status: _parseStatus(data['status'] as String?),
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'username': username,
      'loginEmail': loginEmail,
      'status': status.name,
      'joinedAt': joinedAt != null
          ? Timestamp.fromDate(joinedAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  StaffMember toEntity() {
    return StaffMember(
      id: id,
      name: name,
      username: username,
      loginEmail: loginEmail,
      status: status,
      joinedAt: joinedAt,
    );
  }

  static StaffMemberStatus _parseStatus(String? value) {
    return switch (value) {
      'disabled' => StaffMemberStatus.disabled,
      _ => StaffMemberStatus.active,
    };
  }
}
