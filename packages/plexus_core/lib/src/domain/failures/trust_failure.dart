/// Failure raised by the trust layer (unknown peer, unverified fingerprint, revoked peer).
import 'failure.dart';

class TrustFailure extends Failure {
  const TrustFailure({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}
