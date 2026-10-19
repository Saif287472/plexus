# Plexus — Development Standards

## 1. Code organization (enterprise-grade)

Every feature is a vertical slice under `app/lib/features/<feature>/`:

```
features/<feature>/
├── application/     # Riverpod providers, notifiers, use cases
├── domain/          # Feature-specific entities (if not in plexus_core)
├── data/            # Repositories, mappers, local datasources
└── presentation/    # Widgets, screens, dialogs, sheets
```

Cross-cutting concerns live in `app/lib/core/`:
- `di/` — dependency injection container (get_it or manual containers), DI modules per layer.
- `networking/` — transport manager, transport selection logic.
- `storage/` — database provider, migration runner, encryption helpers.
- `security/` — identity manager, trust manager, crypto helpers.
- `ui/` — design system: theme, tokens, components.
- `platform/` — biometrics, tray, foreground service, platform channels.

Shared UI components live in the `plexus_ui` package.

## 2. Dependency injection

- Use **get_it** for service location, or manual constructor injection via a `Container` class in `core/di/`.
- Each layer registers its own module: `DomainModule`, `ApplicationModule`, `DataModule`, `PresentationModule`, `PlatformModule`.
- App boot sequence: `main()` → zones → error reporting → `Container.setup()` → `runApp()`.
- No singleton service locators imported directly in domain or data layers.

## 3. State management

- **Riverpod** only. Providers, notifiers, `AutoDispose`, `Family`.
- UI reads from `AsyncValue<T>`; never from repositories directly.
- Loading, error, and data states are explicit: `AsyncLoading`, `AsyncError`, `AsyncData`.
- No `setState` in feature screens; all state flows through providers.

## 4. Navigation

- **go_router** with typed routes and route guards.
- Route guards: auth required (app lock), lock screen gate, onboarding gate.
- Deep linking supported for QR payloads and direct-IP invites.

## 5. Error handling

- `Either<Failure, T>` (dartz or custom `Result`) across domain, application, and data layers.
- Typed failures: `DatabaseFailure`, `TransportFailure`, `CryptoFailure`, `TrustFailure`, `ValidationFailure`, `NetworkFailure`, `UnknownFailure`.
- Presentation layer maps `Failure` → user-visible message via `HelixFeedback`-style helper (`PlexusFeedback`).
- No uncaught exceptions cross layer boundaries. Top-level error zone catches and reports.

## 6. Testing strategy

Target: 90%+ line coverage on domain and data layers.

| Layer | Test type | Tool |
|-------|-----------|------|
| Domain | Unit tests (pure logic) | `flutter_test` / `test` |
| Data | Unit tests + DB tests (in-memory SQLite) | `flutter_test` + `drift_test` |
| Application | Use case tests (mock repositories) | `flutter_test` + `mocktail` |
| Presentation | Widget tests | `flutter_test` |
| Integration | App-level flows (send message, discover peer) | `integration_test` |
| Architecture | Import-boundary tests | Custom `architecture_test.dart` per package |

Test naming: `<unit>_test.dart`. Test doubles use `mocktail`, not handwritten mocks.

## 7. Analysis & linting

- `flutter analyze` (whole workspace) must be clean.
- `dart analyze` on pure-Dart packages.
- Custom `analysis_options.yaml` with strict rules:
  - Avoid `print()`; use structured logger (`app_logger.dart` with redaction).
  - Avoid `Color(0x…)` / `Colors.x` in app UI; use theme tokens only.
  - Every `IconButton` has a `tooltip:`.
  - Tap targets ≥ 48 px.
  - No `TODO` left uncommitted without a ticket reference.
  - No `// ignore` comments without justification.

## 8. Formatting

- `dart format --set-exit-if-changed` on changed files only (not the whole repo blindly).
- Line length: 120.

## 9. Code generation

- drift schema + generated code committed in `plexus_storage/lib/generated/`.
- freezed + json_serializable for domain entities and wire DTOs.
- Regenerate with `dart run build_runner build --delete-conflicting-outputs`.
- CI runs `--check` to ensure generated code is committed.

## 10. Logging & redaction

- Structured logger in `app/core/services/app_logger.dart`.
- Never log: passwords, tokens, keys, message content, recovery codes, full phone numbers.
- Server logs (if any) go through the redacting logger; a test enforces it.

## 11. Security rules

- Never weaken authentication, encryption, signature checks, or trust decisions.
- New public route requires deliberate declaration with a rate-limit policy.
- Crypto changes need test vectors and a note in `docs/security/remote_cryptographic_design_review.md`.
- Modules import only another module's public API barrel file.

## 12. CI / verification gate

`scripts/verify.ps1` / `scripts/verify.sh` runs:
1. `flutter analyze` (whole workspace)
2. `dart analyze server tool` (pure-Dart packages)
3. Codegen check (`dart run tool/codegen.dart --check`)
4. Governance check (dependency rules, boundary rules)
5. Full test suite with coverage
6. Golden fixture check (protocol frames)

A PR cannot merge unless the gate passes.

## 13. Releases

- Version: SemVer in `pubspec.yaml` (`major.minor.patch+build`).
- Changelog: `CHANGELOG.md` following Keep a Changelog.
- Git tags for releases: `v1.0.0`, etc.
- No debug APKs built by agents; user builds and installs manually.
