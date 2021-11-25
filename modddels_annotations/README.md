<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

# Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

# Getting started

You should have these packages installed :
- fpdart
- freezed

# Usage

## Value objects :

1. Create a ValueObject, and annotate it with `@modddel`

```dart
@modddel
class Name extends ValueObject<String, NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name(String input) {
    return $Name._create(input);
  }

  const Name._();

  @override
  Option<NameValueFailure> validate(String input) {
    // TODO: implement validate
    return none();
  }
}
```

2. Create a Freezed ValueFailure for your ValueObject

```dart
@freezed
class NameValueFailure extends ValueFailure<String> with _$NameValueFailure {
  const factory NameValueFailure.empty({
    required String failedValue,
  }) = _Empty;
}
```

3. Add the part statements

```dart
part 'name.g.dart';
part 'name.freezed.dart';
```

4. Implement the `validate` method :

```dart
  @override
  Option<NameValueFailure> validate(String input) {
    if (input.isEmpty) {
        return some(NameValueFailure.empty(failedValue: input));
    }
    return none();
  }
```

5. Run the generator

## Entities :

1. Create an Entity, and annotate it with `@modddel`

```dart
@modddel
class FullName extends Entity<FullNameEntityFailure, InvalidFullNameGeneral,
    InvalidFullNameContent, InvalidFullName, ValidFullName> with $FullName {
  factory FullName({
    required Name firstName,
    required Name lastName,
  }) {
    return $FullName._create(
      firstName: firstName,
      lastName: lastName,
    );
  }

  const FullName._();

  @override
  Option<FullNameEntityFailure> validateGeneral(ValidFullName valid) {
    // TODO: implement validate
    return none();
  }
}
```

2. Create a Freezed GeneralEntityFailure for your Entity

```dart
@freezed
class FullNameEntityFailure extends GeneralEntityFailure with _$FullNameEntityFailure {
  const factory FullNameEntityFailure.tooLong() = _TooLong;
}
```

3. Add the part statements

```dart
part 'fullname.g.dart';
part 'fullname.freezed.dart';
```

4. Implement the `validate` method :

```dart
  @override
  Option<FullNameEntityFailure> validateGeneral(ValidFullName valid) {
    if (valid.firstName.value.length + valid.lastName.value.length > 30) {
      return some(const FullNameEntityFailure.tooLong());
    }
    return none();
  }
```

5. Run the generator

### The valid annotation

Sometimes, you want an entity to contain a model that is always valid, or a parameter that isn't a model and that should considered as being valid. For example : a ValidValueObject, a ValidEntity, a boolean...

In that case, you can annotate it with `@valid`. Example :

```dart
factory FullName({
    required Name firstName,
    required Name lastName,
    @valid required bool hasMiddleName,
  }) { ...
```

NB : You can create a ValidValueObject or a ValidEntity by directly extending respectively the class ValidValueObject or ValidEntity.

### Optional and Nullable types

The Entity supports containing optional and nullable parameters, as well as default values.

# Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
