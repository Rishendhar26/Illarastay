import 'package:flutter/material.dart';

void main() => runApp(const IllaraStayApp());

enum UserRole { seeker, owner, admin }

enum PropertyType { pg, room, flat, house, villa, residentialLand, commercial }

enum ListingType { rent, sale }

enum Furnishing { unfurnished, semiFurnished, fullyFurnished }

enum RequestStatus { pending, accepted, rejected, completed }

enum AccountStatus { active, blocked, suspended }

enum PropertyApprovalStatus { pending, approved, rejected }

extension PropertyTypeName on PropertyType {
  String get label => switch (this) {
        PropertyType.pg => 'PG',
        PropertyType.room => 'Room',
        PropertyType.flat => 'Flat',
        PropertyType.house => 'House',
        PropertyType.villa => 'Villa',
        PropertyType.residentialLand => 'Residential land',
        PropertyType.commercial => 'Commercial',
      };
}

extension RequestStatusName on RequestStatus {
  String get label => name[0].toUpperCase() + name.substring(1);
}

extension FurnishingName on Furnishing {
  String get label => switch (this) {
        Furnishing.unfurnished => 'Unfurnished',
        Furnishing.semiFurnished => 'Semi-furnished',
        Furnishing.fullyFurnished => 'Fully furnished',
      };
}

class Property {
  const Property(
      {required this.id,
      required this.title,
      required this.type,
      required this.city,
      required this.locality,
      required this.price,
      required this.area,
      required this.description,
      required this.amenities,
      required this.owner,
      required this.color,
      this.listingType = ListingType.rent,
      this.bedrooms = 0,
      this.bathrooms = 0,
      this.deposit = 0,
      this.maintenance = 0,
      this.furnishing = Furnishing.unfurnished,
      this.floor = 0,
      this.totalFloors = 0,
      this.availability = 'Available now',
      this.address = 'Address shared after a visit is requested',
      this.latitude = 0,
      this.longitude = 0,
      this.availableUnits = 1,
      this.otherCharges = 0,
      this.photos = const [],
      this.published = true,
      this.approvalStatus = PropertyApprovalStatus.approved,
      this.ownerId = 'owner-1'});
  final String id, title, city, locality, description, owner;
  final String availability, address, ownerId;
  final PropertyType type;
  final ListingType listingType;
  final double price, deposit, maintenance;
  final double latitude, longitude, otherCharges;
  final int area, bedrooms, bathrooms, floor, totalFloors;
  final int availableUnits;
  final Furnishing furnishing;
  final List<String> amenities;
  final List<String> photos;
  final Color color;
  final bool published;
  final PropertyApprovalStatus approvalStatus;

  Property copyWith({
    String? id,
    String? title,
    PropertyType? type,
    String? city,
    String? locality,
    String? description,
    String? owner,
    Color? color,
    ListingType? listingType,
    double? price,
    double? deposit,
    double? maintenance,
    double? otherCharges,
    double? latitude,
    double? longitude,
    int? area,
    int? bedrooms,
    int? bathrooms,
    int? floor,
    int? totalFloors,
    int? availableUnits,
    Furnishing? furnishing,
    List<String>? amenities,
    List<String>? photos,
    String? availability,
    String? address,
    String? ownerId,
    bool? published,
    PropertyApprovalStatus? approvalStatus,
  }) =>
      Property(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        city: city ?? this.city,
        locality: locality ?? this.locality,
        price: price ?? this.price,
        area: area ?? this.area,
        description: description ?? this.description,
        amenities: amenities ?? this.amenities,
        owner: owner ?? this.owner,
        color: color ?? this.color,
        listingType: listingType ?? this.listingType,
        bedrooms: bedrooms ?? this.bedrooms,
        bathrooms: bathrooms ?? this.bathrooms,
        deposit: deposit ?? this.deposit,
        maintenance: maintenance ?? this.maintenance,
        furnishing: furnishing ?? this.furnishing,
        floor: floor ?? this.floor,
        totalFloors: totalFloors ?? this.totalFloors,
        availability: availability ?? this.availability,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        availableUnits: availableUnits ?? this.availableUnits,
        otherCharges: otherCharges ?? this.otherCharges,
        photos: photos ?? this.photos,
        published: published ?? this.published,
        approvalStatus: approvalStatus ?? this.approvalStatus,
        ownerId: ownerId ?? this.ownerId,
      );
}

class AppUser {
  AppUser(this.id,
      {required this.name,
      required this.email,
      required this.phone,
      required this.role,
      required this.city,
      required this.createdDate,
      this.status = AccountStatus.active});
  final String id, name, email, phone, city;
  final UserRole role;
  final DateTime createdDate;
  AccountStatus status;
}

class AdminReport {
  AdminReport(this.id,
      {required this.subject,
      required this.reporter,
      required this.reason,
      this.status = 'Pending'});
  final String id, subject, reporter, reason;
  String status;
}

class AdminReview {
  AdminReview(this.id,
      {required this.propertyTitle,
      required this.reviewer,
      required this.rating,
      required this.comment,
      this.status = 'Pending'});
  final String id, propertyTitle, reviewer, comment;
  final int rating;
  String status;
}

class PropertyRequest {
  PropertyRequest(this.id, this.property,
      {this.status = RequestStatus.pending,
      this.preferredDate,
      this.preferredTime,
      this.message = '',
      this.tenantName = 'Aanya Sharma',
      this.requestType = 'Visit request'});
  final String id;
  final Property property;
  final DateTime? preferredDate;
  final TimeOfDay? preferredTime;
  final String message;
  final String tenantName, requestType;
  RequestStatus status;
}

/// Replace this boundary with Firebase, Supabase, or REST without changing the UI.
abstract class PropertyRepository {
  List<Property> properties();
  List<Property> ownedProperties();
  List<PropertyRequest> requests();
  bool saved(String id);
  void toggleSaved(String id);
  void requestVisit(Property property,
      {DateTime? preferredDate, TimeOfDay? preferredTime, String message = ''});
  void updateRequest(String id, RequestStatus status);
  void addProperty(Property property);
  void updateProperty(Property property);
  void deleteProperty(String id);
  void setPublished(String id, bool published);
}

/// Admin data remains behind a separate boundary for a future moderation API.
abstract class AdminRepository {
  List<AppUser> users();
  List<Property> allProperties();
  List<AdminReport> reports();
  List<AdminReview> reviews();
  void setUserStatus(String id, AccountStatus status);
  void setApproval(String id, PropertyApprovalStatus status);
  void resolveReport(String id, String status);
  void resolveReview(String id, String status);
}

class MockPropertyRepository implements PropertyRepository, AdminRepository {
  final savedIds = <String>{'p2'};
  final visitRequests = <PropertyRequest>[
    PropertyRequest('r1', mockProperties.first,
        preferredDate: DateTime(2026, 10, 12),
        preferredTime: const TimeOfDay(hour: 11, minute: 30),
        message: 'I would love to see the natural light and parking.',
        tenantName: 'Aanya Sharma')
  ];
  final ownerProperties = <Property>[
    ...mockProperties.where((p) => p.id == 'p1' || p.id == 'p2' || p.id == 'p6')
  ];
  final mockUsers = <AppUser>[
    AppUser('u1',
        name: 'Aanya Sharma',
        email: 'aanya@example.com',
        phone: '+91 98765 43210',
        role: UserRole.seeker,
        city: 'Bengaluru',
        createdDate: DateTime(2026, 7, 4)),
    AppUser('u2',
        name: 'Aarav Mehta',
        email: 'aarav@illarastay.com',
        phone: '+91 98765 11223',
        role: UserRole.owner,
        city: 'Bengaluru',
        createdDate: DateTime(2026, 6, 18)),
    AppUser('u3',
        name: 'Maya Rao',
        email: 'maya@illarastay.com',
        phone: '+91 98765 22446',
        role: UserRole.owner,
        city: 'Bengaluru',
        createdDate: DateTime(2026, 7, 12),
        status: AccountStatus.suspended),
    AppUser('u4',
        name: 'Ishaan Verma',
        email: 'ishaan@example.com',
        phone: '+91 98765 77889',
        role: UserRole.seeker,
        city: 'Pune',
        createdDate: DateTime(2026, 8, 1)),
    AppUser('u5',
        name: 'Priya Nair',
        email: 'priya@illarastay.com',
        phone: '+91 98765 99001',
        role: UserRole.admin,
        city: 'Bengaluru',
        createdDate: DateTime(2026, 5, 20))
  ];
  final mockReports = <AdminReport>[
    AdminReport('report-1',
        subject: 'The Green Room',
        reporter: 'Ishaan Verma',
        reason: 'Listing address appears misleading.')
  ];
  final mockReviews = <AdminReview>[
    AdminReview('review-1',
        propertyTitle: 'Sunlit 2 BHK in Indiranagar',
        reviewer: 'Aanya Sharma',
        rating: 4,
        comment: 'Helpful owner and a well-maintained home.')
  ];
  @override
  List<Property> properties() => [
        ...ownerProperties,
        ...mockProperties
            .where((p) => !ownerProperties.any((owned) => owned.id == p.id))
      ]
          .where((p) =>
              p.published &&
              p.approvalStatus == PropertyApprovalStatus.approved)
          .toList();
  @override
  List<Property> ownedProperties() => ownerProperties;
  @override
  List<PropertyRequest> requests() => visitRequests;
  @override
  bool saved(String id) => savedIds.contains(id);
  @override
  void toggleSaved(String id) =>
      savedIds.contains(id) ? savedIds.remove(id) : savedIds.add(id);
  @override
  void requestVisit(Property property,
          {DateTime? preferredDate,
          TimeOfDay? preferredTime,
          String message = ''}) =>
      visitRequests.add(PropertyRequest(
          'r${visitRequests.length + 1}', property,
          preferredDate: preferredDate,
          preferredTime: preferredTime,
          message: message));
  @override
  void updateRequest(String id, RequestStatus status) {
    for (final item in visitRequests) {
      if (item.id == id) item.status = status;
    }
  }

