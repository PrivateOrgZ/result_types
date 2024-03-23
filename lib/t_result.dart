library t_result;

abstract class TError extends Error {
  TError from(dynamic value);
}

sealed class TResult<Value> {
  factory TResult.ok(Value value) = TOk<Value>;
  factory TResult.err(TError error) = TErr<Value>;

  /// Constructs a [TResult] from a dynamic value
  /// If the value is [TResult] it will return the value itself
  /// If the value is [Value] it will return [TOk]
  /// otherwise returns [TErr]
  /// Usage:
  /// ```
  /// final res = TResult<int>.from(1);
  /// assert(res is TOk<int>);
  /// assert((res as TOk).value == 1);
  /// ```
  ///
  /// Error Usage:
  /// ```
  /// class TestError extends TError {
  ///   @override
  ///   TError from(dynamic value) {
  ///    return TestError();
  ///   }
  /// }
  /// final res = TResult<int>.from(TestError());
  /// assert(res is TErr);
  /// assert((res as TErr).error is TestError);
  /// ```
  factory TResult.from(dynamic value) {
    if (value is TResult<Value>) {
      return value;
    } else if (value is Value) {
      return TOk(value);
    } else if (value is TError) {
      return TErr(value);
    } else {
      throw UnimplementedError();
    }
  }

  /// Returns the value if it is [TOk] or throws an error if it is [TErr]
  /// Convinient operator to get the value from the result,
  /// user should ensure that the result is [TOk], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = TResult<int>.from(1);
  /// final val = res | 0;
  /// assert(val == 1);
  Value operator |(a) => this | a;

  /// Returns the error if it is [CErr] or throws an error if it is [COk]
  /// Convinient operator to get the error from the result,
  /// user should ensure that the result is [CErr], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = TResult<int>.from(CustomError());
  /// final err = res / 0;
  /// assert(err is CustomError);
  Error operator /(a) => this / a;
}

class TOk<Value> implements TResult<Value> {
  final Value value;
  const TOk(this.value);

  @override
  Value operator |(_) => value;

  @override
  Error operator /(a) => throw UnimplementedError();
}

class TErr<Value> implements TResult<Value> {
  final TError error;
  const TErr(this.error);

  factory TErr.from(TError type) {
    return TErr(type.from(type));
  }

  @override
  Value operator |(_) => throw UnimplementedError();

  @override
  Error operator /(a) => error;
}
