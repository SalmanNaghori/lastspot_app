# KhelBhai

> **Social Sports & Activity Discovery Platform**  
> Connect players, organize local matches, reserve activity spots, and build active sports communities.

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![FVM](https://img.shields.io/badge/FVM-Enabled-2C3E50?logo=flutter&logoColor=white)](https://fvm.app/)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/Push-FCM-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20Clean-orange)](docs/project/flutter/features.md)
[![License](https://img.shields.io/badge/License-Private-lightgrey)]()

---

## Table of Contents

- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Technical Specifications](#technical-specifications)
- [Project Links](#project-links)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running the Application](#running-the-application)
- [Project Architecture](#project-architecture)
- [Key Dependencies](#key-dependencies)
- [Configuration & Environment Variables](#configuration--environment-variables)
- [Dismissible EnvBanner](#dismissible-envbanner)
- [Authentication & Security](#authentication--security)
- [API & Backend Integration](#api--backend-integration)
- [Push Notifications & Realtime Messaging](#push-notifications--realtime-messaging)
- [IDE Configurations (VS Code & Android Studio)](#ide-configurations-vs-code--android-studio)
- [Localization](#localization)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Build & Release](#build--release)
- [Troubleshooting](#troubleshooting)
- [Development Guidelines](#development-guidelines)
- [Maintenance Information](#maintenance-information)

---

## Project Overview

**KhelBhai** (internal package `lastspot_app`) is a social sports and activity discovery platform designed to solve a universal problem for athletes and sports lovers: *finding people to play with and places to play.*

Whether an organizer is short two players for an evening cricket match, a badminton player seeks a local sparring partner, or a weekend football squad needs players, KhelBhai enables users to discover, create, and join local sporting activities with transparent spot reservations and integrated communication.

### Core Capabilities

- **Discover Nearby Matches:** Search local games, filter by distance, category, price, date, and open spots.
- **Host & Publish Spots:** Post activity requests with schedules, map venues, player capacity, and photos.
- **Atomic Slot Booking:** Transparent capacity reservation protected by transactional backend RPCs to prevent overbooking.
- **Realtime Chat:** Direct 1-on-1 messaging and activity-linked group chats with formatted text support and unread counts.
- **My Sports Space:** A personalized dashboard tracking upcoming matches, hosted games, verified achievements, and sport interests.
- **Multi-Language Support:** First-class localization for English, Hindi, and Gujarati.
- **Cross-Platform Responsive Design:** Adaptive phone and tablet layouts using responsive dimension scaling tokens.
- **Multi-Environment Gating & Watermark:** Type-safe compile-time environments (`dev`, `staging`, `prod`, `local`) with an interactive, dismissible environment banner.

---

## Key Features

### 1. Authentication & Session Management
- Email and password sign-up, sign-in, and sign-out.
- One-Time Password (OTP) verification and resend flow.
- Password reset with custom scheme deep-link detection (`com.lastspot.app://reset-password`).
- Multi-device session revocation via `activate_my_session` RPC to ensure single-device integrity.
- Automated device registration with push token upsert (`user_devices` table).

### 2. Startup, Versioning & Gating
- Native launch screen transitions to an animated branding splash screen.
- 4-slide onboarding experience showcasing match discovery, hosting, group chats, and community features.
- Remote app configuration via `app_settings` for maintenance mode gating and forced minimum version checks.

### 3. Sports & Category Discovery
- 22+ sports supported (Cricket, Football/Soccer, Badminton, Tennis, Volleyball, Basketball, Kabaddi, Kho Kho, Cycling, Running, Skating, Swimming, etc.).
- Perspective category carousel with custom 3D sport artwork and theme-aware recoloring.
- Searchable city and state selection bottom sheet backed by database records.

### 4. Activity Creation & Host Management
- Multi-step activity creation form: sport category, match title, date/time picker, map venue with coordinates, participant capacity, price per person, notes, and compressed photo attachments.
- Interactive spot preview before publishing.
- Host request management panel to accept or reject pending join requests atomically.

### 5. Explore & Search
- Debounced keyword search across activity titles, sports, and venues.
- Multi-dimensional filters: category, date range, time of day, price, and distance.
- Responsive grid and card layouts with infinite scroll pagination.

### 6. Realtime Chat & Participant Communication
- Activity group chats automatically unlocked for confirmed participants and the host.
- Direct 1-on-1 messaging between players.
- Rich text formatting (*bold*, _italic_, ~strikethrough~, `code`) with one-tap text copy.
- Unread message counters, message pagination, and real-time streaming via Supabase Realtime channels.

### 7. Push Notifications & In-App Alerts
- Push delivery via Firebase Cloud Messaging (FCM) triggered through a Supabase Edge Function (`send-push`).
- Foreground notification coordinator suppressing popups for the currently open conversation while showing actionable snackbars for others.
- In-app notification inbox with read/unread tracking and deletion.

### 8. My Sports Space (Profile Dashboard)
- Unified sports profile with user avatar (1:1 cropping support), verified email badge, title-cased city and state, and bio.
- 4-metric real activity summary: **Upcoming**, **Hosted**, **Joined**, and **Completed**.
- Verified milestone achievement badges (e.g., First Host, Team Player, Active Athlete).
- Profile editing and sports preferences management.

### 9. Settings, Theming & Accessibility
- Material 3 theme engine supporting `ThemeMode.system`, `ThemeMode.light`, and `ThemeMode.dark`.
- 7 primary brand accent themes: Sunset Orange (default), Sports Green, Emerald Pitch, Forest Turf, Violet, Deep Violet, and Terracotta.
- Language switcher for English, Hindi, and Gujarati.
- High contrast, 48dp minimum touch targets, and scalable text.

### 10. Community Safety & Moderation
- Contextual user and activity reporting workflows with categorized reasons and notes for admin review.
- Terms & Conditions and Privacy Policy viewer.

### 11. Multi-Environment & Dismissible EnvBanner
- Compile-time environment configuration (`String.fromEnvironment`) supporting `dev`, `staging`, `prod`, and `local`.
- Top-right interactive `EnvBanner` showing environment name, build type (`DEBUG` / `PROFILE`), and live version extracted from `PackageInfo`.
- Tap pill to collapse into a side tab; tap tab to expand.
- Automatically suppressed in production release builds unless `--dart-define=SHOW_BANNER=true` is passed.

---

## Technical Specifications

| Component | Specification / Version | Purpose |
| :--- | :--- | :--- |
| **Framework** | Flutter `3.47.5` (Channel: `stable`) | Core Cross-Platform Application Framework |
| **Language** | Dart `^3.11.0` | Primary Development Language |
| **Version Manager** | [FVM](https://fvm.app/) | Pinned Flutter SDK Toolchain (`.fvmrc`) |
| **App Name** | KhelBhai | User-Facing Product Brand |
| **Package Name** | `lastspot_app` | Internal Dart Package Name |
| **Application ID** | `com.lastspot.app` | Android & iOS Bundle Identifier |
| **App Version** | `1.0.3+1` | Semantic Version + Build Number |
| **Architecture** | Feature-First Clean Architecture | Modular `data / domain / presentation` layers |
| **State Management** | `flutter_bloc: ^9.1.1` & `ValueNotifier` | Global Async BLoCs and Local UI Reactivity |
| **Routing** | `go_router: ^17.5.0` | Declarative Routing, Deep Links & Route Guards |
| **Backend & DB** | Supabase (`supabase_flutter: ^2.18.0`) | PostgreSQL, Auth, Realtime, Storage |
| **Push Notifications**| Firebase Messaging `^16.7.0` | FCM Remote Push Notifications |
| **Local Notifications**| `flutter_local_notifications: ^22.3.1`| Foreground In-App Alert Banners |
| **Dependency Injection** | `get_it: ^9.2.1` | Service Locator (`lib/core/di/`) |
| **Code Generation** | `freezed: ^4.0.2`, `json_serializable: ^6.14.1` | Immutable Entities & JSON Converters |
| **Localization** | Flutter `gen-l10n` (`intl: ^0.20.2`) | Multi-Language Support (`en`, `hi`, `gu`) |
| **Android AGP** | `8.11.1` | Android Gradle Plugin |
| **Kotlin** | `2.2.20` | Android Kotlin Toolchain |
| **Android Java Target** | Java 17 (`JavaVersion.VERSION_17`) | Android JVM Target & Core Library Desugaring |
| **iOS Deployment** | iOS 13.0+ | CocoaPods Frameworks Target |

---

## Project Links

- **Source Repository:** [https://github.com/SalmanNaghori/lastspot_app.git](https://github.com/SalmanNaghori/lastspot_app.git)
- **Issue Tracker:** [https://github.com/SalmanNaghori/lastspot_app/issues](https://github.com/SalmanNaghori/lastspot_app/issues)
- **Architecture Decision Records (ADRs):** [`docs/adr/`](docs/adr/)
- **Design & UI Documentation:** [`docs/design/`](docs/design/)
- **Feature Map & Specifications:** [`docs/project/flutter/features.md`](docs/project/flutter/features.md)
- **Support & Feedback:** [support@khelbhai.com](mailto:support@khelbhai.com)

---

## Prerequisites

Before setting up the project, ensure the following tools are installed on your machine:

1. **Flutter Version Management (FVM):**
   ```bash
   dart pub global activate fvm
   ```
2. **Git:** Version 2.30+
3. **Android Development:**
   - Android Studio (Koala / Ladybug or newer)
   - Android SDK Platform 34 or 35
   - Java Development Kit (JDK 17)
4. **iOS Development (macOS only):**
   - Xcode 15.0+
   - CocoaPods (`sudo gem install cocoapods`)
5. **Supabase Account / Project:** A Supabase project with database, storage, and authentication configured.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/SalmanNaghori/lastspot_app.git
cd lastspot_app
```

### 2. Install Flutter via FVM

The project strictly pins Flutter version `3.47.5` in `.fvmrc`. Install and activate it:

```bash
fvm install
fvm use
```

Verify your FVM configuration:

```bash
fvm flutter --version
```

### 3. Install Dependencies

```bash
fvm flutter pub get
```

For iOS, install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

### 4. Run Code Generation

Generate all Freezed models, JSON serializers, and asset accessors:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 5. Generate Localization Files

```bash
fvm flutter gen-l10n
```

---

## Running the Application

### List Connected Devices

```bash
fvm flutter devices
```

### Run by Environment Target

KhelBhai supports 4 distinct environment targets (`dev`, `staging`, `prod`, `local`). Pass configurations using `--dart-define-from-file`:

```bash
# 1. Development (Default) with interactive environment watermark banner
fvm flutter run --dart-define-from-file=.env.dev --dart-define=SHOW_BANNER=true

# 2. Local Emulator / Offline Dev (Local Supabase instance on port 54321)
fvm flutter run --dart-define-from-file=.env.local --dart-define=SHOW_BANNER=true

# 3. Staging (QA / Pre-production)
fvm flutter run --dart-define-from-file=.env.staging --dart-define=SHOW_BANNER=true

# 4. Production Release Mode
fvm flutter run --release --dart-define-from-file=.env.prod
```

### Device Selection

```bash
# Run on connected Android device
fvm flutter run -d android --dart-define-from-file=.env.dev

# Run on iOS Simulator
fvm flutter run -d iPhone --dart-define-from-file=.env.dev
```

---

## Project Architecture

The codebase follows **Feature-First Clean Architecture**, ensuring that business logic is decoupled from external services and user interface components.

```text
lastspot_app/
├── .vscode/                   # VS Code launch configs, tasks, and editor settings
├── .idea/runConfigurations/   # Android Studio / IntelliJ run and shell configurations
├── env/                       # Compile-time environment JSON definitions
│   ├── dev.json               # Development environment parameters
│   ├── staging.json           # Staging environment parameters
│   ├── prod.json              # Production environment parameters
│   ├── local.json             # Local offline / emulator development
│   └── env.example.json       # Template definition
├── android/                   # Native Android host configuration (AGP 8.11.1, Kotlin 2.2.20)
├── ios/                       # Native iOS host configuration (CocoaPods, Runner)
├── assets/                    # Static assets
│   ├── branding/              # High-resolution logos, launcher artwork, splash PNGs
│   ├── icons/                 # Custom navigation, functional, and sport icons
│   ├── images/                # 3D category art, empty state illustrations, onboarding slides
│   ├── ain/                   # Lottie animations (congratulations, empty chat, splash)
│   └── audio/                 # In-app notification sound effects
├── lib/
│   ├── main.dart              # App entry point, Supabase & Service Locator initialization
│   ├── lastspot_app.dart      # Root MaterialApp, MultiBlocProvider, Theme & EnvBanner wrapper
│   ├── core/                  # Shared system components across features
│   │   ├── config/            # Compile-time environment config (AppEnv, EnvironmentType)
│   │   ├── constants/         # AppConstants, Dimensions, AppAssets, AppString
│   │   ├── di/                # Service locator (GetIt) dependency wiring
│   │   ├── extension/         # StringExtension, BuildContext and theme extensions
│   │   ├── l10n/              # ARB localization files (intl_en, intl_hi, intl_gu)
│   │   ├── network/           # SupabaseConfig, ApiEndpoints, AppRoutes, GoRouter
│   │   ├── services/          # ImageService, NotificationCoordinator, SessionService
│   │   ├── theme/             # Material 3 themes (Light/Dark), AppColor palette
│   │   ├── utils/             # AppUtils, formatting, validators, shared preferences
│   │   └── widgets/           # Centralized UI components (EnvBanner, KhelBhaiAppBar, UserAvatar, etc.)
│   └── features/              # Feature modules
│       ├── activities/        # My Activities (Hosted & Joined matches)
│       ├── auth/              # Sign-in, sign-up, password recovery, session handling
│       ├── categories/        # Sports categories & 3D carousel assets
│       ├── chat/              # 1:1 and group chat, rich text formatting, realtime channels
│       ├── cities/            # Database-backed city & state selector
│       ├── explore/           # Activity discovery, search, and multi-filters
│       ├── help_support/      # FAQ and contact email mailer
│       ├── legal/             # Terms & Conditions and Privacy Policy
│       ├── notifications/     # In-app notification inbox & push handlers
│       ├── profile/           # My Sports Space dashboard, achievements, edit profile
│       ├── reports/           # Community moderation and activity/user reporting
│       ├── settings/          # Theme switcher, accent picker, language selection
│       ├── spot/              # Match creation, preview, details, capacity management
│       └── startup/           # Splash screen, onboarding carousel, version enforcement
├── supabase/
│   ├── migrations/            # Versioned SQL migrations (tables, RLS policies, RPCs)
│   └── functions/             # Supabase Edge Functions (Deno / TypeScript)
│       └── send-push/         # Push notification dispatcher to FCM
├── test/                      # Automated test suite (178 tests)
│   ├── core/                  # Unit tests for models, extensions, config, and widgets
│   └── features/              # Bloc, Cubit, and Widget tests for all features
├── tool/                      # Automation & build scripts
│   ├── build_apk_with_banner.sh # Version-aware APK build script with banner
│   └── export_launcher_icons.sh # Launcher icon generator
├── .env.example               # Root environment variable template
├── .fvmrc                     # Pinned Flutter version (3.47.5)
├── pubspec.yaml               # Categorized package manifests and asset declarations
└── schema.sql                 # Consolidated database schema and RPC definitions
```

### Layer Responsibility

```text
┌────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                   │
│   Pages / Screens  ──▶  Widgets  ──▶  BLoC / Cubit     │
└───────────────────────────┬────────────────────────────┘
                            │ depends on
┌───────────────────────────▼────────────────────────────┐
│                      DOMAIN LAYER                      │
│     Use Cases  ──▶  Entities  ──▶  Repository Interface│
└───────────────────────────▲────────────────────────────┘
                            │ implemented by
┌───────────────────────────┴────────────────────────────┐
│                       DATA LAYER                       │
│ Repository Implementation ──▶ Data Sources ──▶ Supabase│
└────────────────────────────────────────────────────────┘
```

- **Presentation:** UI widgets, responsive layouts (`[screen]_mobile.dart` and `[screen]_tablet.dart`), and BLoCs/Cubits. Widgets never query the database directly.
- **Domain:** Pure Dart layer containing business entities, repository interfaces, and use cases. Free of Flutter UI dependencies.
- **Data:** Repository implementations, data models with Freezed serialization, and remote data sources talking to Supabase / APIs.

---

## Key Dependencies

Dependencies are grouped type-wise in [`pubspec.yaml`](pubspec.yaml):

| Category | Package | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **SDK & Core** | `flutter` | `sdk: flutter` | Flutter SDK core runtime |
| | `flutter_localizations` | `sdk: flutter` | Material, Cupertino & Widgets localization |
| | `cupertino_icons` | `^1.0.8` | iOS Cupertino style icons |
| **Backend & Database** | `supabase_flutter` | `^2.18.0` | Supabase Auth, PostgreSQL DB, Storage & Realtime |
| **Firebase & Notifications**| `firebase_core` | `^4.15.0` | Firebase project initialization |
| | `firebase_messaging` | `^16.7.0` | FCM push notification receiver |
| | `flutter_local_notifications`| `^22.3.1` | Local foreground notification alert banners |
| **State Management** | `flutter_bloc` | `^9.1.1` | Business logic component and state management |
| | `equatable` | `^2.1.0` | Value equality for states and events |
| **DI & Routing** | `get_it` | `^9.2.1` | Service locator for inversion of control |
| | `go_router` | `^17.5.0` | Declarative routing & deep link handling |
| **Serialization** | `freezed_annotation` | `^3.1.0` | Annotations for immutable models |
| | `json_annotation` | `^4.12.0` | JSON serialization annotations |
| **Device & Storage** | `package_info_plus` | `^10.2.1` | Live OS version & build number reader |
| | `device_info_plus` | `^13.2.0` | Hardware and OS identifiers |
| | `shared_preferences` | `^2.5.5` | Persistent key-value storage for settings |
| | `path_provider` | `^2.1.6` | Filesystem paths for cache and temp files |
| **Media & Audio** | `image_picker` | `^1.2.3` | Camera & gallery photo picker |
| | `image_cropper` | `^12.2.1` | 1:1 aspect ratio profile avatar cropping |
| | `flutter_image_compress` | `^2.5.1` | Photo compression before uploading |
| | `cached_network_image` | `^3.4.1` | Network image caching with placeholders |
| | `audioplayers` | `^6.6.0` | Notification sound effects playback |
| **UI & Styling** | `google_fonts` | `^8.2.1` | Google typography (Inter / Plus Jakarta Sans) |
| | `intl` | `^0.20.2` | Date, number, and currency formatting |
| | `skeletonizer` | `^2.1.3` | Skeleton loading overlays |
| | `shimmer` | `^3.0.0` | Shimmer gradient animations |
| | `lottie` | `^3.6.1` | Vector Lottie animation playback |
| | `flutter_staggered_animations`| `^1.1.1`| Staggered list entrance animations |
| **Code Generation (Dev)** | `build_runner` | `^2.16.1` | Unified Dart code generator CLI |
| | `freezed` | `^4.0.2` | Data class and union code generator |
| | `json_serializable` | `^6.14.1` | JSON serialization code generator |
| | `flutter_gen_runner` | `^5.15.0` | Type-safe static assets generator |

---

## Configuration & Environment Variables

Environment variables and backend endpoints are bound at compile-time via Dart's native `String.fromEnvironment` and `bool.fromEnvironment`. This guarantees zero bundle extraction leaks, zero runtime parsing overhead, and strict type safety.

### Environment Schema & Keys

Centralized in [`lib/core/config/app_env.dart`](lib/core/config/app_env.dart):

| Key | Type | Default Value | Description |
| :--- | :--- | :--- | :--- |
| `APP_ENV` | `String` | `'dev'` | Target environment: `dev`, `staging`, `prod`, `local` |
| `APP_NAME` | `String` | `'KhelBhai'` | Display application title |
| `APP_VERSION` | `String` | `'1.0.3'` | Application semantic version |
| `SUPABASE_URL` | `String` | `https://zrhmpidlutbyoiysjwxt.supabase.co` | Supabase project URL |
| `SUPABASE_ANON_KEY` | `String` | `eyJhbGciOi...` | Supabase anonymous public client key |
| `SHOW_BANNER` | `bool` | `false` | Enables top-right interactive watermark banner |
| `API_BASE_URL` | `String` | `''` | Optional intermediate API gateway |

### Environment Definition Files

The project supports both JSON and standard `.env` formats for `--dart-define-from-file`:

- **JSON Format:** `env/dev.json`, `env/staging.json`, `env/prod.json`, `env/local.json`, `env/env.example.json`
- **Dotenv Format:** `.env.dev`, `.env.staging`, `.env.prod`, `.env.local`, `.env.example`

Template file: [`.env.example`](.env.example)

```properties
APP_ENV=dev
APP_NAME=KhelBhai (Dev)
APP_VERSION=1.0.3
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key
SHOW_BANNER=true
API_BASE_URL=
```

> **Security Note:** Never commit `SUPABASE_SERVICE_ROLE_KEY` to the client app. The mobile client exclusively uses the public `anonKey`. Sensitive operations (such as atomic spot decrementing or push dispatching) execute via server-side PostgreSQL RPCs and Supabase Edge Functions.

---

## Dismissible EnvBanner

KhelBhai includes an interactive, non-intrusive environment badge widget at [`lib/core/widgets/env_banner.dart`](lib/core/widgets/env_banner.dart) that automatically wraps the application root.

### Features
- **Real Platform Version:** Loads live `version` and `buildNumber` directly from the OS via `PackageInfo.fromPlatform()`.
- **Environment Indicator:** Displays `DEV`, `LOCAL`, `STAGING`, or `PROD` with distinct color tokens.
- **Build Type Marker:** Shows `DEBUG` or `PROFILE` flags.
- **Interactive Collapsing:**
  - Tap the badge pill to slide it into a discreet, 16px side tab on the right screen edge.
  - Tap the side tab arrow to expand it back to full size.
  - Never obstructs UI navigation or testing buttons.
- **Production Safety:** Automatically omitted in production release builds unless `--dart-define=SHOW_BANNER=true` is explicitly provided.

### Color Tokens

| Environment | Accent Color | Visual Representation |
| :--- | :--- | :--- |
| **Dev** | `#EF4444` | Crimson Red pill |
| **Local** | `#8B5CF6` | Purple pill |
| **Staging** | `#F59E0B` | Warm Amber pill |
| **Prod** | `#10B981` | Emerald Green pill |

---

## Authentication & Security

- **Row Level Security (RLS):** Every database table has strict RLS policies enabled. Users can only edit their own profile, messages, and hosted activities.
- **Session Integrity:** Single-device session protection ensures that when a user activates a session on a new device, previous sessions are invalidated via the `activate_my_session` RPC.
- **Capacity Integrity:** Activity capacity and slot reservation logic is enforced exclusively through server-side PostgreSQL transactions, preventing race conditions and client-side manipulation.
- **Push Credentials:** Firebase service account credentials remain strictly on the server (Supabase Edge Function), never bundled in the Flutter app.

---

## API & Backend Integration

The application connects to Supabase for all database, authentication, storage, and realtime services.

### Core Tables

The backend schema is defined in [`schema.sql`](schema.sql) and versioned SQL files in [`supabase/migrations/`](supabase/migrations/):

| Table | Description |
| :--- | :--- |
| `profiles` | User profiles with full name, avatar, bio, city, rating, and preferred sports |
| `user_devices` | Registered device identifiers, platforms, and FCM push tokens |
| `app_settings` | Remote version control, force update minimums, and maintenance mode flags |
| `categories` | Active sport categories with icons and display ordering |
| `cities` | Supported cities and states for local match discovery |
| `requests` | Activity spot posts (sport, title, venue, coordinates, capacity, price, status) |
| `request_images` | Image URLs attached to activity requests |
| `join_requests` | Player requests to join an activity (pending, accepted, rejected, cancelled) |
| `request_participants`| Confirmed participants mapped to activities |
| `conversations` | Chat conversation threads (direct 1:1 or activity-linked group chat) |
| `conversation_members`| Conversation membership, roles, and last read timestamps |
| `messages` | Chat message payloads, sender IDs, and read indicators |
| `notifications` | In-app user notifications with routing data payloads |
| `reports` | User and activity abuse reports pending moderation |

### Atomic RPC Functions

- **`record_user_device`:** Upserts client device tokens and installation IDs without duplicates.
- **`request_to_join`:** Performs atomic capacity verification before creating a join request.
- **`manage_join_request`:** Executes atomic host approvals: decrements available capacity, adds the participant, and updates activity status to `full` when capacity is exhausted.
- **`get_my_chat_conversations`:** Returns user conversations with participant avatars, activity context, unread counters, and last message previews.
- **`activate_my_session`:** Revokes stale sessions on other devices when a user signs in.

---

## Push Notifications & Realtime Messaging

### Realtime Messaging
KhelBhai uses Supabase Realtime Postgres Changes to deliver instant chat messages:
- Chat messages subscribe to `messages` rows filtered by `conversation_id`.
- Unread counts update automatically as incoming messages arrive.

### Push Dispatch Architecture

```text
[Client / Database Trigger]
          │
          ▼
[Supabase Edge Function: send-push]
          │
          ▼
[Firebase Cloud Messaging (FCM)]
          │
          ▼
[Client: flutter_local_notifications (Foreground Coordinator)]
```

- **Android:** Place your `google-services.json` inside `android/app/`.
- **iOS:** Place your `GoogleService-Info.plist` inside `ios/Runner/` using Xcode.

---

## IDE Configurations (VS Code & Android Studio)

Pre-configured run, debug, and build configurations are included in the repository for seamless onboarding.

### VS Code (`.vscode/`)

- **`.vscode/launch.json`:** Multi-target Run & Debug configurations:
  - `KhelBhai (Dev)`
  - `KhelBhai (Dev) + Banner`
  - `KhelBhai (Local)`
  - `KhelBhai (Local) + Banner`
  - `KhelBhai (Staging)`
  - `KhelBhai (Staging) + Banner`
  - `KhelBhai (Prod)`
  - `Release Mode Run APK`
- **`.vscode/tasks.json`:** 17 pre-wired build tasks (`Build APK (Dev) + Banner`, `Build AAB (Prod)`, `Build IPA (Prod)`, `Clean and Pub Get`, etc.).
- **`.vscode/settings.json`:** Binds `dart.flutterSdkPath` to `.fvm/flutter_sdk` and sets format on save.

### Android Studio / IntelliJ (`.idea/runConfigurations/`)

25 shared XML configurations are provided in `.idea/runConfigurations/`:
- **Flutter Run Configurations:** Blue Flutter icon dropdown targets for `Dev`, `Local`, `Staging`, and `Prod`.
- **Shell Tasks (`>_`):** Fast one-click build actions for APK, AAB, IPA, and cache cleaning.

---

## Localization

KhelBhai supports 3 languages out of the box using Flutter's official synthetic localization engine:

- **English (`en`)** — Default source in [`lib/core/l10n/intl_en.arb`](lib/core/l10n/intl_en.arb)
- **Hindi (`hi`)** — [`lib/core/l10n/intl_hi.arb`](lib/core/l10n/intl_hi.arb)
- **Gujarati (`gu`)** — [`lib/core/l10n/intl_gu.arb`](lib/core/l10n/intl_gu.arb)

### Adding or Modifying Strings

1. Add your new key and text to `lib/core/l10n/intl_en.arb`.
2. Add the corresponding translations to `intl_hi.arb` and `intl_gu.arb`.
3. Run the localization generator:
   ```bash
   fvm flutter gen-l10n
   ```
4. Access strings in widgets via `context.loc.<keyName>`.

---

## Testing & Quality Assurance

All features must pass formatting, static analysis, and automated tests before merging.

### Run Static Analysis

```bash
fvm flutter analyze
```

### Check Code Formatting

```bash
fvm dart format --set-exit-if-changed .
```

### Run the Test Suite

```bash
# Run all automated tests (178 tests)
fvm flutter test

# Run a specific feature test suite
fvm flutter test test/features/profile/

# Run core extension, config, and widget tests
fvm flutter test test/core/
```

### Test Coverage Highlights

- **Unit Tests:** Serialization audit for Freezed models, StringExtension formatting, AppEnv environment mapping.
- **Bloc / Cubit Tests:** Auth state transitions, profile metrics calculation, chat conversation flows.
- **Widget Tests:** Responsive layout tests for mobile and tablet, single-action UI validations, EnvBanner collapse/expand interaction, dark theme rendering.

---

## Build & Release

Always compile production releases using FVM.

### Version-Aware Build Automation

To ensure every build accurately carries the semantic version and build number from `pubspec.yaml` (and produces a versioned artifact):

#### One-Line Command (Bash / CI)
```bash
fvm flutter clean && fvm flutter pub get && VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}') && fvm flutter build apk --dart-define-from-file=.env.dev --dart-define=SHOW_BANNER=true --build-name=$(echo $VERSION | cut -d+ -f1) --build-number=$(echo $VERSION | cut -d+ -f2) && cp build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/khelbhai-dev-banner-$VERSION.apk && echo "✅ Built: khelbhai-dev-banner-$VERSION.apk"
```

#### Via Helper Script
Use [`tool/build_apk_with_banner.sh`](tool/build_apk_with_banner.sh) with target and banner flags:

```bash
# Build Dev APK with watermark banner
bash tool/build_apk_with_banner.sh dev true

# Build Staging APK with watermark banner
bash tool/build_apk_with_banner.sh staging true

# Build Production Release APK (No banner)
bash tool/build_apk_with_banner.sh prod false
```

*Output:* `build/app/outputs/flutter-apk/khelbhai-<env>-[banner-]<version>.apk`

---

### Standard Platform Builds

#### Android APK (Standard Release)

```bash
fvm flutter build apk --release --dart-define-from-file=env/prod.json
```
*Output:* `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (AAB for Google Play)

```bash
VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}') && fvm flutter build appbundle --release --dart-define-from-file=env/prod.json --build-name=$(echo $VERSION | cut -d+ -f1) --build-number=$(echo $VERSION | cut -d+ -f2)
```
*Output:* `build/app/outputs/bundle/release/app-release.aab`

#### iOS Release IPA (for App Store / TestFlight)

```bash
VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}') && fvm flutter build ipa --release --dart-define-from-file=env/prod.json --build-name=$(echo $VERSION | cut -d+ -f1) --build-number=$(echo $VERSION | cut -d+ -f2)
```
*Output:* `build/ios/archive/Runner.xcarchive` & `build/ios/ipa/`

### Launcher Artwork Export

To regenerate launcher icons from the master artwork (`assets/branding/khelbhai_launcher_master.png`):

```bash
bash tool/export_launcher_icons.sh
```

---

## Troubleshooting

### 1. FVM Version Mismatch
**Symptom:** CLI warns about using a different Flutter version.  
**Fix:** Ensure commands are prefixed with `fvm`:
```bash
fvm install
fvm use
```

### 2. Code Generation Errors
**Symptom:** Missing `*.freezed.dart` or `*.g.dart` files.  
**Fix:** Run build runner with the delete flag:
```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 3. iOS Pod Installation Failures
**Symptom:** CocoaPods dependency or architecture errors.  
**Fix:**
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install --repo-update
cd ..
```

### 4. Localization Missing Keys
**Symptom:** `context.loc.<key>` is unresolved in IDE.  
**Fix:**
```bash
fvm flutter gen-l10n
```

---

## Development Guidelines

1. **Architecture Rule:** Feature-First Clean Architecture is mandatory. Place code in `lib/features/<name>/{data, domain, presentation}`.
2. **FVM Rule:** NEVER run bare `flutter` or `dart` CLI commands. ALWAYS prefix with `fvm`.
3. **No Hardcoded Dimensions or Colors:**
   - Use `Dimensions.r*.dynamicW/H/SP/R` for all padding, heights, widths, and font sizes.
   - Use `context.primaryColor`, `context.surfaceColor`, or `AppColor` constants. Never hardcode hex codes or `Colors.*`.
4. **No Hardcoded Strings:** Add all user-facing strings to `lib/core/l10n/intl_en.arb`.
5. **No Inline Callback Logic:** Extract multiline event handlers in widget trees into dedicated private helper methods.
6. **Pull Requests:**
   - Branch naming: `feat/<name>`, `fix/<name>`, `chore/<name>` from `main`.
   - Conventional Commits: `feat(spot): add max participants validation`.
   - Ensure `fvm dart format .`, `fvm flutter analyze`, and `fvm flutter test` pass before opening a PR.

---

## Maintenance Information

- **Product Name:** KhelBhai
- **Maintainer:** Engineering Team
- **Repository:** [https://github.com/SalmanNaghori/lastspot_app.git](https://github.com/SalmanNaghori/lastspot_app.git)
- **Contact & Support:** [support@khelbhai.com](mailto:support@khelbhai.com)
- **Documentation Last Updated:** October 19, 2026
