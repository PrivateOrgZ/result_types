library option;

sealed class Option<Value> {
  factory Option.ok(Value value) = Some<Value>;
  factory Option.none() = None;

  /// Constructs a [Option] from a dynamic value
  /// If the value is [Option] it will return the value itself
  /// If the value is [Value] it will return [Some<Value>]
  /// otherwise returns [None]
  factory Option.from(dynamic value) {
    if (value is Option<Value>) {
      return value;
    } else if (value is Value) {
      return Some(value);
    } else {
      return const None();
    }
  }

  /// Returns the [Value] if it is [Some] or throws an error if it is [None]
  /// Convinient operator to get the value from the result,
  /// user should ensure that the result is [Some], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = Option<int>.from(1);
  /// final val = res | 0;
  /// assert(val == 1);
  Value operator |(a) => this | a;

  /// Returns [None] or throws an error if it is [Some]
  /// Convinient operator to get the error from the result,
  /// user should ensure that the value is [None], otherwise it will throw an [UnimplementedError]
  /// Usage:
  /// final res = Option.none();
  /// final err = res / 0;
  /// assert(err is None);
  dynamic operator /(a) => this / a;
}

class Some<Value> implements Option<Value> {
  final Value value;
  const Some(this.value);

  @override
  Value operator |(_) => value;

  @override
  operator /(a) => throw UnimplementedError();
}

class None<T> implements Option<T> {
  const None();

  @override
  T operator |(_) => throw UnimplementedError();

  @override
  operator /(a) => 1;
}
