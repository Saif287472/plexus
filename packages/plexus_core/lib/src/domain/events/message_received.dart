/// Domain event: a message was received from a peer.
import '../entities/message.dart';
import '../value_objects/peer_id.dart';

class MessageReceived {
  final Message message;
  final PeerId fromPeerId;
  final DateTime occurredAt;

  MessageReceived({
    required this.message,
    required this.fromPeerId,
    DateTime? occurredAt,
  }) : occurredAt = occurredAt ?? DateTime.now();

  @override
  String toString() =>
      'MessageReceived(messageId: ${message.messageId}, from: $fromPeerId)';
}