  @override
  void addProperty(Property property) => ownerProperties.add(property);

  @override
  void updateProperty(Property property) {
    final index = ownerProperties.indexWhere((item) => item.id == property.id);
    if (index >= 0) ownerProperties[index] = property;
  }

  @override
  void deleteProperty(String id) =>
      ownerProperties.removeWhere((item) => item.id == id);

  @override
  void setPublished(String id, bool published) {
    final index = ownerProperties.indexWhere((item) => item.id == id);
    if (index >= 0) {
      ownerProperties[index] =
          ownerProperties[index].copyWith(published: published);
    }
  }

  @override
  List<AppUser> users() => mockUsers;

  @override
  List<Property> allProperties() => [
        ...ownerProperties,
        ...mockProperties
            .where((p) => !ownerProperties.any((owned) => owned.id == p.id))
      ];

  @override
  List<AdminReport> reports() => mockReports;

  @override
  List<AdminReview> reviews() => mockReviews;

  @override
  void setUserStatus(String id, AccountStatus status) {
    final user = mockUsers.where((item) => item.id == id).firstOrNull;
    user?.status = status;
  }

  @override
  void setApproval(String id, PropertyApprovalStatus status) {
    final index = ownerProperties.indexWhere((item) => item.id == id);
    if (index >= 0) {
      ownerProperties[index] =
          ownerProperties[index].copyWith(approvalStatus: status);
    }
  }

  @override
  void resolveReport(String id, String status) {
    final report = mockReports.where((item) => item.id == id).firstOrNull;
    report?.status = status;
  }

  @override
  void resolveReview(String id, String status) {
    final review = mockReviews.where((item) => item.id == id).firstOrNull;
    review?.status = status;
  }
}

final mockProperties = <Property>[
  const Property(
      id: 'p1',
      title: 'Sunlit 2 BHK in Indiranagar',
      type: PropertyType.flat,
      city: 'Bengaluru',
      locality: 'Indiranagar',
      price: 32000,
      area: 1180,
      bedrooms: 2,
      bathrooms: 2,
      deposit: 64000,
      maintenance: 2800,
      furnishing: Furnishing.semiFurnished,
      floor: 3,
      totalFloors: 5,
      availability: 'Available from 15 Oct 2026',
      description:
          'A calm, thoughtfully planned home close to cafes and transit.',
      amenities: ['Lift', 'Power backup', 'Parking'],
      owner: 'Aarav Mehta',
      color: Color(0xffdbe9df)),
  const Property(
      id: 'p2',
      title: 'The Green Room',
      type: PropertyType.room,
      city: 'Bengaluru',
      locality: 'Koramangala',
      price: 14500,
      area: 240,
      bedrooms: 1,
      bathrooms: 1,
      deposit: 29000,
      maintenance: 1200,
      furnishing: Furnishing.fullyFurnished,
      floor: 2,
      totalFloors: 4,
      availability: 'Available now',
      description:
          'A private room in a well-managed shared home for professionals.',
      amenities: ['Wi-Fi', 'Housekeeping', 'AC'],
      owner: 'Maya Rao',
      color: Color(0xffe7e0d0)),
  const Property(
      id: 'p3',
      title: 'Oakwood Family Villa',
      type: PropertyType.villa,
      listingType: ListingType.sale,
      city: 'Pune',
      locality: 'Kalyani Nagar',
      price: 18500000,
      area: 2860,
      bedrooms: 4,
      bathrooms: 4,
      deposit: 0,
      furnishing: Furnishing.semiFurnished,
      floor: 0,
      totalFloors: 2,
      description:
          'A spacious villa with a garden, natural light, and room to grow.',
      amenities: ['Garden', 'Parking', 'Security'],
      owner: 'Nisha Properties',
      color: Color(0xffd9e2e9)),
  const Property(
      id: 'p4',
      title: 'Ready-to-build Residential Plot',
      type: PropertyType.residentialLand,
      listingType: ListingType.sale,
      city: 'Hyderabad',
      locality: 'Kompally',
      price: 7800000,
      area: 1500,
      furnishing: Furnishing.unfurnished,
      description:
          'A clear-title plot in a growing neighbourhood with excellent access.',
      amenities: ['Gated community', 'Water connection'],
      owner: 'Saanvi Estates',
      color: Color(0xffe8ddd4)),
  const Property(
      id: 'p5',
      title: 'Lakeside Commercial Studio',
      type: PropertyType.commercial,
      city: 'Mumbai',
      locality: 'Powai',
      price: 62000,
      area: 950,
      furnishing: Furnishing.unfurnished,
      description:
          'Street-facing commercial space suited to a boutique or studio.',
      amenities: ['Signage', 'Parking', 'Power backup'],
      owner: 'Harbor Homes',
      color: Color(0xffdfe7d5)),
  const Property(
      id: 'p6',
      title: 'Maple House near Manyata Tech Park',
      type: PropertyType.house,
      city: 'Bengaluru',
      locality: 'Hebbal',
      price: 48000,
      area: 2100,
      bedrooms: 3,
      bathrooms: 3,
      deposit: 96000,
      maintenance: 3500,
      furnishing: Furnishing.semiFurnished,
      floor: 0,
      totalFloors: 2,
      availability: 'Available from 1 Nov 2026',
      approvalStatus: PropertyApprovalStatus.pending,
      description:
          'An airy independent home with a quiet garden and excellent connectivity.',
      amenities: ['Garden', 'Parking', 'Pet friendly'],
      owner: 'Rohan Kapoor',
      color: Color(0xffe4e0d2)),
  const Property(
      id: 'p7',
      title: 'Cedar Co-living PG',
      type: PropertyType.pg,
      city: 'Hyderabad',
      locality: 'Gachibowli',
      price: 11000,
      area: 180,
      bedrooms: 1,
      bathrooms: 1,
      deposit: 11000,
      maintenance: 0,
      furnishing: Furnishing.fullyFurnished,
      floor: 4,
      totalFloors: 8,
      description:
          'A community-led PG with meals, housekeeping, and a welcoming common area.',
      amenities: ['Meals', 'Wi-Fi', 'Housekeeping', 'Laundry'],
      owner: 'Cedar Living',
      color: Color(0xffdce8e1)),
];

class IllaraStayApp extends StatelessWidget {
  const IllaraStayApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IllaraStay',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff176b52)),
          scaffoldBackgroundColor: const Color(0xfff7f8f6)),
      home: const SplashScreen());
}

