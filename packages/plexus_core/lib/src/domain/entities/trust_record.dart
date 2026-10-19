/// A trust record for a peer, documenting how and when trust was established.
import '../value_objects/peer_id.dart';
import '../value_objects/fingerprint.dart';

class TrustRecord {
  /// Database ID (primary key).
  final int id;

  /// The peer this record belongs to.
  final PeerId peerId;

  /// The verified fingerprint of the peer.
  final Fingerprint fingerprint;

  /// How trust was established.
  final VerificationMethod verificationMethod;

  /// Unix milliseconds when trust was established.
  final int verifiedAt;

  /// Unix milliseconds when trust was revoked, or null.
  final int? revokedAt;

  /// Unix milliseconds when created.
  final int createdAt;

  const TrustRecord({
    required this.id,
    required this.peerId,
    required this.fingerprint,
    required this.verificationMethod,
    required this.verifiedAt,
    this.revokedAt,
    required this.createdAt,
  });

  TrustRecord copyWith({
    int? id,
    PeerId? peerId,
    Fingerprint? fingerprint,
    VerificationMethod? verificationMethod,
    int? verifiedAt,
    int? revokedAt,
    int? createdAt,
  }) {
    return TrustRecord(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      fingerprint: fingerprint ?? this.fingerprint,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Whether this trust record is currently active (not revoked).
  bool get isActive => revokedAt == null;

  @override
  String toString() => 'TrustRecord(peerId: $peerId, active: $isActive)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TrustRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// How trust was established for a peer.
enum VerificationMethod {
  /// QR code scan.
  qr,

  /// Manual verification phrase comparison.
  phrase,

  /// Manual entry without out-of-band verification.
  manual,
}
