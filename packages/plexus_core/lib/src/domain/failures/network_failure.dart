/// Failure raised when the network is unavailable or a peer cannot be reached.
import 'failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}
