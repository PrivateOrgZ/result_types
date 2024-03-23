library c_result;

sealed class CResult<Value, Error> {
  factory CResult.ok(Value value) = COk<Value, Error>;
  factory CResult.err(Error error) = CErr<Value, Error>;

  /// Constructs a [CResult] from a dynamic value
  /// If the value is [CResult] it will return the value itself
  /// If the value is [Value] it will return [COk]
  /// If the value is [Error] it will return [CErr]
  factory CResult.from(dynamic value) {
    if (value is CResult<Value, Error>) {
      return value;
    } else if (value is Value) {
      return COk(value);
    } else if (value is Error) {
      return CErr(value);
    } else {
      throw UnimplementedError();
    }
  }

  /// Returns the value if it is [COk] or throws an error if it is [CErr]
  /// Convinient operator to get the value from the result,
  /// user should ensure that the result is [COk], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = CResult<int, String>.from(1);
  /// final val = res | 0;
  /// assert(val == 1);
  Value operator |(a) => this | a;

  /// Returns the error if it is [CErr] or throws an error if it is [COk]
  /// Convinient operator to get the error from the result,
  /// user should ensure that the result is [CErr], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = CResult<int, String>.from('error');
  /// final err = res / 0;
  /// assert(err == 'error');
  Error operator /(a) => this / a;
}

class COk<Value, Error> implements CResult<Value, Error> {
  final Value value;
  const COk(this.value);

  @override
  Value operator |(_) => value;

  @override
  Error operator /(a) => throw UnimplementedError();
}

class CErr<Value, Error> implements CResult<Value, Error> {
  final Error error;
  const CErr(this.error);

  @override
  Value operator |(_) => throw UnimplementedError();

  @override
  Error operator /(a) => error;
}
