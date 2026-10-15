# Project-Specific Rules

These rules apply **only to this project**. They complement `rules/*.rules` and may override universal RECOMMENDED/OPTIONAL items. Each override cites an ADR. They never override a universal MUST/MUST NOT without an approved exception (`checklists/exception-request.md`).

## A. Structure (ADR-0001)

- PR-A1. Keep the existing **layer-first** layout under `lib/layers/`. Do not introduce a parallel `lib/features/` tree. Migration to feature-first, if ever, is a dedicated ADR + PR series.
- PR-A2. New code goes to: abstract repo → `domain/repositories/`; impl → `data/repositoryImpl/`; models → `data/models/<group>Models/`; cubit/bloc → `presentation/cubit/<name>Cubit/` or `presentation/bloc/<name>Bloc/`; screen + widgets → `presentation/ui/<feature>/` with `widgets/`.
- PR-A3. New **directories** use `snake_case` (universal). Existing camelCase directories are LEGACY; do not rename them in unrelated PRs, and do not create new camelCase directories.
- PR-A4. Do not add code to `lib/layers/app/custom/CountryCodePicker/`. Moving it to `packages/country_code_picker` is a backlog item.
- PR-A5. Do not import `lib/layers/utils/exports.dart` in new `data/`, `domain/` or `core/` files. Import what you use. (Presentation may continue to use it until the barrel is retired.)

## B. Dependency injection (ADR-0002)

- PR-B1. Register in the module matching the type: repositories in `RepositoryInjection`, blocs in `BlocsInjection`, cubits in `CubitsInjection`, infrastructure in `AppLevelInjection`/`ExternalDependency`. Preserve the documented registration order.
- PR-B2. Repositories and services are `registerLazySingleton<Abstract>`; Blocs/Cubits are `registerFactory`.
- PR-B3. `sl<X>()` is permitted only in: `core/di/**`, `BlocProvider.create`, `wrappedRoute`, `AppBootStartup`, `SplashScreen`. Anywhere else, inject through the constructor or read from state.
- PR-B4. Pure UI cubits with no dependencies (e.g. `ChatScrollDownCubit extends Cubit<bool>`) MAY be constructed directly in `BlocProvider(create: (_) => ChatScrollDownCubit())` without DI registration. Document this in the provider comment.

## C. State management (ADR-0003)

- PR-C1. New data-loading Cubits extend `BaseCubit<S>` and implement `onInternetRestored` and `stateWithFailure`.
- PR-C2. New states are `@freezed` with a `Status status`, `String error`, `int errorCode` and data fields. Do not add `isLoading/isSuccess/hasError` flags.
- PR-C3. New Blocs use `sealed class XEvent extends Equatable` and event names `<Verb><Noun>Requested` (e.g. `LoginRequested`, `OtpVerified` for results). Existing `On*Event` names are LEGACY; do not add more.
- PR-C4. Cross-feature updates go through `GlobalEventBus` with a typed `AppRealtimeEvent` subclass in `core/realtime/events/`. Never reach into another cubit from a cubit.
- PR-C5. Pagination uses the standard contract: `skip`, `limit` (project default **10**; chat uses 20 by ADR-0007), `hasMore`, `Status.paginating`.
- PR-C6. Debounce with `easy_debounce` and cancel the key in `close()`. Do not add raw `Timer`-based debouncing.
- PR-C7. After every `await` in a Bloc/Cubit: `if (isClosed) return;` before `emit`.

## D. Networking and data (ADR-0005)

- PR-D1. All HTTP goes through `BaseApiService.executeAPI(ApiRequest)` from a repository impl (or, for multi-source features, a remote data source). No `Dio` import outside `core/network` and `core/di/dioInjection`.
- PR-D2. Endpoints are constants or functions on `ApiEndpoints`. Reuse before adding; do not create near-duplicates.
- PR-D3. Wrap calls with `backToUI<T>` and parse with `parseResponse(response, T.fromJson)`.
- PR-D4. New models use `@freezed` + `json_serializable`. FlutterJsonBeanFactory (`lib/generated/json/`) is frozen: fix bugs only, never add models.
- PR-D5. Model naming for new files: response `XEntity` (matches majority), request `XReqModel`. Do not create `Model*Response*Entity` names.
- PR-D6. A remote data source is introduced only when a feature has 2+ data sources (remote + local cache). Otherwise the repository calls `BaseApiService` directly.
- PR-D7. Use cases are optional; add one only when orchestration spans multiple repositories/services (the chat message list is the precedent).

