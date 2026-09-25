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
    this.description = '',
    this.deposit = 0,
    this.maintenance = 0,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.area = 0,
    this.furnishing = 'unfurnished',
    this.floor,
    this.totalFloors,
    this.address = '',
    this.latitude,
    this.longitude,
    this.availabilityDate,
    this.availableUnits = 1,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String title;
  final String propertyType;
  final String listingType;
  final String city;
  final String locality;
  final double price;
  final String description;
  final double deposit, maintenance, area;
  final int bedrooms, bathrooms, availableUnits;
  final String furnishing, address;
  final int? floor, totalFloors;
  final double? latitude, longitude;
  final DateTime? availabilityDate, createdAt, updatedAt;
  final String? rejectionReason;
  final BackendPropertyStatus status;
  final BackendApprovalStatus approvalStatus;
}

class PropertyImageRecord {
  const PropertyImageRecord({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
    this.isPrimary = false,
    this.displayOrder = 0,
    this.createdAt,
  });

  final String id, propertyId, imageUrl;
  final bool isPrimary;
  final int displayOrder;
  final DateTime? createdAt;
}

class AmenityRecord {
  const AmenityRecord(
      {required this.id, required this.name, this.active = true});

  final String id, name;
  final bool active;
}

class ReviewRecord {
  const ReviewRecord({
    required this.id,
    required this.propertyId,
    required this.reviewerId,
    required this.ownerId,
    required this.rating,
    required this.review,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final String id, propertyId, reviewerId, ownerId, review;
  final int rating;
  final String status;
  final DateTime? createdAt, updatedAt;
}

class ReportRecord {
  const ReportRecord({
    required this.id,
    required this.reporterId,
    required this.reason,
    required this.description,
    required this.status,
    this.propertyId,
    this.reportedUserId,
    this.createdAt,
    this.updatedAt,
  });

  final String id, reporterId, reason, description, status;
  final String? propertyId, reportedUserId;
  final DateTime? createdAt, updatedAt;
}

class RequestRecord {
  const RequestRecord({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.ownerId,
    required this.requestType,
    required this.status,
    this.message = '',
    this.preferredDate,
    this.preferredTime,
  });

  final String id;
  final String propertyId;
  final String tenantId;
  final String ownerId;
  final String requestType;
  final String message;
  final DateTime? preferredDate;
  final String? preferredTime;
  final BackendRequestStatus status;
}
