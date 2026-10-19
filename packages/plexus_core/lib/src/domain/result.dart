/// The result of an operation that can succeed or fail.
///
/// Plexus uses `Result<T, E>` across all layer boundaries instead of throwing
/// exceptions. This makes failure modes explicit, typed, and recoverable.
///
/// ```dart
/// final result = await messageRepository.save(message);
/// result.when(
///   success: (message) => print('saved ${message.id}'),
///   failure: (failure) => handle(failure),
/// );
/// ```
import 'failures/failure.dart';

abstract class Result<T, E extends Failure> {
  const Result();

  /// Returns true if this result is a success.
  bool get isSuccess;

  /// Returns true if this result is a failure.
  bool get isFailure;

  /// Executes [onSuccess] with the value if this is a success,
  /// or [onFailure] with the error if this is a failure.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(E failure) onFailure,
  });

  /// Maps the success value through [transform], keeping the failure as-is.
  Result<R, E> map<R>(R Function(T value) transform);

  /// Flat-maps: if success, applies [transform] which returns another [Result];
  /// if failure, passes through.
  Result<R2, E> flatMap<R2>(
    Result<R2, E> Function(T value) transform,
  );
}

/// A successful result carrying a value of type [T].
class Success<T, E extends Failure> implements Result<T, E> {
  final T value;

  const Success(this.value);

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(E failure) onFailure,
  }) {
    return onSuccess(value);
  }

  @override
  Result<R, E> map<R>(R Function(T value) transform) {
    return Success(transform(value));
  }

  @override
  Result<R2, E> flatMap<R2>(
    Result<R2, E> Function(T value) transform,
  ) {
    return transform(value);
  }

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A failed result carrying a typed [Failure].
class FailureResult<T, E extends Failure> implements Result<T, E> {
  final E failure;

  const FailureResult(this.failure);

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(E failure) onFailure,
  }) {
    return onFailure(failure);
  }

  @override
  Result<R, E> map<R>(R Function(T value) transform) {
    return FailureResult(failure);
  }

  @override
  Result<R2, E> flatMap<R2>(
    Result<R2, E> Function(T value) transform,
  ) {
    return FailureResult(failure);
  }

  @override
  String toString() => 'Failure($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T, E> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;
}

/// Convenience constructor for a successful result.
Result<T, E> ok<T, E extends Failure>(T value) => Success<T, E>(value);

/// Convenience constructor for a failed result.
Result<T, E> err<T, E extends Failure>(E failure) =>
    FailureResult<T, E>(failure);