class Brand extends StatelessWidget {
  const Brand({this.small = false, super.key});
  final bool small;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: small ? 34 : 48,
            height: small ? 34 : 48,
            decoration: BoxDecoration(
                color: const Color(0xff123047),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.home_work_rounded,
                color: const Color(0xffa9d6b6), size: small ? 20 : 29)),
        const SizedBox(width: 10),
        Text('IllaraStay',
            style: TextStyle(
                fontSize: small ? 19 : 27,
                fontWeight: FontWeight.w800,
                color: const Color(0xff123047)))
      ]);
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const Brand(),
                    const SizedBox(height: 28),
                    Text('Find a place that feels like home.',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff123047))),
                    const SizedBox(height: 14),
                    const Text(
                        'Spaces for every chapter, from a room for today to land for tomorrow.',
                        style: TextStyle(color: Colors.black54, height: 1.4)),
                    const SizedBox(height: 36),
                    Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xffdcebe0),
                            borderRadius: BorderRadius.circular(24)),
                        child: const Icon(Icons.house_rounded,
                            size: 78, color: Color(0xff176b52))),
                    const Spacer(),
                    FilledButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen())),
                        child: const Text('Get started'))
                  ]))));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
      title: 'Welcome back',
      subtitle: 'Sign in to continue your property journey.',
      button: 'Sign in',
      next: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleScreen())),
      showAdminEntry: true);
}

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
      title: 'Admin portal',
      subtitle: 'Secure access for IllaraStay operations staff.',
      button: 'Sign in as admin',
      showAdminEntry: false,
      next: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AdminShell(repo: MockPropertyRepository()))));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
      title: 'Create your account',
      subtitle: 'Start with a few details. Complete your profile later.',
      button: 'Continue',
      next: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleScreen())),
      register: true);
}

class AuthPage extends StatelessWidget {
  const AuthPage(
      {required this.title,
      required this.subtitle,
      required this.button,
      required this.next,
      this.register = false,
      this.showAdminEntry = false,
      super.key});
  final String title, subtitle, button;
  final VoidCallback next;
  final bool register;
  final bool showAdminEntry;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar:
          AppBar(leading: const BackButton(), title: const Brand(small: true)),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700, color: const Color(0xff123047))),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 28),
        if (register)
          const TextField(
              decoration: InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline))),
        if (register) const SizedBox(height: 14),
        const TextField(
            decoration: InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline))),
        const SizedBox(height: 14),
        const TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
        const SizedBox(height: 24),
        FilledButton(onPressed: next, child: Text(button)),
        const SizedBox(height: 12),
        TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => register
                        ? const LoginScreen()
                        : const RegisterScreen())),
            child: Text(register
                ? 'Already have an account? Sign in'
                : 'New to IllaraStay? Create an account')),
        if (showAdminEntry)
          TextButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminLoginScreen())),
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Admin portal'))
      ]));
}

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Spacer(),
            const Brand(),
            const SizedBox(height: 36),
            Text('How will you use IllaraStay?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff123047))),
            const SizedBox(height: 24),
            RoleTile(
                icon: Icons.search,
                title: 'I am looking for a place',
                text: 'Explore homes, save favourites and request visits.',
                onTap: () => openApp(context, UserRole.seeker)),
            const SizedBox(height: 12),
            RoleTile(
                icon: Icons.add_business,
                title: 'I want to list a property',
                text: 'Manage listings and connect with prospective tenants.',
                onTap: () => openApp(context, UserRole.owner)),
            const Spacer()
          ])));
}

void openApp(BuildContext context, UserRole role) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (_) => Shell(role: role, repo: MockPropertyRepository())));

class RoleTile extends StatelessWidget {
  const RoleTile(
      {required this.icon,
      required this.title,
      required this.text,
      required this.onTap,
      super.key});
  final IconData icon;
  final String title, text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(14),
          leading: CircleAvatar(
              backgroundColor: const Color(0xffdcebe0),
              child: Icon(icon, color: const Color(0xff176b52))),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(text),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16)));
}

class Shell extends StatefulWidget {
  const Shell({required this.role, required this.repo, super.key});
  final UserRole role;
  final PropertyRepository repo;
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final seeker = widget.role == UserRole.seeker;
    final pages = seeker
        ? [
            Home(repo: widget.repo, refresh: refresh),
            Search(repo: widget.repo, refresh: refresh),
            Saved(repo: widget.repo, refresh: refresh),
            Requests(repo: widget.repo),
            const Profile()
          ]
        : [
            Dashboard(repo: widget.repo, refresh: refresh),
            Listings(repo: widget.repo, refresh: refresh),
            OwnerRequests(repo: widget.repo, refresh: refresh),
            const Profile()
          ];
    final labels = seeker
        ? ['Home', 'Search', 'Saved', 'Requests', 'Profile']
        : ['Dashboard', 'Properties', 'Requests', 'Profile'];
    final icons = seeker
        ? [
            Icons.home_outlined,
            Icons.search,
            Icons.bookmark_border,
            Icons.assignment_outlined,
            Icons.person_outline
          ]
        : [
            Icons.dashboard_outlined,
            Icons.apartment,
            Icons.inbox_outlined,
            Icons.person_outline
          ];
    return Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: [
              for (var i = 0; i < labels.length; i++)
                NavigationDestination(icon: Icon(icons[i]), label: labels[i])
            ]));
  }

  void refresh() => setState(() {});
}

class AdminShell extends StatefulWidget {
  const AdminShell({required this.repo, super.key});
  final MockPropertyRepository repo;
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminDashboard(repo: widget.repo, refresh: refresh),
      AdminUsers(repo: widget.repo, refresh: refresh),
      AdminProperties(repo: widget.repo, refresh: refresh),
      AdminMore(repo: widget.repo, refresh: refresh)
    ];
    const labels = ['Dashboard', 'Users', 'Properties', 'More'];
    const icons = [
      Icons.dashboard_outlined,
      Icons.people_outline,
      Icons.apartment_outlined,
      Icons.menu_rounded
    ];
    return Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: [
              for (var i = 0; i < labels.length; i++)
                NavigationDestination(icon: Icon(icons[i]), label: labels[i])
            ]));
  }

  void refresh() => setState(() {});
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) {
    final users = repo.users();
    final properties = repo.allProperties();
    return AdminFrame(
        title: 'Admin dashboard',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Heading('Operations overview'),
          const SizedBox(height: 6),
          const Text('Keep the IllaraStay marketplace healthy and trusted.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          Row(children: [
            AdminStat(value: '${users.length}', label: 'Total users'),
            const SizedBox(width: 10),
            AdminStat(
                value:
                    '${users.where((u) => u.role == UserRole.seeker).length}',
                label: 'Tenants')
          ]),
          const SizedBox(height: 10),
          Row(children: [
            AdminStat(
                value: '${users.where((u) => u.role == UserRole.owner).length}',
                label: 'Owners'),
            const SizedBox(width: 10),
            AdminStat(value: '${properties.length}', label: 'Properties')
          ]),
          const SizedBox(height: 10),
          Row(children: [
            AdminStat(
                value:
                    '${properties.where((p) => p.approvalStatus == PropertyApprovalStatus.pending).length}',
                label: 'Pending approvals'),
            const SizedBox(width: 10),
            AdminStat(
                value:
                    '${properties.where((p) => p.published && p.approvalStatus == PropertyApprovalStatus.approved).length}',
                label: 'Active properties')
          ]),
          const SizedBox(height: 10),
          Row(children: [
            AdminStat(
                value:
                    '${repo.reports().where((r) => r.status == 'Pending').length}',
                label: 'Pending reports'),
            const SizedBox(width: 10),
            AdminStat(
                value:
                    '${repo.reviews().where((r) => r.status == 'Pending').length}',
                label: 'Pending reviews')
          ]),
          const SizedBox(height: 26),
          const Heading('Recent activity'),
          const SizedBox(height: 10),
          const ActivityRow(
              icon: Icons.person_add_outlined,
              title: 'New tenant registered',
              detail: 'Aanya Sharma joined Bengaluru'),
          const ActivityRow(
              icon: Icons.home_work_outlined,
              title: 'Property awaiting review',
              detail: 'Sunlit 2 BHK in Indiranagar'),
          const ActivityRow(
              icon: Icons.flag_outlined,
              title: 'New report received',
              detail: 'The Green Room was reported')
        ]));
  }
}

class AdminStat extends StatelessWidget {
  const AdminStat({required this.value, required this.label, super.key});
  final String value, label;
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xff123047),
              borderRadius: BorderRadius.circular(14)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12))
          ])));
}

class ActivityRow extends StatelessWidget {
  const ActivityRow(
      {required this.icon,
      required this.title,
      required this.detail,
      super.key});
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
          backgroundColor: const Color(0xffdcebe0),
          child: Icon(icon, color: const Color(0xff176b52))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail));
}

