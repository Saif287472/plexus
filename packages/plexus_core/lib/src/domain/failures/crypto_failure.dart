/// Failure raised by the crypto layer (key generation, encryption, decryption, ratchet).
import 'failure.dart';

class CryptoFailure extends Failure {
  const CryptoFailure({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}
