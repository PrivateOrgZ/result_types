library t_result;

abstract class TError {
  TError from(dynamic value);
}

abstract class TResult<Value> {
  factory TResult.ok(Value value) = TOk<Value>;
  factory TResult.err(TError error) = TErr<Value>;

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
}

class TOk<Value> implements TResult<Value> {
  final Value value;
  const TOk(this.value);
}

class TErr<Value> implements TResult<Value> {
  final TError error;
  const TErr(this.error);

  factory TErr.from(TError type) {
    return TErr(type.from(type));
  }
}
