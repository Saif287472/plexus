/// Frame-specific message payloads.
///
/// Each [FrameType] has a corresponding message structure that is
/// CBOR-encoded and placed in the [Envelope.payload].
library plexus_protocol.protocol_messages;

import 'frame_type.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'displayName': displayName,
      'publicKey': publicKey,
      'fingerprint': fingerprint,
      'supportedTransports': supportedTransports.toList(),
      'meshRelayCapable': meshRelayCapable,
      'nonce': nonce,
    };
  }

  factory RequestFrame.fromMap(Map<String, dynamic> map) {
    return RequestFrame(
      deviceId: map['deviceId'] as String,
      displayName: map['displayName'] as String,
      publicKey: map['publicKey'] as String,
      fingerprint: map['fingerprint'] as String,
      supportedTransports: (map['supportedTransports'] as List).cast<int>().toSet(),
      meshRelayCapable: map['meshRelayCapable'] as bool? ?? false,
      nonce: map['nonce'] as String,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'displayName': displayName,
      'publicKey': publicKey,
      'fingerprint': fingerprint,
      'supportedTransports': supportedTransports.toList(),
      'meshRelayCapable': meshRelayCapable,
      'nonce': nonce,
      'theirNonce': theirNonce,
    };
  }

  factory AcceptFrame.fromMap(Map<String, dynamic> map) {
    return AcceptFrame(
      deviceId: map['deviceId'] as String,
      displayName: map['displayName'] as String,
      publicKey: map['publicKey'] as String,
      fingerprint: map['fingerprint'] as String,
      supportedTransports: (map['supportedTransports'] as List).cast<int>().toSet(),
      meshRelayCapable: map['meshRelayCapable'] as bool? ?? false,
      nonce: map['nonce'] as String,
      theirNonce: map['theirNonce'] as String,
    );
  }
}

/// Connection reject frame.
class RejectFrame {
  final String reason;
  final String? code;

  const RejectFrame({required this.reason, this.code});

  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      if (code != null) 'code': code,
    };
  }

  factory RejectFrame.fromMap(Map<String, dynamic> map) {
    return RejectFrame(
      reason: map['reason'] as String,
      code: map['code'] as String?,
    );
  }
}

/// Connection cancel frame.
class CancelFrame {
  final String reason;

  const CancelFrame({required this.reason});

  Map<String, dynamic> toMap() {
    return {'reason': reason};
  }

  factory CancelFrame.fromMap(Map<String, dynamic> map) {
    return CancelFrame(reason: map['reason'] as String);
  }
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

  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'fingerprint': fingerprint,
      'displayName': displayName,
    };
  }

  factory IdentityFrame.fromMap(Map<String, dynamic> map) {
    return IdentityFrame(
      publicKey: map['publicKey'] as String,
      fingerprint: map['fingerprint'] as String,
      displayName: map['displayName'] as String,
    );
  }
}

/// Identity acknowledgment frame.
class IdentityAckFrame {
  final String fingerprint;
  final bool verified;

  const IdentityAckFrame({required this.fingerprint, required this.verified});

  Map<String, dynamic> toMap() {
    return {
      'fingerprint': fingerprint,
      'verified': verified,
    };
  }

  factory IdentityAckFrame.fromMap(Map<String, dynamic> map) {
    return IdentityAckFrame(
      fingerprint: map['fingerprint'] as String,
      verified: map['verified'] as bool,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'capabilities': capabilities.toList(),
      'meshRelay': meshRelay,
      'fileTransfer': fileTransfer,
      'calls': calls,
    };
  }

  factory CapabilityFrame.fromMap(Map<String, dynamic> map) {
    return CapabilityFrame(
      capabilities: (map['capabilities'] as List).cast<int>().toSet(),
      meshRelay: map['meshRelay'] as bool? ?? false,
      fileTransfer: map['fileTransfer'] as bool? ?? false,
      calls: map['calls'] as bool? ?? false,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'messageId': messageId,
      'senderPeerId': senderPeerId,
      if (recipientPeerId != null) 'recipientPeerId': recipientPeerId,
      'encryptedPayload': encryptedPayload,
      'timestamp': timestamp,
    };
  }

  factory ChatMessageFrame.fromMap(Map<String, dynamic> map) {
    return ChatMessageFrame(
      conversationId: map['conversationId'] as String,
      messageId: map['messageId'] as String,
      senderPeerId: map['senderPeerId'] as String,
      recipientPeerId: map['recipientPeerId'] as String?,
      encryptedPayload: (map['encryptedPayload'] as List).cast<int>(),
      timestamp: map['timestamp'] as int,
    );
  }
}

/// Keepalive frame.
class KeepaliveFrame {
  final int timestamp;

  const KeepaliveFrame({required this.timestamp});

  Map<String, dynamic> toMap() {
    return {'timestamp': timestamp};
  }

  factory KeepaliveFrame.fromMap(Map<String, dynamic> map) {
    return KeepaliveFrame(timestamp: map['timestamp'] as int);
  }
}

/// Close connection frame.
class CloseFrame {
  final String reason;

  const CloseFrame({required this.reason});

  Map<String, dynamic> toMap() {
    return {'reason': reason};
  }

  factory CloseFrame.fromMap(Map<String, dynamic> map) {
    return CloseFrame(reason: map['reason'] as String);
  }
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

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'isRetryable': isRetryable,
    };
  }

  factory ErrorFrame.fromMap(Map<String, dynamic> map) {
    return ErrorFrame(
      code: map['code'] as String,
      message: map['message'] as String,
      isRetryable: map['isRetryable'] as bool? ?? false,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'targetPeerId': targetPeerId,
      'viaPeerId': viaPeerId,
      'linkQuality': linkQuality,
      'rttMs': rttMs,
    };
  }

  factory MeshRouteFrame.fromMap(Map<String, dynamic> map) {
    return MeshRouteFrame(
      targetPeerId: map['targetPeerId'] as String,
      viaPeerId: map['viaPeerId'] as String,
      linkQuality: (map['linkQuality'] as num).toDouble(),
      rttMs: map['rttMs'] as int,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'targetPeerId': targetPeerId,
      'originalSender': originalSender,
      'originalRecipient': originalRecipient,
      'originalMessageId': originalMessageId,
      'originalPayload': originalPayload,
      'originalHopCount': originalHopCount,
      'originalMaxHops': originalMaxHops,
      'originalTtl': originalTtl,
    };
  }

  factory MeshForwardFrame.fromMap(Map<String, dynamic> map) {
    return MeshForwardFrame(
      targetPeerId: map['targetPeerId'] as String,
      originalSender: map['originalSender'] as String,
      originalRecipient: map['originalRecipient'] as String,
      originalMessageId: map['originalMessageId'] as String,
      originalPayload: (map['originalPayload'] as List).cast<int>(),
      originalHopCount: map['originalHopCount'] as int,
      originalMaxHops: map['originalMaxHops'] as int,
      originalTtl: map['originalTtl'] as int,
    );
  }
}
