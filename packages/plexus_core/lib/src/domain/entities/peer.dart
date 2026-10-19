/// A known or trusted peer in the Plexus network.
///
/// Peers are discovered via mDNS, BLE, DNS-SD, or direct IP. Trust is
/// established via out-of-band fingerprint verification.
import '../value_objects/peer_id.dart';

class Peer {
  /// Unique peer identifier (fingerprint of public key).
  final PeerId peerId;

  /// Display name (phone-book name, nickname, or number).
  final String? displayName;

  /// Current trust level.
  final TrustLevel trustLevel;

  /// Whether the fingerprint has been verified out-of-band.
  final bool fingerprintVerified;

  /// Last time this peer was seen (Unix ms), or null if never.
  final int? lastSeenAt;

  /// Unix milliseconds when the peer record was created.
  final int createdAt;

  /// Unix milliseconds when the peer record was last updated.
  final int updatedAt;

  /// Unix milliseconds when the peer record was soft-deleted, or null.
  final int? deletedAt;

  const Peer({
    required this.peerId,
    this.displayName,
    required this.trustLevel,
    required this.fingerprintVerified,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Peer copyWith({
    PeerId? peerId,
    String? displayName,
    TrustLevel? trustLevel,
    bool? fingerprintVerified,
    int? lastSeenAt,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Peer(
      peerId: peerId ?? this.peerId,
      displayName: displayName ?? this.displayName,
      trustLevel: trustLevel ?? this.trustLevel,
      fingerprintVerified: fingerprintVerified ?? this.fingerprintVerified,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Whether this peer is trusted and can be messaged.
  bool get isTrusted => trustLevel == TrustLevel.trusted && fingerprintVerified;

  @override
  String toString() => 'Peer(peerId: $peerId, trustLevel: $trustLevel)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Peer && other.peerId == peerId;

  @override
  int get hashCode => peerId.hashCode;
}

/// Trust level for a peer.
enum TrustLevel {
  /// Unknown / not yet verified.
  unknown,

  /// Trusted via fingerprint verification.
  trusted,

  /// Blocked; messages from this peer are not decrypted.
  blocked,
}
