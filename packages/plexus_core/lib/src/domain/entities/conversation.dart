/// A conversation — either a direct 1:1 thread or a group thread.
import '../value_objects/conversation_type.dart';
import '../value_objects/peer_id.dart';

class Conversation {
  /// Database ID (primary key).
  final int id;

  /// Type of conversation.
  final ConversationType type;

  /// Peer ID for direct conversations (null for groups).
  final PeerId? peerId;

  /// Group ID for group conversations (null for direct).
  final String? groupId;

  /// Unix milliseconds of the last message in this conversation.
  final int lastMessageAt;

  /// Number of unread messages.
  final int unreadCount;

  /// Whether this conversation is pinned to the top.
  final bool isPinned;

  /// Whether this conversation is archived.
  final bool isArchived;

  /// Unix milliseconds when created.
  final int createdAt;

  /// Unix milliseconds when last updated.
  final int updatedAt;

  /// Unix milliseconds when soft-deleted, or null.
  final int? deletedAt;

  const Conversation({
    required this.id,
    required this.type,
    this.peerId,
    this.groupId,
    required this.lastMessageAt,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Conversation copyWith({
    int? id,
    ConversationType? type,
    PeerId? peerId,
    String? groupId,
    int? lastMessageAt,
    int? unreadCount,
    bool? isPinned,
    bool? isArchived,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      type: type ?? this.type,
      peerId: peerId ?? this.peerId,
      groupId: groupId ?? this.groupId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() => 'Conversation(id: $id, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Conversation && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
