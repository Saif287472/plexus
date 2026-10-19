/// A member of a group.
import '../value_objects/peer_id.dart';
import '../value_objects/group_role.dart';

class GroupMember {
  /// Database ID (primary key).
  final int id;

  /// Group ID this member belongs to.
  final String groupId;

  /// Peer ID of the member.
  final PeerId peerId;

  /// Role within the group.
  final GroupRole role;

  /// Unix milliseconds when joined.
  final int joinedAt;

  /// Unix milliseconds when left, or null if still a member.
  final int? leftAt;

  const GroupMember({
    required this.id,
    required this.groupId,
    required this.peerId,
    required this.role,
    required this.joinedAt,
    this.leftAt,
  });

  GroupMember copyWith({
    int? id,
    String? groupId,
    PeerId? peerId,
    GroupRole? role,
    int? joinedAt,
    int? leftAt,
  }) {
    return GroupMember(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      peerId: peerId ?? this.peerId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
    );
  }

  /// Whether this member is currently in the group (not left).
  bool get isActive => leftAt == null;

  @override
  String toString() =>
      'GroupMember(groupId: $groupId, peerId: $peerId, role: $role)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GroupMember && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
