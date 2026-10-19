/// Stable identifier for the local device, generated on first launch.
///
/// Used as part of the key derivation for at-rest encryption and as the
/// anchor for the install-scoped identity keypair.
import '../failures/validation_failure.dart';

class DeviceId {
  final String value;

  const DeviceId._(this.value);

  factory DeviceId(String value) {
    if (value.isEmpty) {
      throw ValidationFailure(
        message: 'Device ID cannot be empty.',
        code: 'invalid_device_id',
      );
    }
    return DeviceId._(value);
  }

  @override
  String toString() => 'DeviceId($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DeviceId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
