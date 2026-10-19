/// Domain event: a peer was discovered on the network.
import '../entities/peer.dart';
import '../value_objects/transport_type.dart';

class PeerDiscovered {
  final Peer peer;
  final TransportType transportType;
  final DateTime occurredAt;

  PeerDiscovered({
    required this.peer,
    required this.transportType,
    DateTime? occurredAt,
  }) : occurredAt = occurredAt ?? DateTime.now();

  @override
  String toString() =>
      'PeerDiscovered(peerId: ${peer.peerId}, transport: $transportType)';
}
