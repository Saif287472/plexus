/// Client-generated UUID identifying a message.
import '../failures/validation_failure.dart';

class MessageId {
  final String value;

  const MessageId._(this.value);

  factory MessageId(String value) {
    if (value.isEmpty) {
      throw ValidationFailure(
        message: 'Message ID cannot be empty.',
        code: 'invalid_message_id',
      );
    }
    return MessageId._(value);
  }

  @override
  String toString() => 'MessageId($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MessageId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
