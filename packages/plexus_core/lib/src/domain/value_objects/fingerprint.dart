/// A peer's identity fingerprint — SHA-256 of their public key, hex-encoded.
///
/// Fingerprints are exchanged out-of-band (QR code or verification phrase)
/// to establish trust. They are displayed to users in groups of 4 characters
/// separated by spaces for readability.
import '../failures/validation_failure.dart';

class Fingerprint {
  /// The lowercase hex-encoded fingerprint (64 characters).
  final String value;

  const Fingerprint._(this.value);

  factory Fingerprint(String value) {
    final cleaned = value.toLowerCase().trim().replaceAll(' ', '');
    if (cleaned.length != 64 || !RegExp(r'^[0-9a-f]{64}$').hasMatch(cleaned)) {
      throw ValidationFailure(
        message: 'Invalid fingerprint: must be a 64-character hex string.',
        code: 'invalid_fingerprint',
      );
    }
    return Fingerprint._(cleaned);
  }

  /// Returns the fingerprint formatted for display (groups of 4, space-separated).
  String get display {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i += 4) {
      if (i > 0) buffer.write(' ');
      buffer.write(value.substring(i, i + 4));
    }
    return buffer.toString();
  }

  @override
  String toString() => 'Fingerprint($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Fingerprint && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
