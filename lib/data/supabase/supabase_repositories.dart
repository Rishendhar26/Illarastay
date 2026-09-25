import '../../core/config/app_config.dart';
import '../../core/models/backend_models.dart';
import '../../core/repositories/repository_interfaces.dart';

class BackendNotConfiguredException implements Exception {
  const BackendNotConfiguredException();

  @override
  String toString() =>
      'Supabase is not configured. Use the mock repositories for local development.';
}

/// Configuration-safe placeholders for the future Supabase implementation.
/// Add the Supabase SDK and queries here once deployment configuration exists.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this.config);
  final AppConfig config;

  void _requireConfiguration() {
    if (!config.hasSupabase) throw const BackendNotConfiguredException();
  }

  @override
  SessionSnapshot get currentSession =>
      const SessionSnapshot(state: BackendSessionState.signedOut);

  @override
  Stream<SessionSnapshot> get sessionStream => const Stream.empty();

  @override
  Future<SessionSnapshot> login(
      {required String email, required String password}) async {
    _requireConfiguration();
    throw UnimplementedError('Connect Supabase Auth here.');
  }

  @override
  Future<SessionSnapshot> register(
      {required String name,
      required String email,
      required String password,
      required BackendRole role}) async {
    _requireConfiguration();
    throw UnimplementedError('Connect Supabase Auth here.');
  }

  @override
  Future<void> logout() async {
    _requireConfiguration();
    throw UnimplementedError('Connect Supabase Auth here.');
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    _requireConfiguration();
    throw UnimplementedError('Connect Supabase Auth here.');
  }
}

class SupabasePropertyRepository implements PropertyRepository {
  SupabasePropertyRepository(this.config);
  final AppConfig config;

  void _requireConfiguration() {
    if (!config.hasSupabase) throw const BackendNotConfiguredException();
  }

  @override
  Future<List<PropertyRecord>> listPublished() async {
    _requireConfiguration();
    throw UnimplementedError('Add the properties query here.');
  }

  @override
  Future<List<PropertyRecord>> listOwned(String ownerId) async {
    _requireConfiguration();
    throw UnimplementedError('Add the owner properties query here.');
  }

  @override
  Future<PropertyRecord> saveDraft(PropertyRecord property) async {
    _requireConfiguration();
    throw UnimplementedError('Add the properties insert/update here.');
  }

  @override
  Future<PropertyRecord> publish(PropertyRecord property) async {
    _requireConfiguration();
    throw UnimplementedError('Add the approval-aware publish update here.');
  }

  @override
  Future<void> delete(String propertyId) async {
    _requireConfiguration();
    throw UnimplementedError('Add the property delete here.');
  }
}
