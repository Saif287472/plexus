# Plexus — Data Layer

## 1. Storage philosophy

Everything is persistent and encrypted at rest. Nothing is RAM-only.

- Messages, conversations, files, trust records, group metadata: stored in encrypted local SQLite.
- Drafts survive app restart (persisted).
- Media thumbnails and cached file chunks: stored in app-private encrypted directories.
- Audit log: redacted, persisted, rotated by size/time.
- Backups: user-initiated encrypted export to a file of their choosing; restore from that file.

## 2. Database engine

- **drift** (ORM/query builder) + **SQLCipher** (encrypted SQLite) via `sqlite3_flutter_libs`.
- Database password derived from the device-bound identity key + user unlock secret (biometric/PIN), using Argon2id + HKDF.
- Journal mode: WAL. Busy timeout: 5s. Foreign keys: ON.
- Schema version: starts at 1. Every schema change adds a numbered migration file; checksums recorded in `schema_migrations`.
- Never edit a migration that has run; always add a new one (expand, migrate, contract).

## 3. Core tables (Phase 1)

### `identities`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| device_id | TEXT UNIQUE | Stable device identifier |
| public_key | BLOB | Install-scoped identity public key |
| private_key_enc | BLOB | Encrypted private key (device-bound) |
| fingerprint | TEXT UNIQUE | SHA-256 of public key, hex |
| display_name | TEXT | User-chosen display name |
| created_at | INTEGER | Unix ms |
| updated_at | INTEGER | Unix ms |
| deleted_at | INTEGER | Soft delete |

### `peers` (known/ trusted peers)
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| peer_id | TEXT UNIQUE | Public key hash / fingerprint |
| display_name | TEXT | Phone-book name or nickname |
| trust_level | INTEGER | 0=unknown,1=trusted,2=blocked |
| fingerprint_verified | INTEGER | 0/1 |
| last_seen | INTEGER | Unix ms |
| created_at | INTEGER | |
| deleted_at | INTEGER | Soft delete |

### `conversations`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| type | TEXT | 'direct' or 'group' |
| peer_id | TEXT | Nullable for direct; FK to peers |
| group_id | TEXT | Nullable for group; FK to groups |
| last_message_at | INTEGER | Unix ms |
| unread_count | INTEGER | Default 0 |
| is_pinned | INTEGER | 0/1 |
| is_archived | INTEGER | 0/1 |
| created_at | INTEGER | |
| updated_at | INTEGER | |
| deleted_at | INTEGER | Soft delete |

### `messages`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| message_id | TEXT UNIQUE | Client-generated UUID |
| conversation_id | INTEGER FK | |
| sender_peer_id | TEXT | |
| recipient_peer_id | TEXT | |
| type | TEXT | 'text','file','media','system','reaction' |
| payload_enc | BLOB | Encrypted message body |
| status | TEXT | 'sending','sent','delivered','read','failed' |
| delivery_receipt | INTEGER | 0/1 |
| hop_count | INTEGER | 0 for direct; increments per mesh hop |
| ttl | INTEGER | Message time-to-live in seconds |
| created_at | INTEGER | Unix ms |
| delivered_at | INTEGER | Nullable |
| read_at | INTEGER | Nullable |
| deleted_at | INTEGER | Soft delete |

### `trust_records`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| peer_id | TEXT FK | |
| fingerprint | TEXT | |
| verification_method | TEXT | 'qr','phrase','manual' |
| verified_at | INTEGER | |
| revoked_at | INTEGER | Nullable |
| created_at | INTEGER | |

### `file_transfers`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| transfer_id | TEXT UNIQUE | |
| conversation_id | INTEGER FK | |
| file_name | TEXT | |
| file_size | INTEGER | |
| mime_type | TEXT | |
| local_path | TEXT | Encrypted app-private path |
| status | TEXT | 'pending','transferring','completed','failed','cancelled' |
| direction | TEXT | 'sent','received' |
| progress | REAL | 0.0–1.0 |
| created_at | INTEGER | |
| completed_at | INTEGER | Nullable |

### `groups`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| group_id | TEXT UNIQUE | |
| name | TEXT | |
| creator_peer_id | TEXT | |
| created_at | INTEGER | |
| updated_at | INTEGER | |
| deleted_at | INTEGER | Soft delete |

### `group_members`
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER PK | |
| group_id | TEXT FK | |
| peer_id | TEXT FK | |
| role | TEXT | 'admin','member' |
| joined_at | INTEGER | |
| left_at | INTEGER | Nullable |

### `schema_migrations`
| Column | Type | Notes |
|--------|------|-------|
| version | INTEGER PK | |
| checksum | TEXT | |
| applied_at | INTEGER | |

## 4. Encryption at rest

- Database file is SQLCipher-encrypted.
- Message payloads are encrypted with the session key (Double Ratchet) before storage.
- Private keys are encrypted with a key derived from: `Argon2id(device_id + unlock_secret) + HKDF`.
- File chunks on disk are encrypted per-transfer with a random content key wrapped by the recipient's public key.

## 5. Repository pattern

Each domain repository interface (in `plexus_core`) has one implementation (in `plexus_storage`):

```
PeerRepository         ->  SqlitePeerRepository
MessageRepository      ->  SqliteMessageRepository
TrustRepository        ->  SqliteTrustRepository
ConversationRepository ->  SqliteConversationRepository
FileTransferRepository ->  SqliteFileTransferRepository
```

Repositories return `Either<Failure, T>`. They never throw; they map SQL errors to typed failures.

## 6. Migrations

Migration files live in `plexus_storage/lib/data/migrations/`:

```
migrations/
  0001_initial_schema.dart
  0002_add_soft_delete.dart
  0003_add_file_transfers.dart
  ...
```

Each migration is a drift `MigrationStrategy` step. The database provider runs `migrate()` on open and records the version in `schema_migrations`.

## 7. Local backup / restore

- **Export**: user selects output path. App serializes all tables to an encrypted CBOR/JSON bundle, wrapped with a user-chosen backup password (Argon2id-derived). Produces a single `.plexusbackup` file.
- **Import**: user selects `.plexusbackup` file. App verifies password, decrypts, validates schema version, imports into a fresh database (replace current).

## 8. Data retention policy (configurable)

- Messages: keep forever by default; user can set auto-delete after N days.
- File transfers: completed transfers keep metadata forever; file chunks can be purged after export.
- Audit log: rotate at 10 MB or 30 days, whichever comes first.
- Failed messages: retry for 7 days, then move to `failed` status (user-visible).
