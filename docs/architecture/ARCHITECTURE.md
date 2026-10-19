# Plexus — Architecture

## 1. Architectural style

Clean Architecture + Layered Modular Monolith.

- **Domain layer** is pure Dart, knows nothing about Flutter, database, or network.
- **Application layer** contains use cases, orchestrates domain + data, knows nothing about UI.
- **Data layer** implements repositories, database, encryption, transport adapters.
- **Presentation layer** is Flutter widgets + Riverpod providers + go_router navigation.
- **Platform layer** isolates OS-specific code (Bluetooth, biometrics, tray, foreground services).

The codebase is a modular monolith: one repo, one workspace, but strictly bounded packages. A new feature adds a package or a feature module inside `app/lib/features/`; it does not reach across module boundaries.

## 2. Layer responsibilities

### Domain (`plexus_core` package)
- Entities: `Peer`, `Identity`, `Message`, `Conversation`, `TrustRecord`, `FileTransfer`, `Group`, `CallSession`
- Value objects: `PeerId`, `DeviceId`, `Fingerprint`, `MessageId`, `TransportType`, `DeliveryStatus`
- Domain events: `MessageSent`, `MessageReceived`, `PeerDiscovered`, `TrustEstablished`, `TransportStateChanged`
- Repository interfaces (ports): `PeerRepository`, `MessageRepository`, `TrustRepository`, `TransportGateway`, `StorageGateway`
- Pure business rules: trust validation, message deduplication, routing eligibility, retention policy

### Application (`app/lib/application/`)
- Use cases: `SendMessageUseCase`, `DiscoverPeersUseCase`, `EstablishTrustUseCase`, `RouteMessageUseCase`, `ExportBackupUseCase`
- Application services: `SessionService`, `RoutingService`, `SyncService`, `WipeService`
- Knows about repository interfaces and domain events; does not import Flutter widgets

### Data (`plexus_storage`, `plexus_transport`, `plexus_crypto`, `plexus_discovery`, `plexus_mesh`)
- Repository implementations backed by encrypted SQLite (drift + SQLCipher)
- Transport adapters: `WifiTransportAdapter`, `BleTransportAdapter`, `CellularTransportAdapter`, `UsbTransportAdapter`, `DirectIpTransportAdapter`
- Mesh: neighbor table, route computation, store-and-forward queue, hop-limit TTL
- Crypto: X3DH-style handshake, Double Ratchet, encrypted at-rest storage, identity key derivation
- Protocol: CBOR wire frames, envelope encoding, codec, versioning

### Presentation (`app/lib/features/`, `app/lib/core/ui/`)
- Riverpod providers for state (notifiers, async values)
- go_router for declarative navigation
- Feature modules: `auth`, `mesh`, `chat`, `calls`, `files`, `groups`, `settings`, `onboarding`
- Design system in `plexus_ui` package: tokens, components, themes

### Platform (`plexus_platform` + `app/lib/core/platform/`)
- Biometric unlock (local_auth)
- Bluetooth/BLE (flutter_blue_plus or similar)
- Windows tray / macOS menu bar
- Android foreground service
- Push notification channels (local only; no cloud push)

## 3. Dependency direction (strict)

```
presentation  -->  application  -->  domain
     ^             ^             ^
     |             |             |
 data/platform <-- adapters <-- interfaces (ports)
```

Rule: `domain` imports nothing external except `meta` and `crypto`. `application` imports `domain` only. `data` imports `domain` + `application` interfaces. `presentation` imports `application` + `domain`. No package may import another package's internals — only its public API barrel file.

## 4. State management

- **Riverpod** for all application state (providers, notifiers, autoDispose, family).
- UI reads from `AsyncValue` / `NotifierProvider`; never reads repositories directly.
- Navigation via `go_router` with typed routes and route guards (auth required, lock screen gate).

## 5. Error handling

- `Either<Failure, T>` from `dartz` (or custom `Result<T, E>`) across all layers.
- Failures are typed: `DatabaseFailure`, `TransportFailure`, `CryptoFailure`, `TrustFailure`, `ValidationFailure`, `NetworkFailure`.
- No uncaught exceptions cross layer boundaries. Presentation maps `Failure` to user-visible messages.

## 6. Database

- **drift** (formerly Moor) + **SQLCipher** for encrypted local storage.
- Schema is versioned with migrations (expand, migrate, contract pattern).
- All tables have `created_at`, `updated_at`, `deleted_at` (soft delete) for audit and recovery.
- WAL mode, busy timeout, foreign keys enforced.
- Local-only; no sync server. Backup/restore is an encrypted file export/import flow.

## 7. Transport & mesh

- `TransportGateway` interface with `send(bytes, peerId)`, `receiveStream()`, `isAvailable(peerId)`, `advertise()`.
- Discovery layer normalizes peers from mDNS, BLE, DNS-SD, direct IP into a single `PeerRegistry`.
- Mesh layer maintains a neighbor table, computes shortest paths (BFS/Dijkstra on link quality), and runs a store-and-forward queue with per-message TTL and hop count.
- All mesh traffic is end-to-end encrypted; intermediate hops cannot read payloads.
