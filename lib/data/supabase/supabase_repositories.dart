import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../../core/models/backend_models.dart';
import '../../core/repositories/repository_interfaces.dart';
import '../../core/services/supabase_service.dart';

class BackendNotConfiguredException implements Exception {
  const BackendNotConfiguredException();

  @override
  String toString() =>
      'Supabase is not configured. Use the mock repositories for local development.';
}

class SupabaseDataException implements Exception {
  const SupabaseDataException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'SupabaseDataException: $message';
}

abstract class _SupabaseRepository {
  _SupabaseRepository(this.config, {SupabaseClient? client}) : _client = client;

  final AppConfig config;
  final SupabaseClient? _client;

  SupabaseClient get client {
    if (!config.hasSupabase) throw const BackendNotConfiguredException();
    return _client ?? SupabaseService.client;
  }

  Future<T> guarded<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on BackendNotConfiguredException {
      rethrow;
    } on AuthException catch (error) {
      throw SupabaseDataException(error.message, error);
    } on PostgrestException catch (error) {
      throw SupabaseDataException(error.message, error);
    } catch (error) {
      throw SupabaseDataException('The data service is unavailable.', error);
    }
  }
}

class SupabaseAuthRepository extends _SupabaseRepository
    implements AuthRepository {
  SupabaseAuthRepository(super.config, {super.client});

  @override
  SessionSnapshot get currentSession {
    if (!config.hasSupabase) {
      return const SessionSnapshot(state: BackendSessionState.signedOut);
    }
    return _snapshot(client.auth.currentSession);
  }

  @override
  Stream<SessionSnapshot> get sessionStream {
    if (!config.hasSupabase) return const Stream.empty();
    return client.auth.onAuthStateChange
        .map((event) => _snapshot(event.session));
  }

  @override
  Future<SessionSnapshot> login(
      {required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return const SessionSnapshot(
          state: BackendSessionState.error,
          message: 'Email and password are required.');
    }
    return guarded(() async {
      final response = await client.auth
          .signInWithPassword(email: email.trim(), password: password);
      return _snapshot(response.session);
    });
  }

  @override
  Future<SessionSnapshot> register({
    required String name,
    required String email,
    required String password,
    required BackendRole role,
  }) =>
      guarded(() async {
        final response = await client.auth.signUp(
            email: email.trim(),
            password: password,
            data: {'name': name.trim(), 'role': role.name});
        return _snapshot(response.session);
      });

  @override
  Future<void> logout() => guarded(client.auth.signOut);

  @override
  Future<void> requestPasswordReset(String email) =>
      guarded(() => client.auth.resetPasswordForEmail(email.trim()));

  SessionSnapshot _snapshot(Session? session) {
    if (session == null) {
      return const SessionSnapshot(state: BackendSessionState.signedOut);
    }
    final user = session.user;
    final roleName = user.userMetadata?['role'] as String?;
    final role = BackendRole.values
            .where((value) => value.name == roleName)
            .firstOrNull ??
        BackendRole.tenant;
    return SessionSnapshot(
        state: BackendSessionState.signedIn,
        user: AuthUserRecord(
            id: user.id,
            email: user.email ?? '',
            name: user.userMetadata?['name'] as String? ??
                user.email ??
                'IllaraStay user',
            role: role));
  }
}

