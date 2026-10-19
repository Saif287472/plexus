/// Repository interfaces (ports) for the domain layer.
///
/// Implementations live in `plexus_storage` (SQLite) and are injected
/// into application use cases. These interfaces know nothing about
/// database or Flutter — only about domain entities and `Result`.
library plexus_core.repositories;

import '../entities/conversation.dart';
import '../entities/file_transfer.dart';
import '../entities/group.dart';
import '../entities/group_member.dart';
import '../entities/identity.dart';
import '../entities/message.dart';
import '../entities/peer.dart';
import '../entities/trust_record.dart';
import '../failures/database_failure.dart';
import '../result.dart';
import '../value_objects/device_id.dart';
import '../value_objects/delivery_status.dart';
import '../value_objects/fingerprint.dart';
import '../value_objects/message_id.dart';
import '../value_objects/peer_id.dart';

/// Persistence for `Identity`.
abstract class IdentityRepository {
  Result<Identity, DatabaseFailure> save(Identity identity);
  Result<Identity?, DatabaseFailure> getByDeviceId(DeviceId deviceId);
  Result<Identity?, DatabaseFailure> getByFingerprint(Fingerprint fingerprint);
  Result<void, DatabaseFailure> delete(DeviceId deviceId);
  Result<List<Identity>, DatabaseFailure> getAll();
}

/// Persistence for `Peer`.
abstract class PeerRepository {
  Result<Peer, DatabaseFailure> save(Peer peer);
  Result<Peer?, DatabaseFailure> getById(PeerId peerId);
  Result<List<Peer>, DatabaseFailure> getAll();
  Result<List<Peer>, DatabaseFailure> getTrusted();
  Result<void, DatabaseFailure> delete(PeerId peerId);
  Result<void, DatabaseFailure> updateLastSeen(PeerId peerId, int timestamp);
}

/// Persistence for `Message`.
abstract class MessageRepository {
  Result<Message, DatabaseFailure> save(Message message);
  Result<Message?, DatabaseFailure> getById(MessageId messageId);
  Result<List<Message>, DatabaseFailure> getByConversation(
    int conversationId, {
    int? limit,
    int? offset,
  });
  Result<List<Message>, DatabaseFailure> getPendingDelivery();
  Result<void, DatabaseFailure> updateStatus(
    MessageId messageId,
    DeliveryStatus status, {
    int? deliveredAt,
    int? readAt,
  });
  Result<void, DatabaseFailure> delete(MessageId messageId);
}

/// Persistence for `Conversation`.
abstract class ConversationRepository {
  Result<Conversation, DatabaseFailure> save(Conversation conversation);
  Result<Conversation?, DatabaseFailure> getById(int id);
  Result<List<Conversation>, DatabaseFailure> getAll({
    bool includeArchived = false,
  });
  Result<List<Conversation>, DatabaseFailure> getByPeer(PeerId peerId);
  Result<void, DatabaseFailure> delete(int id);
}

/// Persistence for `TrustRecord`.
abstract class TrustRepository {
  Result<TrustRecord, DatabaseFailure> save(TrustRecord record);
  Result<TrustRecord?, DatabaseFailure> getByPeer(PeerId peerId);
  Result<List<TrustRecord>, DatabaseFailure> getAllActive();
  Result<void, DatabaseFailure> revoke(PeerId peerId);
}

/// Persistence for `FileTransfer`.
abstract class FileTransferRepository {
  Result<FileTransfer, DatabaseFailure> save(FileTransfer transfer);
  Result<FileTransfer?, DatabaseFailure> getById(String transferId);
  Result<List<FileTransfer>, DatabaseFailure> getByConversation(
    int conversationId,
  );
  Result<List<FileTransfer>, DatabaseFailure> getPending();
  Result<void, DatabaseFailure> updateProgress(String transferId, double progress);
  Result<void, DatabaseFailure> complete(String transferId);
}

/// Persistence for `Group`.
abstract class GroupRepository {
  Result<Group, DatabaseFailure> save(Group group);
  Result<Group?, DatabaseFailure> getById(String groupId);
  Result<List<Group>, DatabaseFailure> getAll();
  Result<void, DatabaseFailure> delete(String groupId);
}

/// Persistence for `GroupMember`.
abstract class GroupMemberRepository {
  Result<GroupMember, DatabaseFailure> save(GroupMember member);
  Result<List<GroupMember>, DatabaseFailure> getByGroup(String groupId);
  Result<GroupMember?, DatabaseFailure> getMember(
    String groupId,
    PeerId peerId,
  );
  Result<void, DatabaseFailure> removeMember(String groupId, PeerId peerId);
}