class AdminUsers extends StatelessWidget {
  const AdminUsers({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'User management',
      child: Column(
          children: repo
              .users()
              .map((user) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                      leading: CircleAvatar(child: Text(user.name[0])),
                      title: Text(user.name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          '${user.email}\n${user.phone} • ${user.city}\n${_roleLabel(user.role)} • ${_statusLabel(user.status)} • Joined ${user.createdDate.day}/${user.createdDate.month}/${user.createdDate.year}'),
                      isThreeLine: true,
                      onTap: () => showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                                  title: Text(user.name),
                                  content: Text(
                                      '${user.email}\n${user.phone}\n${_roleLabel(user.role)}\n${_statusLabel(user.status)}\nJoined ${user.createdDate.day}/${user.createdDate.month}/${user.createdDate.year}'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'))
                                  ])),
                      trailing: PopupMenuButton<AccountStatus>(
                          tooltip: 'Manage user',
                          onSelected: (status) {
                            repo.setUserStatus(user.id, status);
                            refresh();
                          },
                          itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: AccountStatus.active,
                                    child: Text('Unblock / activate')),
                                PopupMenuItem(
                                    value: AccountStatus.blocked,
                                    child: Text('Block')),
                                PopupMenuItem(
                                    value: AccountStatus.suspended,
                                    child: Text('Suspend'))
                              ]))))
              .toList()));

  String _roleLabel(UserRole role) => switch (role) {
        UserRole.seeker => 'Tenant',
        UserRole.owner => 'Owner',
        UserRole.admin => 'Admin'
      };

  String _statusLabel(AccountStatus status) => switch (status) {
        AccountStatus.active => 'Active',
        AccountStatus.blocked => 'Blocked',
        AccountStatus.suspended => 'Suspended'
      };
}

class AdminProperties extends StatelessWidget {
  const AdminProperties({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Property moderation',
      child: Column(
          children: repo
              .allProperties()
              .map((property) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(children: [
                        Row(children: [
                          Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                  color: property.color,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.home_work_rounded,
                                  color: Color(0xff176b52))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(property.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Text(
                                    '${property.owner} • ${property.type.label}',
                                    style:
                                        const TextStyle(color: Colors.black54)),
                                Text(
                                    '${property.locality}, ${property.city} • ₹${property.price.toStringAsFixed(0)}')
                              ]))
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          StatusBadge(
                              label: _approvalLabel(property.approvalStatus),
                              positive: property.approvalStatus ==
                                  PropertyApprovalStatus.approved),
                          const Spacer(),
                          Text(property.published ? 'Published' : 'Unpublished',
                              style: const TextStyle(color: Colors.black54)),
                          if (property.approvalStatus ==
                              PropertyApprovalStatus.pending) ...[
                            const SizedBox(width: 8),
                            TextButton(
                                onPressed: () {
                                  repo.setApproval(property.id,
                                      PropertyApprovalStatus.rejected);
                                  refresh();
                                },
                                child: const Text('Reject')),
                            FilledButton(
                                onPressed: () {
                                  repo.setApproval(property.id,
                                      PropertyApprovalStatus.approved);
                                  refresh();
                                },
                                child: const Text('Approve'))
                          ]
                        ]),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Details(
                                            property: property,
                                            repo: repo,
                                            refresh: refresh))),
                                icon: const Icon(Icons.visibility_outlined),
                                label: const Text('View property')))
                      ]))))
              .toList()));

  String _approvalLabel(PropertyApprovalStatus status) => switch (status) {
        PropertyApprovalStatus.pending => 'Pending approval',
        PropertyApprovalStatus.approved => 'Approved',
        PropertyApprovalStatus.rejected => 'Rejected'
      };
}

class AdminMore extends StatelessWidget {
  const AdminMore({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Admin tools',
      child: Column(children: [
        AdminMenuTile(
            icon: Icons.flag_outlined,
            title: 'Reports',
            subtitle:
                '${repo.reports().where((r) => r.status == 'Pending').length} pending',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AdminReports(repo: repo, refresh: refresh)))),
        AdminMenuTile(
            icon: Icons.rate_review_outlined,
            title: 'Reviews',
            subtitle:
                '${repo.reviews().where((r) => r.status == 'Pending').length} pending',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AdminReviews(repo: repo, refresh: refresh)))),
        AdminMenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Moderation preferences',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminSettings()))),
        AdminMenuTile(
            icon: Icons.person_outline,
            title: 'Admin profile',
            subtitle: 'Priya Nair',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminProfile()))),
        const SizedBox(height: 18),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst))
      ]));
}

class AdminMenuTile extends StatelessWidget {
  const AdminMenuTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap,
      super.key});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: const Color(0xff176b52)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right)));
}

class AdminReports extends StatelessWidget {
  const AdminReports({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Reports',
      child: Column(
          children: repo
              .reports()
              .map((report) => Card(
                  elevation: 0,
                  child: ListTile(
                      title: Text(report.subject,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${report.reporter}\n${report.reason}'),
                      isThreeLine: true,
                      trailing: report.status == 'Pending'
                          ? TextButton(
                              onPressed: () {
                                repo.resolveReport(report.id, 'Resolved');
                                refresh();
                              },
                              child: const Text('Resolve'))
                          : const Text('Resolved'))))
              .toList()));
}

class AdminReviews extends StatelessWidget {
  const AdminReviews({required this.repo, required this.refresh, super.key});
  final MockPropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Reviews',
      child: Column(
          children: repo
              .reviews()
              .map((review) => Card(
                  elevation: 0,
                  child: ListTile(
                      title: Text(review.propertyTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          '${review.reviewer} • ${'★' * review.rating}\n${review.comment}'),
                      isThreeLine: true,
                      trailing: review.status == 'Pending'
                          ? TextButton(
                              onPressed: () {
                                repo.resolveReview(review.id, 'Published');
                                refresh();
                              },
                              child: const Text('Publish'))
                          : const Text('Published'))))
              .toList()));
}

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});
  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  bool approvals = true;
  bool reviewAlerts = true;
  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Settings',
      child: Column(children: [
        SwitchListTile(
            title: const Text('Require property approval'),
            subtitle: const Text(
                'Review owner listings before they appear publicly.'),
            value: approvals,
            onChanged: (value) => setState(() => approvals = value)),
        SwitchListTile(
            title: const Text('Review alerts'),
            subtitle:
                const Text('Notify admins when a new review needs moderation.'),
            value: reviewAlerts,
            onChanged: (value) => setState(() => reviewAlerts = value))
      ]));
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});
  @override
  Widget build(BuildContext context) => AdminFrame(
      title: 'Admin profile',
      child: Column(children: [
        const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xffdcebe0),
            child: Text('P',
                style: TextStyle(fontSize: 28, color: Color(0xff176b52)))),
        const SizedBox(height: 12),
        const Text('Priya Nair',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const Text('priya@illarastay.com',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 22),
        const ListTile(
            leading: Icon(Icons.admin_panel_settings_outlined),
            title: Text('Operations administrator'),
            subtitle: Text('Full moderation access')),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst))
      ]));
}

class AdminFrame extends StatelessWidget {
  const AdminFrame({required this.title, required this.child, super.key});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
          child: CustomScrollView(slivers: [
        SliverAppBar(
            pinned: true,
            title: Row(children: [
              const Icon(Icons.admin_panel_settings_outlined, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
            ])),
        SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(child: child))
      ]));
}

class Frame extends StatelessWidget {
  const Frame({required this.title, required this.child, super.key});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
          child: CustomScrollView(slivers: [
        SliverAppBar(
            pinned: true,
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700))),
        SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(child: child))
      ]));
}

class Heading extends StatelessWidget {
  const Heading(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 19, fontWeight: FontWeight.w700, color: Color(0xff123047)));
}

class Home extends StatelessWidget {
  const Home({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'Good morning, Aanya',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Heading('Find your next address'),
        const SizedBox(height: 18),
        SearchBar(
            hintText: 'Search by city, locality or landmark',
            leading: const Icon(Icons.search),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Search(repo: repo, refresh: refresh)))),
        const SizedBox(height: 24),
        const Heading('Explore categories'),
        const SizedBox(height: 12),
        SizedBox(
            height: 42,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: PropertyType.values
                    .map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                            label: Text(type.label),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Search(
                                        repo: repo,
                                        refresh: refresh,
                                        initialFilter: type))))))
                    .toList())),
        const SizedBox(height: 24),
        const Heading('Handpicked for you'),
        const SizedBox(height: 12),
        ...repo
            .properties()
            .take(3)
            .map((p) => ListingCard(property: p, repo: repo, refresh: refresh))
      ]));
}

