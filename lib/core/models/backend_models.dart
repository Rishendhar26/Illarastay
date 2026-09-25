enum BackendRole { tenant, owner, admin }

enum BackendSessionState { signedOut, signingIn, signedIn, error }

enum BackendAccountStatus { active, blocked, suspended }

enum BackendPropertyStatus { draft, published, unpublished }

enum BackendApprovalStatus { pending, approved, rejected }

enum BackendRequestStatus { pending, accepted, rejected, completed }

class AuthUserRecord {
  const AuthUserRecord({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  final String id;
  final String email;
  final String name;
  final BackendRole role;
}

class SessionSnapshot {
  const SessionSnapshot({required this.state, this.user, this.message});

  final BackendSessionState state;
  final AuthUserRecord? user;
  final String? message;
}

class PropertyRecord {
  const PropertyRecord({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.propertyType,
    required this.listingType,
    required this.city,
    required this.locality,
    required this.price,
    required this.status,
    required this.approvalStatus,
  });

  final String id;
  final String ownerId;
  final String title;
  final String propertyType;
  final String listingType;
  final String city;
  final String locality;
  final double price;
  final BackendPropertyStatus status;
  final BackendApprovalStatus approvalStatus;
}

class RequestRecord {
  const RequestRecord({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.ownerId,
    required this.requestType,
    required this.status,
  });

  final String id;
  final String propertyId;
  final String tenantId;
  final String ownerId;
  final String requestType;
  final BackendRequestStatus status;
}
