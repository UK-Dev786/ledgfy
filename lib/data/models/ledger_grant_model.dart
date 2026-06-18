import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/profile/models/ledger_staff_assignment.dart';

class LedgerGrantModel {
  final String id;
  final String staffId;
  final String ledgerId;
  final LedgerStaffAccess access;
  final List<String>? scopedPartyNames;

  const LedgerGrantModel({
    required this.id,
    required this.staffId,
    required this.ledgerId,
    required this.access,
    this.scopedPartyNames,
  });

  static String documentId({
    required String ledgerId,
    required String staffId,
  }) =>
      '${ledgerId}__$staffId';

  factory LedgerGrantModel.fromFirestore(Map<String, dynamic> data, String id) {
    return LedgerGrantModel(
      id: id,
      staffId: data['staffId'] as String? ?? '',
      ledgerId: data['ledgerId'] as String? ?? '',
      access: _parseAccess(data['access'] as String?),
      scopedPartyNames: (data['scopedPartyNames'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'staffId': staffId,
      'ledgerId': ledgerId,
      'access': access.name,
      if (scopedPartyNames != null) 'scopedPartyNames': scopedPartyNames,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  LedgerStaffAssignment toEntity() {
    return LedgerStaffAssignment(
      staffId: staffId,
      access: access,
      scopedPartyNames: scopedPartyNames,
    );
  }

  static LedgerStaffAccess _parseAccess(String? value) {
    return switch (value) {
      'viewer' => LedgerStaffAccess.viewer,
      _ => LedgerStaffAccess.editor,
    };
  }
}
