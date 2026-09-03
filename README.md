# LastSpot

LastSpot is a mobile app for finding people to play sports and join local activities. Users can discover open spots, publish their own activities, request to join, manage participants, and chat with confirmed players.

## Features

- Email authentication, sign-up, password reset, and OTP verification
- Profile setup with sports interests and avatar upload
- Home feed with sport filters, search, urgent activities, and recent posts
- Create activities with a sport, venue, schedule, participant limit, notes, and images
- Activity details with map links, confirmed players, and join requests
- Host controls for accepting or rejecting join requests
- Group chat for activity participants
- Profile editing, settings, maintenance mode, and forced-update checks
- Responsive layouts for phones and tablets
- English localization with Flutter's generated localization files

## Tech Stack

- Flutter and Dart
- Supabase Auth, Postgres, Storage, and RPC functions
- `flutter_bloc` for state management
- GoRouter for navigation
- Feature-first clean architecture
- Material 3 with system light/dark theme support

## Requirements

- Flutter managed through [FVM](https://fvm.app/)
- Dart SDK `3.11.0` or compatible
- Android Studio and an Android SDK for Android development
- Xcode and CocoaPods for iOS development
- A Supabase project with Auth, database tables, RPC functions, and storage buckets configured

The repository pins the Flutter channel in `.fvmrc`. Use `fvm flutter` and `fvm dart` for project commands.

## Setup

1. Clone the repository and open it in VS Code or Android Studio.

2. Install the configured Flutter SDK and dependencies:

	```bash
	fvm install
	fvm flutter pub get
	```

	For iOS, install CocoaPods dependencies as well:

	```bash
	cd ios
	pod install
	cd ..
	```

3. Configure Supabase. The app reads its Supabase URL and anon key from [`supabase_config.dart`](lib/core/network/supabase_config.dart). Point these values at the Supabase project used for local development.

4. Apply the database foundation from [`schema.sql`](schema.sql) in the Supabase SQL editor or with the Supabase CLI. Enable email authentication and configure the `profiles` and `request_images` storage buckets as required by the app.

5. Generate localization output when translation resources change:

	```bash
	fvm flutter gen-l10n
	```

## Run the App

List available devices:

```bash
fvm flutter devices
```

Run on a connected Android or iOS device:

```bash
fvm flutter run
```

The implemented native targets are Android and iOS. iOS development also requires opening the workspace through `ios/Runner.xcworkspace` after installing CocoaPods dependencies.

## Quality Checks

Run formatting, static analysis, and tests with:

```bash
fvm dart format .
fvm flutter analyze
fvm flutter test
```

Build release artifacts with:

```bash
fvm flutter build apk --release
fvm flutter build ipa --release
```

## Project Structure

```text
lib/
  core/       Shared theme, routing, localization, utilities, and widgets
  features/   Feature-first data, domain, and presentation layers
  main.dart   Supabase, service locator, and app initialization
schema.sql    Supabase database foundation
```

Feature modules currently include authentication, startup checks, categories, sports spots, explore, activities, profile, and settings.

## Backend Alignment

The supplied schema provides the initial `profiles`, `app_settings`, `user_devices`, `posts`, and `join_requests` tables plus the `record_user_device` RPC. Some client data sources also expect `requests`, `request_images`, `categories`, `request_to_join`, and `update_request_status`. Verify or add those objects in the Supabase project before testing the complete create-and-join flow.

## Localization

English strings live in [`lib/core/l10n/intl_en.arb`](lib/core/l10n/intl_en.arb). Add new user-facing strings there and regenerate the generated localization files with `fvm flutter gen-l10n`.
