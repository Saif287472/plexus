/// Immutable identifier for a peer (device) in the Plexus network.
///
/// A `PeerId` is the SHA-256 fingerprint of the peer's public identity key,
/// represented as a lowercase hex string. It is globally unique within the
/// mesh and never changes unless the peer resets their identity.
import '../failures/validation_failure.dart';

class PeerId {
  /// The lowercase hex-encoded fingerprint (64 characters).
  final String value;

  const PeerId._(this.value);

  /// Creates a [PeerId] from a hex string.
  ///
  /// Throws [ValidationFailure] if the string is not exactly 64 hex characters.
  factory PeerId(String value) {
    final cleaned = value.toLowerCase().trim();
    if (cleaned.length != 64 || !RegExp(r'^[0-9a-f]{64}$').hasMatch(cleaned)) {
      throw ValidationFailure(
        message: 'Invalid peer ID: must be a 64-character hex string.',
        code: 'invalid_peer_id',
      );
    }
    return PeerId._(cleaned);
  }

  /// Creates a [PeerId] from raw bytes (SHA-256 digest).
  factory PeerId.fromBytes(List<int> bytes) {
    return PeerId._(
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
    );
  }

  @override
  String toString() => 'PeerId($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PeerId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
