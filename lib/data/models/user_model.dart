import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/organization_member_kind.dart';
import '../../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? username;
  final String? accountType;
  final OrganizationMemberKind memberKind;
  final String? organizationId;
  final bool isVerified;
  final DateTime? createdAt;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.username,
    this.accountType,
    this.memberKind = OrganizationMemberKind.owner,
    this.organizationId,
    this.isVerified = false,
    this.createdAt,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? username,
    String? accountType,
    OrganizationMemberKind? memberKind,
    String? organizationId,
    bool? isVerified,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      accountType: accountType ?? this.accountType,
      memberKind: memberKind ?? this.memberKind,
      organizationId: organizationId ?? this.organizationId,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromFirebaseUser({
    required String uid,
    required String? email,
    String? displayName,
    bool isVerified = false,
  }) {
    return UserModel(
      id: uid,
      email: email ?? '',
      displayName: displayName,
      isVerified: isVerified,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      username: data['username'] as String?,
      accountType: data['accountType'] as String?,
      memberKind: OrganizationMemberKindParsing.fromFirestore(
            data['memberKind'] as String?,
          ) ??
          OrganizationMemberKind.owner,
      organizationId: data['organizationId'] as String?,
      isVerified:
          data['isVerified'] as bool? ??
          data['emailVerified'] as bool? ??
          false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      avatarUrl: data['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'username': username,
      'accountType': accountType,
      'memberKind': memberKind.firestoreValue,
      if (organizationId != null) 'organizationId': organizationId,
      'isVerified': isVerified,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      username: username,
      accountType: accountType,
      memberKind: memberKind,
      organizationId: organizationId,
      isVerified: isVerified,
      avatarUrl: avatarUrl,
    );
  }
}
