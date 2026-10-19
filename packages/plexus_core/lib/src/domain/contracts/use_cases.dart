/// Application use case interfaces.
///
/// These define what the application layer can do. Implementations live in
/// `plexus_app/lib/application/` and orchestrate repositories + gateways.
library plexus_core.use_cases;

import '../entities/message.dart';
import '../entities/trust_record.dart';
import '../entities/peer.dart';
import '../failures/failure.dart';
import '../result.dart';
import '../value_objects/peer_id.dart';
import '../value_objects/fingerprint.dart';

/// Send a message to a peer (direct or group).
abstract class SendMessageUseCase {
  Future<Result<Message, Failure>> call({
    required int conversationId,
    required String plaintext,
    required MessageType type,
  });
}

/// Discover peers on all available transports.
abstract class DiscoverPeersUseCase {
  Future<Result<List<Peer>, Failure>> call();
}

/// Establish trust with a peer via fingerprint verification.
abstract class EstablishTrustUseCase {
  Future<Result<TrustRecord, Failure>> call({
    required PeerId peerId,
    required Fingerprint fingerprint,
    required VerificationMethod method,
  });
}

/// Route a message through the mesh (direct or multi-hop).
abstract class RouteMessageUseCase {
  Future<Result<void, Failure>> call(Message message);
}

/// Export an encrypted backup of all local data.
abstract class ExportBackupUseCase {
  Future<Result<void, Failure>> call(String outputPath);
}

/// Import data from an encrypted backup file.
abstract class ImportBackupUseCase {
  Future<Result<void, Failure>> call(String inputPath, String backupPassword);
}

/// Perform a panic wipe (destroy identity, trust, and database).
abstract class PanicWipeUseCase {
  Future<Result<void, Failure>> call();
}
