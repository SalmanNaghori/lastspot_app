---
description: "LastSpot master product, UX, UI & development specification. Applied to every task in this project."
globs: "**/*"
alwaysApply: true
---

# ============================================================
# LASTSPOT MOBILE APP
# MASTER FLOW-WISE PRODUCT, UX, UI & DEVELOPMENT SPECIFICATION
# ============================================================

## IMPORTANT

Do NOT build isolated screens.
Do NOT create one attractive page and then leave the rest as unfinished placeholders.
The application must be developed FLOW BY FLOW.

Each flow must be completely connected:

UI → User action → BLoC/Cubit → Use Case → Repository → DataSource → Supabase → Backend result → State update → UI feedback → Navigation

Every screen must have a purpose in a real user journey.
When Flow N is completed and tested, move to Flow N+1.
Do NOT start the next flow until the previous flow is working.

---

## PRODUCT CONCEPT

LastSpot is a social/activity discovery and participation platform.

Core use case:
A user needs people for an activity.

Example: "I am going to play cricket at 7 PM and need 2 more players."

The user creates an activity/request.
Other users discover it.
Interested users request to join.
The creator accepts/rejects.
Accepted users become participants.
Participants can communicate through chat.
Users can report users or activities.
The system sends notifications for important actions.

The activity eventually becomes: completed / cancelled / expired / full

The architecture must support many activity types:
Cricket, Football, Badminton, Tennis, Basketball, Volleyball, Running, Cycling, Travel, Ride Sharing, Events, Hiking, Other

Do NOT make the architecture cricket-specific.

---

## CORE USER JOURNEY

### NEW USER
App Launch → Splash → Login → Create Account → Profile Setup → Profile Photo → Device Registration → Home

### DISCOVER USER
Home → Explore → Search/Filter → Activity List → Activity Details → Request to Join → Pending → Accepted → Chat → Activity

### CREATOR
Home → Create → Create Activity → Add Details → Add Images → Preview → Publish → Receive Join Requests → Accept/Reject → Participants → Chat → Complete Activity

### MODERATION
Activity/User → Report → Select Reason → Submit → Admin Review

### NOTIFICATIONS
System Event → Notification → Tap → Correct Destination

### PROFILE
Profile → Edit Profile → Save → Updated Profile

---

## DEVELOPMENT ORDER

Build in this exact order:

- **FLOW 0** — Foundation & Design System
- **FLOW 1** — Authentication & Initial Account Setup
- **FLOW 2** — Home
- **FLOW 3** — Explore / Search / Filters
- **FLOW 4** — Create Activity
- **FLOW 5** — Activity Details
- **FLOW 6** — Join Request
- **FLOW 7** — My Activities & Creator Management
- **FLOW 8** — Chat
- **FLOW 9** — Notifications
- **FLOW 10** — Profile & Settings
- **FLOW 11** — Reports & Moderation
- **FLOW 12** — Account Deletion
- **FLOW 13** — Final Security / Performance / Testing / Release

Do not skip directly from Flow 1 to Flow 8.

---

## ARCHITECTURE

Use Clean Architecture: Presentation → Domain → Data

