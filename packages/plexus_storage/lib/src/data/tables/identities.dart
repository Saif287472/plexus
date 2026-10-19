import 'package:drift/drift.dart';

/// Identities table — stores the install-scoped identity keypair.
class Identities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text().withLength(min: 1, max: 256)();
  TextColumn get publicKey => text().withLength(min: 1)();
  TextColumn get encryptedPrivateKey => text().withLength(min: 1)();
  TextColumn get fingerprint => text().withLength(min: 64, max: 64)();
  TextColumn get displayName => text().withLength(min: 1, max: 128)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn? get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Peers table — stores known and trusted peers.
class Peers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get peerId => text().withLength(min: 64, max: 64)();
  TextColumn? get displayName => text().withLength(max: 128).nullable()();
  IntColumn get trustLevel => integer()();
  IntColumn get fingerprintVerified => integer()();
  IntColumn? get lastSeenAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn? get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Conversations table — direct and group threads.
class Conversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text().withLength(min: 1)();
  TextColumn? get peerId => text().withLength(max: 64).nullable()();
  TextColumn? get groupId => text().withLength(max: 64).nullable()();
  IntColumn get lastMessageAt => integer()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  IntColumn get isPinned => integer().withDefault(const Constant(0))();
  IntColumn get isArchived => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn? get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Messages table — encrypted messages with delivery tracking.
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().withLength(min: 1)();
  IntColumn get conversationId => integer().references(Conversations, #id)();
  TextColumn get senderPeerId => text().withLength(min: 64, max: 64)();
  TextColumn? get recipientPeerId => text().withLength(max: 64).nullable()();
  TextColumn get type => text().withLength(min: 1)();
  TextColumn get encryptedPayload => text().withLength(min: 1)();
  TextColumn get status => text().withLength(min: 1)();
  IntColumn get deliveryReceiptRequested =>
      integer().withDefault(const Constant(0))();
  IntColumn get hopCount => integer().withDefault(const Constant(0))();
  IntColumn get ttlSeconds => integer()();
  IntColumn get maxHops => integer()();
  IntColumn get createdAt => integer()();
  IntColumn? get deliveredAt => integer().nullable()();
  IntColumn? get readAt => integer().nullable()();
  IntColumn? get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Trust records table — fingerprint verification records.
class TrustRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get peerId => text().withLength(min: 64, max: 64)();
  TextColumn get fingerprint => text().withLength(min: 64, max: 64)();
  TextColumn get verificationMethod => text().withLength(min: 1)();
  IntColumn get verifiedAt => integer()();
  IntColumn? get revokedAt => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// File transfers table — tracks file transfer lifecycle.
class FileTransfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transferId => text().withLength(min: 1)();
  IntColumn get conversationId =>
      integer().references(Conversations, #id)();
  TextColumn get fileName => text().withLength(min: 1)();
  IntColumn get fileSize => integer()();
  TextColumn get mimeType => text().withLength(min: 1)();
  TextColumn get localPath => text().withLength(min: 1)();
  TextColumn get status => text().withLength(min: 1)();
  TextColumn get direction => text().withLength(min: 1)();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  IntColumn get createdAt => integer()();
  IntColumn? get completedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Groups table — group conversations.
class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().withLength(min: 1)();
  TextColumn get name => text().withLength(min: 1, max: 128)();
  TextColumn get creatorPeerId => text().withLength(min: 64, max: 64)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn? get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Group members table — membership and roles.
class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().withLength(min: 1)();
  TextColumn get peerId => text().withLength(min: 64, max: 64)();
  TextColumn get role => text().withLength(min: 1)();
  IntColumn get joinedAt => integer()();
  IntColumn? get leftAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Schema migrations table — records applied migration versions.
class SchemaMigrations extends Table {
  IntColumn get version => integer()();
  TextColumn get checksum => text().withLength(min: 1)();
  IntColumn get appliedAt => integer()();

  @override
  Set<Column> get primaryKey => {version};
}
