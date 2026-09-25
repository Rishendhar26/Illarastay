import 'package:flutter/material.dart';

void main() => runApp(const IllaraStayApp());

enum UserRole { seeker, owner }

enum PropertyType { pg, room, flat, house, villa, residentialLand, commercial }

enum ListingType { rent, sale }

enum Furnishing { unfurnished, semiFurnished, fullyFurnished }

enum RequestStatus { pending, accepted, rejected, completed }

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
      this.address = 'Address shared after a visit is requested'});
  final String id, title, city, locality, description, owner;
  final String availability, address;
  final PropertyType type;
  final ListingType listingType;
  final double price, deposit, maintenance;
  final int area, bedrooms, bathrooms, floor, totalFloors;
  final Furnishing furnishing;
  final List<String> amenities;
  final Color color;
}

class PropertyRequest {
  PropertyRequest(this.id, this.property,
      {this.status = RequestStatus.pending,
      this.preferredDate,
      this.preferredTime,
      this.message = ''});
  final String id;
  final Property property;
  final DateTime? preferredDate;
  final TimeOfDay? preferredTime;
  final String message;
  RequestStatus status;
}

/// Replace this boundary with Firebase, Supabase, or REST without changing the UI.
abstract class PropertyRepository {
  List<Property> properties();
  List<PropertyRequest> requests();
  bool saved(String id);
  void toggleSaved(String id);
  void requestVisit(Property property,
      {DateTime? preferredDate, TimeOfDay? preferredTime, String message = ''});
  void updateRequest(String id, RequestStatus status);
}

class MockPropertyRepository implements PropertyRepository {
  final savedIds = <String>{'p2'};
  final visitRequests = <PropertyRequest>[];
  @override
  List<Property> properties() => mockProperties;
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
          context, MaterialPageRoute(builder: (_) => const RoleScreen())));
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
      super.key});
  final String title, subtitle, button;
  final VoidCallback next;
  final bool register;
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
                : 'New to IllaraStay? Create an account'))
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
            Dashboard(repo: widget.repo),
            Listings(repo: widget.repo),
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
  const Dashboard({required this.repo, super.key});
  final PropertyRepository repo;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'Owner dashboard',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Heading('Welcome, Aanya'),
        const SizedBox(height: 6),
        const Text('Here is how your portfolio is doing.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),
        Row(children: [
          Stat(value: '${repo.properties().length}', label: 'Active listings'),
          const SizedBox(width: 12),
          Stat(value: '${repo.requests().length}', label: 'New requests')
        ]),
        const SizedBox(height: 26),
        const Heading('Quick actions'),
        const SizedBox(height: 12),
        FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_home_work_outlined),
            label: const Text('Add a property'))
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
  const Listings({required this.repo, super.key});
  final PropertyRepository repo;
  @override
  Widget build(BuildContext context) => Frame(
      title: 'My properties',
      child: Column(children: [
        FilledButton.icon(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Wizard())),
            icon: const Icon(Icons.add),
            label: const Text('Add a property')),
        const SizedBox(height: 16),
        ...repo
            .properties()
            .map((p) => ListingCard(property: p, repo: repo, refresh: () {}))
      ]));
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
                  .map((r) => Card(
                      elevation: 0,
                      child: Column(children: [
                        ListTile(
                            title: Text(r.property.title),
                            subtitle: const Text('Requested by Aanya Sharma')),
                        if (r.status == RequestStatus.pending)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      repo.updateRequest(
                                          r.id, RequestStatus.rejected);
                                      refresh();
                                    },
                                    child: const Text('Decline')),
                                FilledButton(
                                    onPressed: () {
                                      repo.updateRequest(
                                          r.id, RequestStatus.accepted);
                                      refresh();
                                    },
                                    child: const Text('Accept')),
                                const SizedBox(width: 12)
                              ])
                      ])))
                  .toList()));
}

class Wizard extends StatefulWidget {
  const Wizard({super.key});
  @override
  State<Wizard> createState() => _WizardState();
}

class _WizardState extends State<Wizard> {
  int step = 0;
  @override
  Widget build(BuildContext context) {
    final titles = [
      'Basic information',
      'Location and price',
      'Ready to publish?'
    ];
    return Scaffold(
        appBar: AppBar(title: Text('Add property ${step + 1}/3')),
        body: Padding(
            padding: const EdgeInsets.all(24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titles[step],
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              if (step == 0)
                const TextField(
                    decoration: InputDecoration(labelText: 'Property title')),
              if (step == 0)
                const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: DropdownMenu<String>(
                        label: Text('Property type'),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 'Flat', label: 'Flat'),
                          DropdownMenuEntry(value: 'Room', label: 'Room'),
                          DropdownMenuEntry(value: 'Villa', label: 'Villa')
                        ])),
              if (step == 1)
                const TextField(
                    decoration:
                        InputDecoration(labelText: 'City and locality')),
              if (step == 1)
                const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Expected price', prefixText: '₹ '))),
              if (step == 2)
                const Text('You can edit details any time after publishing.',
                    style: TextStyle(color: Colors.black54)),
              const Spacer(),
              Row(children: [
                if (step > 0)
                  OutlinedButton(
                      onPressed: () => setState(() => step--),
                      child: const Text('Back')),
                const Spacer(),
                FilledButton(
                    onPressed: () => step < 2
                        ? setState(() => step++)
                        : Navigator.pop(context),
                    child: Text(step == 2 ? 'Publish listing' : 'Continue'))
              ])
            ])));
  }
}
