// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name2.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name2 {
  static Name2 _create(String? input) {
    /// 1. **Value Validation**
    return _verifyValue(input).match(
      (valueFailure) => InvalidName2._(valueFailure: valueFailure),

      /// 2. **→ Validations passed**
      (validValue) => ValidName2._(value: validValue),
    );
  }

  /// If the value is null, this holds a [ValueFailure] on the Left returned by
  /// [NullableValueObject.nullFailure]. Otherwise, holds the non-null value on
  /// the right.
  static Either<Name2ValueFailure, String> _verifyNullable(String? input) {
    if (input == null) {
      return left(const Name2._().nullFailure());
    }
    return right(input);
  }

  /// If the value is invalid, this holds the [ValueFailure] on the Left.
  /// Otherwise, holds the value on the Right.
  static Either<Name2ValueFailure, String> _verifyValue(String? input) {
    final nullablesVerification = _verifyNullable(input);

    final valueVerification = nullablesVerification.flatMap((nonNullValue) =>
        const Name2._()
            .validateValue(nonNullValue)
            .toEither(() => nonNullValue)
            .swap());

    return valueVerification;
  }

  /// If [nullableValueObject] is null, returns `right(null)`.
  /// Otherwise, returns `nullableValueObject.toBroadEither`.
  static Either<Failure, ValidName2?> toBroadEitherNullable(
          Name2? nullableValueObject) =>
      optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidName2 valid) valid,
    required TResult Function(InvalidName2 invalid) invalid,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this
  /// NullableValueObject : valid and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidName2 valid) valid,
    required TResult Function(InvalidName2 invalid) invalid,
  }) {
    return map(
      valid: valid,
      invalid: invalid,
    );
  }
}

class ValidName2 extends Name2 implements ValidValueObject<String> {
  const ValidName2._({required this.value}) : super._();

  @override
  final String value;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName2 valid) valid,
      required TResult Function(InvalidName2 invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [value];
}

class InvalidName2 extends Name2
    implements InvalidValueObject<String?, Name2ValueFailure> {
  const InvalidName2._({
    required this.valueFailure,
  }) : super._();

  @override
  final Name2ValueFailure valueFailure;

  @override
  Name2ValueFailure get failure => valueFailure;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName2 valid) valid,
      required TResult Function(InvalidName2 invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get allProps => [failure];
}
