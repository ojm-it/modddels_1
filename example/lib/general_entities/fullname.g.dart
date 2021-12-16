// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullName {
  static FullName _create({
    required Name firstName,
    required Name? lastName,
    required bool hasMiddleName,
  }) {
    /// 1. **Content validation**
    return _verifyContent(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    ).match(
      (contentFailure) => InvalidFullNameContent._(
        contentFailure: contentFailure,
        firstName: firstName,
        lastName: lastName,
        hasMiddleName: hasMiddleName,
      ),

      /// 2. **General validation**
      (validContent) => _verifyGeneral(validContent).match(
        (generalFailure) => InvalidFullNameGeneral._(
          generalFailure: generalFailure,
          firstName: validContent.firstName,
          lastName: validContent.lastName,
          hasMiddleName: validContent.hasMiddleName,
        ),

        /// 3. **→ Validations passed**
        (validGeneral) => validGeneral,
      ),
    );
  }

  /// If any of the modddels is invalid, this holds its failure on the Left (the
  /// failure of the first invalid modddel encountered)
  ///
  /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
  /// _ValidEntityContent, on the Right.
  static Either<Failure, _ValidFullNameContent> _verifyContent({
    required Name firstName,
    required Name? lastName,
    required bool hasMiddleName,
  }) {
    final contentVerification = firstName.toBroadEither.flatMap(
      (validFirstName) => $Name.toBroadEitherNullable(lastName).flatMap(
            (validLastName) =>
                right<Failure, _ValidFullNameContent>(_ValidFullNameContent._(
              firstName: validFirstName,
              lastName: validLastName,
              hasMiddleName: hasMiddleName,
            )),
          ),
    );

    return contentVerification;
  }

  /// This holds a [GeneralFailure] on the Left if :
  ///  - One of the nullable fields marked with `@InvalidNull` is null
  ///  - The validateGeneral method returns a [GeneralFailure]
  /// Otherwise, holds the ValidEntity on the Right.
  static Either<FullNameGeneralFailure, ValidFullName> _verifyGeneral(
      _ValidFullNameContent validEntityContent) {
    final nullablesVerification = validEntityContent.verifyNullables();

    final generalVerification = nullablesVerification.flatMap((validEntity) =>
        const FullName._()
            .validateGeneral(validEntity)
            .toEither(() => validEntity)
            .swap());

    return generalVerification;
  }

  Name? get lastName => mapValidity(
        valid: (valid) => valid.lastName,
        invalid: (invalid) => invalid.lastName,
      );

  bool get hasMiddleName => mapValidity(
        valid: (valid) => valid.hasMiddleName,
        invalid: (invalid) => invalid.hasMiddleName,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`.
  static Either<Failure, ValidFullName?> toBroadEitherNullable(
          FullName? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
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

  /// Equivalent to [map], but only the [valid] callback is required. It also
  /// adds an extra orElse required parameter, for fallback behavior.
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    TResult Function(InvalidFullNameContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullName invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullName valid) valid,
    required TResult Function(InvalidFullName invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

  /// Creates a clone of this entity with the new specified values.
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
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

class _ValidFullNameContent {
  const _ValidFullNameContent._({
    required this.firstName,
    required this.lastName,
    required this.hasMiddleName,
  });

  final ValidName firstName;
  final ValidName? lastName;
  final bool hasMiddleName;

  /// If one of the nullable fields marked with `@InvalidNull` is null, this
  /// holds a [GeneralFailure] on the Left. Otherwise, holds the ValidEntity on
  /// the Right.
  Either<FullNameGeneralFailure, ValidFullName> verifyNullables() {
    final lastName = this.lastName;
    if (lastName == null) {
      return left(const FullNameGeneralFailure.incomplete());
    }

    return right(ValidFullName._(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    ));
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
  Name? get lastName;
  @override
  bool get hasMiddleName;

  @override
  Failure get failure => whenInvalid(
        contentFailure: (contentFailure) => contentFailure,
        generalFailure: (generalFailure) => generalFailure,
      );

  /// Pattern matching for the "specific" invalid union-cases of this "base"
  /// invalid union-case, which are :
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
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

  /// Similar to [mapInvalid], but the union-cases are replaced by the failures
  /// they hold.
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
  final Name? lastName;
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
  final ValidName? lastName;
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
