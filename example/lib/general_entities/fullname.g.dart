// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullName {
  static FullName _create({
    required Name firstName,
    required Name lastName,
    required bool hasMiddleName,
  }) {
    final contentVerification = firstName.toBroadEither.flatMap(
      (validFirstName) => lastName.toBroadEither.flatMap(
        (validLastName) => right(ValidFullName._(
          firstName: validFirstName,
          lastName: validLastName,
          hasMiddleName: hasMiddleName,
        )),
      ),
    );

    return contentVerification.match(
      ///The content is invalid
      (contentFailure) => InvalidFullNameContent._(
        contentFailure: contentFailure,
        firstName: firstName,
        lastName: lastName,
        hasMiddleName: hasMiddleName,
      ),

      ///The content is valid => We check if there's a general failure
      (validContent) => const FullName._().validateGeneral(validContent).match(
            (generalFailure) => InvalidFullNameGeneral._(
              generalFailure: generalFailure,
              firstName: validContent.firstName,
              lastName: validContent.lastName,
              hasMiddleName: validContent.hasMiddleName,
            ),
            () => validContent,
          ),
    );
  }

  Name get lastName => mapValidity(
        valid: (valid) => valid.lastName,
        invalid: (invalid) => invalid.lastName,
      );

  bool get hasMiddleName => mapValidity(
        valid: (valid) => valid.hasMiddleName,
        invalid: (invalid) => invalid.hasMiddleName,
      );

  static Either<Failure, ValidFullName?> toBroadEitherNullable(
          FullName? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    required TResult Function(InvalidFullNameContent invalidContent)
        invalidContent,
    required TResult Function(InvalidFullNameGeneral invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: valid,
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    TResult Function(InvalidFullNameContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullName invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    required TResult Function(InvalidFullName invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

  FullName copyWith({
    Name? firstName,
    Name? lastName,
    bool? hasMiddleName,
  }) {
    return mapValidity(
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

class ValidFullName extends FullName implements ValidEntity {
  const ValidFullName._({
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  final ValidName firstName;
  @override
  final ValidName lastName;
  @override
  final bool hasMiddleName;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    TResult Function(InvalidFullNameContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullName invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        firstName,
        lastName,
        hasMiddleName,
      ];
}

abstract class InvalidFullName extends FullName implements InvalidEntity {
  const InvalidFullName._() : super._();

  Name get firstName;
  @override
  Name get lastName;
  @override
  bool get hasMiddleName;

  @override
  Failure get failure => whenInvalid(
        contentFailure: (contentFailure) => contentFailure,
        generalFailure: (generalFailure) => generalFailure,
      );

  TResult mapInvalid<TResult extends Object?>({
    required TResult Function(InvalidFullNameContent invalidContent)
        invalidContent,
    required TResult Function(InvalidFullNameGeneral invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(Failure contentFailure) contentFailure,
    required TResult Function(FullNameGeneralFailure generalFailure)
        generalFailure,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidContent: (invalidContent) =>
          contentFailure(invalidContent.contentFailure),
      invalidGeneral: (invalidGeneral) =>
          generalFailure(invalidGeneral.generalFailure),
      orElse: (invalid) => throw UnreachableError(),
    );
  }
}

class InvalidFullNameContent extends InvalidFullName
    implements InvalidEntityContent {
  const InvalidFullNameContent._({
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
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    TResult Function(InvalidFullNameContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullName invalid) orElse,
  }) {
    if (invalidContent != null) {
      return invalidContent(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        firstName,
        lastName,
        hasMiddleName,
      ];
}

class InvalidFullNameGeneral extends InvalidFullName
    implements InvalidEntityGeneral<FullNameGeneralFailure> {
  const InvalidFullNameGeneral._({
    required this.generalFailure,
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  }) : super._();

  @override
  final FullNameGeneralFailure generalFailure;

  @override
  final ValidName firstName;
  @override
  final ValidName lastName;
  @override
  final bool hasMiddleName;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    TResult Function(InvalidFullNameContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullName invalid) orElse,
  }) {
    if (invalidGeneral != null) {
      return invalidGeneral(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get allProps => [
        generalFailure,
        firstName,
        lastName,
        hasMiddleName,
      ];
}
