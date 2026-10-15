# SOP: Naming Conventions

## Purpose

Names are the cheapest documentation. Consistent names let a reader (or an agent's search) predict a file's location and role.

## Scope

Directories, files, classes, members, state-management artifacts, data-layer artifacts, routes, tests.

## Principles

1. Follow Effective Dart: `UpperCamelCase` types, `lowerCamelCase` members, `snake_case` files and directories.
2. Suffix by role, not by layer (`XRepository`, not `XDomain`).
3. One name per concept: the class name, file name, and route name share a stem.
4. Don't encode types in names (`productsList` not `productsArrayList`).

## Standard

Each row: an example of a legacy/observed convention → universal standard. Where they differ, new code follows the universal column; existing code is LEGACY.

### Directories and files

| Item | Legacy example | Universal standard | Class |
|------|------------------------------|--------------------|-------|
| Directories | Mixed: `chatDetailsScreen`, `repositoryImpl` (camelCase) and `profile_setting`, `request_tab` (snake) | `snake_case` | UNIVERSAL, HIGH |
| Files | `snake_case.dart` (consistent) with exceptions `completeProfile_request_model_entity.dart` | `snake_case.dart`, file stem = primary class in snake_case | UNIVERSAL, HIGH |
| Generated | `x.g.dart`, `x.freezed.dart`, `app_router.gr.dart` | same | UNIVERSAL |
| Widgets folder | `widget/` and `widgets/` | `widgets/` | UNIVERSAL |
| Feature First screen folder | — | `features/<feature>/views/` | UNIVERSAL when Feature First |
| Feature First state folder | — | `features/<feature>/controller/` (files still `x_cubit.dart` / `x_notifier.dart` per state ADR) | UNIVERSAL when Feature First |
| Layer First screen folder | `presentation/ui/<feature>/` | same, when Layer First | PROJECT-SPECIFIC |
| Test files | none | `<source>_test.dart` mirroring path | UNIVERSAL |

### Types

| Item | Legacy example | Universal standard |
|------|-------------------|--------------------|
| Classes, enums, typedefs, extensions | `UpperCamelCase` | same |
| Abstract repository | `ProductsRepository` | `XRepository` |
| Repository impl | `ProductsRepositoryImpl` | `XRepositoryImpl` (PROJECT-SPECIFIC; universal alternative `RemoteXRepository` is also acceptable — pick one per project) |
| Remote data source | `ChatRemoteDataSource` | `XRemoteDataSource` / `XLocalDataSource` |
| Interface for gateway | `BaseApiService` → `NetworkAPIImpl` | interface `XService`/`XClient`, impl `XServiceImpl` — avoid `Base` prefix for interfaces (Base implies inheritance helper) |
| Base classes (inheritance helpers) | `BaseCubit`, `BaseResponsiveView` | `BaseX` |
| Mixins | `UpdateUiMixin`, `EventSubscriberMixin` | `XMixin` |
| Enums | `Status`, `HttpMethod`, `ApiType` | `UpperCamelCase`, values `lowerCamelCase` |
| Extensions | `ApiRequestKey on ApiRequest` | `XExtension` or descriptive (`ApiRequestKey`) |
| Constants holder | `AppConstant`, `AppString`, `StorageKeys`, `ApiEndpoints` | plural nouns preferred (`AppStrings`, `AppConstants`); existing singular names are LEGACY, not worth renaming |
| Failure types | `Failure` | `Failure` (sealed subclasses `NetworkFailure`, `AuthFailure` … when kinds are needed) |

### Members

| Item | Standard |
|------|----------|
| Variables, methods, parameters | `lowerCamelCase` |
| Private fields | `_lowerCamelCase`; injected dependencies as `final XRepository _repository;` |
| Constants | `lowerCamelCase` (`static const int pageLimit = 10;`), not `SCREAMING_CAPS` |
| Booleans | `is`/`has`/`can`/`should` prefix: `isLoading`, `hasMore`, `canProceed` |
| Async methods | verb, no `Async` suffix: `fetchProducts()`, not `fetchProductsAsync()` |
| Callbacks | `onX`: `onInternetRestored`, `onPaginationRequired` |

### Presentation

| Item | Legacy example | Universal standard |
|------|-------------------|--------------------|
| Screen (routed) | `XScreen` | `XScreen` |
| Tab body | `ProductListTabScreen` | `XTabScreen` or `XTab` — one per project |
| Non-routed widget | `AvailableProductList`, `CategoriesBar`, `MyButton` | descriptive noun; avoid `My`/`Custom` prefixes for new widgets (`AppButton`, `PrimaryButton`) |
| Bottom sheet | `showVenueDetailsSheet()` + `VenueDetailsSheet` | `XSheet` widget + `showXSheet()` function |
| Dialog | `showDeleteMessageDialog` | `showXDialog()` |
| UI model | `ChatMessageUIModel`, `BondCandidate` | `XUiModel` or `XViewData`. Feature First: `features/<feature>/models/` (or `widgets/` if view-only). Layer First: `ui/<feature>/models/` |

### State management

| Item | Legacy example | Universal standard | Class |
|------|---------------------------|--------------------|-------|
| Cubit class/file | `ProductListCubit` / `product_list_cubit.dart` | `XCubit` / `x_cubit.dart` | UNIVERSAL |
| Bloc class/file | `AuthBloc` / `auth_bloc.dart` | `XBloc` / `x_bloc.dart` | UNIVERSAL |
| State | `ProductListState`; mismatch `ChatMessagingBloc` ↔ `LastMessageState` | `XState`, same stem as the owner | UNIVERSAL |
| Event base | `sealed class AuthEvent extends Equatable` (one `abstract` outlier) | `sealed class XEvent extends Equatable` | UNIVERSAL |
| Event names | `OnCreateProductEvent`, `VerifyOtpEvent`, `PinChat`, `LoadPinnedMessages` | Past-tense fact or `<Noun><Verb>Requested`: `LoginRequested`, `OtpSubmitted`, `ChatPinned`, `PinnedMessagesRequested`. No `On` prefix, no `Event` suffix (the sealed parent carries it). | UNIVERSAL, NEEDS-DECISION locally → adopt for new events |
| Status enum | `Status` in `base_status.dart` | `Status` (project-wide single enum) | RECOMMENDED |
| Status enum values | `none, initial, loading, paginating, success, failure, noInternet, syncing` | keep; do not add per-feature status enums (`ContactsStatus`, `CommentsStatus` are LEGACY) | RECOMMENDED |
| Cubit folder | `productListCubit/` | Feature First: `features/<feature>/controller/`. Layer First: `product_list_cubit/` | UNIVERSAL |

### Data

| Item | Legacy example | Universal standard |
|------|---------------------------|--------------------|
| Response model | `ProductEntity`, `LoginResponseModelEntity`, `ModelChatListResponseEntity` | `XEntity` for API response models when no separate domain entity exists (when the project has no separate domain entity); universally `XDto`/`XModel` when a domain entity also exists. Never `Model*Response*Entity`. |
| Request model | `CreateProductReqModel`, `ProductListReqModel` | `XReqModel` (project) / `XRequest` (universal alternative) — one per project |
| Local (Hive) model | `ChatDraftEntity` with adapter | `XLocalModel` + `XLocalModelAdapter` (RECOMMENDED) |
| Mapper | (inline) | `XMapper` or extension `toEntity()/toDto()` |
| Endpoint constants | `fetchProductListAPI`, `login`, `aboutUs`/`aboutUsAPI` | `lowerCamelCase` verb-noun, no `API` suffix, no duplicates: `fetchProductList`, `login`, `aboutUs` (an `API` suffix is LEGACY) |
| Storage keys | `StorageKeys.token` | `StorageKeys.x` |

### Routing

| Item | Standard |
|------|----------|
| Route class | generated from screen: `ProductDetailScreen` → `ProductDetailRoute` (`replaceInRouteName: 'Screen,Route'`) |
| Route args | typed constructor params on the screen; generated `XRouteArgs` |
| Path strings | never hand-written in feature code |
| Guard | `XGuard` (`AuthGuard`) |

### Realtime / events

| Item | Standard |
|------|----------|
| Bus event | `<Noun><PastTenseVerb>Event`: `NewProductAddedEvent`, `ProductRemovedEvent`, `LogoutEvent` — file `x_realtime_event.dart` per domain |

### Tests

| Item | Standard |
|------|----------|
| File | `product_list_cubit_test.dart` |
| Group | `group('ProductListCubit', ...)` |
| Test name | `'emits [loading, success] when fetch succeeds'` — behaviour, not method name |
| Mock | `class MockProductsRepository extends Mock implements ProductsRepository {}` |
| Fixture | `test/fixtures/product_list_response.json`; loader `fixture('product_list_response.json')` |

## Recommended implementation

Add to `analysis_options.yaml`: `file_names`, `camel_case_types`, `non_constant_identifier_names`, `constant_identifier_names` (all in `flutter_lints` core; keep enabled).

## Examples

Good: `product_list_cubit.dart` / `ProductListCubit` / `ProductListState` / `product_list_state.freezed.dart`.

Bad: `fetch_gifcubit_cubit.dart` containing `FetchGifCubit`; `webview_page.dart` containing `WebViewScreen`; `model_reset_edication_...` (typo).

## Anti-patterns

- Prefixing widgets with `My`/`Custom` (tells nothing).
- Naming the state after a field instead of the owner (`LastMessageState`).
- Endpoint constants duplicated under two names.
- Per-feature copies of the global `Status` enum.

## Exceptions

Renames of existing public names are out of scope for feature PRs; schedule hygiene PRs (track them in `docs/project/flutter/remediation-backlog.md`).
