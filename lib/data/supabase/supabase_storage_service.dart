import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/supabase_service.dart';

class SupabaseStorageService implements StorageService {
  SupabaseStorageService(this.config, {SupabaseClient? client})
      : _client = client;

  final AppConfig config;
  final SupabaseClient? _client;

  SupabaseClient get client {
    if (!config.hasSupabase) {
      throw const StorageNotConfiguredException();
    }
    return _client ?? SupabaseService.client;
  }

  @override
  Future<String> uploadPropertyImage({
    required String propertyId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = 'properties/$propertyId/$fileName';
    await client.storage.from('property-images').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );
    return client.storage.from('property-images').getPublicUrl(path);
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = 'profiles/$userId/$fileName';
    await client.storage.from('profile-images').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );
    return client.storage.from('profile-images').getPublicUrl(path);
  }
}
