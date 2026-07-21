# Phase 1 Architecture Decisions

## ADR-001 — Android-First Flutter Client

**Decision:** Generate only Android in Phase 1 while keeping portable Dart boundaries. **Rationale:** Phase 0 identifies Android as the supported initial platform; limiting generated platforms reduces unsupported configuration and testing. **Status:** Accepted, implementation blocked by missing Flutter SDK.

## ADR-002 — Material 3 Foundation

**Decision:** Use centralized Material 3 light/dark themes with system mode. **Rationale:** It supplies accessible platform-consistent primitives without prematurely fixing final branding. **Status:** Accepted, implementation pending mobile generation.

## ADR-003 — Layered Foundation, Feature-First from Phase 2

**Decision:** Phase 1 will contain app-wide configuration, networking, errors, routing, and shared foundation widgets. User-facing capabilities will be grouped by feature beginning in Phase 2. **Rationale:** There are no business features in Phase 1, so empty feature folders would be misleading; feature ownership becomes useful with real screens and workflows.

## ADR-004 — Riverpod at the Composition Boundary

**Decision:** Initialize `ProviderScope` and use Riverpod for configuration/service injection. **Rationale:** It provides testable dependency replacement and lifecycle management without service locators or global mutable state. Business providers are deferred.

## ADR-005 — Declarative Routing with `go_router`

**Decision:** Use `MaterialApp.router` and `go_router` for `/`, `/error`, and not-found handling. **Rationale:** It gives one navigation/error boundary that can expand into feature routes in Phase 2.

## ADR-006 — Isolated Dio Networking

**Decision:** Only `core/network` may depend on Dio; higher layers consume typed services and results. **Rationale:** It prevents transport exceptions from leaking into UI and permits deterministic substitution in tests.

## ADR-007 — Versioned FastAPI Routes

**Decision:** Mount public API routes at the configurable `/api/v1` prefix. **Rationale:** Mobile releases may outlive backend changes; an explicit contract boundary allows later compatibility management.

## ADR-008 — Centralized Environment Configuration

**Decision:** Backend settings use `pydantic-settings`; future mobile settings use compile-time Dart definitions with safe development defaults. **Rationale:** Configuration is validated once, secrets stay outside source, and production failures occur early. Actual secret values are excluded.

## ADR-009 — Debug-Only Cleartext HTTP

**Decision:** Permit HTTP only in Android debug configuration for emulator/ADB-reverse development; production expects HTTPS. **Rationale:** Local TLS adds setup cost, but global cleartext weakens transport security. **Status:** Accepted, Android manifest pending genuine Flutter generation.

## ADR-010 — Database and Authentication Deferred

**Decision:** Do not add database, migrations, Supabase, or authentication in Phase 1. **Rationale:** This phase validates application composition and transport first, avoiding irreversible schema/security choices before their dedicated design and tests.

## ADR-011 — Import-Safe FastAPI Factory

**Decision:** Export both `create_app(settings)` and `app`, with no Uvicorn startup during import. **Rationale:** Tests can inject deterministic settings, ASGI servers can import the application normally, and module imports have no network/process side effects.

