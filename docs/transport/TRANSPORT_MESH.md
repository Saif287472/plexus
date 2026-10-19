# Plexus — Transport & Mesh Layer

## 1. Design goals

- Work with zero network interfaces (offline mode is the baseline).
- Use every transport the OS exposes: Wi-Fi LAN, Wi-Fi Direct, Bluetooth/BLE, cellular data, USB tethering, direct IP.
- Multi-hop mesh: if A cannot reach C directly, store-and-forward through B.
- End-to-end encryption at every hop; intermediate peers cannot read payloads.
- Optional rendezvous relay for NAT traversal / cross-network introduction — never required.

## 2. Transport abstraction (`plexus_transport`)

### `TransportGateway` interface (port)

```dart
abstract class TransportGateway {
  String get transportType; // 'wifi' | 'ble' | 'cellular' | 'usb' | 'direct_ip'
  Future<bool> isAvailable();
  Future<void> advertise(PeerAdvertisement adv);
  Stream<PeerDiscovered> discover();
  Future<TransportConnection> connect(PeerId peerId);
  Stream<InboundFrame> receiveStream();
  Future<Either<Failure, void>> send(PeerId peerId, Uint8List frame);
  Future<void> disconnect(PeerId peerId);
  Stream<TransportState> stateStream();
}
```

### Transport adapters

| Adapter | Package | Platform | Notes |
|---------|---------|----------|-------|
| `WifiTransportAdapter` | `plexus_transport` | Android, iOS, Windows, macOS, Linux | mDNS over UDP + TCP sockets |
| `BleTransportAdapter` | `plexus_transport` | Android, iOS | BLE advertising + GATT |
| `CellularTransportAdapter` | `plexus_transport` | Android, iOS | TCP over cellular data (direct IP) |
| `UsbTransportAdapter` | `plexus_transport` | Android, Windows | USB tethering / RNDIS |
| `DirectIpTransportAdapter` | `plexus_transport` | All | Manual IP:port entry; QR payload |

Each adapter implements `TransportGateway` and is registered in the DI container. The `TransportManager` selects the best available transport per peer based on link quality, latency, and cost.

## 3. Peer discovery (`plexus_discovery`)

Discovery sources normalize into a single `PeerRegistry`:

- **mDNS**: `_plexus._tcp.local` — advertises fingerprint, device suffix, supported capabilities (file, calls, mesh relay).
- **BLE**: advertising packet with truncated fingerprint + capability flags.
- **DNS-SD**: optional, on networks that support it.
- **Direct IP**: QR payload contains IP, port, fingerprint, one-time nonce.

Invariants:
- Discovery advertises session presence, not private identity material.
- Stale peers expire after a configurable TTL (default 5 minutes of silence).
- Off-grid operation must not depend on internet access.

## 4. Mesh routing (`plexus_mesh`)

### Neighbor table

Each tracked peer stores:
- `peerId`, `fingerprint`, `transportType`, `linkQuality` (0.0–1.0), `rttMs`, `lastSeen`, `isRelayCapable`.

### Route computation

- On send, if direct transport is available and healthy: use it (hop count = 0).
- If not, run BFS/Dijkstra over the neighbor table to find a path to the target.
- Max hop count: 3 (configurable). Messages exceeding TTL or hop limit are dropped and sender notified.

### Store-and-forward queue

- Undeliverable messages are persisted to the encrypted database with status `pending`.
- A background `MeshDeliveryService` retries pending messages when a path appears.
- Each message carries: `messageId`, `senderId`, `recipientId`, `payloadEnc`, `ttlSeconds`, `hopCount`, `maxHops`.
- Intermediate peers store-and-forward but cannot decrypt (E2EE). They see only routing headers: next hop, TTL, hop count.

### Delivery semantics

- At-least-once delivery with deduplication by `messageId`.
- Delivery receipts flow back along the reverse path.
- Read receipts are end-to-end (only recipient generates them).

## 5. Optional rendezvous

- A self-hostable or third-party rendezvous service introduces peers across NAT.
- Protocol: lightweight WebSocket or HTTPS long-poll; peers exchange rendezvous tokens via QR or manual entry.
- The rendezvous server sees only encrypted frames and opaque peer IDs. It never sees message content or plaintext identities.
- Plexus works fully without it. Rendezvous is configured manually in Settings → Advanced → Rendezvous (URL + token).

## 6. Transport state handling

- Wi-Fi off/on, Bluetooth toggle, airplane mode: `TransportManager` emits `TransportState` changes.
- UI reacts: connectivity banner shows available transports; mesh status shows direct vs relayed peers.
- Pending messages survive transport suspension; they resume automatically when connectivity returns.

## 7. Security on transport

- All transport channels are TLS (TCP) or DTLS-SRTP (UDP/calls) with certificate pinning to the peer's static fingerprint.
- BLE uses LE Secure Connections with just-works or passkey pairing.
- No plaintext ever crosses a transport.
