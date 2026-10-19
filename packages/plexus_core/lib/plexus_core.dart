/// Plexus domain layer.
///
/// This package contains the core domain model: entities, value objects,
/// repository interfaces (ports), and domain events. It is pure Dart with
/// no Flutter, no database, and no network dependencies.
///
/// All other packages depend on this one. This package depends on nothing
/// outside `meta`, `crypto`, and `convert`.
library plexus_core;

export 'src/domain/entities/identity.dart';
export 'src/domain/entities/peer.dart';
export 'src/domain/entities/message.dart';
export 'src/domain/entities/conversation.dart';
export 'src/domain/entities/trust_record.dart';
export 'src/domain/entities/file_transfer.dart';
export 'src/domain/entities/group.dart';
export 'src/domain/entities/group_member.dart';

export 'src/domain/value_objects/peer_id.dart';
export 'src/domain/value_objects/device_id.dart';
export 'src/domain/value_objects/fingerprint.dart';
export 'src/domain/value_objects/message_id.dart';
export 'src/domain/value_objects/transport_type.dart';
export 'src/domain/value_objects/delivery_status.dart';
export 'src/domain/value_objects/conversation_type.dart';
export 'src/domain/value_objects/group_role.dart';

export 'src/domain/events/message_sent.dart';
export 'src/domain/events/message_received.dart';
export 'src/domain/events/peer_discovered.dart';
export 'src/domain/events/trust_established.dart';
export 'src/domain/events/transport_state_changed.dart';

export 'src/domain/contracts/repositories.dart';
export 'src/domain/contracts/gateways.dart';
export 'src/domain/contracts/use_cases.dart';

export 'src/domain/failures/failure.dart';
export 'src/domain/failures/database_failure.dart';
export 'src/domain/failures/transport_failure.dart';
export 'src/domain/failures/crypto_failure.dart';
export 'src/domain/failures/trust_failure.dart';
export 'src/domain/failures/validation_failure.dart';
export 'src/domain/failures/network_failure.dart';

export 'src/domain/result.dart';
