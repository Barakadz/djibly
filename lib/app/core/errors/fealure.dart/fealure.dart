/// Represents a failure in the application.
class Failure {
  /// The error message describing the failure.
  final String message;

  /// Creates a new [Failure] instance.
  ///
  /// The [message] parameter is required and cannot be null.
  const Failure({this.message});

  @override
  String toString() => 'Failure: $message';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
