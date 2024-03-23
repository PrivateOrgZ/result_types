# Result Types

This package provides a set of types - `CResult`, `IResult`, `TResult`, and `Option` - inspired by the `Result` and `Option` types in the Rust programming language. These types are designed to help you handle errors and nullability in a more structured and predictable way, making your Dart code safer and more robust.


## Getting Started

### Prerequisites

`Dart SDK: '>=3.0.0 <4.0.0'`

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  result_types: ^0.0.3
```

```
flutter pub get
```

### Usage

#### CResult Usage
```dart
sealed class CError {}

class TestError extends CError {}

final result = CResult<int, CError>.from(1);
expect(result, isA<COk<int, CError>>());
expect((result as COk).value, 1);

final result2 = CResult<int, CError>.from(TestError());
expect(result2, isA<CErr>());
expect((result2 as CErr).error, isA<TestError>());

final result3 = CResult<int, CError>.from(UnimplementedError());
expect(result3, isA<CErr>());
expect((result3 as CErr).error, isA<UnimplementedError>());
```

#### Option Usage
```dart
final result = Option<int>.from(1);
expect(result, isA<Some<int>>());
expect((result as Some).value, 1);

final result2 = Option<int>.from(0);
expect(result2, isA<Some<int>>());
expect((result2 as Some).value, 0);

final result3 = Option.none();
expect(result3, isA<None>());

final result4 = ~Option.from(1);
expect(result4, 1);

final result5 = ~Option.none();
expect(result5, isA<None>());
```

More Examples are available in respective tests for each type.