## E. Routing (ADR-0004)

- PR-E1. New screens: `@RoutePage()` class `XScreen` → generated `XRoute`; register in `AppRouter.routes`; run `build_runner`.
- PR-E2. Navigate with `context.router` from widgets/listeners or `NavigationService` from non-widget code. `Navigator.push` / `navigateToPage` are LEGACY.
- PR-E3. Screens requiring a session are listed with `guards: [_authGuard]`.
- PR-E4. Scope screen-level Blocs/Cubits with `AutoRouteWrapper.wrappedRoute`; do not add new providers to `main.dart` unless the state is truly app-wide.

## F. UI

- PR-F1. Colors from `AppColors`, spacing from `Dimensions`, text from `context.fontStyle*` / `AppStyles`. No new `Colors.*`, `Color(0x...)`, inline `TextStyle(fontSize: ...)` in presentation.
- PR-F2. Reuse `MyButton` / `MyOutLineButton` (core/widgets), `MyTextField`, `MyNetworkImage`, `LoadingWidget`, `ErrorView`, `AppConstant.showToast`, `CustomBottomSheet`. Do not add a sixth button.
- PR-F3. User-facing strings go in `AppString` (until l10n is adopted per NEEDS-DECISION ND-6).
- PR-F4. Loading: full-screen blocking → `EasyLoading` from a `BlocListener`; inline content → `LoadingWidget`. Do not use both for the same state.

## G. Security

- PR-G1. Secrets only via `config/<env>.json` + `--dart-define-from-file` → `AppConfiguration`. Never in Dart source, manifest or plist strings.
- PR-G2. Never log `token`, `fcmToken`, phone numbers, OTPs or full notification payloads, even under `kDebugMode`.
- PR-G3. Session/token storage stays behind `AppStorage`; the storage backend is a NEEDS-DECISION (ND-8) and must be swapped in one place.

## H. Testing

- PR-H1. Every new or modified Bloc/Cubit ships with a `test/presentation/<name>_test.dart` using `bloc_test` + `mocktail` (adding these dev dependencies is pre-approved by this document; see ND-9).
- PR-H2. Every new repository impl ships with a test mocking `BaseApiService`.

## I. Open decisions (NEEDS-DECISION register)

| ID | Decision needed | Options | Default until decided |
|----|-----------------|---------|-----------------------|
| ND-1 | Adopt `BaseCubit` for all data cubits, or retire it | adopt / retire | adopt for new cubits |
| ND-2 | Migrate flag-style Bloc states (`AuthState`, `CreateOrbitState`) to `Status` | migrate / leave | leave; new code uses `Status` |
| ND-3 | Add `bloc_concurrency` | yes / no | no; guard double-submits in UI + `isClosed` |
| ND-4 | Single connectivity package | `internet_connection_checker_plus` / `connectivity_plus` | keep `NetworkMonitor` only; do not use `connectivity_plus` in new code |
| ND-5 | Retire FlutterJsonBeanFactory models | migrate to freezed / freeze | freeze |
| ND-6 | Localization (`.arb` + `AppLocalizations`) | adopt / keep `AppString` | keep `AppString` |
| ND-7 | Loading UX (EasyLoading vs inline) | one / both by rule | PR-F4 |
| ND-8 | Token storage backend | `flutter_secure_storage` / keep AES GetStorage | keep; high-priority backlog |
| ND-9 | Test stack | `bloc_test`+`mocktail` / other | `bloc_test`+`mocktail` |
| ND-10 | Stricter lints (`very_good_analysis` or curated list) | adopt / keep | keep; see `sop/code-quality.md` |
| ND-11 | Flutter version pin (`.fvmrc` 3.32.6 vs `.tool-versions` 3.38.3) | align | align to README (3.38.3) |
| ND-12 | Deep link validation and auth binding | add / leave | add (backlog) |
| ND-13 | Commit convention | Conventional Commits / current | Conventional Commits |
| ND-14 | Dio timeouts (120s) | reduce / keep | reduce to 30s except uploads |
