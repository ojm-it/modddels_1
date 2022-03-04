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
    /// 1. **Content Validation**
    return _verifyContent(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    ).match(
      (contentFailure) => InvalidFullName2Content._(
        contentFailure: contentFailure,
        firstName: firstName,
        lastName: lastName,
        hasMiddleName: hasMiddleName,
      ),

      /// 2. **→ Validations passed**
      (validContent) => validContent,
    );
  }

  /// If any of the modddels is invalid, this holds its failure on the Left (the
  /// failure of the first invalid modddel encountered)
  ///
  /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
  /// ValidEntity, on the Right.
  static Either<Failure, ValidFullName2> _verifyContent({
    required Name firstName,
    required Name lastName,
    required bool hasMiddleName,
  }) {
    final contentVerification = firstName.toBroadEither.flatMap(
      (validFirstName) => lastName.toBroadEither.flatMap(
        (validLastName) => right<Failure, ValidFullName2>(ValidFullName2._(
          firstName: validFirstName,
          lastName: validLastName,
          hasMiddleName: hasMiddleName,
        )),
      ),
    );

    return contentVerification;
  }

  Name get firstName => map(
        valid: (valid) => valid.firstName,
        invalidContent: (invalidContent) => invalidContent.firstName,
      );

  Name get lastName => map(
        valid: (valid) => valid.lastName,
        invalidContent: (invalidContent) => invalidContent.lastName,
      );

  bool get hasMiddleName => map(
        valid: (valid) => valid.hasMiddleName,
        invalidContent: (invalidContent) => invalidContent.hasMiddleName,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidFullName2?> toBroadEitherNullable(
          FullName2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent)
        invalidContent,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent) invalid,
  }) {
    return map(
      valid: valid,
      invalidContent: invalid,
    );
  }

  /// Creates a clone of this entity with the new specified values.
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
  FullName2 copyWith({
    Name? firstName,
    Name? lastName,
    bool? hasMiddleName,
  }) {
    return map(
      valid: (valid) => _create(
        firstName: firstName ?? valid.firstName,
        lastName: lastName ?? valid.lastName,
        hasMiddleName: hasMiddleName ?? valid.hasMiddleName,
      ),
      invalidContent: (invalidContent) => _create(
        firstName: firstName ?? invalidContent.firstName,
        lastName: lastName ?? invalidContent.lastName,
        hasMiddleName: hasMiddleName ?? invalidContent.hasMiddleName,
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
  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent)
        invalidContent,
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
  Failure get failure => contentFailure;

  @override
  final Name firstName;
  @override
  final Name lastName;
  @override
  final bool hasMiddleName;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent)
        invalidContent,
  }) {
    return invalidContent(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        firstName,
        lastName,
        hasMiddleName,
      ];
}

class FullName2Tester extends SimpleEntityTester<InvalidFullName2Content,
    ValidFullName2, FullName2> {
  const FullName2Tester({
    int maxSutDescriptionLength = 100,
    String isValidGroupDescription = 'Should be a ValidFullName2',
    String isInvalidContentGroupDescription =
        'Should be an InvalidFullName2Content and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );
}
