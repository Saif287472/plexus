/// Domain event: trust was established with a peer.
import '../entities/trust_record.dart';
import '../value_objects/fingerprint.dart';
import '../value_objects/peer_id.dart';

class TrustEstablished {
  final PeerId peerId;
  final Fingerprint fingerprint;
  final VerificationMethod method;
  final DateTime occurredAt;

  TrustEstablished({
    required this.peerId,
    required this.fingerprint,
    required this.method,
    DateTime? occurredAt,
  }) : occurredAt = occurredAt ?? DateTime.now();

  @override
  String toString() => 'TrustEstablished(peerId: $peerId, method: $method)';
}
