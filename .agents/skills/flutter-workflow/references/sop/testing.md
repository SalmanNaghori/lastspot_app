# SOP: Testing

Applicability: read `../REPOSEED.md`. Package APIs and helper names below are examples conditional on this app's recorded choices; do not adopt a reference-app package or class by copying an example.


## Purpose

Tests exist to make change safe. This SOP defines the minimum that must exist for a change to be considered done, what is worth testing beyond that, and how tests are written so they stay cheap.

## Scope

Unit, Bloc/Cubit, repository, widget, integration, golden tests; naming, structure, mocks, fixtures.

## Principles

1. **Test behaviour at boundaries**: what a Cubit emits, what a repository returns, what a widget shows.
2. **Mock only what you own or what crosses a boundary** (repository interface, gateway). Don't mock models.
3. **Tests are code**: same naming, formatting and review rules.
4. **No test is worse than a flaky test**, and a flaky test is worse than no test.

## Standard

### Minimum required (UNIVERSAL, HIGH)

| Change | Required tests |
|--------|----------------|
| New or modified Cubit/Bloc | success path, failure path, no-internet path (if applicable), pagination/refresh rules, `isClosed` safety where async |
| New or modified repository | each method: success parse, gateway failure pass-through, parse failure → `Failure` |
| New or modified shared widget (design system) | widget test: renders, callbacks fire, states (disabled/loading) |
| New model with custom JSON handling | `fromJson`/`toJson` round-trip against a fixture |
| New route | widget/integration test that the route builds with args |
| Bug fix | a regression test reproducing the bug |

Projects with no or few tests apply the standard to all new and modified code from now on; backfill is tracked in `docs/project/flutter/remediation-backlog.md` (TEST-22).

### Should test (RECOMMENDED)

- Use cases and policies (pure logic — cheapest tests).
- Error mapper (`DioException` → `Failure` table).
- Interceptors (auth header attached only when `requiresAuth`; 401 triggers logout).
- Reducers (realtime merge logic).
- Critical screens: one widget test per state (loading/error/empty/content).

### Usually not worth testing (UNIVERSAL)

- Generated code.
- Simple `copyWith`/freezed equality.
- Pure layout widgets with no logic or state.
- DI registration (covered by a single boot smoke test).

### Stack (RECOMMENDED; record in PR-H1 / ND-9)

| Need | Package |
|------|---------|
| Bloc/Cubit | `bloc_test` |
| Mocks | `mocktail` (no codegen) |
| Widgets | `flutter_test` |
| Golden | `golden_toolkit` or `alchemist` (OPTIONAL) |
| Integration | `integration_test` (SDK) |

### Structure and naming (UNIVERSAL)

```text
test/
  fixtures/                     real API JSON, named <endpoint>_response.json
  helpers/                      fixture loader, pump helpers, mock classes
  <mirror of lib path>/<file>_test.dart
```

- `group('<ClassName>')` → nested `group('<method>')` → `test('<behaviour>')`.
- Test names describe behaviour: `'emits [loading, failure] when repository returns Failure'`.
- Mocks: `class MockProductsRepository extends Mock implements ProductsRepository {}`; register fallback values in `setUpAll`.
- Fixtures loaded once per group; never inline 200-line JSON.

### Bloc/Cubit test template (UNIVERSAL)

```dart
void main() {
  late MockProductsRepository repo;
  late MockNetworkMonitor monitor;

  setUp(() {
    repo = MockProductsRepository();
    monitor = MockNetworkMonitor();
    when(() => monitor.onStatusChange).thenAnswer((_) => const Stream.empty());
  });

  group('ProductListCubit', () {
    blocTest<ProductListCubit, ProductListState>(
      'emits [loading, success] with hasMore=false when all records received',
      build: () {
        when(() => repo.fetchProductCategories()).thenAnswer((_) async => right(['A']));
        when(() => repo.fetchProductList(req: any(named: 'req')))
            .thenAnswer((_) async => right(ProductListEntity(records: twoProducts, total: 2)));
        return ProductListCubit(repository: repo, bus: GlobalEventBus(), networkMonitor: monitor);
      },
      seed: () => const ProductListState(lat: 1, lng: 1),
      act: (c) => c.fetchProducts(),
      expect: () => [
        isA<ProductListState>().having((s) => s.status, 'status', Status.loading),
        isA<ProductListState>()
            .having((s) => s.status, 'status', Status.success)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );
  });
}
```

### Repository test template (UNIVERSAL)

Mock the gateway (PR-D1 type), return fixture JSON, assert parsed model; return `left(Failure)`, assert pass-through; return malformed JSON, assert `Failure(kind: parse)`.

### Widget tests (UNIVERSAL)

Wrap with `MaterialApp` + `BlocProvider.value(value: mockCubit)`; stub `state` and `stream` (`whenListen` from `bloc_test`). Assert by semantics/text/keys, not by widget tree depth.

Accessibility checks for shared widgets: `meetsGuideline(...)` (see `accessibility.md`).

### Integration tests (UNIVERSAL for critical journeys — TEST-20; OPTIONAL elsewhere)

- List the critical journeys in `docs/project/flutter/project-rules.md` §H (e.g. sign-in → home, checkout, send message). Each has one `integration_test/<journey>_test.dart`.
- Package: `integration_test` (SDK). Use `patrol` only if native dialogs (permissions, notifications) must be driven — record it (DEP-1).
- Backend: a deterministic fake (local mock server or DI overrides at the composition root) for CI; staging only for a nightly smoke run.
- Find widgets by `Key`/semantics label, never by text that changes with locale.
- Run on CI (emulator/simulator or device farm) before every release build (`ci-cd.md`, REL-5).

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('sign in lands on home', (tester) async {
    await app.main(overrides: TestOverrides.fakeBackend());
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('signIn.email')), 'user@example.com');
    await tester.enterText(find.byKey(const Key('signIn.password')), 'secret');
    await tester.tap(find.byKey(const Key('signIn.submit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home.screen')), findsOneWidget);
  });
}
```

### Golden tests (OPTIONAL — TEST-21)

- Design-system components and key screens' visual states (light/dark, 1.0×/2.0× text scale).
- Pin fonts (load the real font files in `flutter_test_config.dart`) and surface size; generate goldens on one OS (CI's) to avoid pixel drift.
- Update goldens with `flutter test --update-goldens` only in a dedicated commit whose image diffs are reviewed.

## Recommended implementation

- CI runs `flutter analyze` and `flutter test --coverage`; coverage gate on **changed files** (e.g. ≥ 70 %), not the whole repo, so legacy code does not block.
- `test/helpers/test_di.dart` builds Cubits with mocks — never the real container.

## Examples

Backfill order for a legacy app: the most-used list state holder, the auth flow, the most-used repository, the error mapper, the auth interceptor.

## Anti-patterns

- Testing implementation details (`verify(repo.fetch()).called(1)` as the only assertion).
- Sleeping in tests (`await Future.delayed`) instead of `pump`/`pumpAndSettle`/fake async.
- Sharing mutable mocks across tests without `setUp`.
- Skipping tests "because the project has none".

## Exceptions

Spike branches (`spike/*`) may omit tests; they are not merged.
