// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name {
  static Name _create(String input) {
    /// 1. **Value Validation**
    return _verifyValue(input).match(
      (valueFailure) => InvalidName._(failure: valueFailure),

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
  List<Object?> get allProps => [value];
}

class InvalidName extends Name
    implements InvalidValueObject<String, NameValueFailure> {
  const InvalidName._({
    required this.failure,
  }) : super._();

  @override
  final NameValueFailure failure;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get allProps => [failure];
}
