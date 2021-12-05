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

  static Either<Failure, ValidFullName2?> toBroadEitherNullable(
          FullName2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent)
        invalidContent,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullName2 valid) valid,
    required TResult Function(InvalidFullName2Content invalidContent) invalid,
  }) {
    return map(
      valid: valid,
      invalidContent: invalid,
    );
  }

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
