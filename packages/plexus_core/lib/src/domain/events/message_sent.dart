/// Domain event: a message was sent (or queued for sending).
import '../entities/message.dart';

class MessageSent {
  final Message message;
  final DateTime occurredAt;

  MessageSent({required this.message, DateTime? occurredAt})
      : occurredAt = occurredAt ?? DateTime.now();

  @override
  String toString() => 'MessageSent(messageId: ${message.messageId})';
}
