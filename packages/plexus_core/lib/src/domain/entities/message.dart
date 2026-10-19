/// A message in a conversation.
///
/// Messages are end-to-end encrypted. The payload is stored encrypted at rest
/// and only decrypted in memory for display.
import '../value_objects/message_id.dart';
import '../value_objects/peer_id.dart';
import '../value_objects/delivery_status.dart';

class Message {
  /// Client-generated unique ID.
  final MessageId messageId;

  /// Conversation this message belongs to.
  final int conversationId;

  /// Peer who sent this message.
  final PeerId senderPeerId;

  /// Peer who should receive this message (null for group messages).
  final PeerId? recipientPeerId;

  /// Message type.
  final MessageType type;

  /// Encrypted message payload.
  final String encryptedPayload;

  /// Current delivery status.
  final DeliveryStatus status;

  /// Whether a delivery receipt is requested.
  final bool deliveryReceiptRequested;

  /// Number of mesh hops this message has traversed (0 = direct).
  final int hopCount;

  /// Time-to-live in seconds for mesh forwarding.
  final int ttlSeconds;

  /// Maximum hops allowed before the message is dropped.
  final int maxHops;

  /// Unix milliseconds when the message was created.
  final int createdAt;

  /// Unix milliseconds when the message was delivered, or null.
  final int? deliveredAt;

  /// Unix milliseconds when the message was read, or null.
  final int? readAt;

  /// Unix milliseconds when the message was soft-deleted, or null.
  final int? deletedAt;

  const Message({
    required this.messageId,
    required this.conversationId,
    required this.senderPeerId,
    this.recipientPeerId,
    required this.type,
    required this.encryptedPayload,
    required this.status,
    this.deliveryReceiptRequested = false,
    this.hopCount = 0,
    required this.ttlSeconds,
    required this.maxHops,
    required this.createdAt,
    this.deliveredAt,
    this.readAt,
    this.deletedAt,
  });

  Message copyWith({
    MessageId? messageId,
    int? conversationId,
    PeerId? senderPeerId,
    PeerId? recipientPeerId,
    MessageType? type,
    String? encryptedPayload,
    DeliveryStatus? status,
    bool? deliveryReceiptRequested,
    int? hopCount,
    int? ttlSeconds,
    int? maxHops,
    int? createdAt,
    int? deliveredAt,
    int? readAt,
    int? deletedAt,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      senderPeerId: senderPeerId ?? this.senderPeerId,
      recipientPeerId: recipientPeerId ?? this.recipientPeerId,
      type: type ?? this.type,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      status: status ?? this.status,
      deliveryReceiptRequested:
          deliveryReceiptRequested ?? this.deliveryReceiptRequested,
      hopCount: hopCount ?? this.hopCount,
      ttlSeconds: ttlSeconds ?? this.ttlSeconds,
      maxHops: maxHops ?? this.maxHops,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Whether this message is addressed to a specific peer (not a group).
  bool get isDirect => recipientPeerId != null;

  @override
  String toString() =>
      'Message(messageId: $messageId, type: $type, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && messageId == other.messageId;

  @override
  int get hashCode => messageId.hashCode;
}

/// The type of a message.
enum MessageType {
  /// Plain text message.
  text,

  /// File transfer (metadata + encrypted file chunks).
  file,

  /// Ephemeral media (audio/video/image).
  media,

  /// System message (trust change, group event, etc.).
  system,

  /// Message reaction (emoji).
  reaction,

  /// Delivery receipt.
  receipt,
}
