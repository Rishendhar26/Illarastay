import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Initializes Supabase only when a publishable key is supplied at build time.
/// The app remains fully usable with its local mock data when it is absent.
class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize(AppConfig config) async {
    if (!config.hasSupabase) return false;
    if (_initialized) return true;

    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabasePublishableKey,
    );
    _initialized = true;
    return true;
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError('SupabaseService.initialize must run first.');
    }
    return Supabase.instance.client;
  }
}
