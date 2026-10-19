/// Frame codec — encodes and decodes [Envelope] and frame payloads to/from CBOR.
library plexus_protocol.codecs.frame_codec;

import 'package:plexus_protocol/plexus_protocol.dart';
import 'cbor_codec.dart';

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
  return cborEncode(map);
}

/// Decodes CBOR bytes into an [Envelope].
Envelope decodeEnvelope(List<int> bytes) {
  final map = cborDecode(bytes) as Map<dynamic, dynamic>;

  final protocolVersion = map['v'] as int;
  final frameTypeCode = map['t'] as int;
  final frameType = FrameType.fromCode(frameTypeCode);
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
      return cborEncode((payload as RequestFrame).toMap());
    case FrameType.accept:
      return cborEncode((payload as AcceptFrame).toMap());
    case FrameType.reject:
      return cborEncode((payload as RejectFrame).toMap());
    case FrameType.cancel:
      return cborEncode((payload as CancelFrame).toMap());
    case FrameType.identity:
      return cborEncode((payload as IdentityFrame).toMap());
    case FrameType.identityAck:
      return cborEncode((payload as IdentityAckFrame).toMap());
    case FrameType.capability:
      return cborEncode((payload as CapabilityFrame).toMap());
    case FrameType.chatMessage:
      return cborEncode((payload as ChatMessageFrame).toMap());
    case FrameType.keepalive:
      return cborEncode((payload as KeepaliveFrame).toMap());
    case FrameType.close:
      return cborEncode((payload as CloseFrame).toMap());
    case FrameType.error:
      return cborEncode((payload as ErrorFrame).toMap());
    case FrameType.meshRoute:
      return cborEncode((payload as MeshRouteFrame).toMap());
    case FrameType.meshForward:
      return cborEncode((payload as MeshForwardFrame).toMap());
    default:
      return cborEncode({});
  }
}

/// Decodes a frame payload from CBOR bytes based on its [FrameType].
dynamic decodePayload(FrameType type, List<int> bytes) {
  final map = cborDecode(bytes) as Map<dynamic, dynamic>;
  final typedMap = map.map((k, v) => MapEntry(k.toString(), v));

  switch (type) {
    case FrameType.request:
      return RequestFrame.fromMap(typedMap);
    case FrameType.accept:
      return AcceptFrame.fromMap(typedMap);
    case FrameType.reject:
      return RejectFrame.fromMap(typedMap);
    case FrameType.cancel:
      return CancelFrame.fromMap(typedMap);
    case FrameType.identity:
      return IdentityFrame.fromMap(typedMap);
    case FrameType.identityAck:
      return IdentityAckFrame.fromMap(typedMap);
    case FrameType.capability:
      return CapabilityFrame.fromMap(typedMap);
    case FrameType.chatMessage:
      return ChatMessageFrame.fromMap(typedMap);
    case FrameType.keepalive:
      return KeepaliveFrame.fromMap(typedMap);
    case FrameType.close:
      return CloseFrame.fromMap(typedMap);
    case FrameType.error:
      return ErrorFrame.fromMap(typedMap);
    case FrameType.meshRoute:
      return MeshRouteFrame.fromMap(typedMap);
    case FrameType.meshForward:
      return MeshForwardFrame.fromMap(typedMap);
    default:
      return typedMap;
  }
}