class Search extends StatefulWidget {
  const Search(
      {required this.repo,
      required this.refresh,
      this.initialFilter,
      super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  final PropertyType? initialFilter;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';
  PropertyType? filter;
  double? minPrice;
  double? maxPrice;
  int? bedrooms;
  Furnishing? furnishing;
  final selectedAmenities = <String>{};

  @override
  void initState() {
    super.initState();
    filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.repo
        .properties()
        .where((p) =>
            (filter == null || p.type == filter) &&
            '${p.title} ${p.city} ${p.locality}'
                .toLowerCase()
                .contains(query.toLowerCase()) &&
            (minPrice == null || p.price >= minPrice!) &&
            (maxPrice == null || p.price <= maxPrice!) &&
            (bedrooms == null || p.bedrooms >= bedrooms!) &&
            (furnishing == null || p.furnishing == furnishing) &&
            selectedAmenities.every(p.amenities.contains))
        .toList();
    return Frame(
        title: 'Search homes',
        child: Column(children: [
          TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                  hintText: 'Search homes', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: SizedBox(
                    height: 42,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      ChoiceChip(
                          label: const Text('All'),
                          selected: filter == null,
                          onSelected: (_) => setState(() => filter = null)),
                      ...PropertyType.values.map((t) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ChoiceChip(
                              label: Text(t.label),
                              selected: filter == t,
                              onSelected: (_) => setState(() => filter = t))))
                    ]))),
            IconButton(
                tooltip: 'More filters',
                onPressed: () => _showFilters(context),
                icon: const Icon(Icons.tune))
          ]),
          if (minPrice != null ||
              maxPrice != null ||
              bedrooms != null ||
              furnishing != null ||
              selectedAmenities.isNotEmpty)
            Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear, size: 17),
                    label: const Text('Clear advanced filters'))),
          const SizedBox(height: 16),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('${data.length} places found')),
          const SizedBox(height: 12),
          ...data.map((p) => ListingCard(
              property: p, repo: widget.repo, refresh: widget.refresh))
        ]));
  }

  void _clearFilters() => setState(() {
        minPrice = null;
        maxPrice = null;
        bedrooms = null;
        furnishing = null;
        selectedAmenities.clear();
      });

  Future<void> _showFilters(BuildContext context) async {
    final result = await showModalBottomSheet<_FilterValues>(
        context: context,
        isScrollControlled: true,
        builder: (_) => FilterSheet(
            minPrice: minPrice,
            maxPrice: maxPrice,
            bedrooms: bedrooms,
            furnishing: furnishing,
            amenities: selectedAmenities));
    if (!mounted || result == null) return;
    setState(() {
      minPrice = result.minPrice;
      maxPrice = result.maxPrice;
      bedrooms = result.bedrooms;
      furnishing = result.furnishing;
      selectedAmenities
        ..clear()
        ..addAll(result.amenities);
    });
  }
}

class _FilterValues {
  const _FilterValues(
      {this.minPrice,
      this.maxPrice,
      this.bedrooms,
      this.furnishing,
      required this.amenities});
  final double? minPrice, maxPrice;
  final int? bedrooms;
  final Furnishing? furnishing;
  final Set<String> amenities;
}

class FilterSheet extends StatefulWidget {
  const FilterSheet(
      {required this.minPrice,
      required this.maxPrice,
      required this.bedrooms,
      required this.furnishing,
      required this.amenities,
      super.key});
  final double? minPrice, maxPrice;
  final int? bedrooms;
  final Furnishing? furnishing;
  final Set<String> amenities;
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final minController = TextEditingController(
      text: widget.minPrice == null ? '' : widget.minPrice!.toStringAsFixed(0));
  late final maxController = TextEditingController(
      text: widget.maxPrice == null ? '' : widget.maxPrice!.toStringAsFixed(0));
  int? bedrooms;
  Furnishing? furnishing;
  late final amenities = {...widget.amenities};
  final allAmenities = ['Parking', 'Wi-Fi', 'Lift', 'Power backup', 'Garden'];

  @override
  void initState() {
    super.initState();
    bedrooms = widget.bedrooms;
    furnishing = widget.furnishing;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  const Expanded(child: Heading('Filter properties')),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ]),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Min price', prefixText: '₹ '))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Max price', prefixText: '₹ ')))
                ]),
                const SizedBox(height: 18),
                const Text('Bedrooms',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                Wrap(spacing: 8, children: [
                  for (final value in [1, 2, 3, 4])
                    ChoiceChip(
                        label: Text('$value+'),
                        selected: bedrooms == value,
                        onSelected: (_) => setState(() => bedrooms = value))
                ]),
                const SizedBox(height: 12),
                DropdownButtonFormField<Furnishing>(
                    initialValue: furnishing,
                    decoration: const InputDecoration(labelText: 'Furnishing'),
                    items: Furnishing.values
                        .map((value) => DropdownMenuItem(
                            value: value, child: Text(value.label)))
                        .toList(),
                    onChanged: (value) => setState(() => furnishing = value)),
                const SizedBox(height: 14),
                const Text('Amenities',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                Wrap(spacing: 8, children: [
                  for (final amenity in allAmenities)
                    FilterChip(
                        label: Text(amenity),
                        selected: amenities.contains(amenity),
                        onSelected: (selected) => setState(() => selected
                            ? amenities.add(amenity)
                            : amenities.remove(amenity)))
                ]),
                const SizedBox(height: 18),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () => Navigator.pop(
                            context,
                            _FilterValues(
                                minPrice: double.tryParse(minController.text),
                                maxPrice: double.tryParse(maxController.text),
                                bedrooms: bedrooms,
                                furnishing: furnishing,
                                amenities: amenities)),
                        child: const Text('Apply filters')))
              ]))));
}

class ListingCard extends StatelessWidget {
  const ListingCard(
      {required this.property,
      required this.repo,
      required this.refresh,
      super.key});
  final Property property;
  final PropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    Details(property: property, repo: repo, refresh: refresh))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
                height: 130,
                color: property.color,
                child: const Center(
                    child: Icon(Icons.home_work_rounded,
                        size: 58, color: Color(0xff176b52)))),
            Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      repo.toggleSaved(property.id);
                      refresh();
                    },
                    icon: Icon(
                        repo.saved(property.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: const Color(0xff176b52)))),
          ]),
          Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(property.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('${property.locality}, ${property.city}',
                          style: const TextStyle(color: Colors.black54))
                    ])),
                Text('₹${property.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: Color(0xff123047))),
              ])),
        ]),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details(
      {required this.property,
      required this.repo,
      required this.refresh,
      super.key});
  final Property property;
  final PropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            tooltip: 'Save property',
            onPressed: () {
              repo.toggleSaved(property.id);
              refresh();
            },
            icon: Icon(repo.saved(property.id)
                ? Icons.bookmark
                : Icons.bookmark_border))
      ]),
      body: ListView(children: [
        SizedBox(
            height: 230,
            child: PageView(children: [
              _GalleryPanel(
                  color: property.color, icon: Icons.home_work_rounded),
              const _GalleryPanel(
                  color: Color(0xffe3ece7), icon: Icons.photo_library_outlined),
              const _GalleryPanel(
                  color: Color(0xffe7e0d0), icon: Icons.map_outlined)
            ])),
        Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Chip(label: Text(property.type.label)),
              Text(property.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              Text('${property.locality}, ${property.city}',
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 14),
              Text(
                  '₹${property.price.toStringAsFixed(0)}${property.listingType == ListingType.rent ? ' / month' : ''}',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff176b52))),
              const SizedBox(height: 14),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _InfoPill(
                    icon: Icons.square_foot, text: '${property.area} sq ft'),
                if (property.bedrooms > 0)
                  _InfoPill(
                      icon: Icons.bed_outlined,
                      text: '${property.bedrooms} bedrooms'),
                if (property.bathrooms > 0)
                  _InfoPill(
                      icon: Icons.bathtub_outlined,
                      text: '${property.bathrooms} baths'),
                _InfoPill(
                    icon: Icons.weekend_outlined,
                    text: property.furnishing.label),
                if (property.floor > 0)
                  _InfoPill(
                      icon: Icons.layers_outlined,
                      text: 'Floor ${property.floor}/${property.totalFloors}')
              ]),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                    child: _DetailValue(
                        label: 'Deposit',
                        value: property.deposit == 0
                            ? 'Not applicable'
                            : '₹${property.deposit.toStringAsFixed(0)}')),
                Expanded(
                    child: _DetailValue(
                        label: 'Maintenance',
                        value: property.maintenance == 0
                            ? 'Included'
                            : '₹${property.maintenance.toStringAsFixed(0)} / month'))
              ]),
              const SizedBox(height: 12),
              _DetailValue(label: 'Availability', value: property.availability),
              const SizedBox(height: 18),
              const Heading('Amenities'),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: property.amenities
                      .map((a) => Chip(
                          avatar: const Icon(Icons.check, size: 16),
                          label: Text(a)))
                      .toList()),
              const SizedBox(height: 18),
              const Heading('About this property'),
              const SizedBox(height: 8),
              Text(property.description,
                  style: const TextStyle(color: Colors.black54, height: 1.5)),
              const SizedBox(height: 18),
              const Heading('Owner information'),
              const SizedBox(height: 10),
              Row(children: [
                CircleAvatar(child: Text(property.owner[0])),
                const SizedBox(width: 10),
                Expanded(
                    child: Text('Listed by ${property.owner}',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                OutlinedButton.icon(
                    onPressed: () => _contactOwner(context),
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Contact'))
              ]),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                      onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => RequestVisitSheet(
                              property: property, repo: repo)),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Request a visit')))
            ]))
      ]));

  void _contactOwner(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
              title: Text('Contact ${property.owner}'),
              content: const Text(
                  'The owner will be notified of your interest. You can continue the conversation after they respond.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
                FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Owner contact request sent.')));
                    },
                    child: const Text('Send request'))
              ]));
}

