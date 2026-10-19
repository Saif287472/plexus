# Plexus — Roadmap

## Phase 1 — Persistent 1:1 on LAN (Foundation)

**Goal**: A stable, encrypted, persistent 1:1 messenger over Wi-Fi LAN with multi-transport discovery.

### Deliverables
- Repo scaffold: workspace, `plexus_app`, all 7 pure-Dart packages, CI gate.
- Encrypted local database (drift + SQLCipher) with schema v1 and migration runner.
- Install-scoped X25519 identity, fingerprint, QR share/scan.
- Trust establishment (QR or verification phrase), persistent trust records.
- Peer discovery: mDNS + UDP broadcast over Wi-Fi LAN.
- Direct TCP/TLS connection with certificate pinning to peer fingerprint.
- 1:1 encrypted messaging (Double Ratchet), persisted to DB.
- Delivery receipts, read receipts.
- Conversation list, chat screen, message composer.
- App lock (biometric + PIN), auto-lock timeout.
- Settings: profile, security, appearance, transport preferences.
- Panic wipe (destroys identity + DB).
- Local backup export / import (encrypted file).
- Tests: 90%+ coverage on domain + data layers; clean analyze.

**Exit criteria**: Two phones on the same Wi-Fi can send persistent messages that survive app restarts, with trust established via QR.

---

## Phase 2 — Multi-Transport & Mesh (Connectivity)

**Goal**: Messages move across any available transport and across multiple hops.

### Deliverables
- Transport abstraction with adapters: Wi-Fi, BLE, cellular (direct IP), USB, direct-IP manual.
- Transport manager: selects best transport per peer by link quality, latency, cost.
- BLE discovery and connection (Android + iOS).
- Peer registry normalizes mDNS, BLE, DNS-SD, direct IP into one view.
- Mesh layer: neighbor table, link quality tracking, route computation (BFS/Dijkstra).
- Store-and-forward queue: pending messages persist in DB, retry when path appears.
- Multi-hop delivery: max 3 hops, TTL per message, hop count in frame.
- Delivery receipts flow back along the reverse path.
- Connectivity banner showing available transports and mesh status.
- Resilience: no crashes on Wi-Fi off/on, Bluetooth toggle, airplane mode.

**Exit criteria**: Phone A sends a message to Phone C through Phone B (2-hop mesh) over mixed transports (Wi-Fi + BLE), with no direct A↔C path.

---

## Phase 3 — Optional Rendezvous & Groups (Reach)

**Goal**: Cross-network introduction and group chat.

### Deliverables
- Optional rendezvous relay configuration (URL + token, manual entry).
- Rendezvous introduces peers across NAT; server sees only encrypted frames and opaque IDs.
- Group chat: group creation, members, admin/role model, group messages.
- Group trust: members verify each other's fingerprints.
- File transfer: select file, stream encrypted chunks, recipient stores to encrypted DB.
- Ephemeral media: in-app audio/video player for received media.
- Diagnostics screen: session, network, transport health.
- Windows/macOS desktop support as peers (not primary target).

**Exit criteria**: Two users on different networks connect via rendezvous and exchange messages; a 3-person group chat works over LAN.

---

## Phase 4 — Calls & Polish (Rich Media)

**Goal**: Voice/video calls and refined UX.

### Deliverables
- WebRTC voice/video calls over LAN mesh (DTLS-SRTP).
- Call screen, incoming call overlay, call history.
- Contact-style display names (phone-book name → nickname → number → ~Plexus name).
- Search for people in Chats and Calls tabs.
- Home: three swipeable tabs — Chats, Calls, Settings.
- Screenshot allowed everywhere (no FLAG_SECURE).
- Light theme only; colors from design tokens.
- Accessibility: tooltips on all IconButtons, 48px tap targets.

**Exit criteria**: Encrypted 1:1 video call between two mesh peers; polished UX matching modern messenger expectations.

---

## Phase 5 — Expansion (Enterprise Readiness)

**Goal**: Enterprise deployability and advanced features.

### Deliverables
- MDM / app-config support for managed devices.
- Remote wipe trigger (optional, via rendezvous or SMS-like local trigger).
- Audit log export for compliance.
- Configurable retention policies (message auto-delete, file chunk purge).
- Auto-update mechanism (optional, via rendezvous or manual).
- Dark theme toggle (optional, if product decides).
- Accessibility screening (screen reader labels, high contrast).

**Exit criteria**: Plexus passes an internal security review and is deployable in a managed corporate environment.

---

## Release cadence

- Phase 1: Alpha (internal dogfooding)
- Phase 2: Beta (limited external)
- Phase 3: v1.0 (public release)
- Phase 4-5: v1.x / v2.0

Each phase has its own ADR if it changes the target architecture (sections 3-6 of ARCHITECTURE.md), plus a user-approved changelog entry.
