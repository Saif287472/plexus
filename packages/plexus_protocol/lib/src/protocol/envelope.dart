/// The wire envelope that wraps every Plexus frame.
///
/// All peer-to-peer communication is framed as CBOR-encoded envelopes.
/// The envelope contains routing metadata plus the encrypted payload.
library plexus_protocol.envelope;

import 'frame_type.dart';
import 'codecs/frame_codec.dart';

/// The wire envelope that wraps every Plexus frame.
///
/// All peer-to-peer communication is framed as CBOR-encoded envelopes.
/// The envelope contains routing metadata plus the encrypted payload.
class Envelope {
  /// Protocol version this envelope conforms to.
  final int protocolVersion;

  /// Frame type.
  final FrameType frameType;

  /// Sender peer ID (fingerprint).
  final String fromPeerId;

  /// Intended recipient peer ID (null for broadcast/mesh announcements).
  final String? toPeerId;

  /// Message ID for deduplication and receipts.
  final String messageId;

  /// Timestamp (Unix milliseconds).
  final int timestamp;

  /// Time-to-live in seconds (for mesh forwarding).
  final int ttlSeconds;

  /// Number of hops this frame has traversed.
  final int hopCount;

  /// Maximum hops allowed before the frame is dropped.
  final int maxHops;

  /// Encrypted payload (CBOR-encoded frame-specific content).
  final List<int> payload;

  /// Optional routing headers for mesh forwarding.
  final Map<String, dynamic>? routingHeaders;

  const Envelope({
    required this.protocolVersion,
    required this.frameType,
    required this.fromPeerId,
    this.toPeerId,
    required this.messageId,
    required this.timestamp,
    this.ttlSeconds = 300,
    this.hopCount = 0,
    required this.maxHops,
    required this.payload,
    this.routingHeaders,
  });

  /// Encodes this envelope to CBOR bytes.
  List<int> encode() => encodeEnvelope(this);

  /// Decodes CBOR bytes into an [Envelope].
  factory Envelope.decode(List<int> bytes) => decodeEnvelope(bytes);

  /// Creates a copy with updated hop count and TTL.
  Envelope withHopIncrement({
    int? hopCount,
    int? ttlSeconds,
  }) {
    return Envelope(
      protocolVersion: protocolVersion,
      frameType: frameType,
      fromPeerId: fromPeerId,
      toPeerId: toPeerId,
      messageId: messageId,
      timestamp: timestamp,
      ttlSeconds: ttlSeconds ?? this.ttlSeconds,
      hopCount: hopCount ?? (this.hopCount + 1),
      maxHops: maxHops,
      payload: payload,
      routingHeaders: routingHeaders,
    );
  }

  @override
  String toString() =>
      'Envelope(type: ${frameType.label}, from: $fromPeerId, to: $toPeerId, hops: $hopCount/$maxHops)';
}
