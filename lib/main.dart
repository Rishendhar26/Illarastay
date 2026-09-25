import 'package:flutter/material.dart';

void main() => runApp(const IllaraStayApp());

enum UserRole { seeker, owner }

enum PropertyType { pg, room, flat, house, villa, residentialLand, commercial }

enum ListingType { rent, sale }

enum RequestStatus { pending, accepted, rejected }

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
      this.bathrooms = 0});
  final String id, title, city, locality, description, owner;
  final PropertyType type;
  final ListingType listingType;
  final double price;
  final int area, bedrooms, bathrooms;
  final List<String> amenities;
  final Color color;
}

class PropertyRequest {
  PropertyRequest(this.id, this.property,
      {this.status = RequestStatus.pending});
  final String id;
  final Property property;
  RequestStatus status;
}

/// Replace this boundary with Firebase, Supabase, or REST without changing the UI.
abstract class PropertyRepository {
  List<Property> properties();
  List<PropertyRequest> requests();
  bool saved(String id);
  void toggleSaved(String id);
  void requestVisit(Property property);
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
  void requestVisit(Property property) => visitRequests
      .add(PropertyRequest('r${visitRequests.length + 1}', property));
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
      description:
          'Street-facing commercial space suited to a boutique or studio.',
      amenities: ['Signage', 'Parking', 'Power backup'],
      owner: 'Harbor Homes',
      color: Color(0xffdfe7d5)),
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
        const SearchBar(
            hintText: 'Search by city, locality or landmark',
            leading: Icon(Icons.search)),
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
                        child: Chip(label: Text(type.label))))
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
  const Search({required this.repo, required this.refresh, super.key});
  final PropertyRepository repo;
  final VoidCallback refresh;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';
  PropertyType? filter;
  @override
  Widget build(BuildContext context) {
    final data = widget.repo
        .properties()
        .where((p) =>
            (filter == null || p.type == filter) &&
            '${p.title} ${p.city} ${p.locality}'
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    return Frame(
        title: 'Search homes',
        child: Column(children: [
          TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                  hintText: 'Search homes', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 12),
          SizedBox(
              height: 42,
              child: ListView(scrollDirection: Axis.horizontal, children: [
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
              ])),
          const SizedBox(height: 16),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('${data.length} places found')),
          const SizedBox(height: 12),
          ...data.map((p) => ListingCard(
              property: p, repo: widget.repo, refresh: widget.refresh))
        ]));
  }
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
            onPressed: () {
              repo.toggleSaved(property.id);
              refresh();
            },
            icon: Icon(repo.saved(property.id)
                ? Icons.bookmark
                : Icons.bookmark_border))
      ]),
      body: ListView(children: [
        Container(
            height: 210,
            color: property.color,
            child: const Icon(Icons.home_work_rounded,
                size: 88, color: Color(0xff176b52))),
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
              Text('₹${property.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff176b52))),
              const SizedBox(height: 14),
              Wrap(spacing: 8, children: [
                Chip(label: Text('${property.area} sq ft')),
                if (property.bedrooms > 0)
                  Chip(label: Text('${property.bedrooms} bedrooms')),
                ...property.amenities.map((a) => Chip(label: Text(a)))
              ]),
              const SizedBox(height: 14),
              Text(property.description,
                  style: const TextStyle(color: Colors.black54, height: 1.5)),
              const SizedBox(height: 18),
              Row(children: [
                CircleAvatar(child: Text(property.owner[0])),
                const SizedBox(width: 10),
                Text('Listed by ${property.owner}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Contact'))
              ]),
              const SizedBox(height: 18),
              FilledButton.icon(
                  onPressed: () {
                    repo.requestVisit(property);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visit request sent.')));
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Request a visit'))
            ]))
      ]));
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
      child: ListTile(
          title: Text(request.property.title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(request.property.locality),
          trailing: Chip(label: Text(request.status.label))));
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

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) => const Frame(
      title: 'Profile',
      child: Column(children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Color(0xffdcebe0),
          child: Text('A',
              style: TextStyle(fontSize: 28, color: Color(0xff176b52))),
        ),
        SizedBox(height: 12),
        Text('Aanya Sharma',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        Text('aanya@example.com', style: TextStyle(color: Colors.black54)),
        SizedBox(height: 24),
        ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Personal details')),
        ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notifications')),
        ListTile(
            leading: Icon(Icons.help_outline), title: Text('Help and support')),
        ListTile(leading: Icon(Icons.logout), title: Text('Sign out'))
      ]));
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
                            subtitle: Text('Requested by Aanya Sharma')),
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
