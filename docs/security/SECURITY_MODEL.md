# Plexus — Security Model

## 1. Trust assumptions

- The local network (Wi-Fi, Bluetooth, cellular) is assumed hostile: sniffing and packet injection are active threats.
- Nearby devices are untrusted until authenticated via out-of-band fingerprint exchange.
- The device itself is the trust root. If an adversary has physical access and can unlock the app, all local data is at risk — this is mitigated by biometric + PIN app lock and encrypted at-rest storage.
- Mesh relay peers are untrusted: they forward encrypted blobs but never see message content or plaintext identities.

## 2. Cryptographic design

| Component | Algorithm | Purpose |
|-----------|-----------|---------|
| Identity keypair | X25519 | Install-scoped, generated on first launch |
| Handshake | X3DH (X25519) | Session establishment between two peers |
| Message encryption | AES-256-GCM or ChaCha20-Poly1305 | Per-message symmetric encryption (Double Ratchet) |
| Key derivation | HKDF-SHA256 | Derive message keys from root key |
| At-rest key wrapping | Argon2id + HKDF | Derive DB encryption key from device ID + unlock secret |
| Fingerprint | SHA-256 | Peer identity fingerprint, displayed as hex or QR |
| Secure random | `cryptography` package CSPRNG | Nonces, salts, key material |

- **No external crypto review** — the crypto is custom-built and documented as such. This is recorded in `docs/security/CRYPTO_REVIEW_STATUS.md`.
- The password/PIN never leaves the device. Only derived keys are used internally.
- Sessions are minted only by the identity module (single mint point, architecture-tested).
- Revoked peers/devices get nothing: trust records can be revoked; messages to revoked peers fail encryption.

## 3. Identity lifecycle

1. **First launch**: generate X25519 identity keypair. Private key is encrypted at rest with a key derived from `device_id + unlock_secret`.
2. **Fingerprint**: SHA-256 of the public key, displayed as a QR code and hex string.
3. **Trust establishment**: peer A scans peer B's QR (or enters verification phrase). A stores B's fingerprint as `trusted`. B does the same on acceptance.
4. **Rotation**: wiping the app or resetting the profile destroys all keys and trust records. New identity = new fingerprint.
5. **Revocation**: a peer can be blocked/revoked. Their messages are not decrypted; their trust record is marked `revoked`.

## 4. Local data security

- SQLite database is SQLCipher-encrypted. The DB key never appears in logs.
- Message payloads are encrypted before they touch the database.
- Private keys never leave the secure store (flutter_secure_storage wrapping Android Keystore / Windows DPAPI / macOS Keychain).
- File chunks on disk are encrypted per-transfer.
- Audit logs are redacted (no phone numbers, no message content, no keys) and cleared on app close / wipe.

## 5. App lock

- Biometric (fingerprint/face) + PIN fallback.
- Lock screen gates all routes except setup/onboarding.
- Auto-lock timeout configurable (30s, 1min, 5min, 15min, never).
- Panic wipe: destroys identity keys, trust records, and database. Irreversible. Triggered via hidden tap sequence in Settings → Advanced.

## 6. Network security

- All transport channels use TLS with certificate pinning to the peer's static fingerprint.
- Mesh intermediate peers see only routing headers (next hop, TTL, hop count) and encrypted payload blobs.
- Rendezvous server (optional) sees only opaque peer IDs and encrypted frames. Never message content.
- No server-side message storage. No cloud push tokens tied to identities.

## 7. What Plexus does NOT protect against

- Physical device compromise where the adversary knows the unlock secret.
- Malware running on the same device with access to app storage.
- Coercion to reveal the backup password or unlock PIN.
- Metadata analysis by a global passive adversary (mesh topology may be observable to ISPs if cellular is used).

## 8. Security invariants (architecture-tested)

- No plaintext message content is ever written to disk or sent over any transport.
- Private keys never leave the device; only derived auth material is used internally.
- Messages are encrypted to the recipient's active devices using their current trust fingerprint.
- A revoked peer cannot decrypt new messages.
- The rendezvous server (if configured) cannot link encrypted frames to real identities without the fingerprint.
