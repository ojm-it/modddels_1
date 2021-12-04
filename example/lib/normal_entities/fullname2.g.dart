// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname2.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullName2 {
  static FullName2 _create({
    required Name firstName,
    required Name lastName,
    required bool hasMiddleName,
  }) {
    final contentVerification = firstName.toBroadEither.flatMap(
      (validFirstName) => lastName.toBroadEither.flatMap(
        (validLastName) => right(ValidFullName2._(
          firstName: validFirstName,
          lastName: validLastName,
          hasMiddleName: hasMiddleName,
        )),
      ),
    );

    return contentVerification.match(
      ///The content is invalid
      (contentFailure) => InvalidFullName2Content._(
        contentFailure: contentFailure,
        firstName: firstName,
        lastName: lastName,
        hasMiddleName: hasMiddleName,
      ),

      ///The content is valid => The entity is valid
      (validContent) => validContent,
    );
  }

  Name get firstName => match(
        valid: (valid) => valid.firstName,
        invalid: (invalid) => invalid.firstName,
      );

  Name get lastName => match(
        valid: (valid) => valid.lastName,
        invalid: (invalid) => invalid.lastName,
      );

  bool get hasMiddleName => match(
        valid: (valid) => valid.hasMiddleName,
        invalid: (invalid) => invalid.hasMiddleName,
      );

  static Either<Failure, ValidFullName2?> toBroadEitherNullable(
          FullName2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName2 valid) valid,
      required TResult Function(InvalidFullName2Content invalid) invalid}) {
    throw UnimplementedError();
  }

  FullName2 copyWith({
    Name? firstName,
    Name? lastName,
    bool? hasMiddleName,
  }) {
    return match(
      valid: (valid) => _create(
        firstName: firstName ?? valid.firstName,
        lastName: lastName ?? valid.lastName,
        hasMiddleName: hasMiddleName ?? valid.hasMiddleName,
      ),
      invalid: (invalid) => _create(
        firstName: firstName ?? invalid.firstName,
        lastName: lastName ?? invalid.lastName,
        hasMiddleName: hasMiddleName ?? invalid.hasMiddleName,
      ),
    );
  }
}

class ValidFullName2 extends FullName2 implements ValidEntity {
  const ValidFullName2._({
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  @override
  final ValidName firstName;
  @override
  final ValidName lastName;
  @override
  final bool hasMiddleName;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName2 valid) valid,
      required TResult Function(InvalidFullName2Content invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        firstName,
        lastName,
        hasMiddleName,
      ];
}

class InvalidFullName2Content extends FullName2
    implements InvalidEntityContent {
  const InvalidFullName2Content._({
    required this.contentFailure,
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final Name firstName;
  @override
  final Name lastName;
  @override
  final bool hasMiddleName;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName2 valid) valid,
      required TResult Function(InvalidFullName2Content invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        firstName,
        lastName,
        hasMiddleName,
      ];
}
