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

`MockPropertyRepository` remains the app's current demo implementation. `MockAuthRepository` and `MockStorageService` provide deterministic local behavior for the new contracts. Supabase implementations fail clearly when configuration is absent instead of silently exposing partial behavior.

## Backend architecture

Supabase/PostgreSQL is the planned production backend. The initial schema and least-privilege Row Level Security policies are in [`supabase/migrations/001_initial_schema.sql`](supabase/migrations/001_initial_schema.sql). The schema covers users, properties, images, amenities, requests, saved properties, reviews, and reports.

Marketplace visibility is intentionally modeled as two independent states: a property must be `approval_status = approved` and `status = published` before tenants can see it. Owners can manage their own records; admins moderate approvals, users, reviews, reports, and amenities.

## Supabase configuration

Copy [`.env.example`](.env.example) to `.env` for local reference. Do not commit `.env`, real credentials, passwords, or service-role keys. Flutter can receive the public values at build/run time without storing them in source:

```bash
flutter run \
	--dart-define=SUPABASE_URL=https://your-project.supabase.co \
	--dart-define=SUPABASE_ANON_KEY=your-public-anon-key
```

The app reads these values through `AppConfig.fromEnvironment()`. A real Supabase SDK integration should be added behind the interfaces in `lib/core/repositories/` and `lib/data/supabase/`; credentials are never required for the mock demo.

## Validation

```bash
flutter analyze
flutter test
flutter build web --release
```

## Current limitations

The backend and storage integrations are intentionally placeholders until deployment configuration is supplied. Mock data is local and is reset on app restart. Payments, KYC, subscriptions, advanced chat, agreements, and AI recommendations are not implemented.
