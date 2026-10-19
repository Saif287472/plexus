/// Failure raised by the transport layer (socket, BLE, TLS, handshake).
import 'failure.dart';

class TransportFailure extends Failure {
  const TransportFailure({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}
