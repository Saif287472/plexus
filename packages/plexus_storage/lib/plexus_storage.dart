/// Plexus data layer — encrypted local storage with drift + SQLCipher.
///
/// Provides repository implementations for all domain repository interfaces
/// in `plexus_core`, plus the database and migration runner.
library plexus_storage;

export 'src/data/plexus_database.dart';
export 'src/data/migrations/migration_runner.dart';
export 'src/data/repositories/identity_repository.dart';
export 'src/data/tables/tables.dart';