class SupabasePropertyRepository extends _SupabaseRepository
    implements PropertyRepository {
  SupabasePropertyRepository(super.config, {super.client});

  @override
  Future<List<PropertyRecord>> listPublished() => guarded(() async {
        final rows = await client
            .from('properties')
            .select()
            .eq('status', 'published')
            .eq('approval_status', 'approved');
        return (rows as List)
            .map((row) => _record(Map<String, dynamic>.from(row as Map)))
            .toList();
      });

  @override
  Future<List<PropertyRecord>> listOwned(String ownerId) => guarded(() async {
        final rows = await client
            .from('properties')
            .select()
            .eq('owner_id', ownerId)
            .order('updated_at', ascending: false);
        return (rows as List)
            .map((row) => _record(Map<String, dynamic>.from(row as Map)))
            .toList();
      });

  @override
  Future<PropertyRecord> saveDraft(PropertyRecord property) =>
      guarded(() async {
        final row = await client
            .from('properties')
            .upsert(_toRow(property))
            .select()
            .single();
        return _record(row);
      });

  @override
  Future<PropertyRecord> publish(PropertyRecord property) => guarded(() async {
        final row = await client
            .from('properties')
            .update({'status': 'published'})
            .eq('id', property.id)
            .select()
            .single();
        return _record(row);
      });

  @override
  Future<void> delete(String propertyId) =>
      guarded(() => client.from('properties').delete().eq('id', propertyId));

  PropertyRecord _record(Map<String, dynamic> row) => PropertyRecord(
        id: row['id'] as String,
        ownerId: row['owner_id'] as String,
        title: row['title'] as String,
        propertyType: row['property_type'] as String,
        listingType: row['listing_type'] as String,
        city: row['city'] as String,
        locality: row['locality'] as String,
        price: (row['price'] as num).toDouble(),
        description: row['description'] as String? ?? '',
        deposit: (row['deposit'] as num?)?.toDouble() ?? 0,
        maintenance: (row['maintenance'] as num?)?.toDouble() ?? 0,
        bedrooms: row['bedrooms'] as int? ?? 0,
        bathrooms: row['bathrooms'] as int? ?? 0,
        area: (row['area'] as num?)?.toDouble() ?? 0,
        furnishing: row['furnishing'] as String? ?? 'unfurnished',
        floor: row['floor'] as int?,
        totalFloors: row['total_floors'] as int?,
        address: row['address'] as String? ?? '',
        latitude: (row['latitude'] as num?)?.toDouble(),
        longitude: (row['longitude'] as num?)?.toDouble(),
        availabilityDate: _date(row['availability_date']),
        availableUnits: row['available_units'] as int? ?? 1,
        rejectionReason: row['rejection_reason'] as String?,
        createdAt: _date(row['created_at']),
        updatedAt: _date(row['updated_at']),
        status: BackendPropertyStatus.values.byName(row['status'] as String),
        approvalStatus: BackendApprovalStatus.values
            .byName(row['approval_status'] as String),
      );

  Map<String, dynamic> _toRow(PropertyRecord property) => {
        'id': property.id,
        'owner_id': property.ownerId,
        'title': property.title,
        'property_type': property.propertyType,
        'listing_type': property.listingType,
        'city': property.city,
        'locality': property.locality,
        'price': property.price,
        'description': property.description,
        'deposit': property.deposit,
        'maintenance': property.maintenance,
        'bedrooms': property.bedrooms,
        'bathrooms': property.bathrooms,
        'area': property.area,
        'furnishing': property.furnishing,
        'floor': property.floor,
        'total_floors': property.totalFloors,
        'address': property.address,
        'latitude': property.latitude,
        'longitude': property.longitude,
        'availability_date': property.availabilityDate?.toIso8601String(),
        'available_units': property.availableUnits,
        'status': property.status.name,
        'approval_status': property.approvalStatus.name,
      };

  DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;
}

