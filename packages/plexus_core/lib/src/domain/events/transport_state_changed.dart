/// Domain event: a transport's availability changed.
import '../value_objects/transport_type.dart';

class TransportStateChanged {
  final TransportType transportType;
  final bool isAvailable;
  final DateTime occurredAt;

  TransportStateChanged({
    required this.transportType,
    required this.isAvailable,
    DateTime? occurredAt,
  }) : occurredAt = occurredAt ?? DateTime.now();

  @override
  String toString() =>
      'TransportStateChanged(transport: $transportType, available: $isAvailable)';
}
