// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name {
  static Name _create(String input) {
    /// 1. **Value Validation**
    return _verifyValue(input).match(
      (valueFailure) => InvalidName._(valueFailure: valueFailure),

      /// 2. **→ Validations passed**
      (validValue) => ValidName._(value: validValue),
    );
  }

  /// If the value is invalid, this holds the [ValueFailure] on the Left.
  /// Otherwise, holds the value on the Right.
  static Either<NameValueFailure, String> _verifyValue(String input) {
    final valueVerification = const Name._().validateValue(input);
    return valueVerification.toEither(() => input).swap();
  }

  /// If [nullableValueObject] is null, returns `right(null)`.
  /// Otherwise, returns `nullableValueObject.toBroadEither`.
  static Either<Failure, ValidName?> toBroadEitherNullable(
          Name? nullableValueObject) =>
      optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidName valid) valid,
    required TResult Function(InvalidName invalid) invalid,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this ValueObject :
  /// valid and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidName valid) valid,
    required TResult Function(InvalidName invalid) invalid,
  }) {
    return map(
      valid: valid,
      invalid: invalid,
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidName extends Name implements ValidValueObject<String> {
  const ValidName._({required this.value}) : super._();

  @override
  final String value;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get props => [value];
}

class InvalidName extends Name
    implements InvalidValueObject<String, NameValueFailure> {
  const InvalidName._({
    required this.valueFailure,
  }) : super._();

  @override
  final NameValueFailure valueFailure;

  @override
  NameValueFailure get failure => valueFailure;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get props => [failure];
}

class NameTester extends ValueObjectTester<String, NameValueFailure,
    InvalidName, ValidName, Name> {
  NameTester({
    int maxSutDescriptionLength = 100,
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isInvalidGroupDescription =
        'Should be an InvalidName and hold the NameValueFailure',
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isValidGroupDescription = 'Should be a ValidName',
  }) : super(
          (input) => Name(input),
          maxSutDescriptionLength: maxSutDescriptionLength,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isInvalidGroupDescription: isInvalidGroupDescription,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
        );
}
