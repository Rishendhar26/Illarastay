# IllaraStay

IllaraStay is a Flutter property marketplace for finding and listing PGs, rooms, flats, houses, villas, residential land, and commercial property. The current demo includes tenant, owner, and admin workflows with an in-memory development backend.

## Flutter setup

```bash
flutter pub get
flutter run
```

The app uses Material 3 and works without network credentials. The default mock repository keeps the demo usable offline.

## Architecture

The existing UI depends on repository boundaries instead of making network calls from widgets. The v0.5 backend-ready layer is organized as:

```text
lib/
	core/
		config/       Runtime environment configuration
		models/       Backend-facing records and enums
		repositories/ Auth, property, request, saved, review, report, and user contracts
		services/     Auth and storage service facades
	data/
		mock/         Safe offline implementations used by development
		supabase/     Configuration-safe Supabase implementation placeholders
	main.dart       Existing tenant, owner, and admin UI
```

`MockPropertyRepository` remains the app's current demo implementation. `MockAuthRepository` and `MockStorageService` provide deterministic local behavior for the new contracts. When build-time Supabase configuration is present, `SupabaseService` initializes `supabase_flutter` and the Supabase auth/property repositories are available; otherwise the app stays in safe mock mode.

## Backend architecture

Supabase/PostgreSQL is the planned production backend. The initial schema and least-privilege Row Level Security policies are in [`supabase/migrations/001_initial_schema.sql`](supabase/migrations/001_initial_schema.sql). The schema covers users, properties, images, amenities, requests, saved properties, reviews, and reports.

Marketplace visibility is intentionally modeled as two independent states: a property must be `approval_status = approved` and `status = published` before tenants can see it. Owners can manage their own records; admins moderate approvals, users, reviews, reports, and amenities.

## Supabase configuration

Copy [`.env.example`](.env.example) to `.env` for local reference. Do not commit `.env`, real credentials, passwords, or service-role keys. Flutter receives the project URL and publishable key at build/run time without storing the key in source:

```bash
flutter run \
	--dart-define=SUPABASE_URL=https://fmuhpybmqicsovmetvao.supabase.co \
	--dart-define=SUPABASE_PUBLISHABLE_KEY=your-public-publishable-key
```

The app reads these values through `AppConfig.fromEnvironment()`. The current project URL is used as the safe default URL; provide `SUPABASE_URL` explicitly when targeting another project. The publishable key is always expected through `SUPABASE_PUBLISHABLE_KEY` and is never committed.

## Validation

```bash
flutter analyze
flutter test
flutter build web --release
```

## Current limitations

The storage contract is ready for Supabase Storage but the upload implementation is still pending deployment configuration. Mock data is local and is reset on app restart. Payments, KYC, subscriptions, advanced chat, agreements, and AI recommendations are not implemented.
