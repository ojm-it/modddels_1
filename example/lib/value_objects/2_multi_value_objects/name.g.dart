// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name {
  static Name _create({
    required String firstName,
    required String? lastName,
    required bool? hasMiddleName,
  }) {
    /// 1. **Value Validation**
    return _verifyValue(_NameHolder._(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    )).match(
      (valueFailure) => InvalidName._(
        valueFailure: valueFailure,
        firstName: firstName,
        lastName: lastName,
        hasMiddleName: hasMiddleName,
      ),

      /// 2. **→ Validations passed**
      (validValueObject) => validValueObject,
    );
  }

  /// If the value is invalid, this holds the [ValueFailure] on the Left.
  /// Otherwise, holds the [ValidValueObject] on the Right.
  static Either<NameValueFailure, ValidName> _verifyValue(
      _NameHolder valueObject) {
    final nullablesVerification = valueObject.verifyNullables();

    final valueVerification = nullablesVerification.flatMap(
        (validValueObject) => const Name._()
            .validateValue(validValueObject)
            .toEither(() => validValueObject)
            .swap());

    return valueVerification;
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

class _NameHolder {
  const _NameHolder._({
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  });

  final String firstName;
  final String? lastName;
  final bool? hasMiddleName;

  /// If one of the nullable fields marked with `@NullFailure` is null, this
  /// holds a [ValueFailure] on the Left. Otherwise, holds the
  /// [ValidValueObject] on the Right.
  Either<NameValueFailure, ValidName> verifyNullables() {
    final lastName = this.lastName;
    if (lastName == null) {
      return left(const NameValueFailure.incomplete());
    }

    return right(ValidName._(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    ));
  }
}

class ValidName extends Name implements ValidValueObject {
  const ValidName._({
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  final String firstName;
  final String lastName;
  final bool? hasMiddleName;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        hasMiddleName,
      ];
}

class InvalidName extends Name implements InvalidValueObject<NameValueFailure> {
  const InvalidName._({
    required this.valueFailure,
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  @override
  final NameValueFailure valueFailure;

  @override
  NameValueFailure get failure => valueFailure;

  final String firstName;
  final String? lastName;
  final bool? hasMiddleName;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get props => [
        valueFailure,
        firstName,
        lastName,
        hasMiddleName,
      ];
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
  const _NameInput({
    required this.firstName,
    required this.lastName,
    this.hasMiddleName = false,
  });

  final String firstName;
  final String? lastName;
  final bool? hasMiddleName;
  @override
  List<Object?> get props => [
        firstName,
        lastName,
        hasMiddleName,
      ];

  @override
  _NameInput get sanitizedInput {
    final modddel = Name(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    );

    return _NameInput(
      firstName: modddel.mapValidity(
          valid: (v) => v.firstName, invalid: (i) => i.firstName),
      lastName: modddel.mapValidity(
          valid: (v) => v.lastName, invalid: (i) => i.lastName),
      hasMiddleName: modddel.mapValidity(
          valid: (v) => v.hasMiddleName, invalid: (i) => i.hasMiddleName),
    );
  }
}