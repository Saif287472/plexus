/// The install-scoped identity of the local device.
///
/// Generated on first launch. The private key is encrypted at rest and never
/// leaves the device. The public key is shared with peers for end-to-end
/// encryption and trust establishment.
import '../value_objects/device_id.dart';
import '../value_objects/fingerprint.dart';

class Identity {
  /// Stable device identifier.
  final DeviceId deviceId;

  /// Public identity key (X25519), shared with peers.
  final String publicKey;

  /// Encrypted private key, stored at rest.
  final String encryptedPrivateKey;

  /// SHA-256 fingerprint of the public key.
  final Fingerprint fingerprint;

  /// User-chosen display name.
  final String displayName;

  /// Unix milliseconds when the identity was created.
  final int createdAt;

  /// Unix milliseconds when the identity was last updated.
  final int updatedAt;

  /// Unix milliseconds when the identity was soft-deleted, or null.
  final int? deletedAt;

  const Identity({
    required this.deviceId,
    required this.publicKey,
    required this.encryptedPrivateKey,
    required this.fingerprint,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Creates a copy with the given fields replaced.
  Identity copyWith({
    DeviceId? deviceId,
    String? publicKey,
    String? encryptedPrivateKey,
    Fingerprint? fingerprint,
    String? displayName,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Identity(
      deviceId: deviceId ?? this.deviceId,
      publicKey: publicKey ?? this.publicKey,
      encryptedPrivateKey: encryptedPrivateKey ?? this.encryptedPrivateKey,
      fingerprint: fingerprint ?? this.fingerprint,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() =>
      'Identity(deviceId: $deviceId, fingerprint: $fingerprint)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Identity &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId &&
          fingerprint == other.fingerprint;

  @override
  int get hashCode => Object.hash(deviceId, fingerprint);
}