class _GalleryPanel extends StatelessWidget {
  const _GalleryPanel({required this.color, required this.icon});
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
      color: color,
      child:
          Center(child: Icon(icon, size: 86, color: const Color(0xff176b52))));
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) =>
      Chip(avatar: Icon(icon, size: 17), label: Text(text));
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700))
      ]);
}

class RequestVisitSheet extends StatefulWidget {
  const RequestVisitSheet(
      {required this.property, required this.repo, super.key});
  final Property property;
  final PropertyRepository repo;
  @override
  State<RequestVisitSheet> createState() => _RequestVisitSheetState();
}

class _RequestVisitSheetState extends State<RequestVisitSheet> {
  DateTime? date;
  TimeOfDay? time;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Expanded(child: Heading('Request a visit')),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ]),
                Text(widget.property.title,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () async {
                            final value = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 90)),
                                initialDate: DateTime.now()
                                    .add(const Duration(days: 1)));
                            if (value != null) setState(() => date = value);
                          },
                          icon: const Icon(Icons.event_outlined),
                          label: Text(date == null
                              ? 'Preferred date'
                              : '${date!.day}/${date!.month}/${date!.year}'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () async {
                            final value = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (value != null) setState(() => time = value);
                          },
                          icon: const Icon(Icons.schedule_outlined),
                          label: Text(time == null
                              ? 'Preferred time'
                              : time!.format(context))))
                ]),
                const SizedBox(height: 14),
                TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Message to owner',
                        hintText: 'Tell the owner a little about your visit')),
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: date == null || time == null
                            ? null
                            : () {
                                widget.repo.requestVisit(widget.property,
                                    preferredDate: date,
                                    preferredTime: time,
                                    message: messageController.text);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Visit request sent.')));
                              },
                        child: const Text('Send visit request')))
              ])));

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

class Saved extends StatelessWidget {
  const Saved({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) {
    final values = repo.properties().where((p) => repo.saved(p.id));
    return Frame(
        title: 'Saved homes',
        child: values.isEmpty
            ? const Empty(title: 'Nothing saved yet')
            : Column(
                children: values
                    .map((p) =>
                        ListingCard(property: p, repo: repo, refresh: refresh))
                    .toList()));
  }
}

class Requests extends StatelessWidget {
  const Requests({required this.repo, super.key});
  final PropertyRepository repo;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'My requests',
      child: repo.requests().isEmpty
          ? const Empty(title: 'No visit requests yet')
          : Column(
              children: repo
                  .requests()
                  .map((r) => RequestTile(request: r))
                  .toList()));
}

class RequestTile extends StatelessWidget {
  const RequestTile({required this.request, super.key});
  final PropertyRequest request;
  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      child: ExpansionTile(
          title: Text(request.property.title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle:
              Text('${request.property.locality}, ${request.property.city}'),
          trailing: Chip(label: Text(request.status.label)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(request.preferredDate == null
                    ? 'Appointment: To be scheduled'
                    : 'Appointment: ${request.preferredDate!.day}/${request.preferredDate!.month}/${request.preferredDate!.year} at ${request.preferredTime?.format(context) ?? 'preferred time'}')),
            if (request.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('"${request.message}"',
                      style: const TextStyle(color: Colors.black54)))
            ]
          ]));
}

class Empty extends StatelessWidget {
  const Empty({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(children: [
            const Icon(Icons.inbox_outlined,
                size: 52, color: Color(0xff176b52)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
          ])));
}

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'Aanya Sharma';
  String email = 'aanya@example.com';
  String phone = '+91 98765 43210';
  String city = 'Bengaluru';

  @override
  Widget build(BuildContext context) => Frame(
      title: 'Profile',
      child: Column(children: [
        const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xffdcebe0),
            child: Text('A',
                style: TextStyle(fontSize: 28, color: Color(0xff176b52)))),
        const SizedBox(height: 12),
        Text(name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        Text(email, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        Card(
            elevation: 0,
            child: Column(children: [
              ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(phone),
                  subtitle: const Text('Phone number')),
              ListTile(
                  leading: const Icon(Icons.location_city_outlined),
                  title: Text(city),
                  subtitle: const Text('Current city'))
            ])),
        const SizedBox(height: 12),
        ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit profile'),
            onTap: _editProfile),
        const ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notifications')),
        const ListTile(
            leading: Icon(Icons.help_outline), title: Text('Help and support')),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst))
      ]));

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: phone);
    final cityController = TextEditingController(text: city);
    final saved = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('Edit profile'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name')),
                  TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone')),
                  TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'))
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Save'))
                ]));
    if (!mounted) return;
    if (saved == true) {
      setState(() {
        name = nameController.text.trim().isEmpty
            ? name
            : nameController.text.trim();
        phone = phoneController.text.trim().isEmpty
            ? phone
            : phoneController.text.trim();
        city = cityController.text.trim().isEmpty
            ? city
            : cityController.text.trim();
      });
    }
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'Owner dashboard',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Heading('Welcome back, Aanya'),
        const SizedBox(height: 6),
        const Text('Here is how your property portfolio is doing.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),
        Row(children: [
          Stat(
              value:
                  '${repo.ownedProperties().where((p) => p.published).length}',
              label: 'Active properties'),
          const SizedBox(width: 12),
          Stat(
              value: '${repo.ownedProperties().length}',
              label: 'Total listings')
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Stat(
              value:
                  '${repo.requests().where((r) => r.status == RequestStatus.pending).length}',
              label: 'Pending requests'),
          const SizedBox(width: 12),
          Stat(
              value:
                  '${repo.requests().where((r) => r.status == RequestStatus.accepted).length}',
              label: 'Upcoming visits')
        ]),
        const SizedBox(height: 26),
        const Heading('Quick actions'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: FilledButton.icon(
                  onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Wizard(repo: repo)))
                      .then((_) => refresh()),
                  icon: const Icon(Icons.add_home_work_outlined),
                  label: const Text('Add property'))),
          const SizedBox(width: 10),
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () => refresh(),
                  icon: const Icon(Icons.apartment_outlined),
                  label: const Text('Manage properties')))
        ]),
        const SizedBox(height: 26),
        const Heading('Recent tenant requests'),
        const SizedBox(height: 10),
        if (repo.requests().isEmpty)
          const Empty(title: 'No recent requests')
        else
          ...repo
              .requests()
              .take(3)
              .map((request) => RequestSummary(request: request))
      ]));
}

class Stat extends StatelessWidget {
  const Stat({required this.value, required this.label, super.key});
  final String value, label;
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xff123047),
              borderRadius: BorderRadius.circular(16)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: Colors.white70))
          ])));
}

class Listings extends StatelessWidget {
  const Listings({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'My properties',
      child: Column(children: [
        FilledButton.icon(
            onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => Wizard(repo: repo)))
                .then((_) => refresh()),
            icon: const Icon(Icons.add),
            label: const Text('Add a property')),
        const SizedBox(height: 16),
        ...repo.ownedProperties().map(
            (p) => OwnerPropertyCard(property: p, repo: repo, refresh: refresh))
      ]));
}