class SupabaseRequestRepository extends _SupabaseRepository
    implements RequestRepository {
  SupabaseRequestRepository(super.config, {super.client});

  @override
  Future<List<RequestRecord>> listForTenant(String tenantId) =>
      guarded(() async {
        final rows = await client
            .from('requests')
            .select()
            .eq('tenant_id', tenantId)
            .order('created_at', ascending: false);
        return (rows as List)
            .map((row) => _record(Map<String, dynamic>.from(row as Map)))
            .toList();
      });

  @override
  Future<List<RequestRecord>> listForOwner(String ownerId) => guarded(() async {
        final rows = await client
            .from('requests')
            .select()
            .eq('owner_id', ownerId)
            .order('created_at', ascending: false);
        return (rows as List)
            .map((row) => _record(Map<String, dynamic>.from(row as Map)))
            .toList();
      });

  @override
  Future<RequestRecord> create(RequestRecord request) => guarded(() async {
        final row = await client
            .from('requests')
            .insert({
              'property_id': request.propertyId,
              'tenant_id': request.tenantId,
              'owner_id': request.ownerId,
              'request_type': request.requestType,
              'message': request.message,
              'preferred_date': request.preferredDate?.toIso8601String(),
              'preferred_time': request.preferredTime,
              'status': request.status.name,
            })
            .select()
            .single();
        return _record(row);
      });

  @override
  Future<RequestRecord> updateStatus(
          String requestId, BackendRequestStatus status) =>
      guarded(() async {
        final row = await client
            .from('requests')
            .update({'status': status.name})
            .eq('id', requestId)
            .select()
            .single();
        return _record(row);
      });

  RequestRecord _record(Map<String, dynamic> row) => RequestRecord(
        id: row['id'] as String,
        propertyId: row['property_id'] as String,
        tenantId: row['tenant_id'] as String,
        ownerId: row['owner_id'] as String,
        requestType: row['request_type'] as String,
        message: row['message'] as String? ?? '',
        preferredDate: _date(row['preferred_date']),
        preferredTime: row['preferred_time'] as String?,
        status: BackendRequestStatus.values.byName(row['status'] as String),
      );

  DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;
}

class SupabaseSavedPropertyRepository extends _SupabaseRepository
    implements SavedPropertyRepository {
  SupabaseSavedPropertyRepository(super.config, {super.client});

  @override
  Future<List<String>> listForTenant(String tenantId) => guarded(() async {
        final rows = await client
            .from('saved_properties')
            .select('property_id')
            .eq('tenant_id', tenantId);
        return (rows as List)
            .map((row) => (row as Map)['property_id'] as String)
            .toList();
      });

  @override
  Future<void> save({required String tenantId, required String propertyId}) =>
      guarded(() => client.from('saved_properties').upsert({
            'tenant_id': tenantId,
            'property_id': propertyId,
          }));

  @override
  Future<void> remove({required String tenantId, required String propertyId}) =>
      guarded(() => client
          .from('saved_properties')
          .delete()
          .eq('tenant_id', tenantId)
          .eq('property_id', propertyId));
}

class SupabaseReviewRepository extends _SupabaseRepository
    implements ReviewRepository {
  SupabaseReviewRepository(super.config, {super.client});

  @override
  Future<void> create({
    required String propertyId,
    required String reviewerId,
    required int rating,
    required String review,
  }) =>
      guarded(() => client.from('reviews').insert({
            'property_id': propertyId,
            'reviewer_id': reviewerId,
            'rating': rating,
            'review': review,
          }));
}

class SupabaseReportRepository extends _SupabaseRepository
    implements ReportRepository {
  SupabaseReportRepository(super.config, {super.client});

  @override
  Future<void> create({
    required String reporterId,
    required String propertyId,
    required String reason,
    required String description,
  }) =>
      guarded(() => client.from('reports').insert({
            'reporter_id': reporterId,
            'property_id': propertyId,
            'reason': reason,
            'description': description,
          }));
}

class SupabaseUserRepository extends _SupabaseRepository
    implements UserRepository {
  SupabaseUserRepository(super.config, {super.client});

  @override
  Future<List<AuthUserRecord>> listUsers() => guarded(() async {
        final rows = await client.from('users').select();
        return (rows as List).map((row) {
          final data = Map<String, dynamic>.from(row as Map);
          return AuthUserRecord(
              id: data['id'] as String,
              email: data['email'] as String,
              name: data['name'] as String,
              role: BackendRole.values.byName(data['role'] as String));
        }).toList();
      });

  @override
  Future<void> updateStatus(String userId, BackendAccountStatus status) =>
      guarded(() => client
          .from('users')
          .update({'status': status.name}).eq('id', userId));

  @override
  Future<void> updateProfile(AuthUserRecord user) => guarded(() => client
      .from('users')
      .update({'name': user.name, 'email': user.email}).eq('id', user.id));
}
