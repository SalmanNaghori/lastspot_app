> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0005: Dio behind BaseApiService returning Either<Failure, T>; single model layer

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** UNIVERSAL (single gateway, Either boundary), PROJECT-SPECIFIC (`UpdateUiMixin`, offline queue, no DTO/entity split)

## Context

~20 repositories talk to one REST backend plus a few public APIs (Google Places, Tenor, stickers). Offline behaviour matters (chat). JSON payloads can be large.

## Problem

How do repositories call the network, represent failure, and shape models?

## Decision

- All HTTP goes through `BaseApiService.executeAPI(ApiRequest) → Future<Either<Failure, dynamic>>`, implemented by `NetworkAPIImpl` over Dio with interceptors `AuthInterceptor → AuthFailureInterceptor → RetryInterceptor → PrettyDioLogger(kDebugMode)`.
- `ApiRequest` is the only way to describe a call (url, method, query, body, `requiresAuth`, `allowQueued`, `apiType`, progress).
- Repositories wrap calls in `UpdateUiMixin.backToUI<T>()` and parse with `parseResponse(json, T.fromJson)`; payloads > 50 keys parse in an isolate via `compute`.
- Failure is a single `Failure(error, statusCode)`; Dio errors map via `DioErrorMapper`.
- Requests with `allowQueued: true` are queued offline in `NetworkRequestQueue` and replayed on reconnect.
- **One model layer**: API response models (`*Entity`) are used by domain interfaces and presentation. No separate DTO/entity/UI mapping unless a feature needs it (chat has `ChatMessageUIModel`).
- Serialization standard: `@freezed` + `json_serializable`. FlutterJsonBeanFactory output in `lib/generated/json/` is LEGACY and frozen.
- A remote data source exists only when a feature has more than one source (chat: remote + Hive cache).

## Evidence

- `core/network/client/*`, `core/network/utils/update_ui_mixin.dart`, `core/network/queue/*`, `dio_injection.dart:50-63`.
- `orbits_repository_impl.dart` (typical), `chat_repository_impl.dart` (multi-source).
- 49 freezed vs 23 FJBF vs 6 handwritten models.
- Reason for the no-DTO decision: **Not determinable from repository evidence**; consistent with "separate models only when it adds value".

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| Retrofit-style generated clients | Loses the `ApiRequest` queue/auth/queued flags without extra plumbing. |
| Throwing exceptions instead of `Either` | Forces try/catch in every cubit; `Either` makes failure explicit in the signature. |
| Separate DTO + domain entity + UI model for every feature | Triple boilerplate for a single backend the app controls; not justified. |

## Consequences

- Positive: uniform error flow, offline replay, isolate parsing, testable repos via a single mocked interface.
- Negative: `Either<Failure, dynamic>` at the gateway is untyped until `backToUI`; single `Failure` type lacks kinds (auth/validation/network) beyond `statusCode`; 120s timeouts (ND-14).
- Rules: `sop/networking.md`, `sop/repository.md`, `sop/models-and-data.md`, `guardrails/networking.md`, `rules/networking.rules`.

## Migration

None required. FJBF models migrate opportunistically (ND-5).

## Review trigger

Introduction of a second backend or GraphQL; need for typed failure kinds in UI.
