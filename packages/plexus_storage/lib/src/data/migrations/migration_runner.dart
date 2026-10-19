/// Migration runner for Plexus database schema.
///
/// Applies numbered migrations in order and records them in schema_migrations.
/// Never edit a migration that has run in production — always add a new one.
library plexus_storage.migrations;

import 'package:drift/drift.dart';
import 'package:plexus_storage/plexus_storage.dart';

/// Applies all pending migrations to [database].
Future<void> migrateDatabase(PlexusDatabase database) async {
  final appliedVersions = await database
      .select(database.schemaMigrations)
      .map((row) => row.version)
      .get();

  for (var version = 1; version <= schemaVersion; version++) {
    if (appliedVersions.contains(version)) {
      continue;
    }

    await _applyMigration(database, version);

    await database.into(database.schemaMigrations).insert(
      SchemaMigrationsCompanion(
        version: Value(version),
        checksum: Value(_computeChecksum(version)),
        appliedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}

/// Applies a single numbered migration.
Future<void> _applyMigration(
  PlexusDatabase database,
  int version,
) async {
  switch (version) {
    case 1:
      // Initial schema is created by Drift's onCreate callback.
      break;
    default:
      throw UnsupportedError('No migration defined for version $version');
  }
}

/// Computes a checksum for a migration version (for integrity verification).
String _computeChecksum(int version) {
  return 'v$version';
}
