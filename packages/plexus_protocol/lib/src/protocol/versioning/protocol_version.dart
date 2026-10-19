/// Protocol version management.
///
/// Plexus uses semantic versioning for its wire protocol. Peers must
/// agree on a compatible version before exchanging messages.
class ProtocolVersion {
  final int major;
  final int minor;
  final int patch;

  const ProtocolVersion({required this.major, required this.minor, required this.patch});

  /// Current protocol version.
  static const ProtocolVersion current = ProtocolVersion(
    major: 1,
    minor: 0,
    patch: 0,
  );

  /// Integer representation for wire encoding (major * 10000 + minor * 100 + patch).
  int get code => major * 10000 + minor * 100 + patch;

  /// Whether this version is compatible with [other].
  /// Same major version is compatible; minor/patch differences are acceptable.
  bool isCompatibleWith(ProtocolVersion other) => major == other.major;

  @override
  String toString() => '$major.$minor.$patch';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolVersion &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  /// Parses an integer code back to a [ProtocolVersion].
  static ProtocolVersion fromCode(int code) {
    final major = code ~/ 10000;
    final minor = (code % 10000) ~/ 100;
    final patch = code % 100;
    return ProtocolVersion(major: major, minor: minor, patch: patch);
  }
}
