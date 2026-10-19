/// The type of a Plexus protocol frame.
///
/// Every frame on the wire has a type that determines how it is decoded
/// and dispatched. Frame types are versioned — new types may be added in
/// future protocol versions, but existing types never change.
enum FrameType {
  /// Connection request (handshake initiation).
  request,

  /// Connection accept (handshake response).
  accept,

  /// Connection reject.
  reject,

  /// Connection cancel.
  cancel,

  /// Identity exchange (public key, fingerprint).
  identity,

  /// Identity acknowledgment.
  identityAck,

  /// Capability advertisement.
  capability,

  /// Chat message (encrypted).
  chatMessage,

  /// Chat acknowledgment (delivery receipt).
  chatAck,

  /// Keepalive ping.
  keepalive,

  /// Keepalive pong.
  keepaliveAck,

  /// Close connection.
  close,

  /// Profile update (display name, avatar hash).
  profileUpdate,

  /// Peer is busy.
  busy,

  /// Version mismatch.
  versionMismatch,

  /// Typing indicator.
  typingIndicator,

  /// Read receipt.
  readReceipt,

  /// Message reaction (emoji).
  reaction,

  /// File transfer initiation.
  fileTransfer,

  /// Edit message.
  editMessage,

  /// Delete message.
  deleteMessage,

  /// Wipe notification.
  wipe,

  /// File probe (metadata query).
  fileProbe,

  /// File resume (chunked transfer).
  fileResume,

  /// File complete.
  fileComplete,

  /// File cancel.
  fileCancel,

  /// Ephemeral media (audio/video/image).
  ephemeralMedia,

  /// Group control (create, invite, kick, etc.).
  groupControl,

  /// Group message (encrypted).
  groupMessage,

  /// Error frame.
  error,

  /// Mesh route announcement.
  meshRoute,

  /// Mesh forward (store-and-forward).
  meshForward,
}

extension FrameTypeX on FrameType {
  /// The numeric code used in CBOR encoding.
  int get code {
    switch (this) {
      case FrameType.request:
        return 0x01;
      case FrameType.accept:
        return 0x02;
      case FrameType.reject:
        return 0x03;
      case FrameType.cancel:
        return 0x04;
      case FrameType.identity:
        return 0x05;
      case FrameType.identityAck:
        return 0x06;
      case FrameType.capability:
        return 0x07;
      case FrameType.chatMessage:
        return 0x10;
      case FrameType.chatAck:
        return 0x11;
      case FrameType.keepalive:
        return 0x20;
      case FrameType.keepaliveAck:
        return 0x21;
      case FrameType.close:
        return 0x22;
      case FrameType.profileUpdate:
        return 0x30;
      case FrameType.busy:
        return 0x31;
      case FrameType.versionMismatch:
        return 0x32;
      case FrameType.typingIndicator:
        return 0x40;
      case FrameType.readReceipt:
        return 0x41;
      case FrameType.reaction:
        return 0x42;
      case FrameType.fileTransfer:
        return 0x50;
      case FrameType.editMessage:
        return 0x51;
      case FrameType.deleteMessage:
        return 0x52;
      case FrameType.wipe:
        return 0x53;
      case FrameType.fileProbe:
        return 0x60;
      case FrameType.fileResume:
        return 0x61;
      case FrameType.fileComplete:
        return 0x62;
      case FrameType.fileCancel:
        return 0x63;
      case FrameType.ephemeralMedia:
        return 0x70;
      case FrameType.groupControl:
        return 0x80;
      case FrameType.groupMessage:
        return 0x81;
      case FrameType.error:
        return 0x90;
      case FrameType.meshRoute:
        return 0xA0;
      case FrameType.meshForward:
        return 0xA1;
    }
  }

  /// Decodes a numeric code to a [FrameType], or null if unknown.
  static FrameType? fromCode(int code) {
    return FrameType.values.firstWhere(
      (t) => t.code == code,
      orElse: () => throw ArgumentError('Unknown frame type code: 0x${code.toRadixString(16)}'),
    );
  }

  /// Human-readable label.
  String get label {
    switch (this) {
      case FrameType.request:
        return 'Connection Request';
      case FrameType.accept:
        return 'Connection Accept';
      case FrameType.reject:
        return 'Connection Reject';
      case FrameType.cancel:
        return 'Connection Cancel';
      case FrameType.identity:
        return 'Identity Exchange';
      case FrameType.identityAck:
        return 'Identity Ack';
      case FrameType.capability:
        return 'Capability';
      case FrameType.chatMessage:
        return 'Chat Message';
      case FrameType.chatAck:
        return 'Chat Ack';
      case FrameType.keepalive:
        return 'Keepalive';
      case FrameType.keepaliveAck:
        return 'Keepalive Ack';
      case FrameType.close:
        return 'Close';
      case FrameType.profileUpdate:
        return 'Profile Update';
      case FrameType.busy:
        return 'Busy';
      case FrameType.versionMismatch:
        return 'Version Mismatch';
      case FrameType.typingIndicator:
        return 'Typing Indicator';
      case FrameType.readReceipt:
        return 'Read Receipt';
      case FrameType.reaction:
        return 'Reaction';
      case FrameType.fileTransfer:
        return 'File Transfer';
      case FrameType.editMessage:
        return 'Edit Message';
      case FrameType.deleteMessage:
        return 'Delete Message';
      case FrameType.wipe:
        return 'Wipe';
      case FrameType.fileProbe:
        return 'File Probe';
      case FrameType.fileResume:
        return 'File Resume';
      case FrameType.fileComplete:
        return 'File Complete';
      case FrameType.fileCancel:
        return 'File Cancel';
      case FrameType.ephemeralMedia:
        return 'Ephemeral Media';
      case FrameType.groupControl:
        return 'Group Control';
      case FrameType.groupMessage:
        return 'Group Message';
      case FrameType.error:
        return 'Error';
      case FrameType.meshRoute:
        return 'Mesh Route';
      case FrameType.meshForward:
        return 'Mesh Forward';
    }
  }
}
