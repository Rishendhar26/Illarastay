import 'package:flutter_test/flutter_test.dart';
import 'package:illarastay/core/config/app_config.dart';
import 'package:illarastay/core/models/backend_models.dart';
import 'package:illarastay/core/services/auth_service.dart';
import 'package:illarastay/data/mock/mock_backend_repositories.dart';
import 'package:illarastay/data/supabase/supabase_repositories.dart';
import 'package:illarastay/main.dart' as app;

void main() {
  test('mock auth supports session state and logout', () async {
    final service = AuthService(MockAuthRepository());
    expect(service.currentSession.state, BackendSessionState.signedOut);
    final signedIn = await service.login('demo@example.com', 'password');
    expect(signedIn.state, BackendSessionState.signedIn);
    expect(signedIn.user?.role, BackendRole.tenant);
    await service.logout();
    expect(service.currentSession.state, BackendSessionState.signedOut);
  });

  test('mock auth validates required credentials', () async {
    final repository = MockAuthRepository();
    final result = await repository.login(email: '', password: '');
    expect(result.state, BackendSessionState.error);
    expect(result.message, contains('required'));
  });

  test('public registration supports owner role but rejects admin role',
      () async {
    final repository = MockAuthRepository();
    final owner = await repository.register(
        name: 'Owner',
        email: 'owner@example.com',
        password: 'password',
        role: BackendRole.owner);
    expect(owner.user?.role, BackendRole.owner);
    final admin = await repository.register(
        name: 'Admin',
        email: 'admin@example.com',
        password: 'password',
        role: BackendRole.admin);
    expect(admin.state, BackendSessionState.error);
    expect(admin.message, contains('provisioned'));
  });

  test('mock auth restores the current authenticated session', () async {
    final repository = MockAuthRepository();
    await repository.login(email: 'demo@example.com', password: 'password');
    final restored = await repository.restoreSession();
    expect(restored.state, BackendSessionState.signedIn);
    expect(restored.user?.id, 'mock-user');
  });

  test('supabase repositories fail safely without credentials', () async {
    final repository = SupabaseAuthRepository(const AppConfig());
    await expectLater(repository.login(email: 'a@b.com', password: 'secret'),
        throwsA(isA<BackendNotConfiguredException>()));
  });

  test('configuration only enables Supabase when both values exist', () {
    expect(const AppConfig().hasSupabase, isFalse);
    expect(
        const AppConfig(supabaseUrl: 'url', supabaseAnonKey: 'key').hasSupabase,
        isTrue);
    expect(
        const AppConfig(
                supabaseUrl: 'url', supabasePublishableKey: 'publishable-key')
            .hasSupabase,
        isTrue);
  });
  test('demo repository exposes only approved published marketplace properties',
      () {
    final repository = app.MockPropertyRepository();
    expect(repository.properties(), isNotEmpty);
    expect(
        repository.properties().every((property) =>
            property.published &&
            property.approvalStatus == app.PropertyApprovalStatus.approved),
        isTrue);
  });
  test('demo repository supports saved properties and request status updates',
      () {
    final repository = app.MockPropertyRepository();
    expect(repository.saved('p1'), isFalse);
    repository.toggleSaved('p1');
    expect(repository.saved('p1'), isTrue);
    repository.requestVisit(repository.properties().first,
        message: 'Please share parking details.');
    final request = repository.requests().last;
    expect(request.tenantId, 'mock-user');
    expect(request.message, contains('parking'));
    repository.updateRequest(request.id, app.RequestStatus.accepted);
    expect(request.status, app.RequestStatus.accepted);
  });
}
