import '../models/backend_models.dart';
import '../repositories/repository_interfaces.dart';

/// UI-facing auth service. Replace the repository with SupabaseAuthRepository
/// when runtime configuration is available.
class AuthService {
  AuthService(this.repository);

  final AuthRepository repository;

  SessionSnapshot get currentSession => repository.currentSession;
  Stream<SessionSnapshot> get sessionStream => repository.sessionStream;
  Future<SessionSnapshot> restoreSession() => repository.restoreSession();

  Future<SessionSnapshot> login(String email, String password) =>
      repository.login(email: email, password: password);

  Future<SessionSnapshot> register(
          String name, String email, String password, BackendRole role) =>
      repository.register(
          name: name, email: email, password: password, role: role);

  Future<void> logout() => repository.logout();
  Future<void> resetPassword(String email) =>
      repository.requestPasswordReset(email);
}
