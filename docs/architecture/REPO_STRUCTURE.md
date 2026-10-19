# Plexus — Repository Structure

Plexus lives entirely outside the Helix repo. It is its own Dart/Flutter workspace with no root `pubspec.yaml` at the Helix level.

```
J:/projects/plexus/
├── plexus_app/                 # Flutter application (mobile-first)
│   ├── pubspec.yaml
│   ├── analysis_options.yaml   # Strict lint rules
│   ├── lib/
│   │   ├── main.dart           # Zone setup, error reporting, router init
│   │   ├── app.dart            # MaterialApp, providers scope, theme
│   │   ├── core/
│   │   │   ├── di/             # Dependency injection container (container + modules)
│   │   │   ├── networking/     # Transport abstractions, transport manager
│   │   │   ├── storage/        # Database provider, migration runner, encryption
│   │   │   ├── security/       # Crypto helpers, identity manager, trust manager
│   │   │   ├── ui/             # Design system (theme, tokens, components)
│   │   │   │   ├── theme/
│   │   │   │   ├── tokens/
│   │   │   │   └── components/
│   │   │   ├── utils/          # Extensions, helpers, constants
│   │   │   └── platform/       # Platform channels, biometrics, tray, foreground
│   │   ├── features/           # Feature modules (vertical slices)
│   │   │   ├── onboarding/     # Setup, identity creation, trust intro
│   │   │   ├── auth/           # Local unlock (biometric + PIN)
│   │   │   ├── mesh/           # Peer discovery, mesh status, transport UI
│   │   │   ├── chat/           # Conversations, messages, message composer
│   │   │   ├── calls/          # Voice/video call screens
│   │   │   ├── files/          # File transfer, media gallery
│   │   │   ├── groups/         # Group chats, members, announcements
│   │   │   └── settings/       # Profile, security, appearance, advanced
│   │   ├── shared/             # Cross-feature widgets, localizations
│   │   │   ├── widgets/
│   │   │   ├── l10n/
│   │   │   └── routing/        # go_router configuration, route guards
│   │   └── generated/          # Codegen output (drift, freezed, json)
│   ├── test/
│   │   ├── unit/               # Unit tests for providers, use cases
│   │   ├── widget/             # Widget tests
│   │   └── integration/        # Integration tests (app-level flows)
│   ├── android/, ios/, windows/, macos/, linux/
│   └── assets/                 # Images, sounds, wordlists, fonts
│
├── packages/                   # Pure Dart packages (no Flutter)
│   ├── plexus_core/            # Domain: entities, value objects, repository interfaces
│   ├── plexus_storage/         # Data: encrypted SQLite (drift + SQLCipher), repositories
│   ├── plexus_transport/       # Data: transport adapters, transport gateway impls
│   ├── plexus_mesh/            # Mesh: neighbor table, routing, store-and-forward queue
│   ├── plexus_crypto/          # Crypto: handshake, ratchet, identity keys, encryption
│   ├── plexus_protocol/        # Protocol: wire frames, envelopes, codecs, versioning
│   ├── plexus_discovery/       # Discovery: mDNS, BLE, DNS-SD, direct IP peer registry
│   └── plexus_ui/              # Presentation: shared design system, components, theme tokens
│
├── docs/
│   ├── architecture/
│   ├── product/
│   ├── security/
│   ├── protocol/
│   ├── operations/
│   └── adr/                    # Architecture Decision Records
│
├── tool/                       # Dart admin/scripts: codegen, checks, fixtures
│   ├── codegen.dart
│   ├── check_boundaries.dart
│   └── check_secrets.dart
│
├── scripts/                    # Shell/PowerShell: verify, coverage, CI
│   ├── verify.ps1
│   ├── verify.sh
│   └── coverage.sh
│
├── deploy/                     # Deployment scripts, CI configs
│   └── ci.yml
│
├── CHANGELOG.md
├── LICENSE
├── README.md
└── .gitignore
```

## Package dependency rules

- `plexus_core` imports only `meta` and `crypto` (pure Dart).
- `plexus_protocol` imports `plexus_core` + `cbor` + `uuid` + `convert`.
- `plexus_crypto` imports `plexus_core` + `cryptography` + `pointycastle` + `basic_utils`.
- `plexus_storage` imports `plexus_core` + `drift` + `sqlite3_flutter_libs` + `path_provider`.
- `plexus_transport` imports `plexus_core` + platform socket/ble packages.
- `plexus_mesh` imports `plexus_core` + `plexus_transport` + `plexus_discovery`.
- `plexus_discovery` imports `plexus_core` + `mdns` + `flutter_blue_plus` (abstracted).
- `plexus_ui` imports `plexus_core` + `flutter` + `flutter_riverpod`.
- `plexus_app` imports all packages + `flutter_riverpod` + `go_router`.

No package may import `plexus_app`. `plexus_app` is the leaf consumer.

## Module boundaries (enforced by test)

Each package has `test/architecture_test.dart` using `helix_remote_architecture_rules`-style helpers (adapted for Plexus). Rules:
- Domain packages may not import Flutter, drift, or transport packages.
- Application layer may not import presentation widgets.
- Data layer may import domain + its own transport/crypto deps only.
- A new package must be added to the dependency manifest (`v2PackageDependencies` equivalent) in the same change.

## Code generation

- drift: `dart run build_runner build` in `plexus_storage`; generated code committed.
- freezed + json_serializable: domain entities and DTOs.
- flutter_launcher_icons: app icons per platform.
- `dart format --set-exact-if-changed` on changed files only.
