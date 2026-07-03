import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final path = '$userId/avatar.jpg';

    await _supabase.storage.from('avatars').upload(
      path,
      imageFile,
      fileOptions: const FileOptions(
        upsert: true,
        contentType: 'image/jpeg',
      ),
    );

    final url = _supabase.storage.from('avatars').getPublicUrl(path);
    // Append timestamp so the app re-fetches after re-upload
    return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> deleteAvatar(String userId) async {
    await _supabase.storage
        .from('avatars')
        .remove(['$userId/avatar.jpg']);
  }
}

final avatarDataSourceProvider = Provider<AvatarRemoteDataSource>(
  (_) => AvatarRemoteDataSource(),
);
