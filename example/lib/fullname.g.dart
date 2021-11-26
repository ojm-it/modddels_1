// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullName {
  static FullName _create({
    required Name firstName,
    required Name lastName,
  }) {
    final contentVerification = firstName.toBroadEither.flatMap(
      (validFirstName) => lastName.toBroadEither.flatMap(
        (validLastName) => right(ValidFullName._(
          firstName: validFirstName,
          lastName: validLastName,
        )),
      ),
    );

    return contentVerification.match(
      ///The content is invalid
      (contentFailure) => InvalidFullNameContent._(
        contentFailure: contentFailure,
        firstName: firstName,
        lastName: lastName,
      ),

      ///The content is valid => We check if there's a general failure
      (validContent) => const FullName._().validateGeneral(validContent).match(
            (generalFailure) => InvalidFullNameGeneral._(
              generalEntityFailure: generalFailure,
              firstName: validContent.firstName,
              lastName: validContent.lastName,
            ),
            () => validContent,
          ),
    );
  }

  static Either<Failure, ValidFullName?> toBroadEitherNullable(
          FullName? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName valid) valid,
      required TResult Function(InvalidFullName invalid) invalid}) {
    throw UnimplementedError();
  }

  FullName copyWith({
    Name? firstName,
    Name? lastName,
  }) {
    return match(
      valid: (valid) => _create(
        firstName: firstName ?? valid.firstName,
        lastName: lastName ?? valid.lastName,
      ),
      invalid: (invalid) => _create(
        firstName: firstName ?? invalid.firstName,
        lastName: lastName ?? invalid.lastName,
      ),
    );
  }
}

class ValidFullName extends FullName implements ValidEntity {
  const ValidFullName._({
    required this.firstName,
    required this.lastName,
  }) : super._();

  final ValidName firstName;
  final ValidName lastName;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName valid) valid,
      required TResult Function(InvalidFullName invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        firstName,
        lastName,
      ];
}

abstract class InvalidFullName extends FullName
    implements
        InvalidEntity<FullNameEntityFailure, InvalidFullNameGeneral,
            InvalidFullNameContent> {
  const InvalidFullName._() : super._();

  Name get firstName;
  Name get lastName;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidFullName valid) valid,
      required TResult Function(InvalidFullName invalid) invalid}) {
    return invalid(this);
  }
}

class InvalidFullNameContent extends InvalidFullName
    implements InvalidEntityContent {
  const InvalidFullNameContent._({
    required this.contentFailure,
    required this.firstName,
    required this.lastName,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final Name firstName;
  @override
  final Name lastName;

  @override
  TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(InvalidFullNameGeneral invalidEntityGeneral)
          invalidEntityGeneral,
      required TResult Function(InvalidFullNameContent invalidEntityContent)
          invalidEntityContent}) {
    return invalidEntityContent(this);
  }

  @override
  TResult invalidWhen<TResult extends Object?>({
    required TResult Function(FullNameEntityFailure generalEntityFailure)
        generalEntityFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  }) {
    return contentFailure(this.contentFailure);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        firstName,
        lastName,
      ];
}

class InvalidFullNameGeneral extends InvalidFullName
    implements InvalidEntityGeneral<FullNameEntityFailure> {
  const InvalidFullNameGeneral._({
    required this.generalEntityFailure,
    required this.firstName,
    required this.lastName,
  }) : super._();

  @override
  final FullNameEntityFailure generalEntityFailure;

  @override
  final ValidName firstName;
  @override
  final ValidName lastName;

  @override
  TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(InvalidFullNameGeneral invalidEntityGeneral)
          invalidEntityGeneral,
      required TResult Function(InvalidFullNameContent invalidEntityContent)
          invalidEntityContent}) {
    return invalidEntityGeneral(this);
  }

  @override
  TResult invalidWhen<TResult extends Object?>({
    required TResult Function(FullNameEntityFailure generalEntityFailure)
        generalEntityFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  }) {
    return generalEntityFailure(this.generalEntityFailure);
  }

  @override
  List<Object?> get allProps => [
        generalEntityFailure,
        firstName,
        lastName,
      ];
}
