# ADR-0007: Realtime Messaging via Supabase Realtime Channels

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

Chat (direct and activity group chat) and match participation updates require instant delivery to connected participants without polling the database.

## Problem

How should real-time message delivery and status updates be coordinated without introducing separate WebSocket servers?

## Decision

Use `Supabase.client.channel` Realtime postgres change subscriptions:
1. Subscriptions are created and managed exclusively in remote data sources (`ChatRemoteDataSourceImpl`, `SpotRemoteDataSourceImpl`).
2. Data sources expose standard Dart `Stream<T>` to repositories and use cases.
3. Presentation BLoCs/Cubits listen to streams and emit new states.
4. Channel lifecycle (subscribe / unsubscribe) is strictly tied to Cubit/Bloc initialization and disposal to prevent memory and connection leaks.

## Evidence

- `lib/features/chat/data/datasources/chat_remote_datasource.dart` (`streamMessages`, `subscribeToMessages`)
- `lib/features/spot/data/datasources/spot_remote_datasource.dart` (`streamSpotJoinRequests`)

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Custom WebSocket / Socket.io | Adds unnecessary infrastructure and hosting overhead when Supabase Realtime is native to PostgreSQL. |
| Periodic HTTP Polling | Wastes battery, bandwidth, and adds unacceptable latency to chat. |

## Consequences

- **Positive:** Leverages existing database RLS policies, native postgres event broadcasts.
- **Negative / Costs:** Requires careful stream disposal on screen exit.
- **Rules Enforced:** ASYNC-1, ASYNC-2.
