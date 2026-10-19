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
  Future<Result<Identity, DatabaseFailure>> save(Identity identity);
  Future<Result<Identity?, DatabaseFailure>> getByDeviceId(
    DeviceId deviceId,
  );
  Future<Result<Identity?, DatabaseFailure>> getByFingerprint(
    Fingerprint fingerprint,
  );
  Future<Result<void, DatabaseFailure>> delete(DeviceId deviceId);
  Future<Result<List<Identity>, DatabaseFailure>> getAll();
}

/// Persistence for `Peer`.
abstract class PeerRepository {
  Future<Result<Peer, DatabaseFailure>> save(Peer peer);
  Future<Result<Peer?, DatabaseFailure>> getById(PeerId peerId);
  Future<Result<List<Peer>, DatabaseFailure>> getAll();
  Future<Result<List<Peer>, DatabaseFailure>> getTrusted();
  Future<Result<void, DatabaseFailure>> delete(PeerId peerId);
  Future<Result<void, DatabaseFailure>> updateLastSeen(
    PeerId peerId,
    int timestamp,
  );
}

/// Persistence for `Message`.
abstract class MessageRepository {
  Future<Result<Message, DatabaseFailure>> save(Message message);
  Future<Result<Message?, DatabaseFailure>> getById(MessageId messageId);
  Future<Result<List<Message>, DatabaseFailure>> getByConversation(
    int conversationId, {
    int? limit,
    int? offset,
  });
  Future<Result<List<Message>, DatabaseFailure>> getPendingDelivery();
  Future<Result<void, DatabaseFailure>> updateStatus(
    MessageId messageId,
    DeliveryStatus status, {
    int? deliveredAt,
    int? readAt,
  });
  Future<Result<void, DatabaseFailure>> delete(MessageId messageId);
}

/// Persistence for `Conversation`.
abstract class ConversationRepository {
  Future<Result<Conversation, DatabaseFailure>> save(
    Conversation conversation,
  );
  Future<Result<Conversation?, DatabaseFailure>> getById(int id);
  Future<Result<List<Conversation>, DatabaseFailure>> getAll({
    bool includeArchived = false,
  });
  Future<Result<List<Conversation>, DatabaseFailure>> getByPeer(PeerId peerId);
  Future<Result<void, DatabaseFailure>> delete(int id);
}

/// Persistence for `TrustRecord`.
abstract class TrustRepository {
  Future<Result<TrustRecord, DatabaseFailure>> save(TrustRecord record);
  Future<Result<TrustRecord?, DatabaseFailure>> getByPeer(PeerId peerId);
  Future<Result<List<TrustRecord>, DatabaseFailure>> getAllActive();
  Future<Result<void, DatabaseFailure>> revoke(PeerId peerId);
}

/// Persistence for `FileTransfer`.
abstract class FileTransferRepository {
  Future<Result<FileTransfer, DatabaseFailure>> save(FileTransfer transfer);
  Future<Result<FileTransfer?, DatabaseFailure>> getById(String transferId);
  Future<Result<List<FileTransfer>, DatabaseFailure>> getByConversation(
    int conversationId,
  );
  Future<Result<List<FileTransfer>, DatabaseFailure>> getPending();
  Future<Result<void, DatabaseFailure>> updateProgress(
    String transferId,
    double progress,
  );
  Future<Result<void, DatabaseFailure>> complete(String transferId);
}

/// Persistence for `Group`.
abstract class GroupRepository {
  Future<Result<Group, DatabaseFailure>> save(Group group);
  Future<Result<Group?, DatabaseFailure>> getById(String groupId);
  Future<Result<List<Group>, DatabaseFailure>> getAll();
  Future<Result<void, DatabaseFailure>> delete(String groupId);
}

/// Persistence for `GroupMember`.
abstract class GroupMemberRepository {
  Future<Result<GroupMember, DatabaseFailure>> save(GroupMember member);
  Future<Result<List<GroupMember>, DatabaseFailure>> getByGroup(
    String groupId,
  );
  Future<Result<GroupMember?, DatabaseFailure>> getMember(
    String groupId,
    PeerId peerId,
  );
  Future<Result<void, DatabaseFailure>> removeMember(
    String groupId,
    PeerId peerId,
  );
}
