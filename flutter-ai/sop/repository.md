# SOP: Repository

## Purpose

Define what a repository is responsible for, so that Cubits never know where data comes from and data sources never know who asked.

## Scope

Repository interfaces, implementations, data sources, caching, mapping, error translation, use cases.

## Principles

1. The repository is the **only** door from application logic to data.
2. It returns **domain-ready values** (`Either<Failure, T>`), never raw JSON, never exceptions.
3. It coordinates sources; it does not render, navigate, or know about widgets.
4. Interfaces exist to be mocked and to allow a second implementation — nothing more.

## Standard

### Contract (UNIVERSAL, HIGH)

```dart
abstract class OrbitsRepository {
  Future<Either<Failure, OrbitListEntity>> fetchOrbitList({required OrbitListReqModel req});
  Future<Either<Failure, Unit>> leaveOrbit({required String orbitID});
}
```

- Interface in the domain/application layer; implementation in data.
- Every method returns `Future<Either<Failure, T>>` (or `Stream<T>` for live data). `Unit` for void.
- Named parameters for more than one argument.
- Group by aggregate (orbits, chat, auth), not by screen. One repository per aggregate; check existing ones before adding.

### Responsibilities (UNIVERSAL)

| Does | Does not |
|------|----------|
| Build `ApiRequest`s, call the gateway | Import Flutter (`BuildContext`, widgets, `Navigator`, overlays) |
| Parse JSON into models (in isolate if large) | Hold UI state or presentation models |
| Coordinate remote + local sources, decide cache policy | Decide what to show the user |
| Translate storage/parse errors to `Failure` | Log business events to analytics |
| Emit domain events after successful mutations (OPTIONAL, reference uses `GlobalEventBus`) | Call other repositories' implementations directly (inject the interface if needed) |

### Data sources (OPTIONAL, HIGH)

Introduce `XRemoteDataSource` / `XLocalDataSource` **only** when the repository coordinates 2+ sources. A single-source repository calls the gateway directly (reference: 18 of 20 repositories). The chat repository (remote + Hive cache + socket) is the correct use.

### Caching (OPTIONAL)

- Cache policy lives in the repository (`fetch(forceRefresh: false)`), not in the Cubit.
- Cache keys are versioned (`chat_messages_cache_v1_<id>` in reference — good).
- Encrypt cached sensitive content (reference: chat bodies).

### Use cases (OPTIONAL)

Add a use case class when logic spans 2+ repositories/services or is reused by 2+ Cubits. Otherwise the Cubit calls the repository. Do not create pass-through use cases.

### Dependencies (UNIVERSAL)

Constructor-injected: gateway, data sources, session provider, config. No service locator inside. No platform SDK that belongs to another concern (reference: `OrbitsRepositoryImpl` depends on `FirebaseMessaging` only to fetch an FCM token — NEEDS-DECISION; prefer an injected `DeviceTokenProvider`).

### Model ownership (PROJECT-SPECIFIC for reference; see `models-and-data.md`)

Reference project uses API models throughout (no domain entities, ADR-0005). Repository interfaces therefore import `data/models`. Universally, if a domain entity layer exists, the interface returns entities and the impl maps.

## Recommended implementation

Reference template: `data/repositoryImpl/orbits_repository_impl.dart` (`UpdateUiMixin.backToUI` + `parseResponse`). Keep methods short: one request, one parser.

Test template:

```dart
final api = MockBaseApiService();
final repo = OrbitsRepositoryImpl(apiService: api, messaging: MockMessaging());
when(() => api.executeAPI(apiRequest: any(named: 'apiRequest')))
    .thenAnswer((_) async => right(fixtureJson('orbit_list.json')));
final result = await repo.fetchOrbitList(req: const OrbitListReqModel(...));
expect(result.isRight(), true);
```

## Examples

Good: `orbits_repository_impl.dart`, `chat_repository_impl.dart`.

Fix: `general_repository.dart` imports `presentation/.../agreement_content.dart` (move model to data); `contacts_repository_impl.dart:116` `UnimplementedError`.

## Anti-patterns

- Repository instantiated with `new` in a Cubit or widget.
- Repository showing a toast or loader.
- Repository returning `dynamic` or `Map<String, dynamic>`.
- One "GeneralRepository" that accumulates unrelated endpoints (reference: acceptable for static content; do not grow it).
- Data source for a single-source feature.

## Exceptions

Repositories may accept a `ProgressCallback` for uploads (presentation-adjacent but not UI). Repositories may expose `Stream<T>` from local DB watchers.
