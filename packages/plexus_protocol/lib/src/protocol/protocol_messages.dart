/// Frame-specific message payloads.
///
/// Each [FrameType] has a corresponding message structure that is
/// CBOR-encoded and placed in the [Envelope.payload].
library plexus_protocol.protocol_messages;

import 'package:plexus_protocol/plexus_protocol.dart';

/// Connection request frame (handshake initiation).
class RequestFrame {
  final String deviceId;
  final String displayName;
  final String publicKey;
  final String fingerprint;
  final Set<int> supportedTransports;
  final bool meshRelayCapable;
  final String nonce;

  const RequestFrame({
    required this.deviceId,
    required this.displayName,
    required this.publicKey,
    required this.fingerprint,
    required this.supportedTransports,
    this.meshRelayCapable = false,
    required this.nonce,
  });

  Map<String, dynamic> toMap();
  factory RequestFrame.fromMap(Map<String, dynamic> map);
}

/// Connection accept frame (handshake response).
class AcceptFrame {
  final String deviceId;
  final String displayName;
  final String publicKey;
  final String fingerprint;
  final Set<int> supportedTransports;
  final bool meshRelayCapable;
  final String nonce;
  final String theirNonce;

  const AcceptFrame({
    required this.deviceId,
    required this.displayName,
    required this.publicKey,
    required this.fingerprint,
    required this.supportedTransports,
    this.meshRelayCapable = false,
    required this.nonce,
    required this.theirNonce,
  });

  Map<String, dynamic> toMap();
  factory AcceptFrame.fromMap(Map<String, dynamic> map);
}

/// Connection reject frame.
class RejectFrame {
  final String reason;
  final String? code;

  const RejectFrame({required this.reason, this.code});

  Map<String, dynamic> toMap();
  factory RejectFrame.fromMap(Map<String, dynamic> map);
}

/// Connection cancel frame.
class CancelFrame {
  final String reason;

  const CancelFrame({required this.reason});

  Map<String, dynamic> toMap();
  factory CancelFrame.fromMap(Map<String, dynamic> map);
}

/// Identity exchange frame.
class IdentityFrame {
  final String publicKey;
  final String fingerprint;
  final String displayName;

  const IdentityFrame({
    required this.publicKey,
    required this.fingerprint,
    required this.displayName,
  });

  Map<String, dynamic> toMap();
  factory IdentityFrame.fromMap(Map<String, dynamic> map);
}

/// Identity acknowledgment frame.
class IdentityAckFrame {
  final String fingerprint;
  final bool verified;

  const IdentityAckFrame({required this.fingerprint, required this.verified});

  Map<String, dynamic> toMap();
  factory IdentityAckFrame.fromMap(Map<String, dynamic> map);
}

/// Capability advertisement frame.
class CapabilityFrame {
  final Set<int> capabilities;
  final bool meshRelay;
  final bool fileTransfer;
  final bool calls;

  const CapabilityFrame({
    required this.capabilities,
    this.meshRelay = false,
    this.fileTransfer = false,
    this.calls = false,
  });

  Map<String, dynamic> toMap();
  factory CapabilityFrame.fromMap(Map<String, dynamic> map);
}

/// Chat message frame.
class ChatMessageFrame {
  final String conversationId;
  final String messageId;
  final String senderPeerId;
  final String? recipientPeerId;
  final List<int> encryptedPayload;
  final int timestamp;

  const ChatMessageFrame({
    required this.conversationId,
    required this.messageId,
    required this.senderPeerId,
    this.recipientPeerId,
    required this.encryptedPayload,
    required this.timestamp,
  });

  Map<String, dynamic> toMap();
  factory ChatMessageFrame.fromMap(Map<String, dynamic> map);
}

/// Keepalive frame.
class KeepaliveFrame {
  final int timestamp;

  const KeepaliveFrame({required this.timestamp});

  Map<String, dynamic> toMap();
  factory KeepaliveFrame.fromMap(Map<String, dynamic> map);
}

/// Close connection frame.
class CloseFrame {
  final String reason;

  const CloseFrame({required this.reason});

  Map<String, dynamic> toMap();
  factory CloseFrame.fromMap(Map<String, dynamic> map);
}

/// Error frame.
class ErrorFrame {
  final String code;
  final String message;
  final bool isRetryable;

  const ErrorFrame({
    required this.code,
    required this.message,
    this.isRetryable = false,
  });

  Map<String, dynamic> toMap();
  factory ErrorFrame.fromMap(Map<String, dynamic> map);
}

/// Mesh route announcement frame.
class MeshRouteFrame {
  final String targetPeerId;
  final String viaPeerId;
  final double linkQuality;
  final int rttMs;

  const MeshRouteFrame({
    required this.targetPeerId,
    required this.viaPeerId,
    required this.linkQuality,
    required this.rttMs,
  });

  Map<String, dynamic> toMap();
  factory MeshRouteFrame.fromMap(Map<String, dynamic> map);
}

/// Mesh forward frame (store-and-forward).
class MeshForwardFrame {
  final String targetPeerId;
  final String originalSender;
  final String originalRecipient;
  final String originalMessageId;
  final List<int> originalPayload;
  final int originalHopCount;
  final int originalMaxHops;
  final int originalTtl;

  const MeshForwardFrame({
    required this.targetPeerId,
    required this.originalSender,
    required this.originalRecipient,
    required this.originalMessageId,
    required this.originalPayload,
    required this.originalHopCount,
    required this.originalMaxHops,
    required this.originalTtl,
  });

  Map<String, dynamic> toMap();
  factory MeshForwardFrame.fromMap(Map<String, dynamic> map);
}
