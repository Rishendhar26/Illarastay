import '../models/backend_models.dart';

abstract interface class AuthRepository {
  Stream<SessionSnapshot> get sessionStream;
  SessionSnapshot get currentSession;
  Future<SessionSnapshot> register(
      {required String name,
      required String email,
      required String password,
      required BackendRole role});
  Future<SessionSnapshot> login(
      {required String email, required String password});
  Future<void> logout();
  Future<void> requestPasswordReset(String email);
}

abstract interface class PropertyRepository {
  Future<List<PropertyRecord>> listPublished();
  Future<List<PropertyRecord>> listOwned(String ownerId);
  Future<PropertyRecord> saveDraft(PropertyRecord property);
  Future<PropertyRecord> publish(PropertyRecord property);
  Future<void> delete(String propertyId);
}

abstract interface class RequestRepository {
  Future<List<RequestRecord>> listForTenant(String tenantId);
  Future<List<RequestRecord>> listForOwner(String ownerId);
  Future<RequestRecord> create(RequestRecord request);
  Future<RequestRecord> updateStatus(
      String requestId, BackendRequestStatus status);
}

abstract interface class SavedPropertyRepository {
  Future<List<String>> listForTenant(String tenantId);
  Future<void> save({required String tenantId, required String propertyId});
  Future<void> remove({required String tenantId, required String propertyId});
}

abstract interface class ReviewRepository {
  Future<void> create(
      {required String propertyId,
      required String reviewerId,
      required int rating,
      required String review});
}

abstract interface class ReportRepository {
  Future<void> create(
      {required String reporterId,
      required String propertyId,
      required String reason,
      required String description});
}

abstract interface class UserRepository {
  Future<List<AuthUserRecord>> listUsers();
  Future<void> updateStatus(String userId, BackendAccountStatus status);
  Future<void> updateProfile(AuthUserRecord user);
}
