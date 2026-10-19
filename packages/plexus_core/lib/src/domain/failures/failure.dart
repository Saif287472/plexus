/// Base class for all typed failures in Plexus.
///
/// Failures are immutable value objects that carry enough context for the
/// presentation layer to render a user-visible message without exposing
/// implementation details.
abstract class Failure {
  /// A human-readable message suitable for display to the user.
  final String message;

  /// An optional machine-readable code for programmatic handling.
  final String? code;

  /// Whether this failure is transient (retryable) or permanent.
  final bool isRetryable;

  const Failure({
    required this.message,
    this.code,
    this.isRetryable = false,
  });

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (code: $code)' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code &&
          isRetryable == other.isRetryable;

  @override
  int get hashCode => Object.hash(runtimeType, message, code, isRetryable);
}
