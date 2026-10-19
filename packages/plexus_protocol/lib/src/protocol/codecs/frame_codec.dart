/// Frame codec — encodes and decodes [Envelope] and frame payloads to/from CBOR.
library plexus_protocol.codecs.frame_codec;

import 'package:plexus_protocol/plexus_protocol.dart';

/// Encodes an [Envelope] to CBOR bytes.
List<int> encodeEnvelope(Envelope envelope) {
  final map = <String, dynamic>{
    'v': envelope.protocolVersion,
    't': envelope.frameType.code,
    'f': envelope.fromPeerId,
    if (envelope.toPeerId != null) 'to': envelope.toPeerId,
    'm': envelope.messageId,
    'ts': envelope.timestamp,
    'ttl': envelope.ttlSeconds,
    'hc': envelope.hopCount,
    'mh': envelope.maxHops,
    'p': envelope.payload,
    if (envelope.routingHeaders != null) 'rh': envelope.routingHeaders,
  };
  return cborEncodeMap(map);
}

/// Decodes CBOR bytes into an [Envelope].
Envelope decodeEnvelope(List<int> bytes) {
  final map = cborDecodeMap(bytes);

  final protocolVersion = map['v'] as int;
  final frameTypeCode = map['t'] as int;
  final frameType = FrameType.values.firstWhere(
    (t) => t.code == frameTypeCode,
    orElse: () => throw ArgumentError('Unknown frame type code: $frameTypeCode'),
  );
  final fromPeerId = map['f'] as String;
  final toPeerId = map['to'] as String?;
  final messageId = map['m'] as String;
  final timestamp = map['ts'] as int;
  final ttlSeconds = map['ttl'] as int? ?? 300;
  final hopCount = map['hc'] as int? ?? 0;
  final maxHops = map['mh'] as int;
  final payload = cborDecodeBytes(map['p']);
  final routingHeaders = map['rh'] as Map<String, dynamic>?;

  return Envelope(
    protocolVersion: protocolVersion,
    frameType: frameType,
    fromPeerId: fromPeerId,
    toPeerId: toPeerId,
    messageId: messageId,
    timestamp: timestamp,
    ttlSeconds: ttlSeconds,
    hopCount: hopCount,
    maxHops: maxHops,
    payload: payload,
    routingHeaders: routingHeaders,
  );
}

/// Encodes a frame payload to CBOR bytes based on its [FrameType].
List<int> encodePayload(FrameType type, dynamic payload) {
  switch (type) {
    case FrameType.request:
      return cborEncodeMap((payload as RequestFrame).toMap());
    case FrameType.accept:
      return cborEncodeMap((payload as AcceptFrame).toMap());
    case FrameType.reject:
      return cborEncodeMap((payload as RejectFrame).toMap());
    case FrameType.cancel:
      return cborEncodeMap((payload as CancelFrame).toMap());
    case FrameType.identity:
      return cborEncodeMap((payload as IdentityFrame).toMap());
    case FrameType.identityAck:
      return cborEncodeMap((payload as IdentityAckFrame).toMap());
    case FrameType.capability:
      return cborEncodeMap((payload as CapabilityFrame).toMap());
    case FrameType.chatMessage:
      return cborEncodeMap((payload as ChatMessageFrame).toMap());
    case FrameType.keepalive:
      return cborEncodeMap((payload as KeepaliveFrame).toMap());
    case FrameType.close:
      return cborEncodeMap((payload as CloseFrame).toMap());
    case FrameType.error:
      return cborEncodeMap((payload as ErrorFrame).toMap());
    case FrameType.meshRoute:
      return cborEncodeMap((payload as MeshRouteFrame).toMap());
    case FrameType.meshForward:
      return cborEncodeMap((payload as MeshForwardFrame).toMap());
    default:
      return cborEncodeMap({});
  }
}

/// Decodes a frame payload from CBOR bytes based on its [FrameType].
dynamic decodePayload(FrameType type, List<int> bytes) {
  final map = cborDecodeMap(bytes);

  switch (type) {
    case FrameType.request:
      return RequestFrame.fromMap(map);
    case FrameType.accept:
      return AcceptFrame.fromMap(map);
    case FrameType.reject:
      return RejectFrame.fromMap(map);
    case FrameType.cancel:
      return CancelFrame.fromMap(map);
    case FrameType.identity:
      return IdentityFrame.fromMap(map);
    case FrameType.identityAck:
      return IdentityAckFrame.fromMap(map);
    case FrameType.capability:
      return CapabilityFrame.fromMap(map);
    case FrameType.chatMessage:
      return ChatMessageFrame.fromMap(map);
    case FrameType.keepalive:
      return KeepaliveFrame.fromMap(map);
    case FrameType.close:
      return CloseFrame.fromMap(map);
    case FrameType.error:
      return ErrorFrame.fromMap(map);
    case FrameType.meshRoute:
      return MeshRouteFrame.fromMap(map);
    case FrameType.meshForward:
      return MeshForwardFrame.fromMap(map);
    default:
      return map;
  }
}