```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

Use BLoC/Cubit.
UI must NEVER directly call Supabase.

**Correct:** Page → Cubit → UseCase → Repository → DataSource → Supabase
**Incorrect:** Page → Supabase.from(...)

---

## BACKEND REPLACEMENT

The repository layer must make future backend replacement easy.

Current: Flutter → Repository → Supabase
Future: Flutter → Same Repository interface → REST/API → Node.js/Go → PostgreSQL

Presentation and Domain should not depend directly on Supabase.

---

## MATERIAL 3 DESIGN SYSTEM

Use `ThemeData(useMaterial3: true)`.

Brand:
- Primary: Emerald Green
- Accent: Orange

Semantic: Success / Warning / Error / Info

Use the existing AppColor/AppTheme architecture.
Do not hardcode colors in widgets.
Support Light Theme and Dark Theme.
Use Google Inter typography.

---

## UI STYLE

Design direction: premium, modern, friendly, sporty, social, clean, minimal, approachable.

Use: rounded cards, subtle shadows, proper spacing, clear typography, large primary CTAs, meaningful icons, visual hierarchy, subtle animations.

Avoid: generic CRUD UI, excessive borders, excessive gradients, too many colors, giant empty areas, unnecessary animations.

---

## BOTTOM NAVIGATION

5 primary destinations:
- Home
- Explore
- Create (visually emphasized)
- Activities
- Profile

Do NOT put Chat or Reports in bottom navigation — they are contextual features.
Chat is reached from activities/conversations.
Report is reached from User/Activity/Chat actions.
Notifications are reached from the notification bell.

---

## NAVIGATION ARCHITECTURE

Routes:
- `/home`, `/explore`, `/create`, `/activities`, `/profile`
- `/activity/:id`, `/activity/:id/join-requests`, `/activity/:id/chat`
- `/chat`, `/chat/:conversationId`
- `/notifications`
- `/report/user/:userId`, `/report/activity/:activityId`
- `/profile/edit`, `/settings`
- `/account/delete`
- `/login`, `/signup`, `/forgot-password`, `/profile-setup`

Do not show bottom navigation on:
- Login, Signup, Forgot Password, Profile Cropper, Fullscreen image viewer, Multi-step Create Activity flow

---

## FLOW 1 — AUTHENTICATION

Screens: Splash, Login, Signup, Forgot Password, Profile Setup, Profile Photo Cropper, Suspended Account, Banned Account

### Flow
App Launch → Initialize dependencies → Check Supabase session

NO SESSION → Login

SESSION → Load profile → Check status → Check deletion → Check profile completeness

- ACTIVE: Register/update device → Home
- PROFILE INCOMPLETE: Profile Setup
- SUSPENDED: Suspended state
- BANNED: Banned state

### Login UI
- Welcome back 👋
- Find your next activity and the people to enjoy it with.
- Email, Password, Show Password
- Forgot Password?
- [ Login ]
- Create Account

Buttons must have: loading state, disabled state, validation, error state, duplicate-tap protection.

Successful: Login → Load Profile → Check Status → Device Upsert → Home
Back from Home must NOT return to Login.

### Signup
Fields: Full Name, Email, Password, Confirm Password, Terms & Conditions

Flow: Validate → Supabase signup → Email confirmation if enabled → Profile Setup → Profile Photo → Device Registration → Home

Do not assume email confirmation is disabled.

### Profile Photo
Gallery/Camera → Crop 1:1 → Compress → Upload → Save avatar_url
Profile photo MUST use a cropper. Activity/post images MUST NOT use a cropper.

### Device Registration
Table: `user_devices`
Fields: user_id, device_identifier, platform, device_model, os_version, app_version, build_number, push_token, last_active_at, created_at, updated_at
Unique: (user_id, device_identifier)
Use UPSERT. Do not create duplicate device records.

---

## FLOW 2 — HOME

Structure:
- Top: Avatar, greeting, notification bell
- Hero: "What are you up for today?"
- Search: [ Search activities, sports, players... ]
- Categories: Cricket, Football, Badminton, Tennis, Travel, Other
- Sections: Urgent Matches, Nearby Activities, Coming Up, Popular Activities, Recommended

Data flow: Home → HomeCubit → GetCategoriesUseCase + GetNearbyActivitiesUseCase + GetUpcomingActivitiesUseCase

Use pagination, limit, distance filtering. Do not fetch unlimited records.

---

## ACTIVITY CARD

Every activity card must show:
- Activity image if available
- Category
- Title
- Date, Time
- Location, Distance if available
- Available spots
- Price (or "Free" if no price — do NOT display ₹0)
- Creator
- Status

---

## FLOW 3 — EXPLORE

Contains: Search, Categories, Filters, Sort, Results

Filters: Category, Date, Time, Distance, Price, Available spots, Location
Use filter chips. Search must be debounced. Backend filtering. Pagination required.

Flow: Explore → Search/Filter → Results → Tap Activity → Activity Details

---

## FLOW 4 — CREATE ACTIVITY

Multi-step form:
1. Category
2. Title + Description
3. Date & Time
4. Location (current or search)
5. Participants (total spots, required people)
6. Price (optional, price per person)
7. Images (max 5 for MVP, no crop)
8. Preview
9. Publish

### Validation
Required: Category, Title, Date, Time, Location, Spots
Validate: title, dates, time, positive spots, valid price, location, future activity time, backend limits.

### Activity Images
Camera/Gallery → Select Image → Preserve original aspect ratio → Compress → Optional resize → Preview → Upload
Do not force square dimensions. Maximum 5 images for MVP.

### Image Service (centralized)
Responsibilities: pick image, pick multiple, camera, compress, resize, upload, delete, preview
Defaults: preserve aspect ratio, max long edge ~1920px, reasonable JPEG/WebP quality.

### Storage
Profile: `profiles/{userId}/profile.jpg`
Activity: `requests/{requestId}/image_1.jpg` etc.

---

## REQUEST DATABASE

Table: `requests`

Fields: id, creator_id, category_id, title, description, start_at, end_at, location_name, latitude, longitude, spots_total, spots_available, price, status, created_at, updated_at

Status lifecycle: draft → published → full → started → completed
Alternative: published → cancelled / published → expired

Backend is source of truth. Do not create this table without first inspecting whether it already exists.

---

## FLOW 5 — ACTIVITY DETAILS

Screen: Hero image/gallery, Category, Title, Creator, Date, Time, Location, Distance, Description, Price, Available spots, Participants

CTA depends on state: Request to Join / Pending / Joined / Full / Completed / Cancelled / Expired
Creator: Manage Activity. Others: Request to Join.

Menu: Share, Report Activity. Creator may have: Edit, Cancel, Close.
Only show actions allowed by backend state.

---

## FLOW 6 — JOIN REQUEST

Flow: Activity Details → JoinRequestCubit → SendJoinRequestUseCase → Repository → Backend → join_requests

Prevent: joining own activity, joining cancelled/expired/full activity, duplicate requests.

Table: `join_requests`
Fields: id, request_id, user_id, status (pending/accepted/rejected/cancelled), message, created_at, updated_at

---

## FLOW 7 — ACCEPT / REJECT / PARTICIPANTS

Creator: Activities → Created → Activity → Join Requests

Accept must use backend atomic operation (RPC):
- join_request = accepted
- request_participant created
- spots_available--
- request status updates if full
- notification created
- chat becomes available

Capacity MUST be protected by backend transaction/RPC. Do NOT rely on Flutter-side if-checks alone.

Table: `request_participants`
Fields: id, request_id, user_id, join_request_id, status, joined_at
Do NOT store participant IDs in an array field.

---

## MY ACTIVITIES

Activities tab: Created + Joined

Filters: Upcoming, Active, Completed, Cancelled, Expired
Tap any item → Activity Details

---

## FLOW 8 — CHAT

Chat is contextual — not in bottom navigation.

Architecture: Chat → Conversation List → Conversation Details → Messages

Tables: conversations, conversation_members, messages

Conversation list: Avatar, Name/activity, Last message, Time, Unread count

Chat details: Header (Activity/User), Message list, Input ([ Type a message... ], Attachment, Send)

Chat permissions: Only conversation members can read/send. Activity-related chat available only to valid participants. RLS must enforce membership.

Realtime: Use Supabase Realtime.
Handle: connection lost, reconnect, duplicate messages, loading history, pagination, sending state, failed message, retry.

---

## FLOW 9 — NOTIFICATIONS

Events: Join request received/accepted/rejected, New chat message, Activity updated/cancelled/reminder, Participant changes

Table: `notifications`
Fields: id, user_id, type, title, body, data (JSON), is_read, created_at

Tap notification → parse data → navigate to correct destination.

Delivery: Separate notification record from push delivery.
Use Supabase Edge Function → FCM. Never expose Firebase server credentials in Flutter.

---

## FLOW 10 — PROFILE & SETTINGS

Profile data MUST come from `profiles` table. Never hardcode names/locations.

Structure:
- Large Avatar, Full Name, Location, Bio
- [ Edit Profile ]
- Statistics: Created, Joined, Completed (real data only, no fake stats)
- My Activity: My Requests, My Activities
- Account: Notifications, Settings, Help & Support
- Legal: Privacy Policy, Terms & Conditions
- Logout

Profile looks like a social profile, not a settings page.

Data flow: ProfilePage → ProfileCubit → GetCurrentProfileUseCase → ProfileRepository → Supabase → profiles

Edit Profile fields: Profile Photo, Full Name, Bio, City
Save: Validate → Update backend → Update Cubit state → Return Profile → Immediately display updated info

---

## FLOW 11 — REPORTING

Users can report: User, Activity, Future: Chat/message

Report UI:
- Why are you reporting this?
- Reasons: Spam, Harassment, Fake Activity, Inappropriate Content, Fraud/Scam, Unsafe Behavior, Other
- Optional description
- [ Submit Report ]

Table: `reports`
Fields: id, reporter_id, reported_user_id, request_id, message_id, reason, description, status (pending/reviewing/resolved/dismissed), admin_note, created_at, resolved_at

A report must NOT automatically ban a user — admin reviews first.

---

## FLOW 12 — ACCOUNT DELETION

Profile → Settings → Delete Account

Show warning. Confirm with: Cancel / Delete Account.

Backend follows retention/deletion policy. If soft delete: `deleted_at = timestamp`.
Never automatically reactivate a banned/suspended account.

---

## APP SETTINGS

On startup check: Maintenance Mode, Minimum version, Latest version, Force update, Feature flags.

Flow: App Launch → App Configuration → Maintenance check → Version check → Authentication check → Continue

Configuration from Supabase/admin-managed settings. Do not scatter version logic around the app.

---

## DATA FLOW RULE

Every feature must have: UI → BLoC/Cubit → Use Case → Repository Interface → Repository Implementation → Data Source → Supabase/API

No business logic in widgets. No Supabase query directly inside widgets.

---

## LOADING / EMPTY / ERROR / SUCCESS

EVERY major feature must support: Loading, Success, Empty, Error, Retry.

Do not display raw exceptions. Show friendly messages with retry.

---

## IMAGE RULES

PROFILE IMAGE: Camera/Gallery → Crop 1:1 → Compress → Upload
ACTIVITY IMAGE: Camera/Gallery → NO CROP → Preserve aspect ratio → Compress → Optional resize → Upload

Never mix the workflows.

---

## PRICE RULE

If price exists: show `₹100 per person`
If price does not exist: show `Free`
Do NOT display ₹0 unless ₹0 is actually stored.
Currency should be configurable later.

---

## SECURITY

Never use SUPABASE_SERVICE_ROLE_KEY inside Flutter.
Never expose server credentials.
RLS must remain enabled.
Do not solve security errors by disabling RLS.

Capacity: protect with backend RPC, not Flutter-side conditionals.
Administrative actions: secure backend/RLS/RPC/Edge Functions.

---

## PERFORMANCE

Use: pagination, lazy loading, debounced search, image caching, compressed uploads, efficient BLoC rebuilds, repository caching where appropriate.

Do not load all users, all requests, all messages, all notifications at once.

---

## RESPONSIVE DESIGN

Support: small Android phones, normal Android phones, large Android phones, iPhones, tablets.
Use: SafeArea, Expanded, Flexible, LayoutBuilder, Slivers, constraints.
Avoid: fixed widths, overflow, keyboard overlap, clipped text.

---

## DARK MODE

All features must support Light and Dark.
Use Material 3 ColorScheme.

---

## ACCESSIBILITY

Support: semantic labels, accessible buttons, sufficient contrast, scalable text, meaningful error messages, proper focus, touch-friendly controls.
Do not rely only on color.

---

## FLOW COMPLETION RULE

A flow is complete only when:
- UI works
- Navigation works
- Data flow works
- Backend works
- Error handling works
- Loading works
- Empty state works
- Security works
- Tests work
- Real data is used
- No mock data remains
- No dead buttons remain

---

## DEVELOPMENT METHOD (per flow)

1. Audit dependencies and existing implementation
2. Define data model required
3. Define RLS/security
4. Define domain entity
5. Define repository interface
6. Implement datasource
7. Implement repository
8. Implement use cases
9. Implement BLoC/Cubit
10. Implement UI
11. Connect navigation
12. Implement loading/error/empty/success
13. Test the full flow
14. Fix issues
15. Only then start next flow

---

## DATABASE-FIRST RULE

Before creating any table:
1. Inspect existing Supabase schema
2. Check whether table already exists
3. Check columns, foreign keys, indexes, unique constraints, RLS, existing policies
4. Reuse existing structures when possible
5. Do not create duplicate tables

Potential entities:
profiles, user_roles, user_devices, categories, requests, request_images, join_requests, request_participants, conversations, conversation_members, messages, notifications, reports, app_settings

---

## FINAL PRODUCT MAP

```
LASTSPOT
├── Splash
├── Authentication (Login, Signup, Forgot Password, Profile Setup)
├── Home (Search, Categories, Urgent, Nearby, Upcoming)
├── Explore (Search, Filters, Sort, Results)
├── Create (Category, Details, Date/Time, Location, Participants, Price, Images, Preview, Publish)
├── Activity (Details, Join, Participants, Join Requests, Chat, Report, Share)
├── Activities (Created, Joined)
├── Chat (Conversations, Messages)
├── Notifications
├── Profile (Edit, My Requests, My Activities, Notifications, Settings, Help, Privacy, Terms, Delete Account)
└── Reports (Submit Report)
```

---

## FINAL PRODUCT EXPERIENCE

The user should always know:
- WHAT is happening?
- WHEN?
- WHERE?
- WHO is involved?
- HOW MANY spots?
- WHAT is the price?
- WHAT can I do next?

Primary user journey:
DISCOVER → VIEW → JOIN
or
CREATE → FIND PEOPLE → ACCEPT → CHAT → PARTICIPATE → COMPLETE