class OwnerPropertyCard extends StatelessWidget {
  const OwnerPropertyCard(
      {required this.property,
      required this.repo,
      required this.refresh,
      super.key});
  final Property property;
  final PropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Row(children: [
              Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                      color: property.color,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.home_work_rounded,
                      color: Color(0xff176b52))),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(property.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${property.locality}, ${property.city}',
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 6),
                    Row(children: [
                      StatusBadge(
                          label: property.published ? 'Published' : 'Draft',
                          positive: property.published),
                      const SizedBox(width: 8),
                      Text('₹${property.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w700))
                    ])
                  ])),
              PopupMenuButton<String>(
                  onSelected: (value) => _action(context, value),
                  itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'details', child: Text('View details')),
                        const PopupMenuItem(
                            value: 'edit', child: Text('Edit property')),
                        PopupMenuItem(
                            value: property.published ? 'unpublish' : 'publish',
                            child: Text(
                                property.published ? 'Unpublish' : 'Publish')),
                        const PopupMenuItem(
                            value: 'delete', child: Text('Delete'))
                      ])
            ])
          ])));

  void _action(BuildContext context, String action) {
    switch (action) {
      case 'details':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    Details(property: property, repo: repo, refresh: refresh)));
      case 'edit':
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Wizard(repo: repo, initial: property)))
            .then((_) => refresh());
      case 'publish':
        repo.setPublished(property.id, true);
        refresh();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Property published.')));
      case 'unpublish':
        repo.setPublished(property.id, false);
        refresh();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Property unpublished.')));
      case 'delete':
        showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
                    title: const Text('Delete property?'),
                    content: const Text(
                        'This removes the listing from your portfolio.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () {
                            repo.deleteProperty(property.id);
                            Navigator.pop(context);
                            refresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Property deleted.')));
                          },
                          child: const Text('Delete'))
                    ]));
    }
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.positive, super.key});
  final String label;
  final bool positive;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: positive ? const Color(0xffdcebe0) : const Color(0xfff0e6d8),
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              color:
                  positive ? const Color(0xff176b52) : const Color(0xff8b5e34),
              fontWeight: FontWeight.w700)));
}

class OwnerRequests extends StatelessWidget {
  const OwnerRequests({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'Visit requests',
      child: repo.requests().isEmpty
          ? const Empty(title: 'No requests yet')
          : Column(
              children: repo
                  .requests()
                  .map((r) => OwnerRequestCard(
                      request: r, repo: repo, refresh: refresh))
                  .toList()));
}

class RequestSummary extends StatelessWidget {
  const RequestSummary({required this.request, super.key});
  final PropertyRequest request;
  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(request.tenantName,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${request.property.title}\n${request.requestType}'),
          isThreeLine: true,
          trailing: StatusBadge(
              label: request.status.label,
              positive: request.status == RequestStatus.accepted ||
                  request.status == RequestStatus.completed)));
}

class OwnerRequestCard extends StatelessWidget {
  const OwnerRequestCard(
      {required this.request,
      required this.repo,
      required this.refresh,
      super.key});
  final PropertyRequest request;
  final PropertyRepository repo;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(child: Icon(Icons.person_outline)),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(request.tenantName,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(request.requestType,
                        style: const TextStyle(color: Colors.black54))
                  ])),
              StatusBadge(
                  label: request.status.label,
                  positive: request.status == RequestStatus.accepted ||
                      request.status == RequestStatus.completed)
            ]),
            const Divider(height: 24),
            Text(request.property.title,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(request.preferredDate == null
                ? 'Preferred visit: To be scheduled'
                : 'Preferred visit: ${request.preferredDate!.day}/${request.preferredDate!.month}/${request.preferredDate!.year} at ${request.preferredTime?.format(context) ?? 'any time'}'),
            if (request.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('"${request.message}"',
                  style: const TextStyle(color: Colors.black54))
            ],
            if (request.status != RequestStatus.completed) ...[
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (request.status == RequestStatus.pending) ...[
                  TextButton(
                      onPressed: () {
                        repo.updateRequest(request.id, RequestStatus.rejected);
                        refresh();
                      },
                      child: const Text('Reject')),
                  const SizedBox(width: 8),
                  FilledButton(
                      onPressed: () {
                        repo.updateRequest(request.id, RequestStatus.accepted);
                        refresh();
                      },
                      child: const Text('Accept'))
                ] else if (request.status == RequestStatus.accepted)
                  FilledButton.icon(
                      onPressed: () {
                        repo.updateRequest(request.id, RequestStatus.completed);
                        refresh();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Mark completed'))
              ])
            ]
          ])));
}

class Wizard extends StatefulWidget {
  const Wizard({required this.repo, this.initial, super.key});
  final PropertyRepository repo;
  final Property? initial;
  @override
  State<Wizard> createState() => _WizardState();
}

class _WizardState extends State<Wizard> {
  int step = 0;
  late PropertyType type;
  late ListingType listingType;
  late Furnishing furnishing;
  late final titleController =
      TextEditingController(text: widget.initial?.title ?? '');
  late final descriptionController =
      TextEditingController(text: widget.initial?.description ?? '');
  late final bedroomsController =
      TextEditingController(text: _number(widget.initial?.bedrooms));
  late final bathroomsController =
      TextEditingController(text: _number(widget.initial?.bathrooms));
  late final areaController =
      TextEditingController(text: _number(widget.initial?.area));
  late final floorController =
      TextEditingController(text: _number(widget.initial?.floor));
  late final totalFloorsController =
      TextEditingController(text: _number(widget.initial?.totalFloors));
  late final priceController =
      TextEditingController(text: _decimal(widget.initial?.price));
  late final depositController =
      TextEditingController(text: _decimal(widget.initial?.deposit));
  late final maintenanceController =
      TextEditingController(text: _decimal(widget.initial?.maintenance));
  late final otherChargesController =
      TextEditingController(text: _decimal(widget.initial?.otherCharges));
  late final cityController =
      TextEditingController(text: widget.initial?.city ?? '');
  late final localityController =
      TextEditingController(text: widget.initial?.locality ?? '');
  late final addressController =
      TextEditingController(text: widget.initial?.address ?? '');
  late final latitudeController =
      TextEditingController(text: _decimal(widget.initial?.latitude));
  late final longitudeController =
      TextEditingController(text: _decimal(widget.initial?.longitude));
  late final unitsController =
      TextEditingController(text: _number(widget.initial?.availableUnits ?? 1));
  DateTime? availabilityDate;
  late final selectedAmenities = <String>{...?widget.initial?.amenities};
  late final photos = <String>[...?widget.initial?.photos];
  final allAmenities = const [
    'Wi-Fi',
    'Parking',
    'AC',
    'Power backup',
    'Lift',
    'Security',
    'CCTV',
    'Water supply',
    'Washing machine',
    'Kitchen',
    'Furnished',
    'Gym',
    'Swimming pool'
  ];
  final titles = const [
    'Property type',
    'Basic details',
    'Pricing',
    'Amenities',
    'Photos',
    'Location',
    'Availability',
    'Preview'
  ];

