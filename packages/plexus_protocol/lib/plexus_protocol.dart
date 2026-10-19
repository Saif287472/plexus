/// Plexus wire protocol.
///
/// Defines the binary wire format used for all peer-to-peer communication:
/// frames, envelopes, codecs, protocol versioning, and capability flags.
library plexus_protocol;

export 'src/protocol/frame_type.dart';
export 'src/protocol/envelope.dart';
export 'src/protocol/protocol_messages.dart';

export 'src/protocol/codecs/frame_codec.dart';
export 'src/protocol/codecs/cbor_codec.dart';

export 'src/protocol/versioning/protocol_version.dart';
export 'src/protocol/versioning/capability_flags.dart';
