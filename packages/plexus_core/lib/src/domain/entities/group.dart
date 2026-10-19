/// A group conversation.
import '../value_objects/peer_id.dart';

class Group {
  /// Unique group ID.
  final String groupId;

  /// Human-readable group name.
  final String name;

  /// Peer ID of the group creator.
  final PeerId creatorPeerId;

  /// Unix milliseconds when created.
  final int createdAt;

  /// Unix milliseconds when last updated.
  final int updatedAt;

  /// Unix milliseconds when soft-deleted, or null.
  final int? deletedAt;

  const Group({
    required this.groupId,
    required this.name,
    required this.creatorPeerId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Group copyWith({
    String? groupId,
    String? name,
    PeerId? creatorPeerId,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Group(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      creatorPeerId: creatorPeerId ?? this.creatorPeerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() => 'Group(groupId: $groupId, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Group && other.groupId == groupId;

  @override
  int get hashCode => groupId.hashCode;
}
