# Plexus — Product Vision

## 1. One-line description

Plexus is a mobile-first, offline-capable, encrypted mesh messenger that works without any central server or internet dependency, while optionally using any available network transport — Wi-Fi, Bluetooth, cellular, USB, or an optional rendezvous relay — to move messages between peers across multiple hops.

## 2. Core principles

| Principle | Meaning |
|-----------|---------|
| **Offline-first** | The app must be fully functional with no internet connection. All data is stored locally and encrypted at rest. |
| **Persistent** | Messages, media, files, trust records, and group metadata survive app restarts and device reboots. Nothing is RAM-only. |
| **Multi-transport** | The app discovers and connects over any network interface the OS exposes: Wi-Fi LAN, Wi-Fi Direct, Bluetooth/BLE, cellular data, USB tethering, and direct IP. |
| **Multi-hop mesh** | If peer A cannot reach peer C directly, messages are store-and-forwarded through intermediate peer B. Routing is automatic and encrypted end-to-end. |
| **Optional rendezvous** | A lightweight rendezvous/relay service can introduce peers across NAT or the internet, but it is never required. Plexus works without it. |
| **Mobile-first** | Designed for phones first (Android, iOS). Desktop (Windows, macOS, Linux) is a supported peer, not the primary target. |
| **Zero central dependency** | No account server, no phone-number registry, no cloud push. Identity is local and install-scoped. |
| **Enterprise-grade code** | Clean architecture, strict module boundaries, full test coverage, typed errors, observable state, and documented invariants. |

## 3. Out of scope (explicitly)

- No connection to Helix Remote, Helix Local, or Orbit. Separate brand, separate repo, separate infrastructure.
- No cloud backup or sync service (users can export encrypted backups locally).
- No contact-request / social-graph model (WhatsApp-style: anyone can message anyone who hasn't blocked them).
- No real-time group capacity targets (groups exist, but scale is not a Phase 1 concern).
- No server-side message storage.

## 4. Primary user journeys

1. **First launch** — generate install-scoped identity keypair, set display name, optionally set a local unlock secret (biometric + PIN).
2. **Discover nearby peers** — mDNS/BLE/direct-IP scan shows available devices on any active transport.
3. **Establish trust** — scan a peer's QR code or exchange a verification phrase; fingerprint is stored persistently.
4. **Send a message** — if the peer is online and reachable, deliver immediately. If not, store locally and forward when a path appears (multi-hop).
5. **Receive a message** — decrypt locally, store in the encrypted database, show in the conversation list.
6. **Share a file** — select file, stream encrypted chunks over the best available transport, recipient stores to encrypted local storage.
7. **Export data** — produce an encrypted local backup file; restore from it on reinstall or device move.

## 5. Success metrics (Phase 1)

- App launches and is usable with zero network interfaces active.
- 1:1 encrypted messages persist across app restarts.
- Messages route across one intermediate peer (2-hop) without user configuration.
- App analyzes clean, tests pass at 90%+ line coverage on domain/data layers.
- No crashes on transport suspend/resume (Wi-Fi off/on, Bluetooth toggle, airplane mode).