  @override
  void initState() {
    super.initState();
    type = widget.initial?.type ?? PropertyType.flat;
    listingType = widget.initial?.listingType ?? ListingType.rent;
    furnishing = widget.initial?.furnishing ?? Furnishing.semiFurnished;
    if (widget.initial?.availability.startsWith('Available from ') == true) {
      availabilityDate =
          DateTime.tryParse(widget.initial!.availability.substring(15));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                '${widget.initial == null ? 'Add property' : 'Edit property'} ${step + 1}/8')),
        body: Column(children: [
          LinearProgressIndicator(value: (step + 1) / titles.length),
          Expanded(
              child: ListView(padding: const EdgeInsets.all(20), children: [
            Text(titles[step],
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Step ${step + 1} of ${titles.length}',
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 22),
            _stepContent(),
            const SizedBox(height: 100)
          ]))
        ]),
        bottomNavigationBar: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(children: [
                  if (step > 0)
                    OutlinedButton(
                        onPressed: () => setState(() => step--),
                        child: const Text('Back')),
                  const Spacer(),
                  if (step == 7) ...[
                    OutlinedButton(
                        onPressed: () => _save(false),
                        child: const Text('Save draft')),
                    const SizedBox(width: 8),
                    FilledButton(
                        onPressed: () => _save(true),
                        child: const Text('Publish property'))
                  ] else
                    FilledButton(
                        onPressed: _next, child: const Text('Continue'))
                ]))));
  }

  Widget _stepContent() => switch (step) {
        0 => _typeStep(),
        1 => _detailsStep(),
        2 => _pricingStep(),
        3 => _amenitiesStep(),
        4 => _photosStep(),
        5 => _locationStep(),
        6 => _availabilityStep(),
        _ => PreviewProperty(property: _preview())
      };

  Widget _typeStep() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('What are you listing?',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 14),
        ...PropertyType.values.map((value) => Card(
            elevation: 0,
            child: ListTile(
                leading: Icon(
                    type == value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: const Color(0xff176b52)),
                title: Text(value.label),
                onTap: () => setState(() => type = value))))
      ]);

  Widget _detailsStep() => Column(children: [
        _field(titleController, 'Property title', required: true),
        _field(descriptionController, 'Description',
            maxLines: 4, required: true),
        Row(children: [
          Expanded(child: _field(bedroomsController, 'Bedrooms', number: true)),
          const SizedBox(width: 12),
          Expanded(
              child: _field(bathroomsController, 'Bathrooms', number: true))
        ]),
        Row(children: [
          Expanded(
              child: _field(areaController, 'Area (sq ft)',
                  number: true, required: true)),
          const SizedBox(width: 12),
          Expanded(child: _field(floorController, 'Floor', number: true))
        ]),
        _field(totalFloorsController, 'Total floors', number: true),
        DropdownButtonFormField<Furnishing>(
            initialValue: furnishing,
            decoration: const InputDecoration(labelText: 'Furnishing'),
            items: Furnishing.values
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value.label)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => furnishing = value);
            })
      ]);

  Widget _pricingStep() => Column(children: [
        SegmentedButton<ListingType>(
            segments: const [
              ButtonSegment(
                  value: ListingType.rent,
                  label: Text('Rent'),
                  icon: Icon(Icons.key_outlined)),
              ButtonSegment(
                  value: ListingType.sale,
                  label: Text('Sale'),
                  icon: Icon(Icons.sell_outlined))
            ],
            selected: {
              listingType
            },
            onSelectionChanged: (value) =>
                setState(() => listingType = value.first)),
        const SizedBox(height: 18),
        _field(priceController,
            listingType == ListingType.rent ? 'Monthly rent' : 'Sale price',
            number: true, required: true, prefix: '₹ '),
        _field(depositController, 'Security deposit',
            number: true, prefix: '₹ '),
        _field(maintenanceController, 'Monthly maintenance',
            number: true, prefix: '₹ '),
        _field(otherChargesController, 'Other charges',
            number: true, prefix: '₹ ')
      ]);

  Widget _amenitiesStep() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Choose everything your property offers.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 14),
        Wrap(
            spacing: 8,
            runSpacing: 4,
            children: allAmenities
                .map((amenity) => FilterChip(
                    label: Text(amenity),
                    selected: selectedAmenities.contains(amenity),
                    onSelected: (selected) => setState(() => selected
                        ? selectedAmenities.add(amenity)
                        : selectedAmenities.remove(amenity))))
                .toList())
      ]);

  Widget _photosStep() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Add photos to help tenants understand the space.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          ...photos.asMap().entries.map((entry) => Stack(children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xffdcebe0),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.home_work_rounded,
                        size: 38, color: Color(0xff176b52))),
                Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                        onPressed: () =>
                            setState(() => photos.removeAt(entry.key)),
                        icon: const Icon(Icons.cancel, color: Colors.white)))
              ])),
          InkWell(
              onTap: () =>
                  setState(() => photos.add('mock-photo-${photos.length + 1}')),
              child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff176b52)),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.add_a_photo_outlined,
                      color: Color(0xff176b52))))
        ]),
        const SizedBox(height: 16),
        const Text(
            'Mock gallery placeholders are ready to be replaced by cloud storage uploads.',
            style: TextStyle(color: Colors.black54))
      ]);

  Widget _locationStep() => Column(children: [
        _field(cityController, 'City', required: true),
        _field(localityController, 'Locality', required: true),
        _field(addressController, 'Full address', maxLines: 3, required: true),
        Row(children: [
          Expanded(child: _field(latitudeController, 'Latitude', number: true)),
          const SizedBox(width: 12),
          Expanded(
              child: _field(longitudeController, 'Longitude', number: true))
        ])
      ]);

  Widget _availabilityStep() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
            leading: const Icon(Icons.today_outlined),
            title: Text(availabilityDate == null
                ? 'Available now'
                : 'Available from ${availabilityDate!.day}/${availabilityDate!.month}/${availabilityDate!.year}'),
            subtitle: const Text('Tap to choose a date'),
            onTap: () async {
              final value = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                  initialDate: availabilityDate ?? DateTime.now());
              if (value != null) setState(() => availabilityDate = value);
            }),
        if (availabilityDate != null)
          TextButton.icon(
              onPressed: () => setState(() => availabilityDate = null),
              icon: const Icon(Icons.clear),
              label: const Text('Mark available now')),
        _field(unitsController, 'Available rooms / units',
            number: true, required: true)
      ]);

  TextField _field(TextEditingController controller, String label,
          {bool number = false,
          bool required = false,
          int maxLines = 1,
          String? prefix}) =>
      TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: required ? '$label *' : label, prefixText: prefix));

  void _next() {
    if (step < titles.length - 1) setState(() => step++);
  }

  Property _preview() => Property(
      id: widget.initial?.id ??
          'draft-${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim().isEmpty
          ? 'Untitled property'
          : titleController.text.trim(),
      type: type,
      city: cityController.text.trim().isEmpty
          ? 'City'
          : cityController.text.trim(),
      locality: localityController.text.trim().isEmpty
          ? 'Locality'
          : localityController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0,
      area: int.tryParse(areaController.text) ?? 0,
      bedrooms: int.tryParse(bedroomsController.text) ?? 0,
      bathrooms: int.tryParse(bathroomsController.text) ?? 0,
      description: descriptionController.text.trim(),
      amenities: selectedAmenities.toList(),
      owner: 'Aanya Sharma',
      color: const Color(0xffdcebe0),
      listingType: listingType,
      deposit: double.tryParse(depositController.text) ?? 0,
      maintenance: double.tryParse(maintenanceController.text) ?? 0,
      otherCharges: double.tryParse(otherChargesController.text) ?? 0,
      furnishing: furnishing,
      floor: int.tryParse(floorController.text) ?? 0,
      totalFloors: int.tryParse(totalFloorsController.text) ?? 0,
      availability: availabilityDate == null
          ? 'Available now'
          : 'Available from ${availabilityDate!.year}-${availabilityDate!.month.toString().padLeft(2, '0')}-${availabilityDate!.day.toString().padLeft(2, '0')}',
      address: addressController.text.trim(),
      latitude: double.tryParse(latitudeController.text) ?? 0,
      longitude: double.tryParse(longitudeController.text) ?? 0,
      availableUnits: int.tryParse(unitsController.text) ?? 1,
      photos: photos,
      published: false);

  void _save(bool publish) {
    final missing = <String>[];
    if (titleController.text.trim().isEmpty) {
      missing.add('title');
    }
    if (descriptionController.text.trim().isEmpty) {
      missing.add('description');
    }
    if (cityController.text.trim().isEmpty) {
      missing.add('city');
    }
    if (localityController.text.trim().isEmpty) {
      missing.add('locality');
    }
    if (addressController.text.trim().isEmpty) {
      missing.add('address');
    }
    if (double.tryParse(priceController.text) == null ||
        double.parse(priceController.text) <= 0) {
      missing.add('price');
    }
    if (int.tryParse(areaController.text) == null ||
        int.parse(areaController.text) <= 0) {
      missing.add('area');
    }
    if (missing.isNotEmpty && publish) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Complete required fields: ${missing.join(', ')}')));
      return;
    }
    final property = _preview().copyWith(
        published: publish,
        approvalStatus: publish
            ? PropertyApprovalStatus.pending
            : widget.initial?.approvalStatus ??
                PropertyApprovalStatus.approved);
    if (widget.initial == null) {
      widget.repo.addProperty(property);
    } else {
      widget.repo.updateProperty(property);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(publish ? 'Property published.' : 'Draft saved.')));
  }

  String _number(int? value) => value == null || value == 0 ? '' : '$value';
  String _decimal(double? value) =>
      value == null || value == 0 ? '' : value.toString();

  @override
  void dispose() {
    for (final controller in [
      titleController,
      descriptionController,
      bedroomsController,
      bathroomsController,
      areaController,
      floorController,
      totalFloorsController,
      priceController,
      depositController,
      maintenanceController,
      otherChargesController,
      cityController,
      localityController,
      addressController,
      latitudeController,
      longitudeController,
      unitsController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }
}

class PreviewProperty extends StatelessWidget {
  const PreviewProperty({required this.property, super.key});
  final Property property;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tenant preview', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 150,
                        width: double.infinity,
                        color: property.color,
                        child: const Icon(Icons.home_work_rounded,
                            size: 64, color: Color(0xff176b52))),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(property.title,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700)),
                              Text('${property.locality}, ${property.city}',
                                  style:
                                      const TextStyle(color: Colors.black54)),
                              const SizedBox(height: 10),
                              Text(
                                  '₹${property.price.toStringAsFixed(0)}${property.listingType == ListingType.rent ? ' / month' : ''}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff176b52))),
                              const SizedBox(height: 10),
                              Text(property.description),
                              const SizedBox(height: 10),
                              Wrap(
                                  spacing: 8,
                                  children: property.amenities
                                      .map((amenity) =>
                                          Chip(label: Text(amenity)))
                                      .toList())
                            ]))
                  ]))
        ],
      );
}
