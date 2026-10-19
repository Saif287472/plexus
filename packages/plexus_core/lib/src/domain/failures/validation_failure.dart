/// Failure raised when input validation fails (invalid name, bad QR, etc.).
import 'failure.dart';

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}
