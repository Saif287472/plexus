/// Capability flags advertised by peers during capability negotiation.
///
/// These flags tell other peers what features this device supports.
enum CapabilityFlag {
  /// Can transfer files.
  fileTransfer,

  /// Can make/receive calls.
  calls,

  /// Can act as a mesh relay (store-and-forward).
  meshRelay,

  /// Can host a rendezvous connection.
  rendezvous,
}

extension CapabilityFlagX on CapabilityFlag {
  int get bit {
    switch (this) {
      case CapabilityFlag.fileTransfer:
        return 0x01;
      case CapabilityFlag.calls:
        return 0x02;
      case CapabilityFlag.meshRelay:
        return 0x04;
      case CapabilityFlag.rendezvous:
        return 0x08;
    }
  }
}

/// A set of capability flags with helper methods.
class CapabilityFlags {
  final Set<CapabilityFlag> flags;

  const CapabilityFlags({this.flags = const {}});

  /// Whether all [required] flags are present.
  bool hasAll(Set<CapabilityFlag> required) =>
      required.every((f) => flags.contains(f));

  /// Whether any of [anyOf] flags are present.
  bool hasAny(Set<CapabilityFlag> anyOf) =>
      anyOf.any((f) => flags.contains(f));

  /// Bitmask integer for wire encoding.
  int get bitmask {
    int result = 0;
    for (final flag in flags) {
      result |= flag.bit;
    }
    return result;
  }

  /// Creates [CapabilityFlags] from a bitmask integer.
  static CapabilityFlags fromBitmask(int bitmask) {
    final flags = <CapabilityFlag>{};
    for (final flag in CapabilityFlag.values) {
      if (bitmask & flag.bit != 0) {
        flags.add(flag);
      }
    }
    return CapabilityFlags(flags: flags);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CapabilityFlags && other.flags == flags;

  @override
  int get hashCode => flags.hashCode;
}
