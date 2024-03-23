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

  /// Returns the value if it is [COk] or throws an error if it is [CErr]
  /// Convinient operator to get the value from the result,
  /// user should ensure that the result is [COk], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// ```
  /// final res = CResult<int, String>.from(1);
  /// final val = res | 0;
  /// assert(val == 1);
  /// ```
  Value operator |(a) => this | a;

  /// Returns the error if it is [CErr] or throws an error if it is [COk]
  /// Convinient operator to get the error from the result,
  /// user should ensure that the result is [CErr], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// ```
  /// final res = CResult<int, String>.from('error');
  /// final err = res / 0;
  /// assert(err == 'error');
  /// ```
  Error operator /(a) => this / a;
}

class IOk<Value> implements IResult<Value> {
  final Value value;
  const IOk(this.value);

  @override
  Value operator |(_) => value;

  @override
  Error operator /(a) => throw UnimplementedError();
}

class IErr<Value> implements IResult<Value> {
  final IError error;
  const IErr(this.error);

  factory IErr.from(IErrorType type) {
    return IErr(type.from(type));
  }

  @override
  Value operator |(_) => throw UnimplementedError();

  @override
  Error operator /(a) => error;
}
