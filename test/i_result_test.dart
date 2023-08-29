import 'package:flutter_test/flutter_test.dart';

import 'package:result_types/result_types.dart';

class TestError implements IError {}

class UnimplementedError implements IError {}

enum ErrorType implements IErrorType {
  testError,
  unimplementedError;

  @override
  IError from(dynamic value) {
    switch (this) {
      case ErrorType.testError:
        return TestError();
      case ErrorType.unimplementedError:
        return UnimplementedError();
    }
  }
}

IResult<int> testFunction(int value) {
  if (value == 0) {
    return IResult.from(1);
  } else if (value == 1) {
    return IResult.from(TestError());
  } else {
    return IResult.from(UnimplementedError());
  }
}

IResult<int> testFunctionErr(ErrorType value) => IErr.from(value);

ErrorType testFunctionErrExhastiveness(ErrorType value) {
  switch (value) {
    case ErrorType.testError:
      return ErrorType.testError;
    case ErrorType.unimplementedError:
      return ErrorType.unimplementedError;
  }
}

void main() {
  test('adds one to input values', () {
    final result = IResult<int>.from(1);
    expect(result, isA<IOk<int>>());
    expect((result as IOk<int>).value, 1);

    final result2 = IResult<int>.from(TestError());
    expect(result2, isA<IErr>());
    expect((result2 as IErr).error, isA<TestError>());

    final result3 = IResult<int>.from(UnimplementedError());
    expect(result3, isA<IErr>());
    expect((result3 as IErr).error, isA<UnimplementedError>());

    final result4 = testFunction(0);
    expect(result4, isA<IOk<int>>());
    expect((result4 as IOk<int>).value, 1);

    final result5 = testFunction(1);
    expect(result5, isA<IErr>());
    expect((result5 as IErr).error, isA<TestError>());

    final result6 = testFunction(2);
    expect(result6, isA<IErr>());
    expect((result6 as IErr).error, isA<UnimplementedError>());
  });

  test('test exhaustiveness', () {
    final result = testFunctionErrExhastiveness(ErrorType.testError);
    expect(result, ErrorType.testError);

    final result2 = testFunctionErrExhastiveness(ErrorType.unimplementedError);
    expect(result2, ErrorType.unimplementedError);
  });
}
