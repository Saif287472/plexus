/// SQLite implementation of [IdentityRepository] from plexus_core.
library plexus_storage.repositories.identity_repository;

import 'package:drift/drift.dart';
import 'package:plexus_core/plexus_core.dart' as core;
import 'package:plexus_storage/plexus_storage.dart';

/// Drift-backed identity repository.
class SqliteIdentityRepository implements core.IdentityRepository {
  final PlexusDatabase _db;

  SqliteIdentityRepository(this._db);

  @override
  Future<core.Result<core.Identity, core.DatabaseFailure>> save(
    core.Identity identity,
  ) async {
    try {
      await _db.into(_db.identities).insert(
        IdentitiesCompanion(
          deviceId: Value(identity.deviceId.value),
          publicKey: Value(identity.publicKey),
          encryptedPrivateKey: Value(identity.encryptedPrivateKey),
          fingerprint: Value(identity.fingerprint.value),
          displayName: Value(identity.displayName),
          createdAt: Value(identity.createdAt),
          updatedAt: Value(identity.updatedAt),
          deletedAt:
              identity.deletedAt != null
                  ? Value(identity.deletedAt!)
                  : const Value.absent(),
        ),
      );
      return core.ok(identity);
    } on Exception catch (e) {
      return core.err(core.DatabaseFailure(
        message: 'Failed to save identity: $e',
        code: 'database_save_failed',
        isRetryable: true,
      ));
    }
  }

  @override
  Future<core.Result<core.Identity?, core.DatabaseFailure>> getByDeviceId(
    core.DeviceId deviceId,
  ) async {
    try {
      final row = await _db
          .customSelect(
            'SELECT * FROM identities WHERE device_id = ? LIMIT 1',
            variables: [Variable<Object>(deviceId.value)],
          )
          .map((row) => _rowToIdentity(row))
          .getSingleOrNull();
      return core.ok(row);
    } on Exception catch (e) {
      return core.err(core.DatabaseFailure(
        message: 'Failed to load identity: $e',
        code: 'database_load_failed',
        isRetryable: true,
      ));
    }
  }

  @override
  Future<core.Result<core.Identity?, core.DatabaseFailure>> getByFingerprint(
    core.Fingerprint fingerprint,
  ) async {
    try {
      final row = await _db
          .customSelect(
            'SELECT * FROM identities WHERE fingerprint = ? LIMIT 1',
            variables: [Variable<Object>(fingerprint.value)],
          )
          .map((row) => _rowToIdentity(row))
          .getSingleOrNull();
      return core.ok(row);
    } on Exception catch (e) {
      return core.err(core.DatabaseFailure(
        message: 'Failed to load identity by fingerprint: $e',
        code: 'database_load_failed',
        isRetryable: true,
      ));
    }
  }

  @override
  Future<core.Result<void, core.DatabaseFailure>> delete(
    core.DeviceId deviceId,
  ) async {
    try {
      await _db.customStatement(
        'DELETE FROM identities WHERE device_id = ?',
        [deviceId.value],
      );
      return core.ok(null);
    } on Exception catch (e) {
      return core.err(core.DatabaseFailure(
        message: 'Failed to delete identity: $e',
        code: 'database_delete_failed',
        isRetryable: true,
      ));
    }
  }

  @override
  Future<core.Result<List<core.Identity>, core.DatabaseFailure>> getAll() async {
    try {
      final rows = await _db
          .customSelect('SELECT * FROM identities')
          .map((row) => _rowToIdentity(row))
          .get();
      return core.ok(rows);
    } on Exception catch (e) {
      return core.err(core.DatabaseFailure(
        message: 'Failed to load identities: $e',
        code: 'database_load_failed',
        isRetryable: true,
      ));
    }
  }

  core.Identity _rowToIdentity(QueryRow row) {
    return core.Identity(
      deviceId: core.DeviceId(row.read<String>('device_id')),
      publicKey: row.read<String>('public_key'),
      encryptedPrivateKey: row.read<String>('encrypted_private_key'),
      fingerprint: core.Fingerprint(row.read<String>('fingerprint')),
      displayName: row.read<String>('display_name'),
      createdAt: row.read<int>('created_at'),
      updatedAt: row.read<int>('updated_at'),
      deletedAt: row.read<int?>('deleted_at'),
    );
  }
}
