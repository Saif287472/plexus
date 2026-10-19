/// Failure raised by the storage layer (database, migration, encryption at rest).
import 'failure.dart';

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}
