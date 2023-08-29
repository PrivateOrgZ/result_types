library c_result;

sealed class CResult<Value, Error> {
  factory CResult.ok(Value value) = COk<Value, Error>;
  factory CResult.err(Error error) = CErr<Value, Error>;

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
}

class COk<Value, Error> implements CResult<Value, Error> {
  final Value value;
  const COk(this.value);
}

class CErr<Value, Error> implements CResult<Value, Error> {
  final Error error;
  const CErr(this.error);
}
