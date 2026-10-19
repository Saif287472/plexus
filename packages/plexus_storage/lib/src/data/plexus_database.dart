/// Plexus encrypted local database using drift + SQLCipher.
///
/// All application data is persisted here with encryption at rest.
/// Schema changes are handled via numbered migrations — never edit a
/// migration that has run in production.
library plexus_storage.database;

import 'package:drift/drift.dart';
import 'tables/tables.dart';

part 'plexus_database.g.dart';

/// The current schema version. Increment for every migration.
const int schemaVersion = 1;

/// The Plexus database.
///
/// Uses SQLCipher for encryption at rest. The database key is derived
/// from the device ID and user unlock secret via Argon2id + HKDF.
@DriftDatabase(tables: [
  Identities,
  Peers,
  Conversations,
  Messages,
  TrustRecords,
  FileTransfers,
  Groups,
  GroupMembers,
  SchemaMigrations,
])
class PlexusDatabase extends _$PlexusDatabase {
  /// Whether the database has been unlocked with a key.
  bool _isUnlocked = false;

  PlexusDatabase(super.e);

  @override
  int get schemaVersion => schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          for (var version = from + 1; version <= to; version++) {
            await _applyMigration(m, version);
          }
        },
      );

  /// Applies a specific numbered migration.
  Future<void> _applyMigration(Migrator m, int version) async {
    switch (version) {
      case 1:
        // Initial schema created by onCreate.
        break;
      default:
        throw UnsupportedError('No migration defined for version $version');
    }
  }

  /// Whether the database is unlocked and ready for queries.
  bool get isUnlocked => _isUnlocked;

  /// Marks the database as unlocked.
  void markUnlocked() => _isUnlocked = true;

  /// Marks the database as locked.
  void markLocked() => _isUnlocked = false;
}
