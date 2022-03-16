// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name {
  static Name _create(String? input) {
    /// 1. **Value Validation**
    return _verifyValue(input).match(
      (valueFailure) => InvalidName._(
        valueFailure: valueFailure,
        failedValue: input,
      ),

      /// 2. **→ Validations passed**
      (validValue) => ValidName._(value: validValue),
    );
  }

  /// If the value is invalid, this holds the [ValueFailure] on the Left.
  /// Otherwise, holds the value on the Right.
  static Either<NameValueFailure, String> _verifyValue(String? input) {
    final nullableVerification = _verifyNullable(input);

    final valueVerification = nullableVerification.flatMap((nonNullableInput) =>
        const Name._()
            .validateValue(ValidName._(value: nonNullableInput))
            .toEither(() => nonNullableInput)
            .swap());

    return valueVerification;
  }

  /// If the value is marked with `@NullFailure` and it's null, this holds a
  /// [ValueFailure] on the Left. Otherwise, holds the non-nullable value on the
  /// Right.
  static Either<NameValueFailure, String> _verifyNullable(String? input) {
    if (input == null) {
      return left(const NameValueFailure.none());
    }

    return right(input);
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

class ValidName extends Name implements ValidSingleValueObject<String?> {
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
    implements InvalidSingleValueObject<String?, NameValueFailure> {
  const InvalidName._({
    required this.valueFailure,
    required this.failedValue,
  }) : super._();

  @override
  final NameValueFailure valueFailure;

  @override
  final String? failedValue;

  @override
  NameValueFailure get failure => valueFailure;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get props => [valueFailure, failedValue];
}

class NameTester extends ValueObjectTester<NameValueFailure, InvalidName,
    ValidName, Name, _NameInput> {
  const NameTester({
    int maxSutDescriptionLength = 100,
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isValidGroupDescription = 'Should be a ValidName',
    String isInvalidValueGroupDescription =
        'Should be an InvalidName and hold the NameValueFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidValueGroupDescription: isInvalidValueGroupDescription,
        );

  final makeInput = _NameInput.new;
}

class _NameInput extends ModddelInput<Name> {
  const _NameInput(this.input);

  final String? input;

  @override
  List<Object?> get props => [input];

  @override
  _NameInput get sanitizedInput {
    final modddel = Name(input);
    final modddelValue = modddel.mapValidity(
        valid: (v) => v.value, invalid: (i) => i.failedValue);

    return _NameInput(modddelValue);
  }
}
