library i_result;

abstract class IError extends Error {}

abstract class IErrorType {
  IError from(dynamic value);
}

/// A result type that can be either a value or a error that implements [IError].
///
sealed class IResult<Value> {
  factory IResult.ok(Value value) = IOk<Value>;
  factory IResult.err(IError error) = IErr<Value>;

  /// Constructs a [IResult] from a dynamic value
  /// If the value is [IResult] it will return the value itself
  /// If the value is [Value] it will return [IOk]
  /// otherwise returns [IErr]
  /// Usage:
  /// ```
  /// final res = IResult<int>.from(1);
  /// assert(res is IOk<int>);
  /// assert((res as IOk).value == 1);
  /// ```
  /// Error Usage:
  /// ```
  /// class TestError extends IError {}
  /// final res = IResult<int>.from(TestError());
  /// assert(res is IErr);
  /// assert((res as IErr).error is TestError);
  /// ```
  factory IResult.from(dynamic value) {
    if (value is IResult<Value>) {
      return value;
    } else if (value is Value) {
      return IOk(value);
    } else if (value is IError) {
      return IErr(value);
    } else {
      throw UnimplementedError();
    }
  }
}

class IOk<Value> implements IResult<Value> {
  final Value value;
  const IOk(this.value);
}

class IErr<Value> implements IResult<Value> {
  final IError error;
  const IErr(this.error);

  factory IErr.from(IErrorType type) {
    return IErr(type.from(type));
  }
}
