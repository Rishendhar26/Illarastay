import '../../core/models/backend_models.dart';
import '../../core/repositories/repository_interfaces.dart';
import '../../core/services/storage_service.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.defaultRole = BackendRole.tenant});

  final BackendRole defaultRole;
  final _sessionController = const Stream<SessionSnapshot>.empty();
  SessionSnapshot _session =
      const SessionSnapshot(state: BackendSessionState.signedOut);

  @override
  SessionSnapshot get currentSession => _session;

  @override
  Stream<SessionSnapshot> get sessionStream => _sessionController;

  @override
  Future<SessionSnapshot> login(
      {required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _session = const SessionSnapshot(
          state: BackendSessionState.error,
          message: 'Email and password are required.');
    } else {
      _session = SessionSnapshot(
          state: BackendSessionState.signedIn,
          user: AuthUserRecord(
              id: 'mock-user',
              email: email,
              name: 'Demo User',
              role: defaultRole));
    }
    return _session;
  }

  @override
  Future<SessionSnapshot> register(
          {required String name,
          required String email,
          required String password,
          required BackendRole role}) =>
      login(email: email, password: password);

  @override
  Future<void> logout() async {
    _session = const SessionSnapshot(state: BackendSessionState.signedOut);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    if (email.trim().isEmpty) throw ArgumentError('Email is required.');
  }
}

class MockStorageService implements StorageService {
  @override
  Future<String> uploadPropertyImage(
          {required String propertyId,
          required String fileName,
          required List<int> bytes}) async =>
      'mock://properties/$propertyId/$fileName';

  @override
  Future<String> uploadProfileImage(
          {required String userId,
          required String fileName,
          required List<int> bytes}) async =>
      'mock://profiles/$userId/$fileName';
}
